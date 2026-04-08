# 项目当前基线 PRD（可执行）

> **文档性质**：描述仓库内**已实现或可联调**的真实契约，作为后续迭代的需求基线。  
> **效力**：与本文冲突的旧 PRD、根目录 `database/01_schema.sql`、未迁移的接口说明，**一律以本文为准**。  
> **读者**：产品、后端、前端、以及 Cursor 等 AI 辅助开发工具。

---

## 1. 项目概述

### 1.1 产品定位

微信小程序「减脂/饮食记录」应用：用户通过微信登录，记录每日饮食与运动，查看热量预算与趋势；支持**食物库搜索/选餐**、**拍照识图**写入饮食。

### 1.2 技术栈（基线）

| 层级 | 技术 |
|------|------|
| 前端 | uni-app（Vue 3 + TypeScript），微信小程序目标平台 |
| 后端 | Spring Boot 3 + MyBatis-Plus，JDK 17+ |
| 数据库 | MySQL 8，库名默认 `loseweight` |
| 鉴权 | JWT（微信 `code` 换 token）；部分读接口历史上允许无 Token（**已知债，见 §7**） |

### 1.3 配置基线（联调）

- **后端**：`backend/src/main/resources/application.yml` + **`application-local.yml`**（密码/密钥本地覆盖，勿提交）。  
- **数据源**：`jdbc:mysql://127.0.0.1:3306/loseweight`（以实际配置为准）。  
- **前端**：`frontend` 中 `VITE_API_BASE_URL`、`VITE_API_PATH_PREFIX`（默认 **`/api/v1`**）。

### 1.4 仓库内「非真值」资产

- **`database/01_schema.sql`**：旧版静态脚本（`app_user`、`food_library` 等），**不得**作为当前库结构依据。  
- **识图补充文档**（`docs/photograph-*.md`）：若与本文或代码不一致，以 **代码 + Flyway 迁移 + 已部署库** 为准。

---

## 2. 统一业务模型

### 2.1 用户（User）

- **主实体**：`lw_user`（微信 `openid` 唯一）。  
- **扩展**：`user_profile`（身体数据、目标等展示/编辑聚合来源之一）、`user_budget_config`（预算相关）。  
- **登录**：`POST /api/v1/auth/wx-login` → 返回 `userId`、`token`、`openid`、`profileCompleted`、`userInfo`（`AppUserDto`）。  
- **约束**：新功能**必须**以 JWT 内 `userId` 为操作主体；**禁止**仅依赖路径上的 `userId` 且不做 Token 校验的新增写接口（与现有技术债区分）。

### 2.2 餐次（Meal）

- **定义**：某用户、某日、`meal_type ∈ {breakfast,lunch,dinner,snack}` 下的一餐。  
- **持久化（强制）**：  
  - **`meal_record`**：餐次**头表**（汇总热量、食物条数、`status` 等）。  
  - **`diet_record`**：餐次**明细**（每种食物一行），`meal_id` → `meal_record.id`。  
- **`diet_record.source`**：`manual` | `search` | `custom` | `photo`（及迁移脚本允许的其他枚举，以 DB 注释为准）。  
- **禁止**：将「一餐」建模为单表多义行（旧 `01_schema` 扁平 `meal_record` 形态）作为新标准。

### 2.3 食物（Food）

- **主实体**：`food`（归属 `food_category`，含是否自定义 `is_custom`、营养与份量字段）。  
- **搜索**：服务端 `GET /api/v1/food-library/search`；分类列表 `GET /api/v1/food-categories`。  
- **自定义食物**：`POST /api/v1/users/{userId}/custom-foods`。  
- **禁止**：在新需求中引入 `food_library` 表名或独立「旧食物库」模型。

### 2.4 运动（Sport）

- **项目库**：`sport_item`；查询 `GET /api/v1/sport-library/search`。  
- **记录**：`sport_record`（可关联 `sport_item_id`，快照字段存名称/图标等）。

### 2.5 识图（Photo Recognition）

- **任务实体**：`meal_photo_recognition`（状态、原始响应、解析 JSON、确认后关联 `meal_record_id` / `diet_record_id`）。  
- **唯一产品主链路**：`/api/v1/recognize/meal-photo` →（可选）`/meal-photo/result` → `/meal-photo/confirm`。  
- **确认结果**：新建 `meal_record` + 多条 `diet_record`（`source=photo`），并触发日汇总更新（实现中异常可能被吞，见 §7）。

### 2.6 汇总（Summary）

