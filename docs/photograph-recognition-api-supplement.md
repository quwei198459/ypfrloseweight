# 餐前拍一拍接口补充方案

> **文档性质**：基于 **`docs/photograph-recognition-supplement-prd.md`**（补充 PRD）与 **`database/migrations/V015__photograph_recognition_supplement.sql`**（库表增量），对三条识图相关接口做 **契约级补充设计**。  
> **本文档不修改代码**，供前后端对齐后分阶段实现。

**路径说明**：主 PRD §十一·I 约定路径为 `/api/recognize/meal-photo` 等；当前仓库实现为 **`POST /api/v1/food/recognize`**（`FoodRecognizeController`），返回结构为联调用的 `httpStatus` + `body` 字符串。落地时建议 **统一归一到 PRD 路径与下文物模型**，或保留 v1 路径但 **语义与本文一致**。

### 本文结构（对照输出要求）

| 要求项 | 在本文中的位置 |
| --- | --- |
| A. 当前接口职责 | 各节 **§A**（§1～§3） |
| B. 建议新增入参 | 各节 **§B** |
| C. 建议新增出参 | 各节 **§C** |
| D. DTO / VO 是否调整 | 各节 **§D** |
| E. Service 是否调整 | 各节 **§E** |
| F. badgeProgressPercent 等是否返回前端 | 各节 **§F** + POST/GET 结论为 **建议返回** |
| 识图成功页五类展示（名称/热量/GI/圆环/推荐比例） | §1 **§C**「成功态结构化」+ 文末 **对应关系简表** |
| confirm：`confirmedCalories` / `confirmedMealType` / `confirmedEatRatio` | §3 **§B**、**§C** |
| 避免前端复杂拼装 | **总原则** §1 + §1 **§C**（预算快照与 `foods[]` 同源） |

---

## 总原则

1. **服务端为展示真源**：识图成功页需要的「名称、热量、GI、圆环进度、推荐吃比例」等，应在 **`meal-photo` 提交/轮询结果** 接口中 **结构化返回**，避免前端解析第三方原始 JSON、避免前端重复实现「当日预算 / 已摄入」口径。  
2. **确认写库以用户最终态为准**：`confirm` 必须显式接收 **`confirmedMealType`、`confirmedCalories`（按条或按单）、`confirmedEatRatio`**，并与 **`meal_record` / `diet_record`** 写入及 **`meal_photo_recognition`** 确认字段回填一致（见 V015 列）。  
3. **状态可观测**：`recognizeStatus`（技术态）与 `confirmStatus`（业务态）并存；细粒度识图阶段可用 `recognizePhase` 与补充 PRD 中 `uploading / recognizing_type / recognizing_weight` 对齐。

---

## 1. `POST /api/recognize/meal-photo`

### A. 当前接口职责（目标职责 + 现状对照）

| 维度 | 目标职责（补充 PRD / 主 PRD） | 当前代码现状（参考） |
| --- | --- | --- |
| 定位 | 接收图片（或已上传 URL），创建识图任务，落 `meal_photo_recognition`，异步/同步调用阿里云，返回 **任务 ID + 初始状态** | 同步调阿里云，`insert` 一行后直接返回 **HTTP 状态 + 原始 body 字符串** |
| 侧车数据 | 应记录 `source`、`meal_type`、`record_date`，并可在成功后写入 **`recommended_meal_type`** 等（V015） | 固定 `meal_type=snack`、`source=camera`，无 `record_date` 入参 |
| 前端体验 | 支撑上传中 → 识别中多阶段 UI | 无阶段字段、无结构化食物列表 |

**结论**：该接口在「产品完备形态」下职责应是：**创建 `photoJobId`、持久化请求上下文、触发识别流水线、返回足够前端展示/轮询的结构**；与现状差距大，属于 **重构级** 扩展，而非小改。

### B. 建议新增入参

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `source` | string | 建议必填 | `camera` / `album`，与主 PRD 一致 |
| `mealType` | string | 否 | 用户当前在端上选中的餐别；缺省时服务端按补充 PRD §E **默认推荐** 写入 `recommended_meal_type` 并可同步写 `meal_type` |
| `recordDate` | date | 否 | 默认用户时区当日；用于与 `daily_summary` 同口径算圆环 |
| `clientTimezone` / `utcOffsetMinutes` | string / int | 否 | 与「当日」边界、推荐餐别一致时使用 |
| 图片载体 | multipart `file` 或 `imageUrl` 或 `imageBase64` | 三选一 | 与网关、OSS 策略统一；**不建议** 长期把大 base64 放 JSON |

