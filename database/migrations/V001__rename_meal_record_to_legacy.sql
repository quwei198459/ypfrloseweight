-- =============================================================================
-- V001: 将「一行一食物」的 meal_record 改名为 meal_record_legacy，释放表名供 PRD 餐次头使用。
-- 前置: 已执行 database/01_schema.sql（含 meal_record 表）
-- 说明: 仅改名；外键仍指向 app_user，约束名不变（InnoDB 随表保留）
-- 回滚: RENAME TABLE meal_record_legacy TO meal_record;
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

-- 若已迁移过则跳过（存在 legacy 且无 meal_record）
-- 手动判断：仅当存在 meal_record 时执行改名
SET @has_meal := (
  SELECT COUNT(*) FROM information_schema.tables
  WHERE table_schema = DATABASE() AND table_name = 'meal_record'
);
SET @sql := IF(@has_meal > 0,
  'RENAME TABLE meal_record TO meal_record_legacy',
  'SELECT ''skip: meal_record already renamed or missing'' AS msg'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
