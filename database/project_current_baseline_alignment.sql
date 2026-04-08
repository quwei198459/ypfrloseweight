-- =============================================================================
-- project_current_baseline_alignment.sql
-- 用途：将空库或部分缺表环境向「当前项目基线」对齐（见 docs/project-current-baseline-prd.md）
--
-- 硬性约束（本文件遵守）：
--   · 不允许 DROP TABLE / TRUNCATE / DELETE（不删表、不清数据）
--   · 仅使用 CREATE TABLE IF NOT EXISTS、ALTER TABLE … ADD …（含 ADD COLUMN / KEY / CONSTRAINT）
--   · 可重复执行：重复执行时依赖「若不存在则 ADD」的存储过程；裸 ALTER ADD 仅出现在过程内且带判断
--
-- 局限（须人工 / Flyway 其它脚本处理）：
--   · 若仍存在「旧版一行一食物」的 meal_record 且未改名为 meal_record_legacy，与本基线餐次头 meal_record
--     同名冲突 —— 本脚本不会 RENAME / DROP，请先执行 database/migrations/V001 或手工迁移。
--   · daily_summary 若仍为 01_schema 列名（total_intake_calories 等），需 V011 的 CHANGE —— 非 ADD 可单独完成，
--     请先执行 Flyway V011 或接受保留旧列（本脚本不向旧表 ADD 一套并列的新名列以免重复语义）。
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

-- =============================================================================
-- 【LEGACY】历史/对照用表：与 database/01_schema.sql 及早期迁移一致，非运行时标准模型
-- 真源用户表为 lw_user；真源食物为 food + food_category；真源运动项目库为 sport_item
-- =============================================================================

