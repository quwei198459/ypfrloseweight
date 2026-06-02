# V1.1 功能迭代 PRD：餐前拍一拍多食物识别结果展示与比例调节

## 本次理解

- 需求目标：将“餐前拍一拍”识别成功页从单食物展示升级为多食物展示，支持每个食物独立删除、编辑热量、调整比例，并按最终列表写入饮食记录。
- 主要依据：`需求简要.md`、`pics/调整前.png`、`pics/调整后.png`、当前拍照识别前后端代码。
- 影响范围：`frontend/src/pages/photograph/index.vue`、`usePhotographFlow.ts`、拍照识别组件、`api/recognize.ts`；后端识别确认接口需复核多食物写入逻辑；数据库原则上不新增字段。
- 当前结论：后端已有 `foods[]` 识别出参和 `items[]` 确认入参能力，主要缺口在前端 UI 与状态管理仍按单食物处理。

## 1. 需求来源

### 1.1 简要需求

1. 当前“拍一拍”只支持一种食物展示，但后端 API 支持返回多个食物，需要展示多个食物。
2. 照片上不再展示食物信息，只保留总热量信息。
3. 食物信息改为展示在照片下方；照片和食物列表可上下滚动；底部“取消 / 食物比例调节 / 确定”固定。
4. 每个食物行可删除、可编辑热量；删除或编辑后更新总计值。
5. “食物比例调节”弹层支持多个食物列表，每个食物独立调整比例，弹层固定高度，超出可滚动，顶部实时汇总。

### 1.2 参考资料

- `docs/update/V1.1/需求简要.md`
- `docs/update/V1.1/pics/调整前.png`
- `docs/update/V1.1/pics/调整后.png`

## 2. 当前现状分析

### 2.1 前端现状

| 模块 | 文件 | 当前表现 | 问题 |
| --- | --- | --- | --- |
| 拍照页 | `frontend/src/pages/photograph/index.vue` | 成功态只取 `primaryFood = foods[0]` | 多食物未展示 |
| 状态流 | `frontend/src/composables/usePhotographFlow.ts` | `mockResult.foods` 已是数组，但编辑和比例仍偏单值 | 交互粒度不满足需求 |
| 预览卡片 | `CameraPreviewCard.vue` | 成功态在照片上叠加 `RecognitionFoodCard` | 多食物空间不足，需移到照片下方 |
| 食物卡片 | `RecognitionFoodCard.vue` | 单卡片展示，含编辑/删除入口 | 删除未真正接入；样式可复用为列表项参考 |
| 比例弹层 | `RatioAdjustSheet.vue` | 只接收一个食物和一个 `ratioPercent` | 需改为多食物列表和多 slider |
| 识别 API | `api/recognize.ts` | 类型已支持 `foods[]`、`items[]` | 前端消费不足 |

### 2.2 后端现状

| 模块 | 文件 | 当前能力 | 结论 |
| --- | --- | --- | --- |
| 识别接口 | `MealPhotoRecognizeController.java` | `POST /api/v1/recognize/meal-photo` 返回 `MealPhotoRecognizeResultVo` | 路径无需新增 |
| 识别服务 | `MealPhotoRecognizeService.java` | `submit()` 解析并返回 `foods[]` | 已支持多食物出参 |
| 确认服务 | `MealPhotoRecognizeService.java` | `confirm()` 遍历 `items[]` 写入多条 `diet_record` | 已具备多食物落库基础 |
| 解析器 | `MealPhotoAliyunJsonParser.java` | 支持解析数组、`data.items`、深层 food 节点 | 需联调确认供应商真实多食物结构 |
| DTO | `MealPhotoFoodItemVo.java`、`MealPhotoConfirmItemDto.java` | 支持 `lineId/foodName/calories/foodId/confirmedCalories/confirmedEatRatio` | 字段基本满足本次需求 |

### 2.3 数据库现状

当前可承载本次需求：

- `meal_photo_recognition.parsed_result_json`：保存识别候选食物 JSON。
- `meal_record`：保存一次确认后的餐次头、总热量、食物数量。
- `diet_record`：保存每个确认食物明细。
- `daily_summary`：确认后由服务刷新。

本次核心功能不要求新增表或字段。

## 3. 本次目标

