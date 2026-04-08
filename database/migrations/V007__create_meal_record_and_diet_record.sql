-- =============================================================================
-- V007: 创建 PRD 餐次头 meal_record 与饮食明细 diet_record（空表）。
-- 前置: V004（lw_user 存在）、V005（food 存在）
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE meal_record (
  id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id          BIGINT UNSIGNED NOT NULL,
  record_date      DATE         NOT NULL,
  meal_type        VARCHAR(16)  NOT NULL COMMENT 'breakfast/lunch/dinner/snack',
  total_calories   DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_carb_g     DECIMAL(12,2) DEFAULT NULL,
  total_protein_g  DECIMAL(12,2) DEFAULT NULL,
  total_fat_g      DECIMAL(12,2) DEFAULT NULL,
  food_count       INT NOT NULL DEFAULT 0,
  status           VARCHAR(16)  NOT NULL DEFAULT 'draft' COMMENT 'draft/submitted',
  created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_meal_user_date_type (user_id, record_date, meal_type),
  CONSTRAINT fk_meal_record_user FOREIGN KEY (user_id) REFERENCES lw_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE diet_record (
  id                   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  meal_id              BIGINT UNSIGNED NOT NULL,
  user_id              BIGINT UNSIGNED NOT NULL,
  record_date          DATE         NOT NULL,
  meal_type            VARCHAR(16)  NOT NULL,
  food_id              BIGINT UNSIGNED DEFAULT NULL,
  food_name_snapshot   VARCHAR(128) NOT NULL,
  image_snapshot       VARCHAR(512) DEFAULT NULL,
  gi_level_snapshot    VARCHAR(16)  DEFAULT NULL,
  amount               DECIMAL(12,2) DEFAULT NULL,
  amount_unit          VARCHAR(16)  DEFAULT NULL,
  weight_g             DECIMAL(12,2) DEFAULT NULL,
  calories_total       DECIMAL(12,2) NOT NULL DEFAULT 0,
  carb_total_g         DECIMAL(12,2) DEFAULT NULL,
  protein_total_g      DECIMAL(12,2) DEFAULT NULL,
  fat_total_g          DECIMAL(12,2) DEFAULT NULL,
  source               VARCHAR(16)  NOT NULL DEFAULT 'manual' COMMENT 'search/custom/photo/manual',
  record_time          DATETIME NOT NULL,
  created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_diet_meal (meal_id),
  KEY idx_diet_user_date (user_id, record_date),
  CONSTRAINT fk_diet_meal FOREIGN KEY (meal_id) REFERENCES meal_record (id),
  CONSTRAINT fk_diet_user FOREIGN KEY (user_id) REFERENCES lw_user (id),
  CONSTRAINT fk_diet_food FOREIGN KEY (food_id) REFERENCES food (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
