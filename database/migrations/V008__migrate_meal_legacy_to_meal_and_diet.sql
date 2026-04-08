-- =============================================================================
-- V008: 将 meal_record_legacy 按 (user_id, 日期, meal_type) 聚合写入 meal_record，并写入 diet_record。
-- 前置: V007
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

-- 可重复执行：先清空 PRD 餐次表再自 legacy 重建（勿在生产环境对已写入新餐次后重复执行）
DELETE FROM diet_record;
DELETE FROM meal_record;

INSERT INTO meal_record (
  user_id, record_date, meal_type,
  total_calories, total_carb_g, total_protein_g, total_fat_g, food_count, status,
  created_at, updated_at
)
SELECT
  user_id,
  DATE(recorded_at) AS record_date,
  meal_type,
  SUM(calories),
  SUM(COALESCE(carbs_g, 0)),
  SUM(COALESCE(protein_g, 0)),
  SUM(COALESCE(fat_g, 0)),
  COUNT(*),
  'submitted',
  MIN(created_at),
  MAX(created_at)
FROM meal_record_legacy
GROUP BY user_id, DATE(recorded_at), meal_type;

INSERT INTO diet_record (
  meal_id, user_id, record_date, meal_type, food_id,
  food_name_snapshot, image_snapshot, gi_level_snapshot,
  amount, amount_unit, weight_g,
  calories_total, carb_total_g, protein_total_g, fat_total_g,
  source, record_time, created_at, updated_at
)
SELECT
  m.id,
  l.user_id,
  DATE(l.recorded_at),
  l.meal_type,
  l.food_library_id,
  l.food_name,
  NULL,
  NULL,
  l.amount_value,
  l.amount_unit,
  NULL,
  l.calories,
  l.carbs_g,
  l.protein_g,
  l.fat_g,
  'manual',
  l.recorded_at,
  l.created_at,
  CURRENT_TIMESTAMP
FROM meal_record_legacy l
JOIN meal_record m
  ON m.user_id = l.user_id
 AND m.record_date = DATE(l.recorded_at)
 AND m.meal_type = l.meal_type;