### 3.1 业务目标

- 让拍照识别支持混合餐盘、多菜品场景。
- 降低用户手动补录成本。
- 提高拍照识别结果确认和写入准确度。

### 3.2 用户体验目标

- 用户能看到所有识别食物。
- 用户能删除误识别食物。
- 用户能修改单个食物热量。
- 用户能逐项调整食用比例。
- 用户确认前能看到本次总热量实时变化。
- 底部主操作按钮固定，不被滚动内容挤走。

### 3.3 技术目标

- 不新增接口路径。
- 不改统一响应结构。
- 不新增数据库迁移脚本。
- 优先复用现有 `foods[]`、`items[]` 数据结构。
- 不影响单食物识别和失败态流程。

## 4. 需求范围

### 4.1 本次包含

#### 前端

1. 成功态页面结构调整：照片 + 食物列表进入可滚动内容区。
2. 照片上移除单食物卡片，只保留总热量模块。
3. 照片下方展示多食物列表。
4. 食物行支持删除。
5. 食物行支持点击编辑当前食物热量。
6. 删除/编辑后实时更新总热量。
7. 底部“取消 / 食物比例调节 / 确定”固定。
8. 比例调节弹层支持多食物列表和每食物独立 slider。
9. 弹层顶部实时汇总调整后的本次总热量。
10. 确认时按当前有效食物列表提交 `items[]`。

#### 后端

1. 复核识别接口多食物返回。
2. 复核确认接口多 `items[]` 写入。
3. 保持多食物写入：一条 `meal_record` + 多条 `diet_record`。
4. 保持 `daily_summary` 刷新。
5. 保持现有鉴权、错误处理和统一响应。

#### 数据库

- 不新增表。
- 不新增字段。
- 不新增迁移脚本。

### 4.2 本次不包含

- 不新增拍照识别供应商。
- 不新增管理后台识别记录详情页。
- 不新增食物图片匹配能力。
- 不调整首页、每日记录页、搜索页等无关页面。
- 不改变微信登录/JWT 认证体系。
- 不新增第三方依赖。

## 5. 用户流程

### 5.1 调整前流程

```text
拍照/相册 -> 识别中 -> 成功页照片上显示单个食物卡片 -> 编辑总热量或单比例 -> 确认写入
```

### 5.2 调整后流程

```text
拍照/相册
 -> 识别中
 -> 成功页：照片显示总热量，照片下方显示多食物列表
 -> 用户删除误识别食物 / 编辑单个食物热量
 -> 用户打开比例调节弹层，逐项调整比例
 -> 顶部汇总实时变化
 -> 确认
 -> 前端提交 items[]
 -> 后端写入 meal_record + 多条 diet_record
 -> 跳转每日记录页
```

### 5.3 异常流程

| 场景 | 处理规则 |
| --- | --- |
| 识别失败 | 保持当前失败态，可退出或继续拍照 |
| 返回空 `foods[]` | 展示空状态，禁止确认，引导重新拍照 |
| 删除到 0 条 | 禁止确认，提示“至少保留 1 个食物” |
| 编辑热量非法 | 提示“请输入有效热量” |
| 单个比例为 0 | 可保留展示；确认时建议过滤 0 热量项 |
| 全部比例为 0 | 禁止确认，提示至少保留 1 个有效食物 |
| 确认接口失败 | toast 提示错误，保留当前识别结果 |

## 6. 前端页面调整

### 6.1 涉及页面

| 页面 | 文件 | 调整 |
| --- | --- | --- |
| 餐前拍一拍 | `frontend/src/pages/photograph/index.vue` | 成功态布局、滚动区、列表、按钮固定、弹层调用 |

### 6.2 调整后结构

```text
photograph-page
  photograph-page__body
    PhotographPageHeader
    MealTypeTrigger / MealTypeDropdown
    success-scroll-view（仅成功态）
      CameraPreviewCard
        图片
        HeatSummaryModule（总热量）
      RecognitionFoodListItem x N
    success-bot（固定底部）
      取消
      食物比例调节
      确定
  CalorieEditModal（编辑当前食物热量）
  RatioAdjustSheet（多食物比例调节）
```

### 6.3 页面布局要求

