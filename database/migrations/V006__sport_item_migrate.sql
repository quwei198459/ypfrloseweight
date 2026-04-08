-- =============================================================================
-- V006: 创建 sport_item，从 sport_library 迁移（每60分钟消耗 = 每分钟 * 60）；原表改名 legacy。
-- 前置: V005
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE sport_item (
  id                   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  creator_user_id      BIGINT UNSIGNED DEFAULT NULL,
  name                 VARCHAR(64)  NOT NULL,
  icon                 VARCHAR(32)  DEFAULT NULL,
  calories_per_60min   DECIMAL(10,2) DEFAULT NULL,
  category             VARCHAR(32)  DEFAULT NULL,
  is_custom            TINYINT UNSIGNED NOT NULL DEFAULT 0,
  status               TINYINT UNSIGNED NOT NULL DEFAULT 1,
  sort_no              INT NOT NULL DEFAULT 0,
  created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sport_item_creator (creator_user_id),
  KEY idx_sport_item_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO sport_item (
  id, creator_user_id, name, icon, calories_per_60min, category, is_custom, status, sort_no, created_at, updated_at
)
SELECT
  id,
  NULL,
  name,
  icon,
  CASE
    WHEN calories_per_min IS NOT NULL THEN calories_per_min * 60
    ELSE NULL
  END,
  category,
  0,
  1,
  0,
  created_at,
  CURRENT_TIMESTAMP
FROM sport_library;

RENAME TABLE sport_library TO sport_library_legacy;
