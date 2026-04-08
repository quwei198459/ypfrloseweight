-- MySQL 8.0+ 建表脚本（库名 loseweight）
-- 执行：mysql -uroot -p < 01_schema.sql 或在客户端中运行

CREATE DATABASE IF NOT EXISTS loseweight
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE loseweight;

-- 小程序用户
CREATE TABLE IF NOT EXISTS app_user (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  openid          VARCHAR(64)  NOT NULL COMMENT '微信 openid，开发联调可用占位',
  union_id        VARCHAR(64)           DEFAULT NULL,
  nickname        VARCHAR(64)           DEFAULT NULL,
  avatar_url      VARCHAR(512)          DEFAULT NULL,
  phone           VARCHAR(20)           DEFAULT NULL COMMENT '微信授权手机号',
  profile_completed TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '1=资料已完善',
  gender          TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 未知 1 男 2 女',
  age             INT UNSIGNED          DEFAULT NULL,
  height_cm       DECIMAL(5,2)          DEFAULT NULL,
  current_weight_kg DECIMAL(6,2)        DEFAULT NULL,
  target_weight_kg  DECIMAL(6,2)        DEFAULT NULL,
  initial_weight_kg DECIMAL(6,2)        DEFAULT NULL,
  target_date     DATE                  DEFAULT NULL,
  bmr             INT UNSIGNED          DEFAULT NULL,
  tdee            INT UNSIGNED          DEFAULT NULL,
  daily_calorie_goal INT UNSIGNED       DEFAULT NULL COMMENT '每日摄入目标千卡',
  activity_level  TINYINT UNSIGNED NOT NULL DEFAULT 2 COMMENT '活动系数档位1-5',
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_app_user_openid (openid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 饮食记录（单条食物一行，便于时间线与汇总）
CREATE TABLE IF NOT EXISTS meal_record (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED NOT NULL,
  meal_type       VARCHAR(16)  NOT NULL COMMENT 'breakfast/lunch/dinner/snack',
  food_name       VARCHAR(128) NOT NULL,
  calories        INT UNSIGNED NOT NULL,
  protein_g       DECIMAL(8,2)          DEFAULT NULL,
  fat_g           DECIMAL(8,2)          DEFAULT NULL,
  carbs_g         DECIMAL(8,2)          DEFAULT NULL,
  amount_value    DECIMAL(10,2)         DEFAULT NULL,
  amount_unit     VARCHAR(16)           DEFAULT NULL COMMENT 'g/ml 等',
  recorded_at     DATETIME NOT NULL,
  food_library_id BIGINT UNSIGNED       DEFAULT NULL,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_meal_user_time (user_id, recorded_at),
  CONSTRAINT fk_meal_user FOREIGN KEY (user_id) REFERENCES app_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 运动记录
CREATE TABLE IF NOT EXISTS sport_record (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED NOT NULL,
  sport_name      VARCHAR(64)  NOT NULL,
  duration_min    INT UNSIGNED          DEFAULT NULL,
  calories        INT UNSIGNED NOT NULL,
  icon            VARCHAR(32)           DEFAULT NULL,
  recorded_at     DATETIME NOT NULL,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sport_user_time (user_id, recorded_at),
  CONSTRAINT fk_sport_user FOREIGN KEY (user_id) REFERENCES app_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 体重记录（按日一条，与前端 mock 列表一致）
CREATE TABLE IF NOT EXISTS weight_record (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED NOT NULL,
  record_date     DATE NOT NULL,
  weight_kg       DECIMAL(6,2) NOT NULL,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_weight_user_date (user_id, record_date),
  CONSTRAINT fk_weight_user FOREIGN KEY (user_id) REFERENCES app_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 食物库（热量查询 / 搜索）
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

-- 运动项目库
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

-- 拍照识别调用流水（含第三方原始响应，便于排查）
CREATE TABLE IF NOT EXISTS food_recognition_log (
  id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id           BIGINT UNSIGNED       DEFAULT NULL,
  request_image_ref VARCHAR(512)          DEFAULT NULL,
  raw_response      MEDIUMTEXT            DEFAULT NULL,
  api_http_status   INT                   DEFAULT NULL,
  error_message     VARCHAR(512)          DEFAULT NULL,
  status            TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0待处理1完成2失败',
  result_summary    VARCHAR(512)          DEFAULT NULL,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_food_log_user (user_id, created_at),
  CONSTRAINT fk_food_log_user FOREIGN KEY (user_id) REFERENCES app_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 日汇总（可由任务或接口维护）
CREATE TABLE IF NOT EXISTS daily_summary (
  id                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id               BIGINT UNSIGNED NOT NULL,
  summary_date          DATE NOT NULL,
  total_intake_calories INT UNSIGNED NOT NULL DEFAULT 0,
  total_sport_calories  INT UNSIGNED NOT NULL DEFAULT 0,
  protein_g             DECIMAL(10,2) DEFAULT NULL,
  fat_g                 DECIMAL(10,2) DEFAULT NULL,
  carbs_g               DECIMAL(10,2) DEFAULT NULL,
  eating_window_hours   DECIMAL(6,2) DEFAULT NULL,
  updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_daily_summary_user_date (user_id, summary_date),
  CONSTRAINT fk_daily_summary_user FOREIGN KEY (user_id) REFERENCES app_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 微信小程序每次登录流水（成功/失败均可记一条，便于审计与排错）
CREATE TABLE IF NOT EXISTS wechat_login_log (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED       DEFAULT NULL COMMENT '登录成功后关联 app_user.id；失败时可为空',
  openid          VARCHAR(64)           DEFAULT NULL COMMENT '成功换取后写入；code2session 失败时为空',
  union_id        VARCHAR(64)           DEFAULT NULL,
  success         TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1 成功 0 失败',
  error_message   VARCHAR(256)          DEFAULT NULL COMMENT '失败原因或微信返回错误摘要',
  login_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  client_ip       VARCHAR(45)           DEFAULT NULL,
  client_ua       VARCHAR(512)          DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_wx_login_user_time (user_id, login_at),
  KEY idx_wx_login_openid_time (openid, login_at),
  CONSTRAINT fk_wx_login_user FOREIGN KEY (user_id) REFERENCES app_user (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