- 初始态、识别中、失败态尽量保持现状。
- 成功态中，照片和食物列表放入滚动区。
- 底部三按钮固定在底部，不进入滚动区。
- 滚动区底部预留按钮高度和 `safe-area-inset-bottom`。
- 真机体验版需验证 `scroll-view` 高度，根容器继续保持 `height: 100vh`。

### 6.4 照片区域

- 移除照片上叠加的 `RecognitionFoodCard`。
- 保留 `HeatSummaryModule` 展示总热量和推荐比例。
- 总热量 = 当前有效食物热量求和。
- 删除、编辑、比例调整后，总热量应同步更新。

### 6.5 食物列表

建议新增组件：

```text
frontend/src/components/photograph/RecognitionFoodListItem.vue
```

每行展示：

- 食物名称。
- 热量，单位“千卡”。
- GI 标签：接口返回 `giLabel` 时展示；如果没有值或为空，前端不显示 GI 标签，不做默认文案兜底。
- 编辑入口。
- 删除入口。

交互：

- 点击编辑：打开 `CalorieEditModal`，编辑当前行热量。
- 点击删除：删除当前行并更新总热量。
- 食物顺序：保持后端返回顺序。

### 6.6 热量编辑

当前 `confirmCalorieEdit()` 是编辑总热量并分摊到所有食物。本次应调整为：

- 记录当前编辑食物 `lineId`。
- 弹窗确认后只更新该食物 `calories`。
- 不再自动分摊到其他食物。
- 更新后重新计算总热量。

### 6.7 比例调节弹层

`RatioAdjustSheet.vue` 当前单食物结构需改为多食物结构。

调整后要求：

- props 接收 `foods[]` 和每个食物的比例。
- 每个食物展示独立 slider。
- 弹层高度固定，建议最大 `88vh`。
- 食物列表区域单独滚动。
- 顶部展示实时汇总：文案确定为“本次预计摄入 xx 千卡”。
- 弹层食物列表不展示图片，也不保留图片占位。
- 单项调整后：该食物调整后热量 = 基准热量 × 比例。
- 顶部汇总 = 所有食物调整后热量求和。

比例默认值已确认：

- 采用方案 A：每个食物默认 100%。
- 不使用后端 `recommendedEatRatio` 作为每个食物的默认比例，避免把“推荐吃比例”误用为所有食物的真实食用比例。

### 6.8 确认写入

确认时前端构造：

```json
{
  "photoJobId": 1,
  "confirmedMealType": "lunch",
  "recordDate": "2026-05-06",
  "items": [
    {
      "lineId": "1",
      "foodId": 100,
      "confirmedFoodName": "米饭",
      "confirmedCalories": 220,
      "confirmedEatRatio": 1
    }
  ]
}
```

规则：

- 删除的食物不提交。
- 0 热量食物不提交。
- 全部无有效食物时不请求后端。
- `confirmedCalories` 使用编辑和比例调整后的最终热量。

### 6.9 样式要求

必须保持当前小程序风格：

- 背景延续 `#f7f8f7`。
- 主色延续绿色系。
- 卡片使用白底、浅边框、圆角。
- 按钮顺序和样式保持当前三按钮风格。
- 不做与参考图无关的美化。
- 不改无关页面样式。

## 7. 后端接口调整

### 7.1 涉及接口

| 接口 | 方法 | 本次要求 |
| --- | --- | --- |
| `/api/v1/recognize/meal-photo` | POST | 保持不变，稳定返回多食物 `foods[]` |
| `/api/v1/recognize/meal-photo/result` | GET | 保持不变，返回完整 `foods[]` |
| `/api/v1/recognize/meal-photo/confirm` | POST | 保持不变，接收多条 `items[]` 并落库 |

### 7.2 字段说明

#### 识别结果 `foods[]`

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `lineId` | string | 食物行唯一标识，用于编辑、删除、确认 |
| `foodName` | string | 食物名称 |
| `calories` | number | 基准热量，单位千卡 |
| `giLabel` | string | GI 标签；接口有值时前端展示，无值或空值时前端不显示该标签 |
| `foodId` | number | 食物库 ID，可空 |
| `weightG` | number | 识别重量，可空，本次不强依赖 |

