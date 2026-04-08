-- =============================================================================
-- V017: 食物侧栏 code、分类列表 API、按分类查食物 — 与前端 food-search 对齐
-- 幂等：可重复执行；依赖 food_category / food 表（V005）
-- 执行：mysql -h ... -u ... -p loseweight < database/migrations/V017__food_category_code_sidebar_seed.sql
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

DROP PROCEDURE IF EXISTS sp_v017_apply;

DELIMITER $$

CREATE PROCEDURE sp_v017_apply()
BEGIN
  DECLARE dbname VARCHAR(64);
  SET dbname = DATABASE();

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'food_category' AND COLUMN_NAME = 'code'
  ) THEN
    ALTER TABLE food_category
      ADD COLUMN code VARCHAR(32) NULL COMMENT '前端侧栏 key，与 GET /food-categories 一致' AFTER name;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = dbname AND TABLE_NAME = 'food_category' AND INDEX_NAME = 'uk_food_category_code'
  ) THEN
    ALTER TABLE food_category ADD UNIQUE KEY uk_food_category_code (code);
  END IF;
END$$

DELIMITER ;

CALL sp_v017_apply();
DROP PROCEDURE IF EXISTS sp_v017_apply;

-- 已有中文名则补 code（避免与唯一 name 冲突时重复插入）
UPDATE food_category SET code = 'main_staple' WHERE name = '主食' AND code IS NULL;
UPDATE food_category SET code = 'veg' WHERE name IN ('蔬菜', '青菜') AND code IS NULL;
UPDATE food_category SET code = 'fruit' WHERE name = '水果' AND code IS NULL;
UPDATE food_category SET code = 'milk' WHERE name IN ('乳制品', '奶类') AND code IS NULL;
UPDATE food_category SET code = 'meat' WHERE name IN ('肉类', '肉') AND code IS NULL;
UPDATE food_category SET code = 'seafood' WHERE name IN ('海鲜', '水产') AND code IS NULL;
UPDATE food_category SET code = 'egg' WHERE name IN ('鸡蛋', '蛋类') AND code IS NULL;
UPDATE food_category SET code = 'bean' WHERE name IN ('豆制品', '豆类') AND code IS NULL;
UPDATE food_category SET code = 'nuts' WHERE name IN ('坚果', '干果') AND code IS NULL;
UPDATE food_category SET code = 'drink' WHERE name IN ('饮品', '饮料') AND code IS NULL;
UPDATE food_category SET code = 'other' WHERE name IN ('未分类', '其他') AND code IS NULL;

-- 按侧栏顺序插入缺失分类（uk_food_category_name：名称不可重复）
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '常用', 'common', NULL, 'system', 0, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'common');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '早餐', 'breakfast', NULL, 'system', 1, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'breakfast');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '午餐', 'lunch', NULL, 'system', 2, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'lunch');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '晚餐', 'dinner', NULL, 'system', 3, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'dinner');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '加餐', 'snack', NULL, 'system', 4, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'snack');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '主食', 'main_staple', NULL, 'system', 5, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'main_staple');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '蛋白', 'protein', NULL, 'system', 6, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'protein');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '蔬菜', 'veg', NULL, 'system', 7, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'veg');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '水果', 'fruit', NULL, 'system', 8, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'fruit');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '乳制品', 'milk', NULL, 'system', 9, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'milk');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '豆制品', 'bean', NULL, 'system', 10, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'bean');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '坚果', 'nuts', NULL, 'system', 11, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'nuts');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '海鲜', 'seafood', NULL, 'system', 12, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'seafood');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '肉类', 'meat', NULL, 'system', 13, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'meat');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '鸡蛋', 'egg', NULL, 'system', 14, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'egg');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '面食', 'noodle', NULL, 'system', 15, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'noodle');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '粗粮', 'grain', NULL, 'system', 16, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'grain');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '汤类', 'soup', NULL, 'system', 17, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'soup');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '甜品', 'dessert', NULL, 'system', 18, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'dessert');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '小食', 'snack2', NULL, 'system', 19, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'snack2');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '饮品', 'drink', NULL, 'system', 20, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'drink');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '简餐', 'fastfood', NULL, 'system', 21, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'fastfood');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '调味', 'sauce', NULL, 'system', 22, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'sauce');
INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
SELECT '其他', 'other', NULL, 'system', 23, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM food_category WHERE code = 'other');

