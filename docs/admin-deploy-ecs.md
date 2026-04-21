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
