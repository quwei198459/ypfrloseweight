-- =============================================================================
-- V010: 体重表改名为 user_weight_record（PRD），增加 source/remark，去掉同日唯一（PRD 允许多条）。
-- 前置: V004
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

RENAME TABLE weight_record TO user_weight_record;

ALTER TABLE user_weight_record
  DROP INDEX uk_weight_user_date,
  ADD COLUMN source VARCHAR(16) NOT NULL DEFAULT 'manual' COMMENT 'manual/system' AFTER weight_kg,
  ADD COLUMN remark VARCHAR(256) DEFAULT NULL AFTER source;
