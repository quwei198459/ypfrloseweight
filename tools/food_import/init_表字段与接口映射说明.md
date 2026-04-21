# init\_ 原始层表字段与 MXNZP 接口映射说明

本文档依据 **mxnzp 食物热量接口** 官方返回参数中文说明，对照 `init_tables.sql` 中的表结构，便于后续迁移到正式业务表（`food` / `food_category` 等）时查阅。

- **渠道标识**：采集脚本固定 `channel_name = 'mxnzp'`。
- **命名约定**：接口多为驼峰（camelCase），入库宽表字段统一为 **snake\_case**；对象/数组整体落在 **JSON** 列，不拆子字段到独立列（除已列出的 `glycemic_info_json`、`cookbook_json`）。

---

## 一、接口一览

| 接口用途 | 方法 | 路径 | 主要请求参数 |
|----------|------|------|----------------|
| 食物分类列表 | GET | `/api/food_heat/type/list` | `app_id`、`app_secret` |
| 分类下食物列表 | GET | `/api/food_heat/food/list` | `id`（分类 id）、`page`、`app_id`、`app_secret` |
| 搜索食物 | GET | `/api/food_heat/food/search` | `keyword`、`page`、`app_id`、`app_secret` |
| 食物详情 | GET | `/api/food_heat/food/details` | `foodId`、`app_id`、`app_secret` |
| 食物图片（批量） | GET | `/api/food_heat/images/list` | `ids`（英文逗号分隔，**最多 10 个** foodId）、`app_id`、`app_secret` |

域名示例：`https://www.mxnzp.com`。

---

## 二、健康等级统一说明

列表/搜索接口字段为 **`healthLevel`**（字符串，取值常为 `1` / `2` / `3`）。  
详情接口文档中同时存在 **`health_light`**（字符串）与 **`healthLight`**（整型）等形态，采集端会兼容多种键名。

| 取值 | 含义（中文） | 入库衍生字段 |
|------|----------------|----------------|
| 1 | 推荐 | `health_level_label` / `health_light_label` = `推荐` |
| 2 | 适量 | `适量` |
| 3 | 少吃 | `少吃` |

---

## 三、表 `init_food_channel_category`

**数据来源**：`/api/food_heat/type/list` 返回列表中的每一项（并整段保留在 `raw_json`）。

| 数据库字段 | 类型 | 接口字段 | 说明 |
|------------|------|----------|------|
| `id` | BIGINT | — | 自增主键 |
| `channel_name` | VARCHAR(32) | — | 固定 `mxnzp` |
| `channel_category_id` | VARCHAR(64) | `id` | 分类 id，后续请求 `food/list` 的 `id` 参数 |
| `channel_category_name` | VARCHAR(255) | `name` | 分类名称 |
| `icon` | VARCHAR(1000) | `icon` | 分类图标 URL |
| `raw_json` | JSON | 整行对象 | 该分类在接口中的原始 JSON |
| `created_at` / `updated_at` | DATETIME | — | 写入/更新时间 |

**唯一约束**：`uk_channel_category (channel_name, channel_category_id)`。

---

## 四、表 `init_food_channel_item`

**数据来源**：  
- 主流程：`/api/food_heat/food/list`（按分类分页）。  
- 补采：`/api/food_heat/food/search`；此时 `channel_category_id` 固定为脚本常量 **`special_search`**（与分类采集区分归属）。

| 数据库字段 | 类型 | 接口字段 | 说明 |
|------------|------|----------|------|
| `id` | BIGINT | — | 自增主键 |
| `channel_name` | VARCHAR(32) | — | 固定 `mxnzp` |
| `channel_food_id` | VARCHAR(64) | `foodId` | 食物 id，用于详情、图片接口 |
| `channel_food_name` | VARCHAR(255) | `name` | 食物名称 |
| `channel_category_id` | VARCHAR(64) | 请求参数 `id` 或补采占位 | 列表采集时为分类 id；搜索补采为 `special_search` |
| `health_level` | VARCHAR(32) | `healthLevel`（兼容 `health_light` / `healthLight`） | 健康等级原始值 |
| `health_level_label` | VARCHAR(32) | 衍生 | `1`→推荐，`2`→适量，`3`→少吃 |
| `cover` | VARCHAR(1000) | `cover` | 食物封面图链接 |
| `calory_desc` | VARCHAR(255) | `calory` | 热量描述，如「千卡/100g」类文案 |
| `raw_json` | JSON | 整行对象 | 列表/搜索单条原始 JSON |
| `source_status` | VARCHAR(32) | — | 采集状态，默认 `success` |
| `imported_at` | DATETIME | — | 本条列表数据写入时间 |
| `created_at` / `updated_at` | DATETIME | — | 记录创建/更新 |

**唯一约束**：`uk_channel_food (channel_name, channel_food_id, channel_category_id)`（同一食物可在不同分类/搜索来源下各存一行）。

