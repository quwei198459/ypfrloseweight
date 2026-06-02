-- =============================================================================
-- V027: 用户资料补充出生日期、居住地字段，并初始化省市区数据
-- 说明：地区数据用于小程序个人信息与皮肤检测资料页的省/市/区选择器。
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

ALTER TABLE user_profile
  ADD COLUMN birthday DATE DEFAULT NULL COMMENT '出生日期' AFTER age,
  ADD COLUMN residence_province VARCHAR(64) DEFAULT NULL COMMENT '居住地-省份' AFTER target_date,
  ADD COLUMN residence_city VARCHAR(64) DEFAULT NULL COMMENT '居住地-城市' AFTER residence_province,
  ADD COLUMN residence_district VARCHAR(64) DEFAULT NULL COMMENT '居住地-区县' AFTER residence_city;

CREATE TABLE region_area (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(12) NOT NULL COMMENT '行政区划代码',
  name VARCHAR(64) NOT NULL COMMENT '名称',
  level TINYINT UNSIGNED NOT NULL COMMENT '层级：1省/直辖市，2城市，3区县',
  parent_code VARCHAR(12) DEFAULT NULL COMMENT '父级行政区划代码',
  sort_order INT NOT NULL DEFAULT 0,
  status TINYINT UNSIGNED NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_region_area_code (code),
  KEY idx_region_parent (parent_code),
  KEY idx_region_level_sort (level, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='省市区基础数据';

-- 全国全量省市区数据请执行：database/seed/region_area_full.sql