**说明**：若识别改为 **纯异步**，本接口可只返回 `photoJobId` + `recognizeStatus=uploading`，具体食物字段全部由 **`GET .../result`** 补齐。

### C. 建议新增出参

除错误码/消息外，成功体建议至少包含：

| 字段 | 说明 |
| --- | --- |
| `photoJobId` | 对应 `meal_photo_recognition.id`，后续 result/confirm 主键 |
| `recognizeStatus` | `uploading` / `recognizing` / `success` / `fail` |
| `recognizePhase` | 可选：`uploading` / `recognizing_type` / `recognizing_weight`，与补充 PRD 三阶段文案对齐 |
| `imageUrl` / `previewUrl` | 已落库可访问的预览地址（成功/失败态 UI 需要） |
| `recommendedMealType` | 服务端推荐餐别（可与请求 `mealType` 不同，用于提示「已为您推荐晚餐」等） |
| **当 `recognizeStatus=success` 时** | 见下节「成功态结构化 `foods` + 汇总字段」 |

**成功态结构化（与前端展示强相关，避免前端拼装）**

| 字段 | 说明 |
| --- | --- |
| `foods` | 数组，每项至少：`foodId?`、`foodName`、`calories`（基准千卡）、`giLevel` 或 `giLabel`（如低 GI）、`weightG?`、`sortOrder` |
| `recommendedEatRatio` | decimal，建议 **0～1**（如 `1` = 推荐吃 100%），与库 `recommended_eat_ratio` 一致 |
| `intakeCaloriesToday` | decimal | 当日已记录摄入（与饮食记录、汇总表同源） |
| `dailyBudgetCalories` | decimal | 当日饮食热量预算（与首页/还可吃同源） |
| `badgeProgressPercent` | decimal | **0～100**，服务端按统一公式计算，表示圆环/徽章进度（如 `min(100, intakeAfterMeal / budget * 100)` 或产品给定定义） |
| `totalRecognizedCalories` | decimal | 可选，本张图识别结果总热量（多食物时便于总条展示） |
| `confirmStatus` | string | 建议默认 `none` 或 `pending_confirm`，与库 `confirm_status` 一致，前端可禁用重复提交 |

**失败态**

| 字段 | 说明 |
| --- | --- |
| `errorCode` / `errorMessage` | 用户可读 + 研发排查 |
| `recognizeStatus=fail` | 不写 `meal_record`/`diet_record`，仅识图记录 |

### D. 是否需要 DTO / VO 调整

**需要**。现状 `FoodRecognizeRequest/Response` 无法承载业务；建议拆分例如：

- **入参 DTO**：`MealPhotoRecognizeSubmitRequest`（图片字段 + `source` + `mealType` + `recordDate` + 可选时区）。  
- **出参 VO**：`MealPhotoRecognizeSubmitResponse`（任务 ID、状态、阶段、错误、**内嵌** `MealPhotoFoodItemVO` 列表、**内嵌** `MealPhotoBudgetSnapshotVO`：`intakeCaloriesToday`、`dailyBudgetCalories`、`badgeProgressPercent`、`recommendedEatRatio`）。

避免继续把第三方 `body` 整串给前端作为「正式契约」。

### E. 是否需要 Service 层调整

**需要**。至少包括：

1. 写入 **`meal_photo_recognition`** 时填充 **V015 新列**（能确定的先写，如 `recommended_meal_type`）。  
2. 识别成功后 **解析标准化 `foods[]`**，写入 `parsed_result_json`，并同步 **`recognized_food_name` / `recognized_calories`** 等快照列（主展示行策略需定：首条、合并名、或仅多食物时不填名单列）。  
3. 调用 **`CalorieBudgetCalculator` / DailySummary 查询**，计算 **`intakeCaloriesToday`、`dailyBudgetCalories`、`badgeProgressPercent`**，保证与「每日饮食记录」页同源。  
4. 若异步：本 Service 负责 **状态机迁移**（uploading → recognizing → success/fail）与 **并发安全**（同一 `photoJobId` 更新）。

### F. 是否要把 `badgeProgressPercent` / `recommendedEatRatio` / `confirmStatus` 返回前端

