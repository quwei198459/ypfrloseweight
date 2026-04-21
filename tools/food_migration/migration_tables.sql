-- =============================================================================
-- 食物迁移：中间审核层（check_）表结构
-- 执行：python tools/food_migration/run_migration.py init
-- 或： mysql -h ... -u ... -p loseweight < tools/food_migration/migration_tables.sql
-- 要求：MySQL 5.7+（JSON）；正式表 food_category / food 已存在（Flyway V005+）
-- =============================================================================

SET NAMES utf8mb4;

-- -----------------------------------------------------------------------------
-- 渠道分类 -> 正式 food_category 映射（分类不经 staging，直接迁正式 + 映射）
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `check_food_category_source_mapping` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `channel_name` VARCHAR(32) NOT NULL,
  `channel_category_id` VARCHAR(64) NOT NULL,
  `target_category_id` BIGINT UNSIGNED NOT NULL COMMENT 'food_category.id',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_channel_category` (`channel_name`, `channel_category_id`),
  KEY `idx_target_category` (`target_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 核心：食物中间审核表（仅 food 需要 staging；图片字段落在本表）
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `check_food_staging` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `channel_name` VARCHAR(32) NOT NULL,
  `channel_food_id` VARCHAR(64) NOT NULL,
  `channel_food_name` VARCHAR(255) NOT NULL,
  `channel_category_id` VARCHAR(64) NOT NULL,
  `target_category_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '解析自映射，供审核参考',

  `source_image_url` VARCHAR(1000) DEFAULT NULL,
  `local_image_path` VARCHAR(512) DEFAULT NULL COMMENT '相对路径 /uploads/food-images/...',
  `image_download_status` VARCHAR(16) NOT NULL DEFAULT 'pending',
  `image_download_msg` VARCHAR(512) DEFAULT NULL,

  `raw_calory_value` DECIMAL(12,4) DEFAULT NULL,
  `raw_calory_unit` VARCHAR(64) DEFAULT NULL,
  `raw_calory_desc` VARCHAR(255) DEFAULT NULL,

  `is_liquid` TINYINT NOT NULL DEFAULT 0,
  `energy_basis` VARCHAR(16) NOT NULL DEFAULT 'unknown' COMMENT '100g / 100ml / unknown',
  `calories_per_100g` DECIMAL(12,4) DEFAULT NULL,
  `calories_per_100ml` DECIMAL(12,4) DEFAULT NULL,
  `calories_per_unit` DECIMAL(12,4) DEFAULT NULL,
  `unit_name` VARCHAR(32) DEFAULT NULL,
  `standard_weight_value` DECIMAL(12,4) DEFAULT NULL,
  `standard_weight_unit` VARCHAR(16) DEFAULT NULL COMMENT 'g 或 ml',
  `confidence_score` DECIMAL(5,2) DEFAULT NULL,
  `inference_reason` VARCHAR(512) DEFAULT NULL,

  `protein_per_100g` DECIMAL(12,4) DEFAULT NULL,
  `fat_per_100g` DECIMAL(12,4) DEFAULT NULL,
  `carb_per_100g` DECIMAL(12,4) DEFAULT NULL,

  `gi_level` VARCHAR(16) DEFAULT NULL COMMENT 'low / medium / high，与前端一致',
  `edible_portion_rate` DECIMAL(6,2) DEFAULT NULL,
  `keywords` VARCHAR(256) DEFAULT NULL,
  `is_custom` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `status` TINYINT UNSIGNED NOT NULL DEFAULT 1,

  `stage_status` VARCHAR(16) NOT NULL DEFAULT 'generated',
  `manual_review_status` VARCHAR(24) NOT NULL DEFAULT 'pending',
  `formal_migrate_status` VARCHAR(16) NOT NULL DEFAULT 'not_migrated',

  `target_food_id` BIGINT UNSIGNED DEFAULT NULL,

  `source_item_json` JSON DEFAULT NULL,
  `source_detail_json` JSON DEFAULT NULL,
  `source_image_json` JSON DEFAULT NULL,

  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_channel_food` (`channel_name`, `channel_food_id`),
  KEY `idx_manual_review` (`manual_review_status`),
  KEY `idx_formal_migrate` (`formal_migrate_status`),
  KEY `idx_channel_category` (`channel_category_id`),
  KEY `idx_target_food` (`target_food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 渠道食物 -> 正式 food.id（迁成后写入，防重复）
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `check_food_source_mapping` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `channel_name` VARCHAR(32) NOT NULL,
  `channel_food_id` VARCHAR(64) NOT NULL,
  `target_food_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_channel_food_map` (`channel_name`, `channel_food_id`),
  KEY `idx_target_food` (`target_food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 迁移日志
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `check_food_migrate_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `check_food_staging_id` BIGINT NOT NULL,
  `channel_name` VARCHAR(32) NOT NULL,
  `channel_food_id` VARCHAR(64) NOT NULL,
  `target_food_id` BIGINT UNSIGNED DEFAULT NULL,
  `migrate_action` VARCHAR(32) NOT NULL DEFAULT 'insert_food',
  `detail_msg` VARCHAR(512) DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_staging` (`check_food_staging_id`),
  KEY `idx_channel_food` (`channel_name`, `channel_food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
