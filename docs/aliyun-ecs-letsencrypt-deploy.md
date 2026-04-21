# 阿里云 ECS 部署：初始化命令 + HTTPS（Let’s Encrypt）+ 上线前自检

> 默认以 **Ubuntu 22.04 LTS** 为例（阿里云公共镜像常见）。若为 **CentOS / Alibaba Cloud Linux**，请自行将 `apt` 换成 `dnf/yum`，防火墙用 `firewalld` 对应命令。  
> 域名示例：`admin.baohukeji.com`、`api.baohukeji.com`。请替换为你的真实域名。

---

## 1）ECS 初始化命令清单（可直接整段粘贴执行）

以下建议 **以 root 或 sudo** 执行。执行前请确认：**安全组** 已放行 `22`（SSH）、`80`（HTTP / ACME）、`443`（HTTPS）；**不要**对公网放行 `3306`。

### 1.1 基础与软件源

```bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release software-properties-common unzip
```

### 1.2 时区与时间同步（建议 Asia/Shanghai）

```bash
timedatectl set-timezone Asia/Shanghai
apt-get install -y chrony
systemctl enable --now chrony
timedatectl status
```

### 1.3 OpenJDK 17（与当前 Spring Boot 工程一致）

```bash
apt-get install -y openjdk-17-jre-headless
java -version
```

### 1.4 Nginx

```bash
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx
nginx -v
```

### 1.5 MySQL 8（仅本机访问；密码请自行替换）

```bash
apt-get install -y mysql-server
systemctl enable --now mysql

# 首次建议执行安全配置向导（交互）
# mysql_secure_installation

# 将 MySQL 绑定到本机（避免公网暴露），编辑后重启：
# sed 方式示例：若配置文件中为 bind-address=0.0.0.0 请改为 127.0.0.1
grep -R "bind-address" /etc/mysql/ || true
systemctl restart mysql
```

创建业务库与账号（**请修改密码**）：

```bash
mysql -uroot -p <<'SQL'
CREATE DATABASE IF NOT EXISTS loseweight DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'loseweight'@'localhost' IDENTIFIED BY 'CHANGE_ME_STRONG_PASSWORD';
GRANT ALL PRIVILEGES ON loseweight.* TO 'loseweight'@'localhost';
FLUSH PRIVILEGES;
SQL
```

### 1.6 业务目录

```bash
mkdir -p /www/admin /www/backend /var/www/certbot
chown -R www-data:www-data /www/admin || true
```

### 1.7 本机防火墙 UFW（可选；**阿里云安全组仍是第一道防线**）

```bash
apt-get install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
# 若 Nginx 与 Java 同机，不需要对公网开放 8081
echo "y" | ufw enable || true
ufw status verbose
```

### 1.8 Certbot（Let’s Encrypt，配合 Nginx）

```bash
apt-get install -y certbot python3-certbot-nginx
certbot --version
```

> **签发证书**（域名已解析到本机公网 IP、80 端口可从公网访问后执行）：  
> `certbot certonly --webroot -w /var/www/certbot -d admin.baohukeji.com -d api.baohukeji.com`  
> 或使用 `--nginx` 由插件自动改配置。首次上线可先按本文 **第 2 节** 放好 Nginx 再执行 `certbot --nginx`。

---

## 2）生产 HTTPS 配置版 `baohukeji.conf`（Let’s Encrypt）

将以下内容保存为：`/etc/nginx/sites-available/baohukeji.conf`（或 `/etc/nginx/conf.d/baohukeji.conf`，与发行版习惯一致即可），**然后** `nginx -t && systemctl reload nginx`。

**说明：**

- 证书路径以 Certbot 默认为准：若你用 `certbot certonly ... -d admin.baohukeji.com -d api.baohukeji.com`，常见目录为：  
  `/etc/letsencrypt/live/admin.baohukeji.com/fullchain.pem`  
  `/etc/letsencrypt/live/admin.baohukeji.com/privkey.pem`  
  若 `certbot certificates` 显示不同名称，请把下面两行路径改成实际输出。
- 若系统已安装 `options-ssl-nginx.conf`，建议 `include`（路径可能为 `/etc/letsencrypt/options-ssl-nginx.conf`）。