#### 确认入参 `items[]`

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `lineId` | string | 对应识别食物行 |
| `foodId` | number | 食物库 ID，可空 |
| `confirmedFoodName` | string | 最终确认食物名称 |
| `confirmedCalories` | number | 最终写入热量，必须大于 0 |
| `confirmedEatRatio` | number | 当前食物食用比例，0~1 |

### 7.3 后端逻辑要求

当前 `MealPhotoRecognizeService.confirm()` 已支持：

- 创建一条 `meal_record`。
- 遍历 `items` 写入多条 `diet_record`。
- `meal.foodCount = items.size()`。
- `meal.totalCalories = sum(items.confirmedCalories)`。
- 返回全部 `dietRecordIds`。

本次后端重点是复核与联调，不建议大改。

需要确认：

1. 多条 items 写入结果正确。
2. `dietRecordIds` 返回完整。
3. 日汇总刷新正确。
4. `confirmedCalories <= 0` 时拒绝。
5. `items` 为空时拒绝。
6. 非本人任务不能确认。

### 7.4 兼容性说明

- 不改接口路径。
- 不改统一响应体。
- 不删除字段。
- 单食物场景仍作为 `foods.length === 1` 处理。
- 老数据中 `parsed_result_json` 为空时，前端做空状态兼容。

## 8. 数据库调整

### 8.1 是否涉及数据库

本次不涉及数据库表结构调整，不需要新增迁移脚本。

### 8.2 原因

当前表结构已能承载需求：

| 表 | 用途 |
| --- | --- |
| `meal_photo_recognition` | 保存识图任务、原始响应、解析 JSON、确认状态 |
| `meal_record` | 保存确认后的餐次头、总热量、食物数量 |
| `diet_record` | 每个确认食物写入一条明细 |
| `daily_summary` | 确认后刷新日汇总 |

### 8.3 注意事项

- `meal_photo_recognition.confirmed_eat_ratio` 当前只能表达单值，不适合作为多食物逐项比例的完整来源。
- 本次确认后的最终热量以 `diet_record.calories_total` 为准。
- 如未来需要审计每个食物比例，可另行新增 `diet_record.confirmed_eat_ratio` 或 `meal_photo_recognition.confirmed_items_json`，不纳入本次。

## 9. 管理后台影响

本次不涉及管理后台调整。

不修改：

- `admin-frontend/src/views/**`
- `admin-frontend/src/api/**`
- 管理后台路由和权限。

## 10. 验收标准

### 10.1 前端验收

1. 后端返回多个食物时，前端完整展示所有食物。
2. 照片上不再展示单食物卡片。
3. 照片区域保留总热量信息。
4. 食物列表展示在照片下方。
5. 照片和列表可上下滚动。
6. 底部三按钮固定。
7. 删除食物后，总热量实时更新。
8. 编辑某个食物热量后，仅该项更新，总热量实时更新。
9. 比例弹层展示所有食物。
10. 每个食物可独立调比例。
11. 弹层顶部汇总实时更新。
12. 弹层内容超出时可滚动。
13. 确认后按有效食物列表提交。
14. 真机体验版页面不空白、不遮挡。

### 10.2 后端验收

1. 识别接口返回 `foods[]` 多条数据。
2. 确认接口接收多条 `items[]`。
3. 多食物确认后创建 1 条 `meal_record`。
4. 写入多条 `diet_record`。
5. `meal_record.food_count` 与有效食物数量一致。
6. `meal_record.total_calories` 与明细热量总和一致。
7. 返回全部 `dietRecordIds`。
8. 日汇总刷新后首页/每日记录数据正确。
9. 后端需在识别结果入库和返回前过滤明显非食物的营养素项，例如 `碳水化合物`、`蛋白质`、`脂肪`、`膳食纤维`，避免其进入 `foods[]`、`parsed_result_json` 和后续确认写库。

### 10.3 数据库验收

1. 不新增迁移脚本。
2. 多食物确认后，`meal_record` 和 `diet_record` 数据一致。
3. 被删除食物不写入 `diet_record`。
4. 编辑或比例调整后的热量按最终值写入。

## 11. 测试用例