| 字段 | 是否返回 | 理由 |
| --- | --- | --- |
| `recommendedEatRatio` | **是** | 产品明确「推荐吃比例」；服务端可统一默认 1 或按规则，前端直接展示，避免硬编码 |
| `badgeProgressPercent` | **是** | 圆环进度依赖 **预算 + 已摄入 + 本餐识别热量** 等，口径必须在服务端统一，否则与首页/饮食页不一致 |
| `confirmStatus` | **是（建议）** | 轮询 `result` 时可知是否已 confirm；防止重复写入；历史列表也可展示 |

---

## 2. `GET /api/recognize/meal-photo/result`

### A. 当前接口职责

**目标职责**：按 `photoJobId` 查询 **最新识别结果与技术状态**，供前端轮询或进入页面恢复。  
**现状**：代码中 **未实现**；前端若仅有 POST 返回的原始字符串，无法支撑补充 PRD 状态机。

### B. 建议新增入参

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `photoJobId` | long/string | 是 | 与 POST 一致 |

可选：`lastKnownUpdatedAt` 用于缓存协商（非必须 v1）。

### C. 建议新增出参

**建议与 POST 在 `success` 时的成功体 **同构**（或可嵌入同一 `MealPhotoRecognizeResultVO`）**，包括：

- `photoJobId`、`recognizeStatus`、`recognizePhase`  
- `imageUrl` / `previewUrl`  
- `foods[]`（`foodName`、`calories`、`giLevel`…）  
- `recommendedMealType`、`mealType`（发起时选中）  
- `recommendedEatRatio`  
- `intakeCaloriesToday`、`dailyBudgetCalories`、`badgeProgressPercent`  
- `confirmStatus`、`confirmedAt?`（若已 confirm 可返回只读快照，避免前端再查库）  

**说明**：`badgeProgressPercent` 在轮询过程中若 **随识别结果变化**（例如展示「若本餐按 100% 吃进去的预测占比」），应在文档中固定一种 **产品定义**；每次 result 返回 **当前服务端计算值** 即可。

### D. 是否需要 DTO / VO 调整

**需要**。单独定义 **`MealPhotoRecognizeResultResponse`**（或与 POST 共用 VO + 枚举区分场景），**禁止**仅返回 `parsed_result_json` 字符串由前端解析。

### E. 是否需要 Service 层调整

**需要**。实现按 ID 查询、权限校验（仅本人 `user_id`）、组装 VO、必要时 **重新计算预算快照**（若当日摄入在轮询期间被其他入口修改）。

### F. `badgeProgressPercent` / `recommendedEatRatio` / `confirmStatus`

与第 1 节一致：**均应返回**，保证 result 单接口即可 **渲染成功态整页**（含圆环与推荐比例）。

---

## 3. `POST /api/recognize/meal-photo/confirm`

### A. 当前接口职责

**目标职责**：用户确认（含编辑热量、切换餐别、调节食用比例）后，**写入 `meal_record` / `diet_record`**，回填 **`meal_photo_recognition`** 的确认列与关联 ID，并返回写入结果及可选 **刷新后的汇总**。  
**现状**：代码中 **未实现**。

### B. 建议新增入参

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `photoJobId` | long/string | 是 | 关联识图任务 |
| `confirmedMealType` | string | 是 | 用户最终餐别，与补充 PRD 一致；写入 `meal_record`/`diet_record` 及 `confirmed_meal_type` |
| `recordDate` | date | 否 | 默认与任务一致 |
| `items` | array | 是 | 与识别食物条目对应（见下） |

**`items[]` 每项建议（满足「热量可编辑、比例可调节」）**

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `lineId` / `foodIndex` | string/int | 建议必填 | 与 `foods` 列表或解析 JSON 中的稳定序号对应，避免仅按名称匹配 |
| `foodId` | long | 否 | |
| `confirmedFoodName` | string | 否 | 用户改过名则传；否则服务端用识别名 |
| `confirmedCalories` | decimal | 是 | **编辑后、且已乘食用比例后的最终千卡**（推荐，前端最简单） |
| `confirmedEatRatio` | decimal | 否 | **0～1**；若 `confirmedCalories` 已为最终值，本字段可用于 **审计与回写 V015**；若希望服务端算最终热量，则需在 PRD 中约定二选一主策略 |

**推荐一种契约（减少歧义）**：

- **方案 A（推荐）**：`confirmedCalories` = **最终写入 `diet_record.calories_total` 的值**；`confirmedEatRatio` 一并上传用于 **`confirmed_eat_ratio` 快照** 与校验。  
- **方案 B**：上传「基准热量 + 比例」，由服务端计算最终热量——仍须在响应里返回 **实际写入值**，避免前端与库不一致。