-- LEGACY: 旧小程序用户表（迁移目标 lw_user，勿在新业务写入）
CREATE TABLE IF NOT EXISTS app_user (
  id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  openid            VARCHAR(64)  NOT NULL COMMENT '微信 openid',
  union_id          VARCHAR(64)           DEFAULT NULL,
  nickname          VARCHAR(64)           DEFAULT NULL,
  avatar_url        VARCHAR(512)          DEFAULT NULL,
  phone             VARCHAR(20)           DEFAULT NULL,
  profile_completed TINYINT UNSIGNED NOT NULL DEFAULT 0,
  gender            TINYINT UNSIGNED NOT NULL DEFAULT 0,
  age               INT UNSIGNED          DEFAULT NULL,
  height_cm         DECIMAL(5,2)          DEFAULT NULL,
  current_weight_kg DECIMAL(6,2)        DEFAULT NULL,
  target_weight_kg  DECIMAL(6,2)        DEFAULT NULL,
  initial_weight_kg DECIMAL(6,2)        DEFAULT NULL,
  target_date       DATE                  DEFAULT NULL,
  bmr               INT UNSIGNED          DEFAULT NULL,
  tdee              INT UNSIGNED          DEFAULT NULL,
  daily_calorie_goal INT UNSIGNED       DEFAULT NULL,
  activity_level    TINYINT UNSIGNED NOT NULL DEFAULT 2,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_app_user_openid (openid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- LEGACY: 旧食物库（迁移目标 food；迁移后常见改名为 food_library_legacy）
CREATE TABLE IF NOT EXISTS food_library (
  id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name              VARCHAR(128) NOT NULL,
  calories_per_100  DECIMAL(8,2) NOT NULL,
  protein           DECIMAL(8,2)          DEFAULT NULL,
  fat               DECIMAL(8,2)          DEFAULT NULL,
  carbs             DECIMAL(8,2)          DEFAULT NULL,
  unit_label        VARCHAR(32)           DEFAULT NULL,
  category          VARCHAR(32)           DEFAULT NULL,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_food_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- LEGACY: 旧运动项目库（迁移目标 sport_item；迁移后常见改名为 sport_library_legacy）
CREATE TABLE IF NOT EXISTS sport_library (
  id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name              VARCHAR(64) NOT NULL,
  calories_per_min  DECIMAL(8,2)          DEFAULT NULL,
  icon              VARCHAR(32)           DEFAULT NULL,
  category          VARCHAR(32)           DEFAULT NULL,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sport_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- LEGACY: 识图流水旧表（现行以 meal_photo_recognition 为主）
CREATE TABLE IF NOT EXISTS food_recognition_log (
  id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id           BIGINT UNSIGNED       DEFAULT NULL,
  request_image_ref VARCHAR(512)          DEFAULT NULL,
  raw_response      MEDIUMTEXT            DEFAULT NULL,
  api_http_status   INT                   DEFAULT NULL,
  error_message     VARCHAR(512)          DEFAULT NULL,
  status            TINYINT UNSIGNED NOT NULL DEFAULT 0,
  result_summary    VARCHAR(512)          DEFAULT NULL,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_food_log_user (user_id, created_at),
  CONSTRAINT fk_food_log_user FOREIGN KEY (user_id) REFERENCES app_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- LEGACY: 旧体重表名（现行 user_weight_record；若仅存在本表，须迁移/改名，不在此脚本 DROP/RENAME）
CREATE TABLE IF NOT EXISTS weight_record (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED NOT NULL,
  record_date     DATE NOT NULL,
  weight_kg       DECIMAL(6,2) NOT NULL,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_weight_user_date (user_id, record_date),
  CONSTRAINT fk_weight_legacy_user FOREIGN KEY (user_id) REFERENCES app_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- LEGACY: 旧版「一行一食物」餐次数据归档表名（由 V001 自 meal_record 改名而来；勿与现行餐次头 meal_record 混淆）
CREATE TABLE IF NOT EXISTS meal_record_legacy (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED NOT NULL,
  meal_type       VARCHAR(16)  NOT NULL,
  food_name       VARCHAR(128) NOT NULL,
  calories        INT UNSIGNED NOT NULL,
  protein_g       DECIMAL(8,2)          DEFAULT NULL,
  fat_g           DECIMAL(8,2)          DEFAULT NULL,
  carbs_g         DECIMAL(8,2)          DEFAULT NULL,
  amount_value    DECIMAL(10,2)         DEFAULT NULL,
  amount_unit     VARCHAR(16)           DEFAULT NULL,
  recorded_at     DATETIME NOT NULL,
  food_library_id BIGINT UNSIGNED       DEFAULT NULL,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_meal_legacy_user_time (user_id, recorded_at),
  CONSTRAINT fk_meal_legacy_app_user FOREIGN KEY (user_id) REFERENCES app_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- 【现行】基线表：与 backend 实体、Flyway V003+ 及 docs/project-current-baseline-prd.md 一致
-- =============================================================================

CREATE TABLE IF NOT EXISTS lw_user (
  id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  openid              VARCHAR(64)  NOT NULL COMMENT '微信 openid',
  unionid             VARCHAR(64)           DEFAULT NULL,
  nickname            VARCHAR(64)           DEFAULT NULL,
  nickname_source     VARCHAR(32)  NOT NULL DEFAULT 'system_default',
  nickname_authorized TINYINT UNSIGNED NOT NULL DEFAULT 0,
  avatar              VARCHAR(512)          DEFAULT NULL,
  avatar_source       VARCHAR(32)  NOT NULL DEFAULT 'system_default',
  avatar_authorized   TINYINT UNSIGNED NOT NULL DEFAULT 0,
  phone               VARCHAR(20)           DEFAULT NULL,
  phone_bind_status   TINYINT UNSIGNED NOT NULL DEFAULT 0,
  phone_bind_time     DATETIME              DEFAULT NULL,
  phone_source        VARCHAR(32)           DEFAULT NULL,
  status              TINYINT UNSIGNED NOT NULL DEFAULT 1,
  register_source     VARCHAR(32)  NOT NULL DEFAULT 'wx_miniprogram',
  created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_user_openid (openid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_profile (
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

CREATE TABLE IF NOT EXISTS user_budget_config (
  id                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id               BIGINT UNSIGNED NOT NULL,
  use_custom_bmr        TINYINT UNSIGNED NOT NULL DEFAULT 0,
  custom_bmr            DECIMAL(10,2)         DEFAULT NULL,
  activity_level        DECIMAL(6,3)          DEFAULT NULL,
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

CREATE TABLE IF NOT EXISTS food_category (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name       VARCHAR(64)  NOT NULL,
  parent_id  BIGINT UNSIGNED DEFAULT NULL,
  type       VARCHAR(16)  NOT NULL DEFAULT 'common',
  sort_no    INT NOT NULL DEFAULT 0,
  status     TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uk_food_category_name (name),
  KEY idx_food_category_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS food (
  id                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  creator_user_id       BIGINT UNSIGNED DEFAULT NULL,
  category_id           BIGINT UNSIGNED NOT NULL,
  name                  VARCHAR(128) NOT NULL,
  image                 VARCHAR(512) DEFAULT NULL,
  gi_level              VARCHAR(16)  DEFAULT NULL,
  calories_per_100g     DECIMAL(10,2) NOT NULL,
  calories_per_unit     DECIMAL(10,2) DEFAULT NULL,
  unit_name             VARCHAR(32)  DEFAULT NULL,
  standard_weight_g     DECIMAL(10,2) DEFAULT NULL,
  edible_portion_rate   DECIMAL(6,2) DEFAULT NULL,
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

CREATE TABLE IF NOT EXISTS meal_record (
  id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id          BIGINT UNSIGNED NOT NULL,
  record_date      DATE         NOT NULL,
  meal_type        VARCHAR(16)  NOT NULL COMMENT 'breakfast/lunch/dinner/snack',
  total_calories   DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_carb_g     DECIMAL(12,2) DEFAULT NULL,
  total_protein_g  DECIMAL(12,2) DEFAULT NULL,
  total_fat_g      DECIMAL(12,2) DEFAULT NULL,
  food_count       INT NOT NULL DEFAULT 0,
  status           VARCHAR(16)  NOT NULL DEFAULT 'draft',
  created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_meal_user_date_type (user_id, record_date, meal_type),
  CONSTRAINT fk_meal_record_user FOREIGN KEY (user_id) REFERENCES lw_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS diet_record (
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
  source               VARCHAR(16)  NOT NULL DEFAULT 'manual',
  record_time          DATETIME NOT NULL,
  created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_diet_meal (meal_id),
  KEY idx_diet_user_date (user_id, record_date),
  KEY fk_diet_food (food_id),
  CONSTRAINT fk_diet_meal FOREIGN KEY (meal_id) REFERENCES meal_record (id),
  CONSTRAINT fk_diet_user FOREIGN KEY (user_id) REFERENCES lw_user (id),
  CONSTRAINT fk_diet_food FOREIGN KEY (food_id) REFERENCES food (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS sport_item (
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

CREATE TABLE IF NOT EXISTS sport_record (
  id                   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id              BIGINT UNSIGNED NOT NULL,
  record_date          DATE DEFAULT NULL,
  sport_item_id        BIGINT UNSIGNED DEFAULT NULL,
  sport_name_snapshot  VARCHAR(64) DEFAULT NULL,
  icon_snapshot        VARCHAR(32) DEFAULT NULL,
  duration_min         INT UNSIGNED DEFAULT NULL,
  calories_burned      DECIMAL(12,2) DEFAULT NULL,
  source               VARCHAR(16) NOT NULL DEFAULT 'manual',
  record_time          DATETIME DEFAULT NULL,
  created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sr_user_id (user_id),
  KEY idx_sport_record_user_date (user_id, record_date),
  KEY fk_sport_record_item (sport_item_id),
  CONSTRAINT fk_sport_record_user FOREIGN KEY (user_id) REFERENCES lw_user (id),
  CONSTRAINT fk_sport_record_item FOREIGN KEY (sport_item_id) REFERENCES sport_item (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_weight_record (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id      BIGINT UNSIGNED NOT NULL,
  record_date  DATE NOT NULL,
  weight_kg    DECIMAL(6,2) NOT NULL,
  source       VARCHAR(16) NOT NULL DEFAULT 'manual',
  remark       VARCHAR(256) DEFAULT NULL,
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_uwr_user_id (user_id),
  CONSTRAINT fk_weight_record_user FOREIGN KEY (user_id) REFERENCES lw_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS daily_summary (
  id                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id               BIGINT UNSIGNED NOT NULL,
  summary_date          DATE NOT NULL,
  daily_budget          DECIMAL(12,2) DEFAULT NULL,
  intake_calories       DECIMAL(12,2) NOT NULL DEFAULT 0,
  exercise_calories     DECIMAL(12,2) NOT NULL DEFAULT 0,
  remain_calories       DECIMAL(12,2) DEFAULT NULL,
  actual_deficit_calories   DECIMAL(12,2) DEFAULT NULL,
  budget_deficit_calories   DECIMAL(12,2) DEFAULT NULL,
  protein_total_g       DECIMAL(12,2) DEFAULT NULL,
  protein_target_g      DECIMAL(12,2) DEFAULT NULL,
  fat_total_g           DECIMAL(12,2) DEFAULT NULL,
  fat_target_g          DECIMAL(12,2) DEFAULT NULL,
  carb_total_g          DECIMAL(12,2) DEFAULT NULL,
  carb_target_g         DECIMAL(12,2) DEFAULT NULL,
  first_meal_time       DATETIME DEFAULT NULL,
  last_meal_time        DATETIME DEFAULT NULL,
  eating_window_hours   DECIMAL(6,2) DEFAULT NULL,
  healthy_diet_flag     TINYINT UNSIGNED NOT NULL DEFAULT 0,
  day_status            VARCHAR(16) NOT NULL DEFAULT 'normal',
  created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_daily_summary_user_date (user_id, summary_date),
  CONSTRAINT fk_daily_summary_user FOREIGN KEY (user_id) REFERENCES lw_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS meal_photo_recognition (
  id                   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id              BIGINT UNSIGNED NOT NULL,
  meal_type            VARCHAR(16)  NOT NULL,
  recommended_meal_type VARCHAR(16) DEFAULT NULL,
  confirmed_meal_type  VARCHAR(16) DEFAULT NULL,
  record_date          DATE         NOT NULL,
  source               VARCHAR(16)  NOT NULL DEFAULT 'camera',
  image_url            VARCHAR(512) DEFAULT NULL,
  recognized_food_name VARCHAR(128) DEFAULT NULL,
  confirmed_food_name  VARCHAR(128) DEFAULT NULL,
  recognized_calories  DECIMAL(12,2) DEFAULT NULL,
  confirmed_calories   DECIMAL(12,2) DEFAULT NULL,
  recommended_eat_ratio DECIMAL(6,4) DEFAULT NULL,
  confirmed_eat_ratio  DECIMAL(6,4) DEFAULT NULL,
  badge_progress_percent DECIMAL(5,2) DEFAULT NULL,
  recognize_status     VARCHAR(24)  NOT NULL DEFAULT 'uploading',
  confirm_status       VARCHAR(24)  NOT NULL DEFAULT 'none',
  confirmed_at         DATETIME DEFAULT NULL,
  meal_record_id       BIGINT UNSIGNED DEFAULT NULL,
  diet_record_id       BIGINT UNSIGNED DEFAULT NULL,
  vendor               VARCHAR(32)  DEFAULT NULL,
  vendor_request_id    VARCHAR(128) DEFAULT NULL,
  raw_result           TEXT,
  parsed_result_json   TEXT,
  result_type          VARCHAR(32)  DEFAULT NULL,
  error_code           VARCHAR(64)  DEFAULT NULL,
  error_message        VARCHAR(512) DEFAULT NULL,
  created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_photo_recog_user_date (user_id, record_date, recognize_status),
  KEY idx_photo_recog_meal_record (meal_record_id),
  KEY idx_photo_recog_confirm (user_id, confirm_status, record_date),
  KEY idx_photo_recog_confirmed_at (confirmed_at),
  KEY fk_photo_recog_diet_record (diet_record_id),
  CONSTRAINT fk_photo_recog_user FOREIGN KEY (user_id) REFERENCES lw_user (id),
  CONSTRAINT fk_photo_recog_meal_record FOREIGN KEY (meal_record_id) REFERENCES meal_record (id) ON DELETE SET NULL,
  CONSTRAINT fk_photo_recog_diet_record FOREIGN KEY (diet_record_id) REFERENCES diet_record (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS meal_evaluation (
  id                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id            BIGINT UNSIGNED NOT NULL,
  meal_id            BIGINT UNSIGNED NOT NULL,
  record_date        DATE         NOT NULL,
  meal_type          VARCHAR(16)  NOT NULL,
  total_calories     DECIMAL(12,2) NOT NULL DEFAULT 0,
  score_level        VARCHAR(16)  NOT NULL,
  advantage_text     TEXT,
  disadvantage_text  TEXT,
  suggestion_text    TEXT,
  created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_meal_eval_user (user_id, record_date),
  CONSTRAINT fk_meal_eval_user FOREIGN KEY (user_id) REFERENCES lw_user (id),
  CONSTRAINT fk_meal_eval_meal FOREIGN KEY (meal_id) REFERENCES meal_record (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS wechat_login_log (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED       DEFAULT NULL,
  openid          VARCHAR(64)           DEFAULT NULL,
  union_id        VARCHAR(64)           DEFAULT NULL,
  success         TINYINT UNSIGNED NOT NULL DEFAULT 1,
  error_message   VARCHAR(256)          DEFAULT NULL,
  login_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  client_ip       VARCHAR(45)           DEFAULT NULL,
  client_ua       VARCHAR(512)          DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_wx_login_user_time (user_id, login_at),
  KEY idx_wx_login_openid_time (openid, login_at),
  CONSTRAINT fk_wx_login_user FOREIGN KEY (user_id) REFERENCES lw_user (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_plan (
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

CREATE TABLE IF NOT EXISTS vip_user (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id     BIGINT UNSIGNED NOT NULL,
  vip_type    VARCHAR(16)  NOT NULL,
  start_time  DATETIME              DEFAULT NULL,
  end_time    DATETIME              DEFAULT NULL,
  status      TINYINT UNSIGNED NOT NULL DEFAULT 0,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_vip_user_user (user_id),
  CONSTRAINT fk_vip_user_user FOREIGN KEY (user_id) REFERENCES lw_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS vip_order (
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

-- =============================================================================
-- 幂等补充：仅 ALTER … ADD（列 / 索引 / 外键），用于「表已存在但缺 V017 / V015 等增量」的环境
-- =============================================================================

DROP PROCEDURE IF EXISTS sp_project_baseline_align_add_only;

DELIMITER $$

CREATE PROCEDURE sp_project_baseline_align_add_only()
BEGIN
  DECLARE dbname VARCHAR(64);
  SET dbname = DATABASE();

  -- food_category.code + 唯一索引（V017）
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'food_category' AND COLUMN_NAME = 'code'
  ) THEN
    ALTER TABLE food_category
      ADD COLUMN code VARCHAR(32) NULL COMMENT 'sidebar key' AFTER name;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'food_category' AND INDEX_NAME = 'uk_food_category_code'
  ) THEN
    ALTER TABLE food_category ADD UNIQUE KEY uk_food_category_code (code);
  END IF;

  -- user_weight_record：source / remark（V010）
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'user_weight_record' AND COLUMN_NAME = 'source'
  ) THEN
    ALTER TABLE user_weight_record
      ADD COLUMN source VARCHAR(16) NOT NULL DEFAULT 'manual' COMMENT 'manual/system' AFTER weight_kg;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'user_weight_record' AND COLUMN_NAME = 'remark'
  ) THEN
    ALTER TABLE user_weight_record
      ADD COLUMN remark VARCHAR(256) DEFAULT NULL AFTER source;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'user_weight_record' AND INDEX_NAME = 'idx_uwr_user_id'
  ) THEN
    ALTER TABLE user_weight_record ADD KEY idx_uwr_user_id (user_id);
  END IF;

  -- sport_record：PRD 增量列（V009 思路，仅 ADD）
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'record_date'
  ) THEN
    ALTER TABLE sport_record ADD COLUMN record_date DATE DEFAULT NULL AFTER user_id;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'sport_item_id'
  ) THEN
    ALTER TABLE sport_record ADD COLUMN sport_item_id BIGINT UNSIGNED DEFAULT NULL AFTER record_date;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'sport_name_snapshot'
  ) THEN
    ALTER TABLE sport_record ADD COLUMN sport_name_snapshot VARCHAR(64) DEFAULT NULL AFTER sport_item_id;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'icon_snapshot'
  ) THEN
    ALTER TABLE sport_record ADD COLUMN icon_snapshot VARCHAR(32) DEFAULT NULL AFTER sport_name_snapshot;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'calories_burned'
  ) THEN
    ALTER TABLE sport_record ADD COLUMN calories_burned DECIMAL(12,2) DEFAULT NULL AFTER duration_min;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'source'
  ) THEN
    ALTER TABLE sport_record ADD COLUMN source VARCHAR(16) NOT NULL DEFAULT 'manual' AFTER calories_burned;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'record_time'
  ) THEN
    ALTER TABLE sport_record ADD COLUMN record_time DATETIME DEFAULT NULL AFTER source;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND COLUMN_NAME = 'updated_at'
  ) THEN
    ALTER TABLE sport_record
      ADD COLUMN updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND INDEX_NAME = 'idx_sr_user_id'
  ) THEN
    ALTER TABLE sport_record ADD KEY idx_sr_user_id (user_id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND INDEX_NAME = 'idx_sport_record_user_date'
  ) THEN
    ALTER TABLE sport_record ADD KEY idx_sport_record_user_date (user_id, record_date);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record' AND INDEX_NAME = 'fk_sport_record_item'
  ) THEN
    ALTER TABLE sport_record ADD KEY fk_sport_record_item (sport_item_id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'sport_record'
      AND CONSTRAINT_NAME = 'fk_sport_record_item' AND CONSTRAINT_TYPE = 'FOREIGN KEY'
  ) THEN
    ALTER TABLE sport_record
      ADD CONSTRAINT fk_sport_record_item FOREIGN KEY (sport_item_id) REFERENCES sport_item (id);
  END IF;

  -- meal_photo_recognition：若仅存 V012 窄表，则补 V015 列（仅 ADD；单列判断避免半迁移失败）
  IF EXISTS (
    SELECT 1 FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition'
  ) THEN
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'recommended_meal_type'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN recommended_meal_type VARCHAR(16) DEFAULT NULL COMMENT 'server recommend meal' AFTER meal_type;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'confirmed_meal_type'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN confirmed_meal_type VARCHAR(16) DEFAULT NULL COMMENT 'user confirmed meal' AFTER recommended_meal_type;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'recognized_food_name'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN recognized_food_name VARCHAR(128) DEFAULT NULL AFTER image_url;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'confirmed_food_name'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN confirmed_food_name VARCHAR(128) DEFAULT NULL AFTER recognized_food_name;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'recognized_calories'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN recognized_calories DECIMAL(12,2) DEFAULT NULL AFTER confirmed_food_name;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'confirmed_calories'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN confirmed_calories DECIMAL(12,2) DEFAULT NULL AFTER recognized_calories;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'recommended_eat_ratio'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN recommended_eat_ratio DECIMAL(6,4) DEFAULT NULL AFTER confirmed_calories;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'confirmed_eat_ratio'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN confirmed_eat_ratio DECIMAL(6,4) DEFAULT NULL AFTER recommended_eat_ratio;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'badge_progress_percent'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN badge_progress_percent DECIMAL(5,2) DEFAULT NULL AFTER confirmed_eat_ratio;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'confirm_status'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN confirm_status VARCHAR(24) NOT NULL DEFAULT 'none' AFTER recognize_status;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'confirmed_at'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN confirmed_at DATETIME DEFAULT NULL AFTER confirm_status;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'meal_record_id'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN meal_record_id BIGINT UNSIGNED DEFAULT NULL AFTER confirmed_at;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND COLUMN_NAME = 'diet_record_id'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD COLUMN diet_record_id BIGINT UNSIGNED DEFAULT NULL AFTER meal_record_id;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND INDEX_NAME = 'idx_photo_recog_meal_record'
    ) THEN
      ALTER TABLE meal_photo_recognition ADD KEY idx_photo_recog_meal_record (meal_record_id);
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND INDEX_NAME = 'idx_photo_recog_confirm'
    ) THEN
      ALTER TABLE meal_photo_recognition ADD KEY idx_photo_recog_confirm (user_id, confirm_status, record_date);
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND INDEX_NAME = 'idx_photo_recog_confirmed_at'
    ) THEN
      ALTER TABLE meal_photo_recognition ADD KEY idx_photo_recog_confirmed_at (confirmed_at);
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition' AND INDEX_NAME = 'fk_photo_recog_diet_record'
    ) THEN
      ALTER TABLE meal_photo_recognition ADD KEY fk_photo_recog_diet_record (diet_record_id);
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition'
        AND CONSTRAINT_NAME = 'fk_photo_recog_meal_record' AND CONSTRAINT_TYPE = 'FOREIGN KEY'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD CONSTRAINT fk_photo_recog_meal_record FOREIGN KEY (meal_record_id) REFERENCES meal_record (id) ON DELETE SET NULL;
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
      WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'meal_photo_recognition'
        AND CONSTRAINT_NAME = 'fk_photo_recog_diet_record' AND CONSTRAINT_TYPE = 'FOREIGN KEY'
    ) THEN
      ALTER TABLE meal_photo_recognition
        ADD CONSTRAINT fk_photo_recog_diet_record FOREIGN KEY (diet_record_id) REFERENCES diet_record (id) ON DELETE SET NULL;
    END IF;
  END IF;

END$$

DELIMITER ;

CALL sp_project_baseline_align_add_only();

DROP PROCEDURE IF EXISTS sp_project_baseline_align_add_only;

-- 结束：未包含 DROP INDEX / MODIFY / UPDATE / INSERT，故不删除唯一约束、不改列类型、不搬运数据。
-- 需要删除 uk_weight_user_date 或宽 sport_record 旧列等非 ADD 操作时，请使用 Flyway V016/V009 等在备份后执行。
