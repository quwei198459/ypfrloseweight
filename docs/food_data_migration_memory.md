# 食物数据迁移 — 记忆文档（简化 Python 方案）

本文档与 `tools/food_migration/` 脚本、`migration_tables.sql` 一致，供人工与 Cursor 复用。

---

## 1. 数据分层

| 层级 | 表前缀/表名 | 说明 |
|------|-------------|------|
| **原始层** | `init_food_channel_*` | 渠道拉取的原始分类、条目、详情、图片，只读来源 |
| **中间审核层** | `check_*` | 中间表、映射表、迁移日志；可人工改字段与状态 |
| **正式层** | `food_category`、`food` | 小程序与后端使用的主数据 |

---

## 2. 方案选型：仅 Python 脚本

- **不做**复杂 Web 后台、审核系统、权限。
- **流程**：脚本生成 `check_food_staging` → 在 Navicat / 客户端中人工审核改字段与 `manual_review_status` → 再执行 `migrate-formal` 写入正式表。
- 分类从 `init_*` **直接**进 `food_category`（无分类 staging），通过 `check_food_category_source_mapping` 做幂等与溯源。

---

## 3. `food` 表字段规则（严格执行）

| 字段 | 规则 |
|------|------|
| `category_id` | 由 `check_food_category_source_mapping` 按 `channel_category_id` 解析；**无映射则不入正式表** |
| `name` | 优先 `channel_food_name`，去首尾空格、轻量清洗 |
| `image` | **仅**本地相对路径（如 `/uploads/food-images/xxx.jpg`），**禁止**第三方 URL |
| `gi_level` | **仅**来自详情 `glycemic_info_json`（`glycemicInfoData`）；优先 `gi.lable`/`gi.label`；仅有 `gi.value` 时按数值映射为 `low`/`medium`/`high`；**禁止**按名称猜 GI |
| `calories_per_100g`、`calories_per_unit` | 以 `check_food_staging` **人工审核后**为准；未通过审核不迁移 |
| `unit_name`、`standard_weight_g` | 同上；`standard_weight_unit` 为 `ml` 时本阶段仍将数值写入 `standard_weight_g`（统一近似，后续可细化单位体系） |
| `edible_portion_rate` | **固定 null**，禁止默认 1 或 100% |
| `carb_per_100g` 等宏量 | 仅当详情单位口径可明确为每 100g 等时写入，否则 null |
| `keywords` | 由正式 `name`、`channel_food_name`、分类名等**有限规则**生成，去重、控长（≤256） |
| `is_custom` | 渠道导入固定 **0** |
| `status` | 仅审核通过且成功写入 `food` 的为 **1** |
| `creator_user_id` | 系统导入固定 **null** |

**说明**：库表 `calories_per_100g` 为 NOT NULL。液体且仅有 `calories_per_100ml` 时，迁移阶段将**审核后的**每百毫升热量写入该列（与 `unit_name`/份量语义一起在 staging 中由人工把关）；宁可人工补全也不要脚本乱填。

---

## 4. 图片规则

- 物理目录：`D:\mycode\ypfrloseweight\backend\uploads\food-images`（可通过环境变量覆盖）。
- 优先 `init_food_channel_image.image_url`，缺省则用 `init_food_channel_item.cover`。
- 文件名：`mxnzp_{channel_food_id}.{ext}`，已存在则跳过下载。
- 写入 staging / 正式表的路径形态：`/uploads/food-images/文件名`。
- 失败不中断批处理；`image_download_status` / `image_download_msg` 记录结果。

---

## 5. 状态枚举

### `manual_review_status`（人工）

- `pending`：未审核，**不可**迁正式表  
- `approved`：直接通过  
- `modified_approved`：人工改字段后通过  
- `rejected`：拒绝，不迁移  

### `formal_migrate_status`（正式迁移）

- `not_migrated`：未迁  
- `migrated`：已成功写入 `food`  
- `failed`：尝试迁移失败（如缺分类、缺热量等）  

### `stage_status`（生成 staging）

- `generated`：已从 init 生成行  
- `failed`：生成失败（极少，如必填异常）  

### 图片 `image_download_status`（脚本内）

- `pending` / `success` / `failed` / `skipped`（无 URL）

---

## 6. 增量与幂等

- `generate_food_staging(..., only_new=True)`：跳过已在 `check_food_staging` 的 `(channel_name, channel_food_id)`。
- `migrate_foods_to_formal`：仅处理 `manual_review_status IN ('approved','modified_approved')` 且 `formal_migrate_status='not_migrated'`；成功则写 `check_food_source_mapping`、更新 staging、写 `check_food_migrate_log`。
- 已 `migrated` 的行不会重复插入 `food`。
- 新增 init 数据可再次跑 generate / migrate，实现增量。

---

## 7. `check_` 前缀约定

所有中间审核、映射、迁移日志表**统一** `check_` 前缀，例如：

- `check_food_staging`
- `check_food_category_source_mapping`
- `check_food_source_mapping`
- `check_food_migrate_log`

**禁止**使用旧名：`food_staging`、`food_category_source_mapping`、`food_source_mapping`、`food_migrate_log`。

---

## 8b. 人工补 `unit_name` 与重算 `calories_per_unit`

- 可在 `check_food_staging` 中手工填写 `unit_name`（及可选 `standard_weight_*`）。
- 执行 `python tools/food_migration/run_migration.py recalc-unit-calories` 按公式回填 `calories_per_unit`（内置规则补标准量，**不调用在线大模型**）。
- 详见 `tools/food_migration/README.md` 第 8b 节。

## 8. 推荐执行顺序

1. `python tools/food_migration/run_migration.py init`  
2. `python tools/food_migration/run_migration.py migrate-categories`  
3. `python tools/food_migration/run_migration.py generate-staging --only-new`  
4. 数据库内人工审核 `check_food_staging`  
5. `python tools/food_migration/run_migration.py migrate-formal`  
6. 可选：`repair-images` 补图  

详细命令见 `tools/food_migration/README.md`。

---

## 9. 常用命令（与 README 一致）

```bash
pip install -r tools/food_migration/requirements.txt

python tools/food_migration/run_migration.py init
python tools/food_migration/run_migration.py migrate-categories
python tools/food_migration/run_migration.py generate-staging --limit 100 --only-new
python tools/food_migration/run_migration.py repair-images --limit 100
python tools/food_migration/run_migration.py migrate-formal --limit 100
python tools/food_migration/run_migration.py stats
```

扫描全部 init 行（已存在 staging 仅会因唯一键跳过插入）：

```bash
python tools/food_migration/run_migration.py generate-staging --all
```