---

## 五、表 `init_food_channel_detail`

**数据来源**：`/api/food_heat/food/details`，请求参数 `foodId`。  
详情字段较多：标量以 **字符串** 形式落宽表；**对象**落在 JSON 列。

### 5.1 基础与营养宽表字段（与接口名对照）

| 数据库字段 | 接口字段 | 说明 |
|------------|----------|------|
| `channel_food_id` | `id` 或 `foodId` | 食物 id（与列表 `foodId` 对应） |
| `channel_food_name` | `name` | 食物名称 |
| `health_light` | `health_light` / `healthLight` 等 | 健康等级原始值 |
| `health_light_label` | 衍生 | 同第二节映射 |
| `calory` | `calory` | 热量值 |
| `calory_unit` | `caloryUnit` | 热量单位 |
| `joule` | `joule` | 热量千焦值 |
| `joule_unit` | `jouleUnit` | 千焦等单位说明 |
| `protein` / `protein_unit` | `protein` / `proteinUnit` | 蛋白质值 / 单位 |
| `fat` / `fat_unit` | `fat` / `fatUnit` | 脂肪值 / 单位 |
| `saturated_fat` / `saturated_fat_unit` | `saturatedFat` / `saturatedFatUnit` | 饱和脂肪值 / 单位 |
| `fatty_acid` / `fatty_acid_unit` | `fattyAcid` / `fattyAcidUnit` | 反式脂肪值 / 单位 |
| `mufa` / `mufa_unit` | `mufa` / `mufaUnit` | 单不饱和脂肪值 / 单位 |
| `pufa` / `pufa_unit` | `pufa` / `pufaUnit` | 多不饱和脂肪值 / 单位 |
| `cholesterol` / `cholesterol_unit` | `cholesterol` / `cholesterolUnit` | 胆固醇值 / 单位 |
| `carbohydrate` / `carbohydrate_unit` | `carbohydrate` / `carbohydrateUnit` | 碳水化合物值 / 单位 |
| `sugar` / `sugar_unit` | `sugar` / `sugarUnit` | 糖值 / 单位 |
| `fiber_dietary` / `fiber_dietary_unit` | `fiberDietary` / `fiberDietaryUnit` | 膳食纤维值 / 单位 |
| `natrium` / `natrium_unit` | `natrium` / `natriumUnit` | 钠值 / 单位 |
| `alcohol` / `alcohol_unit` | `alcohol` / `alcoholUnit` | 酒精度值 / 单位 |
| `vitamin_a` / `vitamin_a_unit` | `vitaminA` / `vitaminAUnit` | 维生素 A 值 / 单位 |
| `carotene` / `carotene_unit` | `carotene` / `caroteneUnit` | 胡萝卜素值 / 单位 |
| `vitamin_d` / `vitamin_d_unit` | `vitaminD` / `vitaminDUnit` | 维生素 D 值 / 单位 |
| `vitamin_e` / `vitamin_e_unit` | `vitaminE` / `vitaminEUnit` | 维生素 E 值 / 单位 |
| `vitamin_k` / `vitamin_k_unit` | `vitaminK` / `vitaminKUnit` | 维生素 K 值 / 单位 |
| `thiamine` / `thiamine_unit` | `thiamine` / `thiamineUnit` | 维生素 B1 值 / 单位 |
| `lactoflavin` / `lactoflavin_unit` | `lactoflavin` / `lactoflavinUnit` | 维生素 B2 值 / 单位 |
| `vitamin_b6` / `vitamin_b6_unit` | `vitaminB6` / `vitaminB6Unit` | 维生素 B6 值 / 单位 |
| `vitamin_b12` / `vitamin_b12_unit` | `vitaminB12` / `vitaminB12Unit` | 维生素 B12 值 / 单位 |
| `vitamin_c` / `vitamin_c_unit` | `vitaminC` / `vitaminCUnit` | 维生素 C 值 / 单位 |
| `niacin` / `niacin_unit` | `niacin` / `niacinUnit` | 烟酸值 / 单位 |
| `folacin` / `folacin_unit` | `folacin` / `folacinUnit` | 叶酸值 / 单位 |
| `pantothenic` / `pantothenic_unit` | `pantothenic` / `pantothenicUnit` | 泛酸值 / 单位 |
| `biotin` / `biotin_unit` | `biotin` / `biotinUnit` | 生物素值 / 单位 |
| `choline` / `choline_unit` | `choline` / `cholineUnit` | 胆碱值 / 单位 |
| `phosphor` / `phosphor_unit` | `phosphor` / `phosphorUnit` | 磷值 / 单位 |
| `kalium` / `kalium_unit` | `kalium` / `kaliumUnit` | 钾值 / 单位 |
| `magnesium` / `magnesium_unit` | `magnesium` / `magnesiumUnit` | 镁值 / 单位 |
| `calcium` / `calcium_unit` | `calcium` / `calciumUnit` | 钙值 / 单位 |
| `iron` / `iron_unit` | `iron` / `ironUnit` | 铁值 / 单位 |
| `zinc` / `zinc_unit` | `zinc` / `zincUnit` | 锌值 / 单位 |
| `iodine` / `iodine_unit` | `iodine` / `iodineUnit` | 碘值 / 单位 |
| `selenium` / `selenium_unit` | `selenium` / `seleniumUnit` | 硒值 / 单位 |
| `copper` / `copper_unit` | `copper` / `copperUnit` | 铜值 / 单位 |
| `fluorine` / `fluorine_unit` | `fluorine` / `fluorineUnit` | 氟值 / 单位 |
| `manganese` / `manganese_unit` | `manganese` / `manganeseUnit` | 锰值 / 单位 |

