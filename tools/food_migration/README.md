# 食物数据迁移（Python 脚本 / `check_*` 中间层）

将 `init_food_channel_*` 原始表处理为可人工审核的 `check_food_staging`，再迁移到正式表 `food` / `food_category`。**不包含 Web 后台、审核系统或权限。**

## 1. 为什么需要 `check_food_staging`

- 渠道原始字段与正式主数据口径不一致（热量单位、GI、图片 URL、宏量营养素等）。
- 需要**人工确认**后再写入 `food`，避免把主数据表当成“垃圾桶”。
- 图片需**本地化**，staging 记录下载状态与相对路径，便于补图与排查。

## 2. 为什么不直接 init → food

- 缺少审核与修正环节，错误数据会直接进入小程序可见主数据。
- 正式表 `calories_per_100g` 等为强约束字段，需与分类映射、图片路径、GI 规则等一并校验。
- 中间层可重复生成、补图、增量迁移，且状态可追溯（`check_food_migrate_log`）。

## 3. `check_` 前缀规则

所有中间审核表、映射表、迁移日志表**必须**使用 `check_` 前缀，与下列名称保持一致（**勿**再使用 `food_staging`、`food_source_mapping` 等旧名）：

- `check_food_staging`
- `check_food_category_source_mapping`
- `check_food_source_mapping`
- `check_food_migrate_log`

## 4. 环境准备

```bash
pip install -r tools/food_migration/requirements.txt
```

数据库连接与 `tools/food_import` 一致，使用环境变量（可写在项目根 `.env` 或 `tools/food_import/.env`）：

- `MYSQL_HOST`、`MYSQL_PORT`、`MYSQL_USER`、`MYSQL_PASSWORD`、`MYSQL_DATABASE`（默认 `loseweight`）

图片目录默认：

- `D:\mycode\ypfrloseweight\backend\uploads\food-images`

可通过 `FOOD_IMAGE_LOCAL_DIR` 覆盖。

## 5. 初始化表（创建 `check_*`）

```bash
python tools/food_migration/run_migration.py init
```

等价于执行本目录下的 `migration_tables.sql`。

## 6. 迁移分类（init → `food_category` + 映射）

```bash
python tools/food_migration/run_migration.py migrate-categories
```

- 从 `init_food_channel_category` 写入 `food_category`（`type='channel'`，`code` 形如 `mxnzp_{channel_category_id}`，截断至 64 字符）。
- 写入 `check_food_category_source_mapping`，按 `(channel_name, channel_category_id)` 幂等。
- 若 `code` 或 `name` 与已有正式分类冲突，脚本会尝试微调名称或 `code` 以满足唯一约束。

## 7. 生成 `check_food_staging`

```bash
python tools/food_migration/run_migration.py generate-staging --limit 100 --only-new
```

默认 `--only-new`：跳过已在 `check_food_staging` 的 `(channel_name, channel_food_id)`。

若要扫描全部 init 行（已存在 staging 会因唯一约束跳过插入），使用：

```bash
python tools/food_migration/run_migration.py generate-staging --all
```

本步骤会：

- 关联 `init_food_channel_detail`、`init_food_channel_image`、分类映射；
- 按规则填充热量/单位候选、`gi_level`（**仅**来自 `glycemic_info_json`）、宏量（仅单位明确为每 100g 时）；
- 下载图片到本地，并写入 `local_image_path`（形如 `/uploads/food-images/mxnzp_{channel_food_id}.jpg`）；
- 设置 `stage_status=generated`、`manual_review_status=pending`、`formal_migrate_status=not_migrated`。

## 8. 人工审核 `check_food_staging`

在 Navicat / 客户端中直接修改行：

- 修正名称、热量、单位、标准份量、`gi_level`（`low` / `medium` / `high`）、宏量等；
- 将 `manual_review_status` 设为：
  - `approved`：直接通过；
  - `modified_approved`：改字段后通过；
  - `rejected`：拒绝，不迁移；
- `pending` 或未通过审核的**不会**进入正式表。

### 8b. 补 `unit_name` 后重算 `calories_per_unit`

若自动规则未给出 `unit_name`，可在库里**手工填写** `unit_name`（如「碗」「个」「片」）。需要每单位热量时，运行（**不调用在线大模型**，按公式 + 内置默认份量表推断）：

