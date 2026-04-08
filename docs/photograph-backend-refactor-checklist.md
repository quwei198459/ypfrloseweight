# 餐前拍一拍 · 后端改造清单

> **文档性质**：基于 **`docs/photograph-recognition-supplement-prd.md`**（补充 PRD）、**`database/migrations/V015__photograph_recognition_supplement.sql`**（库表增量）、**`docs/photograph-recognition-api-supplement.md`**（接口补充方案）、以及前端 **`frontend/src/types/photograph.ts`** 中的页面阶段定义，整理 **后端待办清单**。  
> **本文档不修改任何代码**，供排期与拆分任务使用。

---

## 0. 现状与目标差距（摘要）

| 维度 | 当前后端（参考） | 目标形态 |
| --- | --- | --- |
| 入口 | `POST /api/v1/food/recognize`（`FoodRecognizeController`） | 主 PRD / 补充方案：`POST/GET/POST` 三条识图链路（路径可统一为 `/api/recognize/meal-photo*` 或与网关约定版本前缀） |
| 响应 | `httpStatus` + 原始 `body` 字符串 | 结构化 JSON：`photoJobId`、`recognizeStatus`、可选 `recognizePhase`、`foods[]`、预算快照、`confirmStatus` 等 |
| 持久化 | `MealPhotoRecognition` 仅部分字段；固定 `meal_type=snack` 等 | 执行 **V015** 后实体与写入逻辑覆盖 **推荐/确认餐别、识别与确认快照、确认状态、关联餐次/明细** |
| 写餐次 | 无 `confirm` 实现 | **事务** 写入 `meal_record` / `diet_record`，回填 `meal_photo_recognition`，并重算 **日汇总**（主 PRD §12.3） |
| 异步 | 同步调阿里云并一次 insert | 支持 **任务 ID + 轮询/回调**（至少满足前端 `uploading` → `recognizing_*` → `success/fail` 可观测） |

---

## 一、数据库与迁移

- [ ] **执行** `V015__photograph_recognition_supplement.sql`（在已存在 `meal_photo_recognition` 的环境按序执行；勿在 V012 之前执行）。  
- [ ] **校验** 外键：`meal_record_id`、`diet_record_id` 与 `ON DELETE SET NULL` 是否符合运维策略（删餐次是否允许、是否改业务删除为软删）。  
- [ ] **评估** 补充 PRD §J.1 中的 **`recognize_phase`**（uploading / recognizing_type / recognizing_weight）：**V015 未包含该列**，若需与前端精确同步而非仅靠前端本地模拟，需 **另起迁移** 增加列或约定仅用 `parsed_result_json` 扩展字段（二选一并在接口文档写死）。  
- [ ] **历史数据**：`confirm_status` 默认 `none`；旧行无需强制回填，但报表需区分「未确认识图」与「已确认」。

---

## 二、领域模型与持久层（MyBatis-Plus / Mapper）

- [ ] **实体 `MealPhotoRecognition`**：增加与 V015 一一对应的属性（驼峰映射列名）。  
- [ ] **Mapper / XML**（若手写 SQL）：`insert` / `updateById` 字段列表更新；查询 `result` 时需带出全部展示所需列。  
- [ ] **枚举或常量类**：`recognize_status`（主 PRD：`uploading` / `recognizing` / `success` / `fail`）、`confirm_status`（V015 注释：`none` / `pending_confirm` / `confirmed` / `aborted` 等，需产品收口）、`meal_type` 与前端 `MealTypeKey` 一致。  
- [ ] **`diet_record` / `meal_record`**：确认写入时字段与主 PRD §8.7 / §8.8 一致；`diet_record.source = photo`（或主 PRD 约定枚举）。

---

## 三、接口层（Controller + DTO/VO）

按 **`photograph-recognition-api-supplement.md`** 拆分，建议独立 **`MealPhotoRecognizeController`**（或等价命名），避免继续污染 `FoodRecognizeController` 的联调形态。

### 3.1 `POST …/meal-photo`（提交识图）