- **日汇总表**：`daily_summary`（摄入、运动、预算、剩余、宏量、进餐窗口等，以当前 DDL 为准）。  
- **读接口**：`GET /api/v1/users/{userId}/dashboard?date=`、`GET .../daily-records?date=`。  
- **周统计**：`GET /api/v1/users/{userId}/week-stats?startDate=&endDate=`（闭区间，与「自然周」解耦）。

---

## 3. 页面体系

### 3.1 路由注册

以 **`frontend/src/pages.json`** 为唯一页面清单；**TabBar** 三项：

| Tab | path |
|-----|------|
| 首页 | `pages/home/index` |
| 拍照 | `pages/photograph/index` |
| 我的 | `pages/user/index` |

### 3.2 主要非 Tab 页面（须与导航代码一致）

| path | 导航栏标题（配置） | 职责（基线） |
|------|-------------------|--------------|
| `pages/login/index` | 登录 | 微信登录 → `wx-login` → 进首页 |
| `pages/search/index` | 热量查询 | 搜食物库 → 写 `meal-records` |
| `pages/food-search/index` | （配置含占位文案，建议后续改为动态标题） | 分类选餐 + 自定义食物 + 批量写库 |
| `pages/sport-search/index` | 运动项目 | 选运动 → 写 `sport-records` |
| `pages/daily-record/index` | 每日饮食记录 | 日历 + 时间线 + 营养汇总 |
| `pages/record-success/index` | 记录成功 | 成功反馈/跳转 |
| `pages/plan-result/index` | 计划页 | 基于用户资料聚合展示 |
| `pages/member/index` | VIP | 会员相关（以代码为准） |
| `pages/user/account-edit` | 个人信息 | `user/profile` 读写 |
| `pages/user/week-stats` | 近7日数据统计 | `week-stats` |
| `pages/user/weight-trend` | 减脂趋势 | 体重曲线 |
| `pages/user/weight` | 体重记录 | `weight-records` |
| `pages/index/index` | 占位 | **非业务入口**，主入口为 `home` |

### 3.3 导航约束（可执行）

- **进入 Tab 页「拍照」**：**必须**使用 `uni.switchTab({ url: '/pages/photograph/index' })`；**禁止**从首页搜索条相机使用 `navigateTo` 打开 Tab 页（微信小程序会失败或行为异常）。  
- **识图确认成功后**：跳转 `pages/daily-record/index?date=yyyy-MM-dd`（与识图当日一致）。

### 3.4 前端 API 封装位置

- 全局：`frontend/src/config/api.ts`（`apiPath`、`resolveUserId`）。  
- 领域：`frontend/src/api/*.ts`；类型：`frontend/src/api/types.ts`、`frontend/src/types/*.ts`。

---

## 4. 接口体系

### 4.1 约定

- **前缀**：`/api/v1`（除非部署时显式修改且前后端同步）。  
- **响应包装**：`{ code, message, data }`，业务成功 **`code === 0`**。  
- **例外**：`GET /api/v1/public/avatars/{userId}` 返回 **JPEG 字节流**，非 JSON 包装。

### 4.2 接口清单（基线必须支持）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/v1/health` | 健康检查 |
| POST | `/api/v1/auth/wx-login` | 微信登录 |
| POST | `/api/v1/auth/bind-phone` | Bearer + 手机号 code |
| GET | `/api/v1/user/profile` | Bearer 当前用户 |
| POST | `/api/v1/user/profile/update` | Bearer 更新资料 |
| POST | `/api/v1/user/bind-phone` | Bearer（与 auth 绑定语义一致） |
| GET | `/api/v1/users/{id}` | 用户资料（**存在匿名可读债**） |
| GET | `/api/v1/users/{userId}/week-stats` | startDate、endDate |
| GET | `/api/v1/users/{userId}/dashboard` | date 可选 |
| GET | `/api/v1/users/{userId}/daily-records` | date 可选 |
| POST | `/api/v1/users/{userId}/meal-records` | 创建饮食（头+明细） |
| DELETE | `/api/v1/users/{userId}/meal-records/{id}` | 删除（**id 语义为饮食明细**，以实现为准） |
| POST | `/api/v1/users/{userId}/sport-records` | 创建运动 |
| DELETE | `/api/v1/users/{userId}/sport-records/{id}` | 删除运动 |
| GET | `/api/v1/users/{userId}/weight-records` | limit 默认 30，最大 200 |
| POST | `/api/v1/users/{userId}/weight-records` | 按日 upsert 体重 |
| GET | `/api/v1/food-library/search` | q、limit、forUserId、categoryCode |
| GET | `/api/v1/food-categories` | 分类列表 |
| POST | `/api/v1/users/{userId}/custom-foods` | 自定义食物 |
| GET | `/api/v1/sport-library/search` | q、limit |
| POST | `/api/v1/recognize/meal-photo` | 识图提交（**主链路**） |
| GET | `/api/v1/recognize/meal-photo/result` | 查询任务结果 |
| POST | `/api/v1/recognize/meal-photo/confirm` | 确认写入餐次+明细 |
| POST | `/api/v1/food/recognize` | **遗留透传**，非主链路（§8） |

