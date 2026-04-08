-- =============================================================================
-- V002: 删除所有引用 app_user 的外键，便于后续删除 app_user 并创建物理表 lw_user（PRD 逻辑名 user）。
-- 前置: V001
-- 回滚: 在 V004 中重建指向 lw_user 的外键；本步无单独回滚（需记录原约束名）
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE meal_record_legacy DROP FOREIGN KEY fk_meal_user;
ALTER TABLE sport_record DROP FOREIGN KEY fk_sport_user;
ALTER TABLE weight_record DROP FOREIGN KEY fk_weight_user;
ALTER TABLE food_recognition_log DROP FOREIGN KEY fk_food_log_user;
ALTER TABLE daily_summary DROP FOREIGN KEY fk_daily_summary_user;
ALTER TABLE wechat_login_log DROP FOREIGN KEY fk_wx_login_user;

SET FOREIGN_KEY_CHECKS = 1;