- [ ] **入参 DTO**：`source`、`mealType`（可选）、`recordDate`（可选）、时区（可选）、图片载体（multipart / URL / base64 三选一策略与网关一致）。  
- [ ] **出参 VO**：`photoJobId`、`recognizeStatus`、可选 `recognizePhase`、`imageUrl`/`previewUrl`；成功时 **`foods[]` + 预算快照**（`intakeCaloriesToday`、`dailyBudgetCalories`、`badgeProgressPercent`、`recommendedEatRatio`、`confirmStatus`）。  
- [ ] **错误体**：统一 `ApiResponse` 错误码 + `errorMessage`，与前端 `failed` 态展示一致。  
- [ ] **兼容**：是否保留 `/api/v1/food/recognize` 作 deprecated 转发或并行双轨（需网关与小程序发版节奏）。

### 3.2 `GET …/meal-photo/result`

- [ ] **入参**：`photoJobId`（必填）。  
- [ ] **鉴权**：仅允许 **`user_id` 与当前登录用户一致** 的任务查询。  
- [ ] **出参**：与 POST 成功体 **同构**（或共享 `MealPhotoRecognizeResultVO`），便于前端轮询。  
- [ ] **语义**：返回 **最新** `recognize_status` / 可选 `recognize_phase` / 解析结果；预算类字段可按需每次重算以保证与首页同源。

### 3.3 `POST …/meal-photo/confirm`

- [ ] **入参 DTO**：`photoJobId`、`confirmedMealType`、`recordDate`（可选）、`items[]`（含 `lineId`/`foodIndex`、`confirmedCalories`、`confirmedEatRatio`、可选 `confirmedFoodName`、`foodId`）。  
- [ ] **出参 VO**：`mealRecordId`、`dietRecordIds[]`、`confirmStatus=confirmed`、`confirmedAt`、可选 **日汇总摘要** 减少前端二次请求。  
- [ ] **幂等**：`confirm_status` 已为 `confirmed` 时，返回 **已有结果** 或 **409/业务码**（需文档约定）。

---

## 四、Service 层职责拆分（建议）

- [ ] **`MealPhotoRecognizeService`（新建或从 `FoodRecognizeService` 演进）**  
  - 创建任务行、填充 `meal_type`（端上选中）、`recommended_meal_type`（时间规则 §E）、`record_date`、`source`、`image_url`。  
  - 编排 **上传存储**（若 OSS）与 **阿里云调用**；维护 `recognize_status`、失败时写 `error_code` / `error_message`，**不写入** `meal_record`/`diet_record`。  
  - 解析第三方结果为 **`foods[]` 标准结构**，写入 `parsed_result_json`，并填充 **`recognized_*` 快照列**（名称、热量等，多食物策略需定）。  
  - 组装 **预算快照**：调用现有 **`CalorieBudgetCalculator` / `daily_summary` / 饮食聚合查询**，计算 `badgeProgressPercent`（**产品公式**必须在 PRD 写死，见接口补充方案「风险与决策点」）。  

- [ ] **`MealPhotoConfirmService`（或合并在上层同一 Facade）**  
  - **事务**：校验 `photo_job` 状态 → 创建或合并 `meal_record`（策略见下）→ 插入一条或多条 `diet_record` → 更新 `meal_photo_recognition` 的 **`confirmed_*`、`confirm_status`、`confirmed_at`、`meal_record_id`、`diet_record_id`（首条）** → 触发 **日汇总重算**（主 PRD §12.3）。  
  - 校验 `confirmedCalories` 与 `items` 合法性（正数、上限等）。  

- [ ] **异步与阶段**（若识别耗时）  
  - 可选：**线程池 / 消息队列** 推进 `recognizing`；或通过同步接口 + 前端轮询简化 v1。  
  - 若仅返回粗粒度 `recognizing`，前端仍可本地拆三阶段；若要与后端一致，需 **`recognize_phase` 列 + 更新逻辑**。

---

## 五、与现有「餐次 / 饮食 / 汇总」模块集成

- [ ] **复用**已有 `MealService`（或等价）完成 `meal_record` 合并规则：**同一用户 + 同一 `record_date` + 同一 `meal_type` 是否合并到已有餐次**（补充 PRD / 接口方案中的待拍板项）。  
- [ ] **写入 `diet_record`**：`calories_total` 与 `confirmedCalories` 一致；宏量若有则按规则换算；`food_name_snapshot`、`gi_level_snapshot`、`image_snapshot` 与识图任务一致。  
- [ ] **日汇总**：写入后刷新 `daily_summary` 或与现有「增删饮食记录重算」链路对齐。  
- [ ] **首页「还可吃」**：与 `GET result` / `confirm` 返回的预算口径一致。