-- 样例食物：每分类至少 2 条（仅当该分类下尚无同名公共食物时插入）
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'common' LIMIT 1), '燕麦片', 389.00, 100.00, '100g', 66.0, 13.0, 7.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'common')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'common' AND f.name = '燕麦片' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'common' LIMIT 1), '全麦面包', 246.00, 100.00, '100g', 41.0, 13.0, 4.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'common')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'common' AND f.name = '全麦面包' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'breakfast' LIMIT 1), '小米粥', 46.00, 100.00, '100g', 8.0, 1.4, 0.7, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'breakfast')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'breakfast' AND f.name = '小米粥' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'breakfast' LIMIT 1), '水煮蛋', 144.00, 100.00, '100g', 1.0, 13.0, 10.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'breakfast')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'breakfast' AND f.name = '水煮蛋' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'lunch' LIMIT 1), '糙米饭', 111.00, 100.00, '100g', 23.0, 2.6, 0.9, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'lunch')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'lunch' AND f.name = '糙米饭' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'lunch' LIMIT 1), '清蒸鲈鱼', 105.00, 100.00, '100g', 0.0, 18.0, 3.5, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'lunch')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'lunch' AND f.name = '清蒸鲈鱼' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'dinner' LIMIT 1), '番茄鸡蛋面', 98.00, 100.00, '100g', 12.0, 5.0, 3.5, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'dinner')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'dinner' AND f.name = '番茄鸡蛋面' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'dinner' LIMIT 1), '凉拌黄瓜', 16.00, 100.00, '100g', 2.5, 0.8, 0.2, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'dinner')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'dinner' AND f.name = '凉拌黄瓜' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'snack' LIMIT 1), '希腊酸奶', 59.00, 100.00, '100g', 3.6, 10.0, 0.4, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'snack')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'snack' AND f.name = '希腊酸奶' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'snack' LIMIT 1), '苹果', 52.00, 100.00, '100g', 14.0, 0.3, 0.2, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'snack')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'snack' AND f.name = '苹果' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'main_staple' LIMIT 1), '白米饭', 116.00, 100.00, '100g', 25.6, 2.6, 0.3, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'main_staple')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'main_staple' AND f.name = '白米饭' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'main_staple' LIMIT 1), '红薯', 86.00, 100.00, '100g', 20.0, 1.6, 0.1, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'main_staple')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'main_staple' AND f.name = '红薯' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'protein' LIMIT 1), '鸡胸肉', 165.00, 100.00, '100g', 0.0, 31.0, 3.6, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'protein')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'protein' AND f.name = '鸡胸肉' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'protein' LIMIT 1), '北豆腐', 76.00, 100.00, '100g', 1.8, 8.0, 4.8, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'protein')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'protein' AND f.name = '北豆腐' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'veg' LIMIT 1), '西兰花', 34.00, 100.00, '100g', 4.0, 3.0, 0.4, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'veg')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'veg' AND f.name = '西兰花' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'veg' LIMIT 1), '菠菜', 23.00, 100.00, '100g', 2.0, 2.9, 0.4, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'veg')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'veg' AND f.name = '菠菜' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'fruit' LIMIT 1), '香蕉', 89.00, 100.00, '100g', 23.0, 1.1, 0.3, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'fruit')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'fruit' AND f.name = '香蕉' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'fruit' LIMIT 1), '蓝莓', 57.00, 100.00, '100g', 14.0, 0.7, 0.3, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'fruit')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'fruit' AND f.name = '蓝莓' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'milk' LIMIT 1), '纯牛奶', 54.00, 100.00, '100g', 4.8, 3.0, 3.2, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'milk')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'milk' AND f.name = '纯牛奶' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'milk' LIMIT 1), '无糖酸奶', 61.00, 100.00, '100g', 4.7, 3.2, 3.3, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'milk')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'milk' AND f.name = '无糖酸奶' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'bean' LIMIT 1), '豆浆', 31.00, 100.00, '100g', 1.0, 3.0, 1.6, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'bean')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'bean' AND f.name = '豆浆' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'bean' LIMIT 1), '毛豆', 131.00, 100.00, '100g', 10.0, 13.0, 5.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'bean')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'bean' AND f.name = '毛豆' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'nuts' LIMIT 1), '杏仁', 578.00, 100.00, '100g', 10.0, 21.0, 50.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'nuts')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'nuts' AND f.name = '杏仁' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'nuts' LIMIT 1), '核桃', 654.00, 100.00, '100g', 8.0, 15.0, 65.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'nuts')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'nuts' AND f.name = '核桃' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'seafood' LIMIT 1), '虾仁', 48.00, 100.00, '100g', 0.0, 11.0, 0.3, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'seafood')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'seafood' AND f.name = '虾仁' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'seafood' LIMIT 1), '三文鱼', 139.00, 100.00, '100g', 0.0, 20.0, 6.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'seafood')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'seafood' AND f.name = '三文鱼' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'meat' LIMIT 1), '瘦牛肉', 250.00, 100.00, '100g', 0.0, 26.0, 15.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'meat')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'meat' AND f.name = '瘦牛肉' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'meat' LIMIT 1), '猪里脊', 155.00, 100.00, '100g', 0.0, 21.0, 7.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'meat')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'meat' AND f.name = '猪里脊' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'egg' LIMIT 1), '鸡蛋（带壳）', 144.00, 100.00, '100g', 1.0, 13.0, 10.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'egg')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'egg' AND f.name = '鸡蛋（带壳）' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'egg' LIMIT 1), '蛋清', 48.00, 100.00, '100g', 0.7, 11.0, 0.1, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'egg')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'egg' AND f.name = '蛋清' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'noodle' LIMIT 1), '挂面', 348.00, 100.00, '100g', 72.0, 12.0, 1.5, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'noodle')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'noodle' AND f.name = '挂面' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'noodle' LIMIT 1), '刀削面', 110.00, 100.00, '100g', 22.0, 4.0, 0.5, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'noodle')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'noodle' AND f.name = '刀削面' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'grain' LIMIT 1), '藜麦', 368.00, 100.00, '100g', 64.0, 14.0, 6.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'grain')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'grain' AND f.name = '藜麦' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'grain' LIMIT 1), '玉米', 86.00, 100.00, '100g', 19.0, 3.2, 1.2, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'grain')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'grain' AND f.name = '玉米' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'soup' LIMIT 1), '紫菜蛋花汤', 28.00, 100.00, '100g', 2.0, 2.5, 1.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'soup')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'soup' AND f.name = '紫菜蛋花汤' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'soup' LIMIT 1), '冬瓜排骨汤', 45.00, 100.00, '100g', 1.0, 4.0, 2.5, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'soup')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'soup' AND f.name = '冬瓜排骨汤' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'dessert' LIMIT 1), '无糖布丁', 95.00, 100.00, '100g', 15.0, 3.0, 2.5, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'dessert')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'dessert' AND f.name = '无糖布丁' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'dessert' LIMIT 1), '红豆沙', 120.00, 100.00, '100g', 22.0, 2.0, 2.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'dessert')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'dessert' AND f.name = '红豆沙' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'snack2' LIMIT 1), '海苔', 35.00, 100.00, '100g', 4.0, 2.0, 0.5, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'snack2')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'snack2' AND f.name = '海苔' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'snack2' LIMIT 1), '魔芋爽', 12.00, 100.00, '100g', 2.0, 0.5, 0.1, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'snack2')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'snack2' AND f.name = '魔芋爽' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'drink' LIMIT 1), '黑咖啡', 2.00, 100.00, '100g', 0.0, 0.1, 0.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'drink')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'drink' AND f.name = '黑咖啡' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'drink' LIMIT 1), '柠檬水', 22.00, 100.00, '100g', 6.0, 0.1, 0.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'drink')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'drink' AND f.name = '柠檬水' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'fastfood' LIMIT 1), '全麦三明治', 210.00, 100.00, '100g', 28.0, 10.0, 6.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'fastfood')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'fastfood' AND f.name = '全麦三明治' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'fastfood' LIMIT 1), '鸡胸肉沙拉', 85.00, 100.00, '100g', 5.0, 12.0, 2.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'fastfood')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'fastfood' AND f.name = '鸡胸肉沙拉' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'sauce' LIMIT 1), '生抽', 20.00, 100.00, '100g', 3.0, 2.0, 0.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'sauce')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'sauce' AND f.name = '生抽' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'sauce' LIMIT 1), '橄榄油', 884.00, 100.00, '100g', 0.0, 0.0, 100.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'sauce')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'sauce' AND f.name = '橄榄油' AND f.creator_user_id IS NULL);

INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'other' LIMIT 1), '综合杂粮', 340.00, 100.00, '100g', 65.0, 12.0, 3.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'other')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'other' AND f.name = '综合杂粮' AND f.creator_user_id IS NULL);
INSERT INTO food (creator_user_id, category_id, name, calories_per_100g, standard_weight_g, unit_name, carb_per_100g, protein_per_100g, fat_per_100g, is_custom, status)
SELECT NULL, (SELECT id FROM food_category WHERE code = 'other' LIMIT 1), '即食燕麦杯', 380.00, 100.00, '100g', 62.0, 12.0, 8.0, 0, 1 FROM DUAL
WHERE EXISTS (SELECT 1 FROM food_category WHERE code = 'other')
  AND NOT EXISTS (SELECT 1 FROM food f INNER JOIN food_category c ON c.id = f.category_id WHERE c.code = 'other' AND f.name = '即食燕麦杯' AND f.creator_user_id IS NULL);
