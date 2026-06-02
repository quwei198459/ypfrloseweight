-- =============================================================================
-- V018: 旧分类(2–31)合并到侧栏 code 分类；全库默认食物图 URL；TOP50 单独图；补 gi_level 粗粒度
-- 幂等性：重复执行时 category 已为目标 id 的 UPDATE 行数可能为 0；image/gi 会再次覆盖为同一值
-- 执行后请运行: python tools/gen_food_image_assets.py（生成 default.png 与各 id.png）
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

-- ---------- 1) 旧分类 → 侧栏 code 对应分类主键（与 V017 food_category 一致） ----------
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'grain' LIMIT 1) WHERE category_id = 2;
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'meat' LIMIT 1) WHERE category_id IN (3, 4, 5);
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'egg' LIMIT 1) WHERE category_id = 6;
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'milk' LIMIT 1) WHERE category_id = 7;
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'fruit' LIMIT 1) WHERE category_id = 8;
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'veg' LIMIT 1) WHERE category_id IN (9, 10, 11);
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'bean' LIMIT 1) WHERE category_id IN (12, 13);
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'nuts' LIMIT 1) WHERE category_id = 14;
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'seafood' LIMIT 1) WHERE category_id IN (15, 16, 17, 18);
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'soup' LIMIT 1) WHERE category_id = 19;
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'breakfast' LIMIT 1) WHERE category_id = 20;
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'fastfood' LIMIT 1) WHERE category_id IN (21, 23, 24, 25);
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'snack2' LIMIT 1) WHERE category_id IN (22, 31);
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'dessert' LIMIT 1) WHERE category_id = 26;
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'drink' LIMIT 1) WHERE category_id IN (27, 28, 29);
UPDATE food SET category_id = (SELECT id FROM food_category WHERE code = 'sauce' LIMIT 1) WHERE category_id = 30;

-- id=1 主食(main_staple)、32–54 已为侧栏分类：不修改

-- ---------- 2) GI 粗分类（英文 low/medium/high，与前端 mapGiOptional 兼容） ----------
UPDATE food f
INNER JOIN food_category c ON c.id = f.category_id
SET f.gi_level = CASE c.code
  WHEN 'veg' THEN 'low'
  WHEN 'fruit' THEN 'low'
  WHEN 'bean' THEN 'low'
  WHEN 'nuts' THEN 'low'
  WHEN 'milk' THEN 'low'
  WHEN 'egg' THEN 'low'
  WHEN 'seafood' THEN 'low'
  WHEN 'meat' THEN 'low'
  WHEN 'protein' THEN 'low'
  WHEN 'soup' THEN 'low'
  WHEN 'sauce' THEN 'low'
  WHEN 'main_staple' THEN 'medium'
  WHEN 'grain' THEN 'medium'
  WHEN 'noodle' THEN 'medium'
  WHEN 'breakfast' THEN 'medium'
  WHEN 'lunch' THEN 'medium'
  WHEN 'dinner' THEN 'medium'
  WHEN 'snack' THEN 'medium'
  WHEN 'snack2' THEN 'medium'
  WHEN 'common' THEN 'medium'
  WHEN 'drink' THEN 'medium'
  WHEN 'fastfood' THEN 'high'
  WHEN 'dessert' THEN 'high'
  WHEN 'other' THEN 'medium'
  ELSE 'medium'
END
WHERE f.gi_level IS NULL OR TRIM(f.gi_level) = '';

-- ---------- 3) 食物图 URL（小程序端由前端 API_BASE_URL + path 拼接） ----------
UPDATE food SET image = '/api/v1/public/food-images/default.png' WHERE status = 1;

UPDATE food f
INNER JOIN (
  SELECT id FROM (
    SELECT f2.id AS id, COALESCE(d.cnt, 0) AS cnt
    FROM food f2
    LEFT JOIN (
      SELECT food_id, COUNT(*) AS cnt FROM diet_record WHERE food_id IS NOT NULL GROUP BY food_id
    ) d ON d.food_id = f2.id
    WHERE f2.status = 1
    ORDER BY cnt DESC, f2.id ASC
    LIMIT 50
  ) AS ranked
) AS t ON f.id = t.id
SET f.image = CONCAT('/api/v1/public/food-images/', f.id, '.png');