| 用例 | 操作 | 预期 |
| --- | --- | --- |
| 单食物识别 | 返回 1 个食物后确认 | 写入 1 条明细 |
| 多食物识别 | 返回 3 个食物后确认 | 展示 3 条，写入 3 条明细 |
| 删除食物 | 删除 1 条后确认 | 只写入剩余食物，总热量更新 |
| 编辑热量 | 编辑第 1 个食物热量后确认 | 第 1 条按新热量写入 |
| 比例调节 | 分别调整多个食物比例后确认 | 按比例后的热量写入 |
| 删除到 0 条 | 删除全部后点确定 | 不请求后端，提示至少保留 1 个食物 |
| 识别失败 | 供应商失败或网络失败 | 保持失败态，可继续拍照 |
| 非食物营养素过滤 | 识别结果包含“碳水化合物/蛋白质/脂肪/膳食纤维”等项 | 后端过滤，不在食物列表展示，也不写入饮食记录 |
| 真机体验版 | 上传体验版扫码 | 页面正常展示，按钮不遮挡 |

## 12. 风险与注意事项

1. 当前前端 `foods[]` 已存在，但 UI 只用 `primaryFood`，实现时需彻底替换单食物依赖。
2. 当前热量编辑是编辑总热量并分摊，本次需改成编辑单项。
3. 当前比例是单值 `ratioPercent`，需改为按 `lineId` 管理的多值。
4. 弹层固定高度和滚动区域需真机验证。
5. 后端 `confirmed_eat_ratio` 单字段不能完整表达多食物比例，本次不依赖该字段。
6. 如果供应商返回结构不稳定，解析器可能生成占位食物，需要联调覆盖。
7. 供应商可能把营养素或成分项混入食物候选列表，后端需做保守过滤；首批采用精确名称过滤，避免误伤“高蛋白奶昔”“低脂牛奶”等真实食物名称。

## 13. 已确认事项

1. 比例弹层中每个食物默认比例采用 100%。
2. 弹层顶部汇总文案确定为“本次预计摄入 xx 千卡”。
3. 食物比例调整弹层中的食物列表不展示图片，去除图片占位。
4. 删除最后一条食物时，允许删除，但禁止确认提交，并提示至少保留 1 个食物。
5. 单个食物比例为 0 时，确认提交时过滤该项。
6. 热量编辑展示整数，提交时可保留两位小数。
7. GI 标签由接口返回决定：有值则显示，无值或空值则不显示，前端不做“低 GI”等默认文案兜底。
8. 识别返回的 `foods[]` 只允许包含真实食物；`碳水化合物`、`蛋白质`、`脂肪`、`膳食纤维` 等营养素项由后端过滤，不交由前端兜底处理。

## 14. 开发拆解建议

### 14.1 前端任务

1. `usePhotographFlow.ts` 增加：删除食物、编辑单食物热量、多食物比例、构造确认 items。
2. `photograph/index.vue` 调整成功态布局，新增滚动区和食物列表。
3. `CameraPreviewCard.vue` 成功态移除照片上的单食物卡片。
4. 新增或改造食物列表项组件。
5. 改造 `RatioAdjustSheet.vue` 为多食物比例列表。
6. 确认写入时过滤无效食物。
7. 进行微信开发者工具和真机体验版验证。

### 14.2 后端任务

1. 复核 `MealPhotoAliyunJsonParser` 对多食物响应的解析。
2. 在识别结果解析后、`parsed_result_json` 入库前过滤非食物营养素项，首批过滤：`碳水化合物`、`蛋白质`、`脂肪`、`膳食纤维`。
3. 过滤后重新计算 `totalRecognizedCalories` 和进度百分比，确保只统计真实食物热量。
4. 复核 `MealPhotoRecognizeService.confirm()` 多 items 写入逻辑。
5. 联调确认 `dietRecordIds` 返回完整。
6. 不新增数据库迁移。

### 14.3 联调 SQL

```sql
SELECT id, user_id, record_date, meal_type, total_calories, food_count
FROM meal_record
WHERE user_id = ?
ORDER BY id DESC
LIMIT 5;

SELECT id, meal_id, food_name_snapshot, calories_total, source
FROM diet_record
WHERE meal_id = ?
ORDER BY id ASC;
```

## 15. 本次不修改范围

- 不改登录认证。
- 不改接口统一响应。
- 不改数据库表结构。
- 不改管理后台。
- 不改非拍照识别页面。
- 不新增第三方依赖。
