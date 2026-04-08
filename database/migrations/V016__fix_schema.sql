-- =============================================================================
-- V016: 数据库结构修复（对齐后端实体与 V009/V010 目标态；幂等、可重复执行）
--
-- 背景：部分环境 V009/V010 未完整执行，导致 sport_record 残留旧列 NOT NULL、
--       user_weight_record 缺少 source/remark 或仍保留 uk_weight_user_date。
--
-- 执行前：请备份 loseweight 库（mysqldump 或快照）。
-- 执行：mysql -h ... -u ... -p loseweight < database/migrations/V016__fix_schema.sql
--
-- 说明：
--   - 优先使用 ADD COLUMN、MODIFY（放宽约束）保护已有行数据。
--   - 文末「可选」注释块含 DROP COLUMN，仅在与产品确认且已备份后手工取消注释执行。
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

-- -----------------------------------------------------------------------------
-- 执行方式：下方存储过程 sp_v016_apply_fix 内为幂等逻辑（按 information_schema 判断）。
-- 若 user_weight_record / sport_record 整表缺失，请先执行 database/migrations 中 V001–V007
-- 等基线脚本建库，本文件不负责创建完整业务表（避免与基线分叉）。
-- -----------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS sp_v016_apply_fix;

DELIMITER $$

CREATE PROCEDURE sp_v016_apply_fix()
BEGIN
  DECLARE dbname VARCHAR(64);
  SET dbname = DATABASE();

  -- ========== user_weight_record ==========

  -- 1.1 用途：补充 source 列，避免 INSERT 报 Unknown column 'source'
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'user_weight_record' AND COLUMN_NAME = 'source'
  ) THEN
    ALTER TABLE user_weight_record
      ADD COLUMN source VARCHAR(16) NOT NULL DEFAULT 'manual' COMMENT 'manual/system' AFTER weight_kg;
  END IF;

  -- 1.2 用途：补充 remark 列，与实体 WeightRecord.remark 一致
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'user_weight_record' AND COLUMN_NAME = 'remark'
  ) THEN
    ALTER TABLE user_weight_record
      ADD COLUMN remark VARCHAR(256) DEFAULT NULL AFTER source;
  END IF;

  -- 1.2b 用途：为 fk_weight_record_user(user_id) 提供左前缀索引；否则 DROP uk_weight_user_date 会报 1553
  -- （InnoDB 原用 UNIQUE(user_id,record_date) 满足对 user_id 的索引需求）
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'user_weight_record' AND INDEX_NAME = 'idx_uwr_user_id'
  ) THEN
    ALTER TABLE user_weight_record ADD KEY idx_uwr_user_id (user_id);
  END IF;

  -- 1.3 用途：删除同日唯一索引，允许同一用户同一天多条体重（V010 / PRD）
  -- 风险：若存在重复 (user_id, record_date) 行，DROP 前必须先处理重复数据
  IF EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'user_weight_record' AND INDEX_NAME = 'uk_weight_user_date'
  ) THEN
    ALTER TABLE user_weight_record DROP INDEX uk_weight_user_date;
  END IF;

  -- ========== sport_record：补全 V009 新增列（若缺失）==========

  -- 2.1 record_date
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'record_date'
  ) THEN
    ALTER TABLE sport_record
      ADD COLUMN record_date DATE DEFAULT NULL AFTER user_id;
  END IF;

  -- 2.2 sport_item_id
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'sport_item_id'
  ) THEN
    ALTER TABLE sport_record
      ADD COLUMN sport_item_id BIGINT UNSIGNED DEFAULT NULL AFTER record_date;
  END IF;

  -- 2.3 sport_name_snapshot
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'sport_name_snapshot'
  ) THEN
    ALTER TABLE sport_record
      ADD COLUMN sport_name_snapshot VARCHAR(64) DEFAULT NULL AFTER sport_item_id;
  END IF;

  -- 2.4 icon_snapshot
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'icon_snapshot'
  ) THEN
    ALTER TABLE sport_record
      ADD COLUMN icon_snapshot VARCHAR(32) DEFAULT NULL AFTER sport_name_snapshot;
  END IF;

  -- 2.5 calories_burned（放在 duration_min 后；若 duration_min 不存在则追加在表尾）
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'calories_burned'
  ) THEN
    IF EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'duration_min'
    ) THEN
      ALTER TABLE sport_record
        ADD COLUMN calories_burned DECIMAL(12,2) DEFAULT NULL AFTER duration_min;
    ELSE
      ALTER TABLE sport_record
        ADD COLUMN calories_burned DECIMAL(12,2) DEFAULT NULL;
    END IF;
  END IF;

  -- 2.6 source
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'source'
  ) THEN
    ALTER TABLE sport_record
      ADD COLUMN source VARCHAR(16) NOT NULL DEFAULT 'manual' AFTER calories_burned;
  END IF;

  -- 2.7 record_time
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'record_time'
  ) THEN
    ALTER TABLE sport_record
      ADD COLUMN record_time DATETIME DEFAULT NULL AFTER source;
  END IF;

  -- 2.8 updated_at
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'updated_at'
  ) THEN
    ALTER TABLE sport_record
      ADD COLUMN updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;
  END IF;

  -- 2.9 用途：从旧列回填新列（仅当旧列仍存在时引用，避免破坏已有新数据）
  IF EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'sport_name'
  ) AND EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'recorded_at'
  ) AND EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'calories'
  ) THEN
    UPDATE sport_record sr
    LEFT JOIN (
      SELECT MIN(id) AS id, name FROM sport_item GROUP BY name
    ) si ON si.name = sr.sport_name
    SET
      sr.record_date = COALESCE(sr.record_date, DATE(sr.recorded_at)),
      sr.sport_item_id = COALESCE(sr.sport_item_id, si.id),
      sr.sport_name_snapshot = COALESCE(sr.sport_name_snapshot, sr.sport_name),
      sr.icon_snapshot = COALESCE(sr.icon_snapshot, sr.icon),
      sr.calories_burned = COALESCE(sr.calories_burned, sr.calories),
      sr.record_time = COALESCE(sr.record_time, sr.recorded_at)
    WHERE sr.sport_name IS NOT NULL OR sr.recorded_at IS NOT NULL;
  ELSEIF EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'sport_name'
  ) AND EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'recorded_at'
  ) THEN
    UPDATE sport_record sr
    LEFT JOIN (
      SELECT MIN(id) AS id, name FROM sport_item GROUP BY name
    ) si ON si.name = sr.sport_name
    SET
      sr.record_date = COALESCE(sr.record_date, DATE(sr.recorded_at)),
      sr.sport_item_id = COALESCE(sr.sport_item_id, si.id),
      sr.sport_name_snapshot = COALESCE(sr.sport_name_snapshot, sr.sport_name),
      sr.icon_snapshot = COALESCE(sr.icon_snapshot, sr.icon),
      sr.record_time = COALESCE(sr.record_time, sr.recorded_at)
    WHERE sr.sport_name IS NOT NULL OR sr.recorded_at IS NOT NULL;
  ELSEIF EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'sport_name'
  ) THEN
    IF EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'calories'
    ) THEN
      UPDATE sport_record sr
      LEFT JOIN (
        SELECT MIN(id) AS id, name FROM sport_item GROUP BY name
      ) si ON si.name = sr.sport_name
      SET
        sr.sport_item_id = COALESCE(sr.sport_item_id, si.id),
        sr.sport_name_snapshot = COALESCE(sr.sport_name_snapshot, sr.sport_name),
        sr.icon_snapshot = COALESCE(sr.icon_snapshot, sr.icon),
        sr.calories_burned = COALESCE(sr.calories_burned, sr.calories)
      WHERE sr.sport_name IS NOT NULL;
    ELSE
      UPDATE sport_record sr
      LEFT JOIN (
        SELECT MIN(id) AS id, name FROM sport_item GROUP BY name
      ) si ON si.name = sr.sport_name
      SET
        sr.sport_item_id = COALESCE(sr.sport_item_id, si.id),
        sr.sport_name_snapshot = COALESCE(sr.sport_name_snapshot, sr.sport_name),
        sr.icon_snapshot = COALESCE(sr.icon_snapshot, sr.icon)
      WHERE sr.sport_name IS NOT NULL;
    END IF;
  END IF;

  -- 2.10 用途：不删列前提下，将旧版必填列改为可空，避免后端只写新列时 INSERT 失败（保留原值）
  IF EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'sport_name'
  ) THEN
    ALTER TABLE sport_record MODIFY COLUMN sport_name VARCHAR(64) NULL DEFAULT NULL;
  END IF;

  IF EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'calories'
  ) THEN
    ALTER TABLE sport_record MODIFY COLUMN calories INT UNSIGNED NULL DEFAULT NULL;
  END IF;

  IF EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'icon'
  ) THEN
    ALTER TABLE sport_record MODIFY COLUMN icon VARCHAR(32) NULL DEFAULT NULL;
  END IF;

  IF EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'recorded_at'
  ) THEN
    ALTER TABLE sport_record MODIFY COLUMN recorded_at DATETIME NULL DEFAULT NULL;
  END IF;

  -- 2.10b 用途：为 fk_sport_record_user(user_id) 提供左前缀索引；否则 DROP idx_sport_user_time 会报 1553
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND INDEX_NAME = 'idx_sr_user_id'
  ) THEN
    ALTER TABLE sport_record ADD KEY idx_sr_user_id (user_id);
  END IF;

  -- 2.11 用途：删除旧索引 idx_sport_user_time，改为按 (user_id, record_date) 查询（与 V009 一致）
  IF EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND INDEX_NAME = 'idx_sport_user_time'
  ) THEN
    ALTER TABLE sport_record DROP INDEX idx_sport_user_time;
  END IF;

  -- 2.12 用途：补充复合索引，加速按用户+日期查运动记录
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND INDEX_NAME = 'idx_sport_record_user_date'
  ) THEN
    ALTER TABLE sport_record ADD KEY idx_sport_record_user_date (user_id, record_date);
  END IF;

  -- 2.12b 用途：外键添加前，将无法匹配的 sport_item_id 置为 NULL，避免 ALTER 因脏数据失败
  UPDATE sport_record sr
  LEFT JOIN sport_item si ON si.id = sr.sport_item_id
  SET sr.sport_item_id = NULL
  WHERE sr.sport_item_id IS NOT NULL AND si.id IS NULL;

  -- 2.13 用途：sport_item 外键（若不存在则添加，引用 sport_item.id）
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record'
      AND CONSTRAINT_NAME = 'fk_sport_record_item' AND CONSTRAINT_TYPE = 'FOREIGN KEY'
  ) THEN
    ALTER TABLE sport_record
      ADD CONSTRAINT fk_sport_record_item FOREIGN KEY (sport_item_id) REFERENCES sport_item (id);
  END IF;

