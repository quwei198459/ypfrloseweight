# 宝护健康瘦管理后台 ECS 部署步骤

## 1. 服务目录准备

```bash
mkdir -p /www/admin
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

## 4. 后端 systemd

创建 `/etc/systemd/system/loseweight-api.service`：

```ini
[Unit]
Description=LoseWeight API
After=network.target

[Service]
User=root
WorkingDirectory=/www/backend
ExecStart=/usr/bin/java -jar /www/backend/loseweight-api.jar --spring.profiles.active=prod
Restart=always
RestartSec=5
Environment=DB_USERNAME=root
Environment=DB_PASSWORD=your_db_password
Environment=APP_JWT_SECRET=replace_with_32+_chars_secret

[Install]
WantedBy=multi-user.target
```

启动：

```bash
systemctl daemon-reload
systemctl enable loseweight-api
systemctl start loseweight-api
systemctl status loseweight-api
```

## 5. 构建并上传前端

本地构建：

```bash
cd admin-frontend
npm install
npm run build
```

上传 `admin-frontend/dist/*` 到：

`/www/admin/`

## 6. Nginx 配置

把 `docs/nginx-admin.conf` 内容放到：

`/etc/nginx/conf.d/baohukeji.conf`

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

### 10.4 后端启动与重启

```bash
cd /www/backend
export DB_USERNAME=root
export DB_PASSWORD='你的数据库密码'
export APP_JWT_SECRET='请换成至少32位的随机字符串'
export WECHAT_MINIAPP_APP_ID='wxfd93d8228139adca'
export WECHAT_MINIAPP_APP_SECRET='请换成你自己的小程序密钥'
export ALIYUN_FOOD_APPCODE='请换成你自己的 AppCode'
nohup java -jar /www/backend/loseweight-api.jar --spring.profiles.active=prod > /www/backend/app.log 2>&1 &
```

查看日志：

```bash
tail -f /www/backend/app.log
```

检查端口：

```bash
ss -lntp | grep 8081
```

重启：

```bash
ps -ef | grep loseweight-api.jar | grep -v grep
pkill -f loseweight-api.jar
cd /www/backend
export DB_USERNAME=root
export DB_PASSWORD='你的数据库密码'
export APP_JWT_SECRET='请换成至少32位的随机字符串'
export WECHAT_MINIAPP_APP_ID='wxfd93d8228139adca'
export WECHAT_MINIAPP_APP_SECRET='请换成你自己的小程序密钥'
export ALIYUN_FOOD_APPCODE='请换成你自己的 AppCode'
nohup java -jar /www/backend/loseweight-api.jar --spring.profiles.active=prod > /www/backend/app.log 2>&1 &
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