```nginx
# /etc/nginx/sites-available/baohukeji.conf
# 域名：admin.baohukeji.com（管理后台静态） + api.baohukeji.com（反代 Spring Boot）

# ---------- ACME HTTP-01 + 强制跳转 HTTPS ----------
server {
    listen 80;
    listen [::]:80;
    server_name admin.baohukeji.com api.baohukeji.com;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
        allow all;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

# ---------- 管理后台（Vue dist）HTTPS ----------
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name admin.baohukeji.com;

    # TODO：与 certbot certificates 输出保持一致
    ssl_certificate     /etc/letsencrypt/live/admin.baohukeji.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/admin.baohukeji.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    # 若已执行 openssl dhparam -out /etc/letsencrypt/ssl-dhparams.pem 2048 再取消下一行注释
    # ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    root /www/admin;
    index index.html;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location / {
        try_files $uri $uri/ /index.html;
    }

    access_log /var/log/nginx/admin.baohukeji.access.log;
    error_log  /var/log/nginx/admin.baohukeji.error.log;
}

# ---------- API（Spring Boot 本机 8081）HTTPS ----------
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name api.baohukeji.com;

    ssl_certificate     /etc/letsencrypt/live/admin.baohukeji.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/admin.baohukeji.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    # 若已执行 openssl dhparam -out /etc/letsencrypt/ssl-dhparams.pem 2048 再取消下一行注释
    # ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    client_max_body_size 20m;

    location / {
        proxy_pass http://127.0.0.1:8081;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_connect_timeout 10s;
        proxy_read_timeout 120s;
        proxy_send_timeout 120s;
    }

    access_log /var/log/nginx/api.baohukeji.access.log;
    error_log  /var/log/nginx/api.baohukeji.error.log;
}
```

**首次申请证书（示例，二选一）：**

```bash
# 方式 A：webroot（需先保证 server 块中 /.well-known 已生效）
certbot certonly --webroot -w /var/www/certbot \
  -d admin.baohukeji.com -d api.baohukeji.com \
  --email you@example.com --agree-tos --no-eff-email

# 方式 B：nginx 插件（会临时改配置，适合已有 80 server）
# certbot --nginx -d admin.baohukeji.com -d api.baohukeji.com
```

**若提示缺少 `ssl-dhparams.pem`：**

```bash
openssl dhparam -out /etc/letsencrypt/ssl-dhparams.pem 2048
```

**自动续期（通常 certbot 已装 cron/systemd timer）：**

```bash
systemctl list-timers | grep certbot || true
certbot renew --dry-run
```

---

## 3）上线前 10 分钟自检清单

按顺序勾选，全部通过再切流量或对外宣传。

| # | 检查项 | 操作 / 期望 |
|---|--------|-------------|
| 1 | **DNS** | `admin`、`api` 的 A 记录指向 ECS 公网 IP；`dig +short admin.baohukeji.com` 正确 |
| 2 | **安全组** | 公网入站：`80`、`443`、`22`；**无** `3306` 对 `0.0.0.0/0` |
| 3 | **本机 MySQL** | `ss -lntp | grep 3306` 仅 `127.0.0.1`；业务账号可 `mysql -u loseweight -p loseweight` |
| 4 | **Nginx** | `nginx -t` 无报错；`systemctl status nginx` active |
| 5 | **证书** | 浏览器打开 `https://admin...` 锁正常；`certbot certificates` 显示未过期 |
| 6 | **HTTP→HTTPS** | 访问 `http://admin...` 应 **301** 到 https |
| 7 | **静态后台** | `https://admin...` 能打开登录页；刷新子路由不出现 404（`try_files`） |
| 8 | **API 存活** | `curl -sS https://api.../api/v1/health` 或项目已有健康检查接口返回 200 |
| 9 | **管理登录** | `POST https://api.../api/v1/admin/login` 返回 `code=0` 且带 `token`；管理后台能进首页统计 |
| 10 | **跨域** | 小程序/H5 若直连 `api` 域名：浏览器 Network 无 CORS 报错；或统一只调 `api` 域名、后台静态与 API 同源策略清晰 |
| 11 | **回源 / 真实 IP**（可选） | 若前有 CDN，确认 `X-Forwarded-For` 与后端限流/日志需求；当前直连 Nginx 一般已够用 |
| 12 | **后端日志** | `journalctl -u loseweight-api -n 200 --no-pager` 无连续异常栈；Nginx `error_log` 无大量 502 |
| 13 | **JWT / 密钥** | `application-prod` 或 systemd 中 `APP_JWT_SECRET` ≥32 字节且已更换默认值 |
| 14 | **前端环境** | 生产构建 `admin-frontend` 的 `VITE_API_BASE_URL=https://api.baohukeji.com/api/v1` 已生效后再上传 `dist` |

---

## 与仓库内其他文档的关系

- 业务库迁移、systemd、目录结构：见 `docs/admin-deploy-ecs.md`  
- 仅 HTTP 的简化 Nginx：见 `docs/nginx-admin.conf`（上线 HTTPS 后建议以本文 **第 2 节** 为准）

---

## 合规与运维提醒（简）

- 域名对外提供 **Web/HTTPS** 服务需完成 **ICP 备案**（大陆机房）。  
- 定期：`certbot renew` 演练、数据库备份、安全组最小权限、SSH 密钥登录替代弱密码。