END$$

DELIMITER ;

-- 用途：执行上述修复逻辑（可重复执行：过程内已做存在性判断）
CALL sp_v016_apply_fix();

-- 用途：执行完毕后删除过程，避免库内长期残留维护对象
DROP PROCEDURE IF EXISTS sp_v016_apply_fix;

-- =============================================================================
-- 【可选 / 手工】与 V009 终态完全一致：在确认已备份、且不再需要旧列后，取消下一行注释执行。
-- 用途：删除 legacy 列 sport_name, calories, icon, recorded_at（不可逆，列数据丢失）
-- =============================================================================
-- ALTER TABLE sport_record
--   DROP COLUMN sport_name,
--   DROP COLUMN calories,
--   DROP COLUMN icon,
--   DROP COLUMN recorded_at;

-- =============================================================================
-- 【可选 / 手工】在已执行上一段 DROP 且全表新列无 NULL 后，收紧非空约束（与 V009 一致）
-- =============================================================================
-- ALTER TABLE sport_record
--   MODIFY COLUMN record_date DATE NOT NULL,
--   MODIFY COLUMN sport_name_snapshot VARCHAR(64) NOT NULL,
--   MODIFY COLUMN calories_burned DECIMAL(12,2) NOT NULL,
--   MODIFY COLUMN record_time DATETIME NOT NULL;
