-- =============================================================================
-- V004: 为仍引用 user_id 的子表添加指向 lw_user(id) 的外键（PRD 逻辑名 user）。
-- 前置: V003
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

ALTER TABLE meal_record_legacy
  ADD CONSTRAINT fk_meal_legacy_user FOREIGN KEY (user_id) REFERENCES lw_user (id);

ALTER TABLE sport_record
  ADD CONSTRAINT fk_sport_record_user FOREIGN KEY (user_id) REFERENCES lw_user (id);

ALTER TABLE weight_record
  ADD CONSTRAINT fk_weight_record_user FOREIGN KEY (user_id) REFERENCES lw_user (id);

ALTER TABLE food_recognition_log
  ADD CONSTRAINT fk_food_recog_log_user FOREIGN KEY (user_id) REFERENCES lw_user (id);

ALTER TABLE daily_summary
  ADD CONSTRAINT fk_daily_summary_user FOREIGN KEY (user_id) REFERENCES lw_user (id);

ALTER TABLE wechat_login_log
  ADD CONSTRAINT fk_wx_login_user FOREIGN KEY (user_id) REFERENCES lw_user (id) ON DELETE SET NULL;