### 5.2 JSON 对象字段

| 数据库字段 | 接口字段 | 说明 |
|------------|----------|------|
| `glycemic_info_json` | `glycemicInfoData` | GI/GL 等信息；常见子结构：`gi` / `gl` 对象，内含 `value`、`lable`（接口文档拼写为 lable）等 |
| `health_tips` | `healthTips` | 健康描述 |
| `health_suggest` | `healthSuggest` | 健康建议 |
| `cookbook_json` | `cookBook` | 菜谱信息：`cookbookName`（菜谱名称）、`majorMaterialsData`（主料数组）、`minorMaterialsData`（辅料数组）、`seasoningData`（配料数组）、`ext`（制作步骤） |

### 5.3 其它列

| 数据库字段 | 说明 |
|------------|------|
| `raw_json` | 接口返回中 `data` 整包或等价完整体的 JSON，便于对账与二次解析 |
| `detail_status` | 采集结果：`success` / `error` 等 |
| `detail_fetched_at` | 成功拉取详情时的时间 |
| `created_at` / `updated_at` | 记录创建/更新 |

**唯一约束**：`uk_food_detail (channel_name, channel_food_id)`。

---

## 六、表 `init_food_channel_image`

**数据来源**：`/api/food_heat/images/list`，参数 `ids` 为英文逗号分隔的 foodId，**单次最多 10 个**。

| 数据库字段 | 类型 | 接口字段 | 说明 |
|------------|------|----------|------|
| `channel_food_id` | VARCHAR(64) | `foodId` | 回显传入的 id |
| `image_url` | VARCHAR(1000) | `image` | 图片链接；若 id 不存在，接口该字段为 **《ID不存在，无图片》**（脚本会置空 URL 并标记状态） |
| `image_status` | VARCHAR(32) | 衍生 | `success`：正常 URL；`invalid_id`：命中「不存在/无图片」类文案；`no_image`：空串或其它无图情况；`api_error`：HTTP/业务失败（如额度 `20009`）或响应中缺少该 id，**占位便于对账**，`only_missing` 批量时会自动重试 |
| `raw_json` | JSON | 单行对象 | 该 foodId 在图片接口返回中的原始 JSON |
| `fetched_at` | DATETIME | — | 拉取时间 |

**唯一约束**：`uk_food_image (channel_name, channel_food_id)`。

---

## 七、表 `init_food_channel_pull_task`

**数据来源**：采集工具对每次 HTTP 调用的自记录，**非** mxnzp 业务返回字段。

| 数据库字段 | 说明 |
|------------|------|
| `api_name` | 如 `type_list`、`food_list`、`food_search`、`food_details`、`images_list` |
| `request_params_json` | 本次请求参数 JSON |
| `page_no` | 分页类接口的页码（若有） |
| `response_code` / `response_msg` | HTTP 或业务包装层信息摘要 |
| `is_success` | 是否判定为成功（含 HTTP 与业务 code） |
| `item_count` | 本次解析到的列表条数等 |
| `response_json` | 响应体 JSON（或错误摘要） |
| `started_at` / `finished_at` | 单次调用起止时间 |

用于排查限流、配额（如业务 `code`）与重跑策略。

---

## 八、迁移到正式表时的使用建议

1. **主键与去重**：正式表通常以业务 `food_id` 为主；`init_food_channel_item` 可能同一 `channel_food_id` 多行（不同 `channel_category_id`），迁移时需定义合并规则（优先详情行、或按分类优先级等）。
2. **数值与单位**：当前宽表多为字符串，迁移时再统一转 DECIMAL 与标准单位。
3. **图片**：`init_food_channel_image` 与列表里的 `cover`、详情无混存，迁移时按产品规则选主图或多图。
4. **JSON 列**：`glycemic_info_json`、`cookbook_json`、`raw_json` 保留渠道原貌，清洗脚本可按需展开。

---

*文档版本与 `tools/food_import/init_tables.sql` 结构保持一致；若改表请先更新本文件。*
