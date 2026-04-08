-- =============================================================================
-- V009: 将 sport_record 演进为 PRD 结构：增加快照/日期/项目引用，删除旧列。
-- 前置: V006（sport_item）、V004
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

ALTER TABLE sport_record
  ADD COLUMN record_date DATE DEFAULT NULL AFTER user_id,
  ADD COLUMN sport_item_id BIGINT UNSIGNED DEFAULT NULL AFTER record_date,
  ADD COLUMN sport_name_snapshot VARCHAR(64) DEFAULT NULL AFTER sport_item_id,
  ADD COLUMN icon_snapshot VARCHAR(32) DEFAULT NULL AFTER sport_name_snapshot,
  ADD COLUMN calories_burned DECIMAL(12,2) DEFAULT NULL AFTER duration_min,
  ADD COLUMN source VARCHAR(16) NOT NULL DEFAULT 'manual' AFTER calories_burned,
  ADD COLUMN record_time DATETIME DEFAULT NULL AFTER source,
  ADD COLUMN updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

UPDATE sport_record sr
LEFT JOIN (
  SELECT MIN(id) AS id, name FROM sport_item GROUP BY name
) si ON si.name = sr.sport_name
SET
  sr.record_date = DATE(sr.recorded_at),
  sr.sport_item_id = si.id,
  sr.sport_name_snapshot = sr.sport_name,
  sr.icon_snapshot = sr.icon,
  sr.calories_burned = sr.calories,
  sr.source = 'manual',
  sr.record_time = sr.recorded_at;

ALTER TABLE sport_record DROP INDEX idx_sport_user_time;

ALTER TABLE sport_record
  DROP COLUMN sport_name,
  DROP COLUMN calories,
  DROP COLUMN icon,
  DROP COLUMN recorded_at;

ALTER TABLE sport_record
  MODIFY COLUMN record_date DATE NOT NULL,
  MODIFY COLUMN sport_name_snapshot VARCHAR(64) NOT NULL,
  MODIFY COLUMN calories_burned DECIMAL(12,2) NOT NULL,
  MODIFY COLUMN record_time DATETIME NOT NULL;

ALTER TABLE sport_record
  ADD KEY idx_sport_record_user_date (user_id, record_date),
  ADD CONSTRAINT fk_sport_record_item FOREIGN KEY (sport_item_id) REFERENCES sport_item (id);
