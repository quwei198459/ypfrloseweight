-- =============================================================================
-- MXNZP 食物渠道原始层（init_），数据库 loseweight
-- 执行：mysql -h ... -u ... -p loseweight < tools/food_import/init_tables.sql
-- 要求：MySQL 5.7+（使用 JSON 类型）
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `init_food_channel_pull_task`;
DROP TABLE IF EXISTS `init_food_channel_image`;
DROP TABLE IF EXISTS `init_food_channel_detail`;
DROP TABLE IF EXISTS `init_food_channel_item`;
DROP TABLE IF EXISTS `init_food_channel_category`;

CREATE TABLE `init_food_channel_category` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `channel_name` VARCHAR(32) NOT NULL,
  `channel_category_id` VARCHAR(64) NOT NULL,
  `channel_category_name` VARCHAR(255) NOT NULL,
  `icon` VARCHAR(1000) NULL,
  `raw_json` JSON NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_channel_category` (`channel_name`, `channel_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `init_food_channel_item` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `channel_name` VARCHAR(32) NOT NULL,
  `channel_food_id` VARCHAR(64) NOT NULL,
  `channel_food_name` VARCHAR(255) NOT NULL,
  `channel_category_id` VARCHAR(64) NOT NULL,
  `health_level` VARCHAR(32) NULL,
  `health_level_label` VARCHAR(32) NULL,
  `cover` VARCHAR(1000) NULL,
  `calory_desc` VARCHAR(255) NULL,
  `raw_json` JSON NULL,
  `source_status` VARCHAR(32) NOT NULL DEFAULT 'success',
  `imported_at` DATETIME NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_channel_food` (`channel_name`, `channel_food_id`, `channel_category_id`),
  KEY `idx_category_id` (`channel_category_id`),
  KEY `idx_food_name` (`channel_food_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `init_food_channel_detail` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `channel_name` VARCHAR(32) NOT NULL,
  `channel_food_id` VARCHAR(64) NOT NULL,
  `channel_food_name` VARCHAR(255) NULL,
  `health_light` VARCHAR(32) NULL,
  `health_light_label` VARCHAR(32) NULL,
  `calory` VARCHAR(64) NULL,
  `calory_unit` VARCHAR(64) NULL,
  `joule` VARCHAR(64) NULL,
  `joule_unit` VARCHAR(64) NULL,
  `protein` VARCHAR(64) NULL,
  `protein_unit` VARCHAR(64) NULL,
  `fat` VARCHAR(64) NULL,
  `fat_unit` VARCHAR(64) NULL,
  `saturated_fat` VARCHAR(64) NULL,
  `saturated_fat_unit` VARCHAR(64) NULL,
  `fatty_acid` VARCHAR(64) NULL,
  `fatty_acid_unit` VARCHAR(64) NULL,
  `mufa` VARCHAR(64) NULL,
  `mufa_unit` VARCHAR(64) NULL,
  `pufa` VARCHAR(64) NULL,
  `pufa_unit` VARCHAR(64) NULL,
  `cholesterol` VARCHAR(64) NULL,
  `cholesterol_unit` VARCHAR(64) NULL,
  `carbohydrate` VARCHAR(64) NULL,
  `carbohydrate_unit` VARCHAR(64) NULL,
  `sugar` VARCHAR(64) NULL,
  `sugar_unit` VARCHAR(64) NULL,
  `fiber_dietary` VARCHAR(64) NULL,
  `fiber_dietary_unit` VARCHAR(64) NULL,
  `natrium` VARCHAR(64) NULL,
  `natrium_unit` VARCHAR(64) NULL,
  `alcohol` VARCHAR(64) NULL,
  `alcohol_unit` VARCHAR(64) NULL,
  `vitamin_a` VARCHAR(64) NULL,
  `vitamin_a_unit` VARCHAR(64) NULL,
  `carotene` VARCHAR(64) NULL,
  `carotene_unit` VARCHAR(64) NULL,
  `vitamin_d` VARCHAR(64) NULL,
  `vitamin_d_unit` VARCHAR(64) NULL,
  `vitamin_e` VARCHAR(64) NULL,
  `vitamin_e_unit` VARCHAR(64) NULL,
  `vitamin_k` VARCHAR(64) NULL,
  `vitamin_k_unit` VARCHAR(64) NULL,
  `thiamine` VARCHAR(64) NULL,
  `thiamine_unit` VARCHAR(64) NULL,
  `lactoflavin` VARCHAR(64) NULL,
  `lactoflavin_unit` VARCHAR(64) NULL,
  `vitamin_b6` VARCHAR(64) NULL,
  `vitamin_b6_unit` VARCHAR(64) NULL,
  `vitamin_b12` VARCHAR(64) NULL,
  `vitamin_b12_unit` VARCHAR(64) NULL,
  `vitamin_c` VARCHAR(64) NULL,
  `vitamin_c_unit` VARCHAR(64) NULL,
  `niacin` VARCHAR(64) NULL,
  `niacin_unit` VARCHAR(64) NULL,
  `folacin` VARCHAR(64) NULL,
  `folacin_unit` VARCHAR(64) NULL,
  `pantothenic` VARCHAR(64) NULL,
  `pantothenic_unit` VARCHAR(64) NULL,
  `biotin` VARCHAR(64) NULL,
  `biotin_unit` VARCHAR(64) NULL,
  `choline` VARCHAR(64) NULL,
  `choline_unit` VARCHAR(64) NULL,
  `phosphor` VARCHAR(64) NULL,
  `phosphor_unit` VARCHAR(64) NULL,
  `kalium` VARCHAR(64) NULL,
  `kalium_unit` VARCHAR(64) NULL,
  `magnesium` VARCHAR(64) NULL,
  `magnesium_unit` VARCHAR(64) NULL,
  `calcium` VARCHAR(64) NULL,
  `calcium_unit` VARCHAR(64) NULL,
  `iron` VARCHAR(64) NULL,
  `iron_unit` VARCHAR(64) NULL,
  `zinc` VARCHAR(64) NULL,
  `zinc_unit` VARCHAR(64) NULL,
  `iodine` VARCHAR(64) NULL,
  `iodine_unit` VARCHAR(64) NULL,
  `selenium` VARCHAR(64) NULL,
  `selenium_unit` VARCHAR(64) NULL,
  `copper` VARCHAR(64) NULL,
  `copper_unit` VARCHAR(64) NULL,
  `fluorine` VARCHAR(64) NULL,
  `fluorine_unit` VARCHAR(64) NULL,
  `manganese` VARCHAR(64) NULL,
  `manganese_unit` VARCHAR(64) NULL,
  `glycemic_info_json` JSON NULL,
  `health_tips` TEXT NULL,
  `health_suggest` TEXT NULL,
  `cookbook_json` JSON NULL,
  `raw_json` JSON NULL,
  `detail_status` VARCHAR(32) NOT NULL DEFAULT 'success',
  `detail_fetched_at` DATETIME NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_food_detail` (`channel_name`, `channel_food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `init_food_channel_image` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `channel_name` VARCHAR(32) NOT NULL,
  `channel_food_id` VARCHAR(64) NOT NULL,
  `image_url` VARCHAR(1000) NULL,
  `image_status` VARCHAR(32) NOT NULL DEFAULT 'success',
  `raw_json` JSON NULL,
  `fetched_at` DATETIME NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_food_image` (`channel_name`, `channel_food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `init_food_channel_pull_task` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `channel_name` VARCHAR(32) NOT NULL,
  `api_name` VARCHAR(64) NOT NULL,
  `request_params_json` JSON NULL,
  `page_no` INT NULL,
  `response_code` VARCHAR(64) NULL,
  `response_msg` VARCHAR(255) NULL,
  `is_success` TINYINT NOT NULL DEFAULT 0,
  `item_count` INT NOT NULL DEFAULT 0,
  `response_json` JSON NULL,
  `started_at` DATETIME NULL,
  `finished_at` DATETIME NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_api` (`channel_name`, `api_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
