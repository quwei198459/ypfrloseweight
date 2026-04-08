-- =============================================================================
-- V012: meal_evaluation（空表）、meal_photo_recognition；迁移 food_recognition_log 后删除旧表。
-- 前置: V004
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE meal_evaluation (
  id                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id            BIGINT UNSIGNED NOT NULL,
  meal_id            BIGINT UNSIGNED NOT NULL,
  record_date        DATE         NOT NULL,
  meal_type          VARCHAR(16)  NOT NULL,
  total_calories     DECIMAL(12,2) NOT NULL DEFAULT 0,
  score_level        VARCHAR(16)  NOT NULL COMMENT '优秀/良好/欠佳',
  advantage_text     TEXT,
  disadvantage_text  TEXT,
  suggestion_text    TEXT,
  created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_meal_eval_user (user_id, record_date),
  CONSTRAINT fk_meal_eval_user FOREIGN KEY (user_id) REFERENCES lw_user (id),
  CONSTRAINT fk_meal_eval_meal FOREIGN KEY (meal_id) REFERENCES meal_record (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE meal_photo_recognition (
  id                   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id              BIGINT UNSIGNED NOT NULL,
  meal_type            VARCHAR(16)  NOT NULL,
  record_date          DATE         NOT NULL,
  source               VARCHAR(16)  NOT NULL DEFAULT 'camera' COMMENT 'camera/album',
  image_url            VARCHAR(512) DEFAULT NULL,
  recognize_status     VARCHAR(24)  NOT NULL DEFAULT 'uploading' COMMENT 'uploading/recognizing/success/fail',
  vendor               VARCHAR(32)  DEFAULT NULL COMMENT 'aliyun',
  vendor_request_id    VARCHAR(128) DEFAULT NULL,
  raw_result           TEXT,
  parsed_result_json   TEXT,
  result_type          VARCHAR(32)  DEFAULT NULL COMMENT 'candidate_foods/keyword_only/failed',
  error_code           VARCHAR(64)  DEFAULT NULL,
  error_message        VARCHAR(512) DEFAULT NULL,
  created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_photo_recog_user_date (user_id, record_date, recognize_status),
  CONSTRAINT fk_photo_recog_user FOREIGN KEY (user_id) REFERENCES lw_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO meal_photo_recognition (
  user_id, meal_type, record_date, source, image_url, recognize_status,
  vendor, vendor_request_id, raw_result, parsed_result_json, result_type,
  error_code, error_message, created_at, updated_at
)
SELECT
  user_id,
  'snack',
  DATE(created_at),
  'camera',
  request_image_ref,
  CASE status
    WHEN 0 THEN 'uploading'
    WHEN 1 THEN 'success'
    WHEN 2 THEN 'fail'
    ELSE 'uploading'
  END,
  'aliyun',
  NULL,
  raw_response,
  NULL,
  NULL,
  NULL,
  error_message,
  created_at,
  created_at
FROM food_recognition_log
WHERE user_id IS NOT NULL;

ALTER TABLE food_recognition_log DROP FOREIGN KEY fk_food_recog_log_user;

DROP TABLE food_recognition_log;
