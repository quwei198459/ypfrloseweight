-- =============================================================================
-- V005: 创建 food_category、food，从 food_library 迁移；原表改名为 food_library_legacy。
-- 前置: V004
-- 说明: 保留 food.id = 原 food_library.id，便于 diet_record.food_id 直接对应
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE food_category (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name       VARCHAR(64)  NOT NULL,
  parent_id  BIGINT UNSIGNED DEFAULT NULL,
  type       VARCHAR(16)  NOT NULL DEFAULT 'common' COMMENT 'system/brand/common/custom',
  sort_no    INT NOT NULL DEFAULT 0,
  status     TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uk_food_category_name (name),
  KEY idx_food_category_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO food_category (name, parent_id, type, sort_no, status)
SELECT DISTINCT
  COALESCE(NULLIF(TRIM(category), ''), '未分类'),
  NULL,
  'common',
  0,
  1
FROM food_library;

CREATE TABLE food (
  id                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  creator_user_id       BIGINT UNSIGNED DEFAULT NULL,
  category_id           BIGINT UNSIGNED NOT NULL,
  name                  VARCHAR(128) NOT NULL,
  image                 VARCHAR(512) DEFAULT NULL,
  gi_level              VARCHAR(16)  DEFAULT NULL COMMENT 'low/mid/high',
  calories_per_100g     DECIMAL(10,2) NOT NULL,
  calories_per_unit     DECIMAL(10,2) DEFAULT NULL,
  unit_name             VARCHAR(32)  DEFAULT NULL,
  standard_weight_g     DECIMAL(10,2) DEFAULT NULL,
  edible_portion_rate   DECIMAL(6,2) DEFAULT NULL COMMENT '可食部率 %',
  carb_per_100g         DECIMAL(10,2) DEFAULT NULL,
  protein_per_100g      DECIMAL(10,2) DEFAULT NULL,
  fat_per_100g          DECIMAL(10,2) DEFAULT NULL,
  keywords              VARCHAR(256) DEFAULT NULL,
  is_custom             TINYINT UNSIGNED NOT NULL DEFAULT 0,
  status                TINYINT UNSIGNED NOT NULL DEFAULT 1,
  created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_food_category (category_id),
  KEY idx_food_creator (creator_user_id),
  CONSTRAINT fk_food_category FOREIGN KEY (category_id) REFERENCES food_category (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO food (
  id, creator_user_id, category_id, name, image, gi_level,
  calories_per_100g, calories_per_unit, unit_name, standard_weight_g, edible_portion_rate,
  carb_per_100g, protein_per_100g, fat_per_100g, keywords,
  is_custom, status, created_at, updated_at
)
SELECT
  fl.id,
  NULL,
  fc.id,
  fl.name,
  NULL,
  NULL,
  fl.calories_per_100,
  NULL,
  COALESCE(NULLIF(TRIM(fl.unit_label), ''), '100g'),
  CASE
    WHEN fl.unit_label LIKE '%100g%' OR fl.unit_label = '100g' THEN 100
    ELSE NULL
  END,
  100.00,
  fl.carbs,
  fl.protein,
  fl.fat,
  NULL,
  0,
  1,
  fl.created_at,
  CURRENT_TIMESTAMP
FROM food_library fl
JOIN food_category fc ON fc.name = COALESCE(NULLIF(TRIM(fl.category), ''), '未分类');

RENAME TABLE food_library TO food_library_legacy;
