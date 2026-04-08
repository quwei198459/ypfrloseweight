-- =============================================================================
-- V011: daily_summary 列名与 PRD 对齐，并补充缺口/目标/餐时/日状态等字段。
-- 前置: V004
-- 说明: 新增数值列默认 NULL，由后续批任务或应用按 PRD 公式回填
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

ALTER TABLE daily_summary
  CHANGE COLUMN total_intake_calories intake_calories DECIMAL(12,2) NOT NULL DEFAULT 0,
  CHANGE COLUMN total_sport_calories exercise_calories DECIMAL(12,2) NOT NULL DEFAULT 0,
  CHANGE COLUMN protein_g protein_total_g DECIMAL(12,2) DEFAULT NULL,
  CHANGE COLUMN fat_g fat_total_g DECIMAL(12,2) DEFAULT NULL,
  CHANGE COLUMN carbs_g carb_total_g DECIMAL(12,2) DEFAULT NULL,
  ADD COLUMN daily_budget DECIMAL(12,2) DEFAULT NULL AFTER summary_date,
  ADD COLUMN remain_calories DECIMAL(12,2) DEFAULT NULL AFTER exercise_calories,
  ADD COLUMN actual_deficit_calories DECIMAL(12,2) DEFAULT NULL AFTER remain_calories,
  ADD COLUMN budget_deficit_calories DECIMAL(12,2) DEFAULT NULL AFTER actual_deficit_calories,
  ADD COLUMN carb_target_g DECIMAL(12,2) DEFAULT NULL AFTER carb_total_g,
  ADD COLUMN protein_target_g DECIMAL(12,2) DEFAULT NULL AFTER protein_total_g,
  ADD COLUMN fat_target_g DECIMAL(12,2) DEFAULT NULL AFTER fat_total_g,
  ADD COLUMN first_meal_time DATETIME DEFAULT NULL AFTER fat_target_g,
  ADD COLUMN last_meal_time DATETIME DEFAULT NULL AFTER first_meal_time,
  ADD COLUMN healthy_diet_flag TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER eating_window_hours,
  ADD COLUMN day_status VARCHAR(16) NOT NULL DEFAULT 'normal' COMMENT 'normal/overeat/invalid' AFTER healthy_diet_flag,
  ADD COLUMN created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER day_status;
