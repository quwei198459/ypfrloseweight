# MXNZP 食物渠道原始层采集（staging / init\_）

本工具调用 [mxnzp](https://www.mxnzp.com) 食物热量相关接口，将**原始 JSON** 写入 `loseweight` 库中 **`init_` 前缀表**。本阶段**不**写入正式业务表 `food`、`food_category`、`diet_record`、`meal_record`、`daily_summary`。

## 依赖

```bash
pip install -r tools/food_import/requirements.txt
```

## 配置 .env

参考 `tools/food_import/.env.example`，在项目**根目录**或 **`tools/food_import/`** 下创建 `.env`（后者优先级更高）：

- `MXNZP_APP_ID` / `MXNZP_APP_SECRET`：接口鉴权
- `MYSQL_*`：MySQL 连接；`MYSQL_DATABASE` 默认为 `loseweight`
- `REQUEST_TIMEOUT` / `REQUEST_SLEEP_SECONDS` / `REQUEST_RETRY_TIMES`：超时、限流、失败重试

## 初始化表

会 **DROP** 后重建所有 `init_food_channel_*` 与 `init_food_channel_pull_task`（仅影响原始层表）。

```bash
python tools/food_import/run_import.py init-tables
```

也可手动：`mysql ... loseweight < tools/food_import/init_tables.sql`

## 推荐执行顺序

1. **分类**：写入 `init_food_channel_category`

   ```bash
   python tools/food_import/run_import.py categories
   ```

2. **按分类抓列表**：分页写入 `init_food_channel_item`，支持每类上限 `limit_per_category`

   ```bash
   python tools/food_import/run_import.py foods --category-id 1 --limit-per-category 100
   python tools/food_import/run_import.py foods --all --limit-per-category 100
   ```

3. **详情**：写入 `init_food_channel_detail`（宽表 + JSON 子对象原样字段）

   ```bash
   python tools/food_import/run_import.py detail --food-id befa2163948534a9
   python tools/food_import/run_import.py detail --batch --limit 500 --only-missing
   ```

   默认批量模式**只补**尚未 `detail_status='success'` 的 foodId；若要重拉已有成功记录，加 `--include-existing`。

4. **图片**：写入 `init_food_channel_image`（与详情分表）；接口单次最多 10 个 id，脚本自动分批。

   ```bash
   python tools/food_import/run_import.py images --food-ids id1,id2
   python tools/food_import/run_import.py images --batch --limit 500 --only-missing
   ```

   **明细已齐后**，建议只给「已成功拉取详情」的食物拉图（与 item 列表解耦，避免对无明细的 id 浪费图片接口次数）：

   ```bash
   python tools/food_import/run_import.py images --batch --from-detail --limit 2000 --only-missing
   ```

   若接口返回「ID不存在，无图片」，则 `image_status=invalid_id`；空或异常文案为 `no_image`。  
   若 HTTP 失败或业务失败（如额度 `20009`），会为**本批请求的每个 foodId** 写入 `image_status=api_error` 及 `raw_json` 中的错误包络，便于与计费/对账一致；额度恢复后再次执行 `--only-missing` 会自动重试这些 id（`success` / `no_image` / `invalid_id` 不会重复请求）。

5. **统计**

   ```bash
   python tools/food_import/run_import.py stats
   ```

## 搜索补采（非主流程）

搜索接口用于按关键字补数据，结果同样写入 `init_food_channel_item`，其中 `channel_category_id` 固定为 **`special_search`**，与「按分类列表」采集的归属不同；同一 `foodId` 可在不同 `(channel_name, channel_food_id, channel_category_id)` 组合下各存一行（符合唯一键设计）。

```bash
python tools/food_import/run_import.py search --keyword 苹果 --max-pages 2
```

## 为什么第一阶段只写 init\_ 表

- 保留渠道原始字段与 `raw_json`，便于对账、重跑、审计。
- 正式表需要统一编码、去重、单位换算、分类映射等业务规则，应在**第二阶段**由清洗任务从 `init_*` 映射到 `food` / `food_category` 等（本工具不包含该步骤）。

## 第二阶段如何清洗到正式表（思路）

1. 以 `init_food_channel_detail`（及 item）为主数据源，按业务主键去重、合并多分类下的同一食物。
2. 映射字段类型与单位，写入 `food`；分类树从 `init_food_channel_category` 或运营规则生成 `food_category`。
3. 用 `channel_food_id` 等保留与渠道的追溯关系（可在正式表加渠道 id 字段或映射表）。
4. 清洗脚本与迁移应**单独**维护，避免与原始采集耦合。

## 断点续跑与重复执行

- 分类、item、detail、image 均使用 **UPSERT**（`ON DUPLICATE KEY UPDATE`），重复执行会更新记录。
- 批量详情默认 `only_missing=True`，只补未成功详情；图片批量默认只补尚无 `init_food_channel_image` 行的 foodId。
- 每次 HTTP 调用写入 `init_food_channel_pull_task`，便于排查失败与限流。

## Windows / Cursor

在仓库根目录执行上述 `python tools/food_import/run_import.py ...` 即可；请使用已安装依赖的同一 Python 解释器。
