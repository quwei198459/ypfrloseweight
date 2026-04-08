-- =============================================================================
-- V003: 创建物理表 lw_user（对应 PRD 8.1 user）、user_profile、user_budget_config，从 app_user 迁移后删除 app_user。
-- 前置: V002（外键已删）
-- 注意: user_id 主键值保持不变，便于子表无需改 user_id
-- 回滚: 需从备份恢复 app_user 及数据；不建议在生产无备份时单独回滚本脚本
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE lw_user (
  id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  openid              VARCHAR(64)  NOT NULL COMMENT '微信 openid',
  unionid             VARCHAR(64)           DEFAULT NULL,
  nickname            VARCHAR(64)           DEFAULT NULL,
  nickname_source     VARCHAR(32)  NOT NULL DEFAULT 'system_default' COMMENT 'system_default/wx_profile/manual',
  nickname_authorized TINYINT UNSIGNED NOT NULL DEFAULT 0,
  avatar              VARCHAR(512)          DEFAULT NULL,
  avatar_source       VARCHAR(32)  NOT NULL DEFAULT 'system_default',
  avatar_authorized   TINYINT UNSIGNED NOT NULL DEFAULT 0,
  phone               VARCHAR(20)           DEFAULT NULL,
  phone_bind_status   TINYINT UNSIGNED NOT NULL DEFAULT 0,
  phone_bind_time     DATETIME              DEFAULT NULL,
  phone_source        VARCHAR(32)           DEFAULT NULL COMMENT 'wx_phone',
  status              TINYINT UNSIGNED NOT NULL DEFAULT 1,
  register_source     VARCHAR(32)  NOT NULL DEFAULT 'wx_miniprogram',
  created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_user_openid (openid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_profile (
  id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id             BIGINT UNSIGNED NOT NULL,
  gender              TINYINT UNSIGNED NOT NULL DEFAULT 0,
  age                 INT                   DEFAULT NULL,
  height_cm           DECIMAL(5,2)          DEFAULT NULL,
  initial_weight_kg   DECIMAL(6,2)          DEFAULT NULL,
  current_weight_kg   DECIMAL(6,2)          DEFAULT NULL,
  target_weight_kg    DECIMAL(6,2)          DEFAULT NULL,
  target_date         DATE                  DEFAULT NULL,
  profile_completed   TINYINT UNSIGNED NOT NULL DEFAULT 0,
  created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_user_profile_user (user_id),
  CONSTRAINT fk_user_profile_user FOREIGN KEY (user_id) REFERENCES lw_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_budget_config (
  id                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id               BIGINT UNSIGNED NOT NULL,
  use_custom_bmr        TINYINT UNSIGNED NOT NULL DEFAULT 0,
  custom_bmr            DECIMAL(10,2)         DEFAULT NULL,
  activity_level        DECIMAL(6,3)          DEFAULT NULL COMMENT '活动系数（PRD decimal）',
  calculated_bmr        DECIMAL(10,2)         DEFAULT NULL,
  calculated_tdee       DECIMAL(10,2)         DEFAULT NULL,
  recommended_deficit   DECIMAL(10,2)         DEFAULT NULL,
  daily_budget          DECIMAL(10,2)         DEFAULT NULL,
  carb_target_g         DECIMAL(10,2)         DEFAULT NULL,
  protein_target_g      DECIMAL(10,2)         DEFAULT NULL,
  fat_target_g          DECIMAL(10,2)         DEFAULT NULL,
  effective_date        DATE         NOT NULL,
  created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_budget_user_effective (user_id, effective_date),
  CONSTRAINT fk_user_budget_user FOREIGN KEY (user_id) REFERENCES lw_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO lw_user (
  id, openid, unionid, nickname, nickname_source, nickname_authorized,
  avatar, avatar_source, avatar_authorized, phone, phone_bind_status, phone_bind_time, phone_source,
  status, register_source, created_at, updated_at
)
SELECT
  id,
  openid,
  union_id,
  nickname,
  CASE
    WHEN nickname IS NULL OR TRIM(nickname) = '' THEN 'system_default'
    ELSE 'manual'
  END,
  0,
  avatar_url,
  CASE
    WHEN avatar_url IS NULL OR TRIM(avatar_url) = '' THEN 'system_default'
    ELSE 'manual'
  END,
  0,
  phone,
  CASE WHEN phone IS NOT NULL AND TRIM(phone) <> '' THEN 1 ELSE 0 END,
  NULL,
  CASE WHEN phone IS NOT NULL AND TRIM(phone) <> '' THEN 'wx_phone' ELSE NULL END,
  1,
  'wx_miniprogram',
  created_at,
  updated_at
FROM app_user;

INSERT INTO user_profile (
  user_id, gender, age, height_cm, initial_weight_kg, current_weight_kg, target_weight_kg,
  target_date, profile_completed, created_at, updated_at
)
SELECT
  id, gender, age, height_cm, initial_weight_kg, current_weight_kg, target_weight_kg,
  target_date, profile_completed, created_at, updated_at
FROM app_user;

INSERT INTO user_budget_config (
  user_id, use_custom_bmr, custom_bmr, activity_level, calculated_bmr, calculated_tdee,
  recommended_deficit, daily_budget, carb_target_g, protein_target_g, fat_target_g, effective_date,
  created_at, updated_at
)
SELECT
  id,
  0,
  NULL,
  CASE activity_level
    WHEN 1 THEN 1.200
    WHEN 2 THEN 1.375
    WHEN 3 THEN 1.550
    WHEN 4 THEN 1.725
    WHEN 5 THEN 1.900
    ELSE 1.375
  END,
  bmr,
  tdee,
  CASE
    WHEN tdee IS NOT NULL AND daily_calorie_goal IS NOT NULL THEN tdee - daily_calorie_goal
    ELSE NULL
  END,
  daily_calorie_goal,
  NULL,
  NULL,
  NULL,
  DATE(created_at),
  created_at,
  updated_at
FROM app_user;

DROP TABLE app_user;