### 4.3 请求/响应真源

- **以后端** `web/dto`、`web/dto/photograph/*`、`domain/Food` 的 JSON 别名为准。  
- **前端** `frontend/src/api/recognize.ts`、`meal.ts`、`food.ts`、`loseweight.ts`、`user.ts`、`auth.ts` **必须与上述字段对齐**；改接口先改后端 DTO 与 OpenAPI/文档，再改前端类型。

---

## 5. 数据库体系

### 5.1 真值顺序

1. **已执行迁移的 MySQL 库**（`SHOW TABLES` / `SHOW CREATE TABLE`）。  
2. **`database/migrations/V*.sql`**（Flyway 版本脚本）。  
3. **MyBatis-Plus 实体 `@TableName`**。  
4. **禁止**：用 `database/01_schema.sql` 推导当前字段。

### 5.2 基线表集合（与 Phase4 一致）

`lw_user`、`user_profile`、`user_budget_config`、`food_category`、`food`、`meal_record`、`diet_record`、`meal_photo_recognition`、`sport_item`、`sport_record`、`user_weight_record`、`daily_summary`、`wechat_login_log`、`meal_evaluation`、`user_plan`、`vip_order`、`vip_user`。

### 5.3 核心关系（必须遵守）

- `diet_record.meal_id` → `meal_record.id`；`diet_record.user_id` → `lw_user.id`；`diet_record.food_id` → `food.id`（可空）。  
- `food.category_id` → `food_category.id`。  
- `meal_photo_recognition.user_id` → `lw_user.id`；确认后 `meal_record_id`、`diet_record_id` 指向对应表（FK 策略以 DDL 为准，含 ON DELETE SET NULL）。  
- `daily_summary`：`(user_id, summary_date)` 唯一。

### 5.4 预留表

`meal_evaluation`、`user_plan`、`vip_*`：**表存在**；是否纳入产品范围由迭代单独开需求，**禁止**在未评审情况下假设其有完整后端 API。

---

## 6. 识图完整链路（端到端可执行）

### 6.1 参与者

- 小程序：`pages/photograph/index` + `composables/usePhotographFlow.ts`。  
- 后端：`MealPhotoRecognizeController` → `MealPhotoRecognizeService`。  
- 第三方：阿里云食物热量识别 HTTP（配置 `aliyun.food.*`）。

### 6.2 流程（必须按序理解）

1. **选图**：`uni.chooseImage`（相册/相机）→ 本地临时路径。  
2. **提交识图**：前端 `readLocalFileAsBase64` → `POST /api/v1/recognize/meal-photo`，Body 含 `userId`、`source`（camera/album）、`mealType`（可传）、`recordDate`（yyyy-MM-dd）、`imageBase64` 或 `imageUrl`。  
3. **后端同步处理（当前实现）**：插入 `meal_photo_recognition` → 调阿里云 → 成功则解析为 `foods[]` 写入 `parsed_result_json`，返回 `MealPhotoRecognizeResultVo`（含 `photoJobId`、`recognizeStatus`、`foods`、`totalRecognizedCalories`、预算快照等）。**非 2xx 或业务 fail 则失败态。**  
4. **前端展示**：成功态可编辑总热量、餐次、食用比例；**删除多食物等能力若未实现须标 TODO，不得假已实现。**  
5. **确认写入**：`POST /api/v1/recognize/meal-photo/confirm`，Body 含 `photoJobId`、`confirmedMealType`、`recordDate`（可选覆盖）、`items[]`（`lineId`、`foodId`、`confirmedFoodName`、`confirmedCalories`、`confirmedEatRatio`）。  
6. **后端落库**：新建 `meal_record` + 多条 `diet_record`（`source=photo`）→ 更新 `meal_photo_recognition` 确认字段 → 尝试刷新 `daily_summary`。  
7. **跳转**：前端进入 `daily-record` 指定日期。

### 6.3 与 UI 状态机的已知差距（可执行记录）