```bash
python tools/food_migration/run_migration.py recalc-unit-calories
python tools/food_migration/run_migration.py recalc-unit-calories --limit 200
python tools/food_migration/run_migration.py recalc-unit-calories --only-if-null-cpu
python tools/food_migration/run_migration.py recalc-unit-calories --no-fill-standard
```

维护好 `unit_name` 后，**只给「尚未有 calories_per_unit」的行补标准量与每单位热量**（已有每单位热量的行不改）：

```bash
python tools/food_migration/run_migration.py init-unit-fields
```

等价于 `recalc-unit-calories --only-if-null-cpu`，且不修改 `unit_name` 列。

- 默认：若 `standard_weight_value` / `standard_weight_unit` 为空，会按食物名 + 单位猜一份量（如「个」+ 马铃薯 → 150g），再算  
  `calories_per_unit = calories_per_100g × 标准克数 / 100`（或按 ml 用 `calories_per_100ml`）。
- `--no-fill-standard`：你必须已在库中填好标准量，否则该行会跳过。
- `--only-if-null-cpu`：仅更新 `calories_per_unit` 仍为空的行。

特殊份量请以 Navicat **直接改** `standard_weight_value` / `standard_weight_unit`，再跑本命令覆盖 `calories_per_unit`。

## 9. 迁移到正式表 `food`

```bash
python tools/food_migration/run_migration.py migrate-formal --limit 100
```

仅处理：

- `manual_review_status IN ('approved','modified_approved')`
- `formal_migrate_status = 'not_migrated'`

成功后会：

1. `INSERT` 到 `food`；
2. 写入 `check_food_source_mapping`；
3. 更新 `check_food_staging`：`formal_migrate_status=migrated`，`target_food_id`；
4. 写入 `check_food_migrate_log`。

若缺分类映射、缺审核后热量等，会将该行标为 `formal_migrate_status=failed` 并写日志，**不中断**批处理。

## 10. 增量处理

1. 新数据进入 `init_*` 后，再执行 `generate-staging --only-new`。
2. 人工审核新增行。
3. 再执行 `migrate-formal`。

已 `migrated` 的行不会重复插入 `food`（映射表与唯一约束双保险）。

## 11. 仅补图

```bash
python tools/food_migration/run_migration.py repair-images --limit 100
```

对 `image_download_status` 为 `failed` / `pending` / `skipped` 或缺少 `local_image_path` 的 staging 行重试下载。

## 11b. 按 `init_food_channel_image` 整批刷新图片

从 **`init_food_channel_image.image_url`** 写回 `check_food_staging.source_image_url` 并重新下载；若该表无 URL，再退回 `init_food_channel_item.cover`。

```bash
python tools/food_migration/run_migration.py refetch-init-images
python tools/food_migration/run_migration.py refetch-init-images --limit 100
python tools/food_migration/run_migration.py refetch-init-images --force
```

`--force`：删除已有 `mxnzp_{channel_food_id}.*` 后强制重新拉取（默认已存在且非空文件会跳过下载）。

## 12. 统计

```bash
python tools/food_migration/run_migration.py stats
```

输出 init / `check_*` / `food` / 本地图片文件数 / 下载失败数等。

**注意**：若尚未执行过本节上方的 `init`，`stats` 会提示先创建 `check_*` 表（避免 `1146 Table doesn't exist` 长栈）。

## 13. `food` 字段处理规则摘要

详见项目根目录 [`docs/food_data_migration_memory.md`](../../docs/food_data_migration_memory.md)。要点：

- `category_id`：必须能通过 `check_food_category_source_mapping` 解析；
- `image`：仅本地相对路径，禁止外链；
- `gi_level`：仅来自详情 JSON，**禁止**按名称猜测；
- `edible_portion_rate`：当前固定 `NULL`；
- `is_custom`：渠道导入为 `0`；
- `creator_user_id`：`NULL`；
- `keywords`：由名称、渠道名、分类名等规则生成，控长去重。

## 14. 图片本地化规则

- 优先 `init_food_channel_image.image_url`，否则 `init_food_channel_item.cover`；
- 文件名：`mxnzp_{channel_food_id}.{扩展名}`，已存在则跳过下载；
- 数据库中保存：`/uploads/food-images/文件名`；
- 失败记录 `image_download_status` / `image_download_msg`，不中断整批。

## 15. 与记忆文档的关系

设计约定、状态枚举、分层说明以 [`docs/food_data_migration_memory.md`](../../docs/food_data_migration_memory.md) 为准，便于你与 Cursor 长期复用。
