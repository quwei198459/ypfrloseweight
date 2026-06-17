# 宝护健康瘦管理后台 ECS 部署步骤

> ⚠️ 本文 §1–§9 为「**首次搭建**」步骤。日常发版请直接看 **§0 当前真实部署架构 + 一键部署**，那才是与线上一致的实测口径。

---

## 0. 当前真实部署架构（实测，2026-06 校准）

| 项 | 实际值 |
|---|---|
| 服务器 | 阿里云 ECS `8.136.24.243`（Ubuntu，user `root`） |
| 后端进程 | **systemd 服务 `loseweight-api`**（已 `enable` 开机自启），监听 **`127.0.0.1:8081`** |
| 后端 jar | `/www/backend/loseweight-api.jar`（由 `--spring.profiles.active=prod` 启动） |
| 后端密钥 | `/www/backend/loseweight-api.env`（**600 权限 EnvironmentFile**，含 DB/JWT/微信/阿里云/易美/DeepSeek 等 14 个变量） |
| 后端日志 | `/www/backend/app.log` |
| 管理后台静态 | **`/www/frontend-admin/`**（注意：不是 `/www/admin`） |
| Nginx 域名 | `api.baohukeji.com` → 反代 `127.0.0.1:8081`；`admin.baohukeji.com` → 静态 `/www/frontend-admin` |
| Nginx 配置 | `/etc/nginx/sites-available/default`（同 `sites-enabled/default`） |

### 0.1 一键部署（本地 `scripts/deploy.sh`）

前提：本机 `~/.ssh/config` 配好 `Host aliyun-www`（连接复用 + 免密，见 §0.3），并已 `ssh-copy-id aliyun-www`。

```bash
./scripts/deploy.sh backend     # 构建 jar → rsync 上传 → systemctl restart → 健康检查(8081)
./scripts/deploy.sh admin       # 构建后台 → rsync --delete 到 /www/frontend-admin → nginx reload
./scripts/deploy.sh all         # 后端 + 后台
# 纯运维：
./scripts/deploy.sh restart|stop|start|status|logs
```

脚本默认 `DEPLOY_SSH_HOST=root@8.136.24.243`、`REMOTE_ADMIN_DIR=/www/frontend-admin`、`HEALTH_PORT=8081`，可用同名环境变量覆盖。

### 0.2 数据库迁移（发版含新表/改表时）

仓库迁移脚本在 `database/migrations/V0xx__*.sql`，**Flyway 未接入，需手动执行**：

```bash
# 本地把脚本传上去后，在服务器执行（mysql root 需密码）
mysql -u root -p loseweight < V029__system_config.sql
```

### 0.3 本机 SSH 复用 + 免密（提速 Cursor Remote-SSH 与部署）

`~/.ssh/config`：

```sshconfig
Host aliyun-www 8.136.24.243
    HostName 8.136.24.243
    User root
    IdentityFile ~/.ssh/id_ed25519
    ControlMaster auto
    ControlPath ~/.ssh/cm-%r@%h:%p
    ControlPersist 10m
    Compression yes
    ServerAliveInterval 30
    ServerAliveCountMax 3
```

首次执行 `ssh-copy-id aliyun-www`（输一次密码）后即全程免密。

---

## 1. 服务目录准备（首次搭建）

```bash
mkdir -p /www/frontend-admin
mkdir -p /www/backend
```

## 2. 数据库脚本执行

在 MySQL 执行：

1. 已有业务库迁移脚本（如尚未执行）
2. `database/migrations/V022__admin_user_and_login_log.sql`

或一次性执行 `database/admin-system.sql`（仅新增后台相关表和账号）。

## 3. 构建并上传后端

本地构建：

```bash
cd backend
mvn clean package -DskipTests
```

上传 `target/loseweight-api-0.0.1-SNAPSHOT.jar` 到：

`/www/backend/loseweight-api.jar`

## 4. 后端 systemd（线上实际单元）

密钥放在 **600 权限的 EnvironmentFile**（不要写进进程命令行参数，避免在 `ps` 里泄露）。

`/www/backend/loseweight-api.env`（每行 `KEY=value`，无 `export`、无引号）：

```dotenv
DB_USERNAME=root
DB_PASSWORD=你的数据库密码
APP_JWT_SECRET=至少32位随机串
WECHAT_MINIAPP_APP_ID=wxfd93d8228139adca
WECHAT_MINIAPP_APP_SECRET=...
ALIYUN_FOOD_APPCODE=...
YIMEI_API_BASE_URL=https://api.yimei.ai
YIMEI_CLIENT_ID=...
YIMEI_CLIENT_SECRET=...
YIMEI_FACE_DETECT_TYPES=0
DEEPSEEK_BASE_URL=https://api.deepseek.com
DEEPSEEK_API_KEY=...
SKIN_DETECT_DEFAULT_TIMES=3
SKIN_DETECT_IMAGE_DIR_SUFFIX=skin-detection
```

```bash
chmod 600 /www/backend/loseweight-api.env
```

`/etc/systemd/system/loseweight-api.service`：