**多食物**：`items.length > 1` 时，`meal_photo_recognition.diet_record_id` 仅能指首条（V015 文档已说明），服务端应 **以 `meal_record_id` 为主关联**。

### C. 建议新增出参

| 字段 | 说明 |
| --- | --- |
| `mealRecordId` | |
| `dietRecordIds` | 数组 |
| `confirmStatus` | 固定返回 `confirmed` |
| `confirmedAt` | |
| `dailySummary` 或 `intakeCaloriesToday` 等 | 可选，便于跳转「每日饮食记录」后立即刷新，无需再调多个接口 |

### D. 是否需要 DTO / VO 调整

**需要**。`MealPhotoConfirmRequest`（含 `List<MealPhotoConfirmItemDTO>`）、`MealPhotoConfirmResponse`。

### E. 是否需要 Service 层调整

**需要**。核心事务逻辑：

1. 校验 `photoJobId` 归属、`recognizeStatus=success`、**幂等**（`confirmStatus` 已为 `confirmed` 时拒绝或返回已有结果）。  
2. 合并/创建 `meal_record`（同用户、同 `recordDate`、同 `confirmedMealType` 策略需产品定：合并 draft 或新建）。  
3. 插入一条或多条 `diet_record`，`source=photo`。  
4. 更新 `meal_photo_recognition`：**`confirmed_*`、V015 关联字段、`confirm_status`、`confirmed_at`**。  
5. 触发 **日汇总重算**（与主 PRD §12.3 一致）。

### F. `badgeProgressPercent` / `recommendedEatRatio` / `confirmStatus`

| 字段 | 是否在 confirm 响应中返回 |
| --- | --- |
| `confirmStatus` | **是**（`confirmed`） |
| `badgeProgressPercent` | **建议返回（写入后新值）** | 用户跳转饮食页前可短暂展示「已更新后的圆环」；若前端只跳转不展示，可省略 |
| `recommendedEatRatio` | **可选** | 确认后 UI 弱相关；若响应带 `dailySummary` 即可 |

---

## 汇总表：三接口扩展必要性

| 接口 | 入参扩展 | 出参扩展 | DTO/VO | Service |
| --- | --- | --- | --- | --- |
| POST meal-photo | **必须**（source、餐别、日期、图片规范） | **必须**（结构化成功/失败 + 预算快照 + 推荐比例） | **必须** | **必须** |
| GET …/result | **必须**（photoJobId） | **必须**（与成功态同构） | **必须** | **必须** |
| POST …/confirm | **必须**（confirmedMealType、items.confirmedCalories、confirmedEatRatio 等） | **必须**（餐次 ID、明细 ID、状态、可选汇总） | **必须** | **必须** |

---

## 与补充 PRD、V015 的对应关系（简表）

| 前端展示需求 | 主要依赖接口与字段 |
| --- | --- |
| 食物名称、热量、GI | `foods[].foodName` / `calories` / `giLevel`（POST 或 GET result） |
| 热量圆圈进度 | `badgeProgressPercent` +（可选）`intakeCaloriesToday`、`dailyBudgetCalories` |
| 推荐吃比例 | `recommendedEatRatio`（可与 `foods` 同行或顶层） |
| 热量编辑后写入 | confirm.`items[].confirmedCalories`（+ 比例字段） |
| 餐别切换后写入 | confirm.`confirmedMealType` |
| 食用比例调节 | confirm.`items[].confirmedEatRatio`（与热量最终值策略一致） |

---

## 风险与决策点（实现前需产品拍板）

1. **`badgeProgressPercent` 定义**：是「当前已摄入/预算」还是「假设本餐吃完后的预测占比」——必须在 PRD 写死，否则前后端与 UI 易分歧。  
2. **`confirmedCalories` 是否含比例**：建议 **含**，前端实现成本最低；比例列专用于 **审计与展示回滚**。  
3. **同餐别合并**：confirm 时是否合并到当日已有 `meal_record`（draft/submitted）——影响 `meal_record_id` 复用规则。  
4. **路径统一**：`/api/recognize/...` 与现有 `/api/v1/food/recognize` 的兼容策略（版本、网关、小程序域名）。

---

**文档版本**：v1.1（增补结构导航表，正文分析不变）  
**关联**：`docs/photograph-recognition-supplement-prd.md`、`database/migrations/V015__photograph_recognition_supplement.sql`