---

## 六、前端页面状态 ↔ 后端字段/接口映射（对齐清单）

| 前端 `PhotographPhase`（`photograph.ts`） | 后端支撑要点 |
| --- | --- |
| `idle` | 无请求；可选拉取用户默认餐别配置（非必须）。 |
| `uploading` / `recognizing_type` / `recognizing_weight` | `GET result` 返回 `recognizeStatus` + 可选 `recognizePhase`；或前端本地模拟 + 仅 `recognizing`。 |
| `success` | `recognizeStatus=success`，返回 `foods[]`、预算快照、`recommendedEatRatio`、`confirmStatus`（如 `pending_confirm`）。 |
| `mealtype_dropdown_open` | **纯前端**；写入目标餐别以 **confirm 的 `confirmedMealType`** 为准。 |
| `editing_calorie` | **纯前端**直至 confirm；可选未来 `PATCH` 草稿接口（接口补充方案 §I.4）。 |
| `adjusting_ratio` | **纯前端**展示；confirm 带 `confirmedEatRatio` + 最终 `confirmedCalories`。 |
| `failed` | `recognizeStatus=fail`；仅更新 `meal_photo_recognition`，**无** 餐次写入。 |
| `saving` | **建议**前端在调用 `confirm` 等待响应期间进入；后端可提供长时间任务 id（v2），v1 同步 confirm 即可。 |
| `saved` | **纯前端**过渡；后端以 `confirm` 成功 + `confirm_status=confirmed` 为准。 |

---

## 七、安全、幂等与并发

- [ ] 所有识图相关接口 **强制登录用户**，`photoJobId` **仅能访问本人数据**。  
- [ ] `confirm` **防重复提交**（数据库唯一约束或 `confirm_status` 乐观锁 / 幂等键）。  
- [ ] 图片上传：**大小限制、格式校验、病毒扫描（按需）**；base64 路径限流。  
- [ ] 第三方调用：**超时、重试、熔断** 与 `vendor_request_id` 记录（主 PRD 已有字段）。

---

## 八、观测与运维

- [ ] 结构化日志：`photoJobId`、`userId`、`recognizeStatus`、`confirmStatus`、耗时、阿里云错误码。  
- [ ] 监控指标：识别成功率、confirm 失败率、P99 延迟。  
- [ ] 数据对账：抽查 `meal_photo_recognition.meal_record_id` 与 `diet_record.meal_id` 一致性。

---

## 九、测试建议（后端）

- [ ] 单元测试：解析阿里云响应 → `foods[]`；预算快照计算（给定 `daily_summary` mock）。  
- [ ] 集成测试：`confirm` 后 `meal_record`/`diet_record`/`meal_photo_recognition` 字段与汇总更新。  
- [ ] 失败路径：第三方失败仅识图表；confirm 非法状态（非 success、他人 job）返回预期错误。  
- [ ] 幂等：重复 `confirm` 行为符合文档。

---

## 十、交付顺序建议（迭代）

1. 执行 V015 + 实体/Mapper 对齐。  
2. 实现 **`GET result` + 重构 POST** 返回结构化 VO（可先同步识别简化）。  
3. 实现 **`confirm` 事务写餐次** + 汇总重算。  
4. 路径统一与废弃旧 `food/recognize` 联调接口（协调小程序发版）。  
5. （可选）异步流水线 + `recognize_phase` 列 + 草稿 PATCH。

---

## 十一、关联文档索引

| 文档 | 用途 |
| --- | --- |
| `docs/photograph-recognition-supplement-prd.md` | 产品状态、流转、写库边界 |
| `docs/photograph-recognition-api-supplement.md` | 三接口契约与 DTO 建议 |
| `docs/photograph-recognition-db-supplement.md` | V015 字段语义说明 |
| `database/migrations/V015__photograph_recognition_supplement.sql` | 增量 DDL |
| `frontend/src/types/photograph.ts` | 前端阶段枚举（对齐用） |

---

**文档版本**：v1.0  
**说明**：清单中勾选框供项目管理复制使用；实施时可将每一项拆为独立 Issue/任务单。
