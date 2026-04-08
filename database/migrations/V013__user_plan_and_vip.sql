-- =============================================================================
-- V013: user_plan、vip_user、vip_order（PRD 8.14～8.16）
-- 前置: V004
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE user_plan (
  id                      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id                 BIGINT UNSIGNED NOT NULL,
  total_weeks             INT                   DEFAULT NULL,
  target_weight_loss_kg   DECIMAL(8,2)          DEFAULT NULL,
  daily_deficit_target    DECIMAL(10,2)         DEFAULT NULL,
  exercise_plan_desc      VARCHAR(512)          DEFAULT NULL,
  diet_plan_desc          VARCHAR(512)          DEFAULT NULL,
  status                  TINYINT UNSIGNED NOT NULL DEFAULT 0,
  activated_at            DATETIME              DEFAULT NULL,
  created_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_user_plan_user (user_id),
  CONSTRAINT fk_user_plan_user FOREIGN KEY (user_id) REFERENCES lw_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vip_user (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id     BIGINT UNSIGNED NOT NULL,
  vip_type    VARCHAR(16)  NOT NULL COMMENT 'quarter/year/lifetime',
  start_time  DATETIME              DEFAULT NULL,
  end_time    DATETIME              DEFAULT NULL,
  status      TINYINT UNSIGNED NOT NULL DEFAULT 0,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_vip_user_user (user_id),
  CONSTRAINT fk_vip_user_user FOREIGN KEY (user_id) REFERENCES lw_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vip_order (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id     BIGINT UNSIGNED NOT NULL,
  order_no    VARCHAR(64)  NOT NULL,
  vip_type    VARCHAR(16)  NOT NULL,
  price       DECIMAL(10,2) NOT NULL DEFAULT 0,
  pay_status  TINYINT UNSIGNED NOT NULL DEFAULT 0,
  paid_at     DATETIME              DEFAULT NULL,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_vip_order_no (order_no),
  KEY idx_vip_order_user (user_id),
  CONSTRAINT fk_vip_order_user FOREIGN KEY (user_id) REFERENCES lw_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
