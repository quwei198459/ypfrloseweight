-- =============================================================================
-- V015: meal_photo_recognition 识图确认场景增量字段（对齐 docs/photograph-recognition-supplement-prd.md）
--
-- 文件名说明：
--   若使用「V006_photograph_recognition_supplement.sql」这类名称，在本仓库按文件名排序执行时，
--   可能早于 V012（建表脚本）执行，导致 ALTER 失败。且已有 V006__sport_item_migrate.sql。
--   故采用 V015 作为版本号，保证在 V012 建表之后执行。
--
-- 未采纳单独落库、由 JSON 即可完全替代的字段（仍可按需在本脚本中删除对应 ADD 行）：
--   · recognized_food_name / confirmed_food_name：真源可在 parsed_result_json；增加列是为列表查询、
--     客服与审计时免解析 JSON。若团队坚持单源，可不加，但本脚本按需求保留。
--   · badge_progress_percent：可由「当日已摄入、预算」与 confirmed_calories 在查询端计算；
--     增加列用于还原用户确认当下 UI 圆环比例（与预算快照一致时）。若不做 UI 审计可省略。
--   · diet_record_id：一单识图确认可能写入多条 diet_record，单列仅能指向「首条」或代表行；
--     关联完整明细应以 meal_record_id + diet_record.meal_id 反查。若仅需要餐次头关联可只保留 meal_record_id。
--
-- 现有列 meal_type：本脚本不修改语义，继续表示「发起识图时用户在端上选中的餐别」；
--   recommended_meal_type / confirmed_meal_type 分别承载服务端推荐与用户最终确认，避免与旧逻辑混淆。
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

ALTER TABLE meal_photo_recognition
  ADD COLUMN recommended_meal_type VARCHAR(16) DEFAULT NULL
    COMMENT '服务端按时间规则推荐的餐别：breakfast/lunch/dinner/snack' AFTER meal_type,
  ADD COLUMN confirmed_meal_type VARCHAR(16) DEFAULT NULL
    COMMENT '用户确认写入时锁定的餐别（与 meal_record / diet_record 一致）' AFTER recommended_meal_type,
  ADD COLUMN recognized_food_name VARCHAR(128) DEFAULT NULL
    COMMENT '识别结果主展示名称快照；多条食物时完整结构仍以 parsed_result_json 为准' AFTER image_url,
  ADD COLUMN confirmed_food_name VARCHAR(128) DEFAULT NULL
    COMMENT '用户确认或编辑后的主食物名称快照（与写入 diet_record 展示一致）' AFTER recognized_food_name,
  ADD COLUMN recognized_calories DECIMAL(12,2) DEFAULT NULL
    COMMENT '识别出的基准热量（千卡），写入前快照' AFTER confirmed_food_name,
  ADD COLUMN confirmed_calories DECIMAL(12,2) DEFAULT NULL
    COMMENT '用户确认写入的最终热量（千卡），与明细汇总一致' AFTER recognized_calories,
  ADD COLUMN recommended_eat_ratio DECIMAL(6,4) DEFAULT NULL
    COMMENT '推荐食用比例，建议存 0~1（如 1.0000 表示 100%）' AFTER confirmed_calories,
  ADD COLUMN confirmed_eat_ratio DECIMAL(6,4) DEFAULT NULL
    COMMENT '用户确认的食用比例 0~1，与食用比例滑杆一致' AFTER recommended_eat_ratio,
  ADD COLUMN badge_progress_percent DECIMAL(5,2) DEFAULT NULL
    COMMENT '热量徽章/圆环展示的摄入相对预算百分比 0~100，用于还原当时 UI' AFTER confirmed_eat_ratio,
  ADD COLUMN confirm_status VARCHAR(24) NOT NULL DEFAULT 'none'
    COMMENT '确认流状态：none 未进入确认/pending_confirm 待用户确认/confirmed 已写入/aborted 用户放弃' AFTER recognize_status,
  ADD COLUMN confirmed_at DATETIME DEFAULT NULL
    COMMENT '用户点击确定或「添加到某餐」并成功写入餐次的时间' AFTER confirm_status,
  ADD COLUMN meal_record_id BIGINT UNSIGNED DEFAULT NULL
    COMMENT '确认写入后关联的 meal_record.id' AFTER confirmed_at,
  ADD COLUMN diet_record_id BIGINT UNSIGNED DEFAULT NULL
    COMMENT '仅一条明细或代表行时指向 diet_record.id；多条时请用 meal_record_id 反查 diet_record' AFTER meal_record_id,
  ADD KEY idx_photo_recog_meal_record (meal_record_id),
  ADD KEY idx_photo_recog_confirm (user_id, confirm_status, record_date),
  ADD KEY idx_photo_recog_confirmed_at (confirmed_at),
  ADD CONSTRAINT fk_photo_recog_meal_record FOREIGN KEY (meal_record_id) REFERENCES meal_record (id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_photo_recog_diet_record FOREIGN KEY (diet_record_id) REFERENCES diet_record (id) ON DELETE SET NULL;