- 后端返回的 **`recognizePhase`** 当前实现为 **null**；前端分阶段文案为**本地动画/阶段**，**不得**要求后端推送 `recognizing_type` / `recognizing_weight` 作为真状态机。  
- **仅 Base64、无 URL**：`meal_photo_recognition.image_url` 可能为空，**时间线图缩略图可能缺失**——若产品要求必显图，须新增「上传 COS + 存 URL」需求。  
- **`GET /meal-photo/result`**：后端已提供；前端当前可仅用 submit 返回值。**若未来改为异步**，须同时改：submit 立即返回 jobId + 轮询契约。

### 6.4 遗留接口 `POST /api/v1/food/recognize`

- 返回第三方 `httpStatus` + `body` 字符串；**不得**作为小程序主流程标准。  
- **新需求禁止依赖**；下线须评估调用方后删除或标记 deprecated。

---

## 7. 差异与冲突

| 主题 | 冲突描述 | 基线处理 |
|------|----------|----------|
| 数据库脚本 | `01_schema.sql` vs 迁移后库 | **以迁移 + 实库为准** |
| 用户表名 | 文档 `app_user` vs 实现 `lw_user` | **统一为 lw_user** |
| 食物表 | `food_library` vs `food` + `food_category` | **统一为后者** |
| 识图 | 异步 PRD vs 同步 submit | **以当前同步实现为准**；改异步单独立项 |
| 鉴权 | 全站 JWT vs 部分接口仅路径 userId | **新写接口必须校验**；旧接口逐步加固 |
| 前端 Tab | `navigateTo` vs `switchTab` 打开拍照 | **必须用 switchTab** |
| 搜索页写库 | 前端固定 `mealType=snack` | **与产品是否一致需评审**；基线如实记录代码行为 |
| 日汇总 | `dailySummaryService` 异常被吞 | **已知数据一致风险**；排障需查库与日志 |

---

## 8. 统一结论

- **唯一结构标准**：Flyway 迁移 + 当前 MySQL `loseweight` 库。  
- **唯一接口标准**：`/api/v1` 下 Controller + DTO + 实体序列化字段。  
- **唯一识图标准**：`/api/v1/recognize/meal-photo` + `confirm` + 表 `meal_photo_recognition` + 写入 `meal_record`/`diet_record`。  
- **唯一前端路由标准**：`pages.json` + 现有 `navigateTo`/`switchTab` 规范。  
- **废弃作为标准的模型**：根目录 `01_schema.sql`、以 `food/recognize` 为主识图、`food_library` 单表叙事。

---

## 9. 开发约束（给未来 Cursor / 开发者）

### 9.1 开始任务前（MUST）

1. 阅读 **`docs/project-current-baseline-prd.md`**（本文）与涉及的 **`database/migrations`** 版本。  
2. 用实体 `@TableName` 与 **实库 `SHOW CREATE TABLE`** 核对，不猜表名。  
3. 用 **`frontend/src/api/*`** 与后端 DTO 核对字段名（含 `@JsonProperty`）。

### 9.2 修改范围（MUST NOT）

1. **禁止**用 `01_schema.sql` 新建库或改表。  
2. **禁止**新增「第二套」识图主路径（若需替换，先废弃旧路径再迁移调用方）。  
3. **禁止**在 Tab 页使用 `navigateTo` 从非 Tab 页打开（拍照 Tab）。  
4. **禁止**在未同步前端类型的情况下只改后端 JSON 字段名。

### 9.3 新功能默认路径（SHOULD）

1. 新表：**新增 Flyway 迁移** `V0xx__description.sql`，可回滚说明写在 MR 描述。  
2. 新接口：`/api/v1/...`，`ApiResponse` 包装；需要登录的 **必须** Bearer 校验并与路径 `userId` 一致。  
3. 新饮食记录：**必须**走 `meal_record` + `diet_record`；若从识图来，`source=photo`。  
4. 文档更新：改契约时 **同步更新本文相关小节**（或注明「待合并到 baseline PRD」的临时附录）。

### 9.4 PR 自检清单（可复制）

- [ ] 未引用 `01_schema.sql` 作为结构依据  
- [ ] 识图相关仅使用 `/api/v1/recognize/*`（除非显式处理遗留 `food/recognize`）  
- [ ] 打开 Tab 页使用 `switchTab`  
- [ ] 前后端字段与 DTO/TypeScript 类型一致  
- [ ] 迁移脚本已在本地 MySQL 执行验证  

---

**文档版本**：与仓库当前代码/库结构同步；重大变更请递增说明于提交信息或文末修订记录。
