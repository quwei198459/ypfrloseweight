# 宝护健康瘦管理后台系统 PRD

## 1. 项目目标

在现有 `Spring Boot + MyBatis-Plus + MySQL` 业务系统上，新增一套 PC Web 管理后台（`admin-frontend`），用于：

- 管理员账号登录
- 食物分类管理（`food_category`）
- 食物信息管理（`food`）
- 运动项目管理（`sport_item`）
- 用户列表查看（`lw_user` + `user_profile`）

要求可直接部署至阿里云 ECS + Nginx 生产环境。

## 2. 页面结构

- 登录页 `/login`
  - 账号、密码输入
  - 登录成功后进入 Dashboard
- 首页 `/dashboard`（统计看板）
  - 用户总数（`lw_user` 行数）
  - 食物数量（`food` 行数）
  - 今日记录数（`meal_record` 中 `record_date` = 当日，时区 Asia/Shanghai）
- 用户列表 `/users`
  - 搜索（昵称/手机号）
  - 分页列表（基础信息 + 身高体重档案）
- 食物分类管理 `/food-categories`
  - 列表、新增、编辑、删除
- 食物管理 `/foods`
  - 列表、新增、编辑、删除
- 运动管理 `/sports`
  - 列表、新增、编辑、删除
- 修改密码（顶部栏「修改密码」）
  - 输入原密码、新密码、确认新密码；成功后退出登录并跳转登录页

布局：Element Plus Admin 风格（左侧菜单 + 右侧内容区）。

## 3. 字段说明

## 3.1 管理员表 `admin_user`

- `id`：主键
- `username`：登录名（唯一）
- `password`：BCrypt 密文
- `status`：状态（1 启用 / 0 禁用）
- `created_at`：创建时间
- `updated_at`：更新时间

初始化账号：

- 用户名：`admin`
- 密码：`123456`（数据库中为 BCrypt 密文）

## 3.2 登录日志表 `admin_login_log`（可扩展）

- `id`：主键
- `admin_id`：管理员 ID（失败可空）
- `username`：尝试登录账号
- `success`：1 成功 / 0 失败
- `ip`：登录 IP
- `user_agent`：浏览器标识
- `created_at`：创建时间

## 4. 接口说明

统一前缀：`/api/v1/admin`

## 4.1 登录

- `POST /api/v1/admin/login`
- 请求：
  - `username`
  - `password`
- 返回：
  - `token`
  - `username`
  - `expireSeconds`

## 4.1.2 首页统计（需登录）

- `GET /api/v1/admin/dashboard/stats`
- Header：`Authorization: Bearer <token>`
- 返回 JSON 字段：
  - `userTotal`：用户总数
  - `foodTotal`：食物条数
  - `todayMealRecordTotal`：今日餐次记录数

## 4.1.1 修改密码（需登录）

- `POST /api/v1/admin/change-password`
- Header：`Authorization: Bearer <token>`
- 请求 JSON：
  - `oldPassword`：原密码
  - `newPassword`：新密码（6～64 位）
- 返回：`data` 为 `true` 表示已更新数据库中的密文

## 4.2 用户

- `GET /api/v1/admin/users`
- Query：
  - `keyword`（可选）
  - `page`（默认 1）
  - `pageSize`（默认 20）
- 返回分页结构：`total/page/pageSize/list`

## 4.3 食物分类

- `GET /api/v1/admin/food-categories`
- `POST /api/v1/admin/food-categories`
- `PUT /api/v1/admin/food-categories/{id}`
- `DELETE /api/v1/admin/food-categories/{id}`

## 4.4 食物

- `GET /api/v1/admin/foods`
- `POST /api/v1/admin/foods`
- `PUT /api/v1/admin/foods/{id}`
- `DELETE /api/v1/admin/foods/{id}`

## 4.5 运动

- `GET /api/v1/admin/sports`
- `POST /api/v1/admin/sports`
- `PUT /api/v1/admin/sports/{id}`
- `DELETE /api/v1/admin/sports/{id}`

## 5. 操作流程

1. 管理员访问 `admin.baohukeji.com`
2. 输入账号密码调用登录接口
3. 后端校验后返回 JWT（含 `role=admin`）
4. 前端存储 token，后续请求带 `Authorization: Bearer <token>`
5. 进入各业务页进行增删改查

## 6. 权限说明（预留）

当前版本为单角色后台管理员。

后续可扩展：

- 角色表（super_admin/editor/viewer）
- 资源表（菜单/API 权限点）
- 角色-资源关系表
- 接口级鉴权注解或拦截器

## 7. 非功能要求

- 不改动现有业务表结构
- 兼容现有 API 响应格式（`ApiResponse`）
- 前端构建产物为静态文件 `dist`
- 支持 Nginx 反向代理部署