```ini
[Unit]
Description=LoseWeight API (Spring Boot)
After=network.target mysql.service

[Service]
Type=simple
User=root
WorkingDirectory=/www/backend
EnvironmentFile=/www/backend/loseweight-api.env
ExecStart=/usr/lib/jvm/java-17-openjdk-amd64/bin/java -jar /www/backend/loseweight-api.jar --spring.profiles.active=prod --app.upload.avatar-dir=/www/backend/uploads/avatars --app.upload.food-image-dir=/www/backend/uploads/food-images
SuccessExitStatus=143
Restart=always
RestartSec=5
StandardOutput=append:/www/backend/app.log
StandardError=append:/www/backend/app.log

[Install]
WantedBy=multi-user.target
```

> `java` 绝对路径以 `readlink -f "$(command -v java)"` 为准（本机为 OpenJDK 17）。`prod` 档监听 `127.0.0.1:8081`（见 `application-prod.yml`）。

启动：

```bash
systemctl daemon-reload
systemctl enable --now loseweight-api
systemctl status loseweight-api
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8081/api/v1/health   # 期望 200
```

## 5. 构建并上传前端

本地构建：

```bash
cd admin-frontend
npm install
npm run build
```

上传 `admin-frontend/dist/*` 到：

`/www/frontend-admin/`

## 6. Nginx 配置

参考配置见本文 §10.5。线上实际写在 **`/etc/nginx/sites-available/default`**（软链到 `sites-enabled/default`），首次搭建可沿用该文件或新建 `conf.d/baohukeji.conf`，二选一即可。

检查与重载：

```bash
nginx -t
systemctl reload nginx
```

## 7. 安全组与域名

- ECS 安全组开放 `80/443`
- `admin.baohukeji.com` A 记录到 ECS
- `api.baohukeji.com` A 记录到 ECS

## 8. 相关文档

- **ECS 初始化 + Let’s Encrypt HTTPS + 10 分钟自检**：见同目录 `aliyun-ecs-letsencrypt-deploy.md`

## 9. 验证清单

1. 访问 `https://admin.baohukeji.com`（或 HTTP 环境）打开登录页
2. 使用 `admin / 123456` 登录（上线后请立即改密）
3. 用户列表可查询
4. 食物分类/食物/运动可增删改查
5. `https://api.baohukeji.com/api/v1/admin/login` 返回正常 JSON

## 10. 服务器命令备忘

### 10.1 Nginx 与证书

```bash
vim /etc/nginx/sites-available/default
cd /etc/nginx/ssl
ls /etc/nginx/ssl
chmod 600 /etc/nginx/ssl/*
mv /etc/nginx/ssl/api.baohukeji.com.pem /etc/nginx/ssl/fullchain.pem
mv /etc/nginx/ssl/api.baohukeji.com.key /etc/nginx/ssl/privkey.pem
nginx -t
systemctl restart nginx
```

证书上传示例：

```bash
scp D:\mycode\ypfrloseweight\certs\api.baohukeji.com.pem root@8.136.24.243:/etc/nginx/ssl/
scp D:\mycode\ypfrloseweight\certs\api.baohukeji.com.key root@8.136.24.243:/etc/nginx/ssl/
```

### 10.2 前端更新

```bash
rm -rf /www/frontend-admin/*
scp -r admin-frontend/dist/* root@8.136.24.243:/www/frontend-admin/
```

### 10.3 后端打包与上传

```bash
cd backend
mvn clean package -DskipTests
scp backend/target/loseweight-api-0.0.1-SNAPSHOT.jar root@8.136.24.243:/www/backend/loseweight-api.jar
```

### 10.4 后端启动与重启（systemd，线上现状）

```bash
systemctl restart loseweight-api      # 重启（发版换 jar 后用）
systemctl stop loseweight-api         # 关闭
systemctl start loseweight-api        # 启动
systemctl status loseweight-api       # 状态
journalctl -u loseweight-api -f       # 跟踪 journald 日志
tail -f /www/backend/app.log          # 应用日志文件
ss -lntp | grep 8081                  # 确认端口
```

> 改密钥：编辑 `/www/backend/loseweight-api.env` 后 `systemctl restart loseweight-api` 生效。

**应急兜底（systemd 不可用时手动起）**：

```bash
pkill -f loseweight-api.jar
cd /www/backend
set -a; . /www/backend/loseweight-api.env; set +a
nohup java -jar /www/backend/loseweight-api.jar --spring.profiles.active=prod \
  --app.upload.avatar-dir=/www/backend/uploads/avatars \
  --app.upload.food-image-dir=/www/backend/uploads/food-images \
  > /www/backend/app.log 2>&1 &
```

### 10.5 Nginx 参考配置

```nginx
server {
    listen 443 ssl;
    server_name api.baohukeji.com;

    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;
    
    location /uploads/food-images/ {
      alias /www/backend/uploads/food-images/;
      access_log off;
      expires 30d;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:8081/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location / {
        return 404;
    }
}

server {
    listen 80;
    server_name api.baohukeji.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name admin.baohukeji.com;

    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;

    root /www/frontend-admin;
    index index.html;
     
    location /api/ {
      proxy_pass http://127.0.0.1:8081/api/;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
    }

    location / {
        try_files $uri $uri/ /index.html;
    }
}

server {
    listen 80;
    server_name admin.baohukeji.com;
    return 301 https://$host$request_uri;
}
```

