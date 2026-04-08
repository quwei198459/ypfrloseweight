# 餐前拍一拍 · 数据库补充说明

本文档配合 **`database/migrations/V015__photograph_recognition_supplement.sql`**（下称「本迁移」）使用，并承接 **`docs/photograph-recognition-supplement-prd.md`** 中的识图确认、写入餐次、跳转饮食记录等产品规则。

## 迁移文件命名

主仓库中 **`meal_photo_recognition`** 在 **`V012__meal_evaluation_and_photo_recognition.sql`** 才创建，且已存在 **`V006__sport_item_migrate.sql`**。若采用建议名 `V006_photograph_recognition_supplement.sql`，在按文件名排序批量执行时可能 **早于 V012 执行** 而导致 `ALTER TABLE` 失败。因此本迁移使用 **`V015__photograph_recognition_supplement.sql`**，确保在建表之后执行。脚本头部注释中有相同说明。

## 为什么要补这些字段

主表已有 `meal_type`、`recognize_status`、`parsed_result_json` 等，可支撑「调用第三方 + 存原始/解析结果」的 **技术链路**，但对以下 **产品能力** 支撑不足：

1. **推荐餐别 vs 用户最终餐别**：`meal_type` 在现实现中表示「发起识图时端上选中的餐别」，与「服务端按时间推荐」和「确认写入时锁定」易混淆；拆分 **`recommended_meal_type` / `confirmed_meal_type`** 后，审计与对账清晰。  
2. **识别结果 vs 用户编辑结果**：解析 JSON 是真源，但列表、报表、客服常需 **免解析** 的主名称与千卡快照；**`recognized_*` / `confirmed_*`** 成对存放，便于对比「模型给出」与「用户确认」。  
3. **食用比例**：补充 PRD 要求滑杆调节与写入一致；比例落在 **`recommended_eat_ratio` / `confirmed_eat_ratio`**，与 `diet_record` 中实际写入热量可交叉校验。  
4. **确认流状态**：`recognize_status` 仍表示上传/识别技术状态（success/fail 等）；**`confirm_status`** 单独表示用户是否完成「确认写入」业务闭环。  
5. **与正式饮食记录关联**：写入成功后需要稳定关联 **`meal_record` / `diet_record`**，便于从一次识图任务跳转到当日饮食记录、做撤销与统计（**`meal_record_id` / `diet_record_id`**）。  
6. **UI 还原（可选）**：**`badge_progress_percent`** 用于还原用户确认当下圆环/徽章展示的百分比；若团队认为可完全由查询计算，可按迁移头部说明省略该列。

## 字段用途一览（按语义分组）

### 与现有列的关系

| 现有列 | 说明 |
| --- | --- |
| `meal_type` | **保留**：发起识图时用户在界面选中的餐别（与历史数据兼容）。 |
| `parsed_result_json` | 识别解析后的 **完整结构真源**（多食物、坐标等）。 |
| `recognize_status` | 上传/识别 **技术状态**（uploading/recognizing/success/fail）。 |

### 识图原始侧（模型/服务端解析产出）

| 新增列 | 用途 |
| --- | --- |
| `recommended_meal_type` | 服务端按默认规则推荐的餐别，可与用户当前 `meal_type` 对比展示。 |
| `recognized_food_name` | 主展示食物名称快照；多条时仍以 `parsed_result_json` 为准。 |
| `recognized_calories` | 识别基准热量（千卡）快照。 |
| `recommended_eat_ratio` | 产品配置的「推荐吃多少」比例（如 100% → 1.0）。 |

### 用户最终确认侧（点击确定 / 添加到某餐前）

| 新增列 | 用途 |
| --- | --- |
| `confirmed_meal_type` | 用户确认写入的餐别，应与 `meal_record.meal_type` 一致。 |
| `confirmed_food_name` | 用户编辑或选定后的主名称，应与写入的 `diet_record.food_name_snapshot` 等一致。 |
| `confirmed_calories` | 用户确认的最终千卡（含编辑热量 × 食用比例等后的结果，与业务规则一致）。 |
| `confirmed_eat_ratio` | 用户滑杆确认的食用比例。 |
| `confirm_status` | 业务确认流：`none` / `pending_confirm` / `confirmed` / `aborted` 等（具体枚举由研发与产品收口）。 |
| `confirmed_at` | 成功写入餐次的确认为时间点。 |
| `badge_progress_percent` | （可选）当时 UI 上圆环/徽章使用的摄入占预算百分比，用于还原而非替代统计计算。 |

### 与正式饮食记录关联

| 新增列 | 用途 |
| --- | --- |
| `meal_record_id` | 指向本次确认写入的 **`meal_record`**；一单多菜仍只有 **一个餐次头** 时足够串联。 |
| `diet_record_id` | **局限**：一单可能产生 **多条** `diet_record`，单列只能存 **首条或代表行**；完整明细应 **`meal_record_id` + `diet_record.meal_id`** 反查。若未来需要严格一对多，可再增子表或 JSON 列存 id 列表。 |

## 索引与外键

- **`idx_photo_recog_meal_record (meal_record_id)`**：从识图任务反查餐次、做联表展示。  
- **`idx_photo_recog_confirm (user_id, confirm_status, record_date)`**：按用户、确认状态、日期筛列表（如「待确认」「已写入」）。  
- **`idx_photo_recog_confirmed_at (confirmed_at)`**：按确认时间做报表或排序。  
- **外键** `meal_record_id`、`diet_record_id` 使用 **`ON DELETE SET NULL`**，避免删除饮食明细时阻塞识图历史行或产生级联误删；是否允许删餐次由业务策略单独约束。

## 后续建议（非本迁移必选）

1. **Java 实体 `MealPhotoRecognition`**：需增加与上列对应的属性及 Mapper。  
2. **多餐品**：在 `confirm` 接口层将多条 `diet_record` 写入后，至少保证 **`meal_record_id`** 正确；`diet_record_id` 仅作首条或代表行时，应在接口文档中写明。  
3. **confirm_status 枚举**：与 `recognize_status` 组合使用时的状态矩阵（例如识别 success 且 confirm pending）建议在接口文档中画表说明。

---

**文档版本**：v1.0  
**关联**：`docs/photograph-recognition-supplement-prd.md`、`database/migrations/V015__photograph_recognition_supplement.sql`
