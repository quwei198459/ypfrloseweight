/*
 Navicat Premium Data Transfer

 Source Server         : 本地
 Source Server Type    : MySQL
 Source Server Version : 80041 (8.0.41)
 Source Host           : localhost:3306
 Source Schema         : loseweight

 Target Server Type    : MySQL
 Target Server Version : 80041 (8.0.41)
 File Encoding         : 65001

 Date: 05/04/2026 03:54:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for daily_summary
-- ----------------------------
DROP TABLE IF EXISTS `daily_summary`;
CREATE TABLE `daily_summary`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `summary_date` date NOT NULL,
  `daily_budget` decimal(12, 2) NULL DEFAULT NULL,
  `intake_calories` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `exercise_calories` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `remain_calories` decimal(12, 2) NULL DEFAULT NULL,
  `actual_deficit_calories` decimal(12, 2) NULL DEFAULT NULL,
  `budget_deficit_calories` decimal(12, 2) NULL DEFAULT NULL,
  `protein_total_g` decimal(12, 2) NULL DEFAULT NULL,
  `protein_target_g` decimal(12, 2) NULL DEFAULT NULL,
  `fat_total_g` decimal(12, 2) NULL DEFAULT NULL,
  `fat_target_g` decimal(12, 2) NULL DEFAULT NULL,
  `first_meal_time` datetime NULL DEFAULT NULL,
  `last_meal_time` datetime NULL DEFAULT NULL,
  `carb_total_g` decimal(12, 2) NULL DEFAULT NULL,
  `carb_target_g` decimal(12, 2) NULL DEFAULT NULL,
  `eating_window_hours` decimal(6, 2) NULL DEFAULT NULL COMMENT '首餐至末餐间隔小时',
  `healthy_diet_flag` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `day_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal' COMMENT 'normal/overeat/invalid',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_daily_summary_user_date`(`user_id` ASC, `summary_date` ASC) USING BTREE,
  CONSTRAINT `fk_daily_summary_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of daily_summary
-- ----------------------------
INSERT INTO `daily_summary` VALUES (1, 4, '2026-02-01', NULL, 1586.00, 356.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13.50, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (2, 4, '2026-02-02', NULL, 1407.00, 150.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.23, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (3, 4, '2026-02-03', NULL, 1342.00, 270.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.10, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (4, 4, '2026-02-04', NULL, 1406.00, 174.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.67, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (5, 4, '2026-02-05', NULL, 1204.00, 181.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.15, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (6, 4, '2026-02-06', NULL, 1346.00, 126.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13.85, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (7, 4, '2026-02-07', NULL, 1719.00, 263.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12.92, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (8, 4, '2026-02-08', NULL, 1504.00, 232.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.70, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (9, 4, '2026-02-09', NULL, 1517.00, 129.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.03, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (10, 4, '2026-02-10', NULL, 1467.00, 135.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.00, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (11, 4, '2026-02-11', NULL, 1635.00, 176.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.50, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (12, 4, '2026-02-12', NULL, 1510.00, 80.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14.40, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (13, 4, '2026-02-13', NULL, 1471.00, 462.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.93, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (14, 4, '2026-02-14', NULL, 1471.00, 505.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.47, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (15, 4, '2026-02-15', NULL, 1375.00, 188.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.23, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (16, 4, '2026-02-16', NULL, 1330.00, 276.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.10, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (17, 4, '2026-02-17', NULL, 1692.00, 312.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.28, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (18, 4, '2026-02-18', NULL, 1485.00, 185.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.07, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (19, 4, '2026-02-19', NULL, 1460.00, 176.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.38, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (20, 4, '2026-02-20', NULL, 1504.00, 507.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.87, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (21, 4, '2026-02-21', NULL, 1491.00, 118.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.85, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (22, 4, '2026-02-22', NULL, 1610.00, 248.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.43, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (23, 4, '2026-02-23', NULL, 1490.00, 603.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12.80, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (24, 4, '2026-02-24', NULL, 1590.00, 265.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13.12, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (25, 4, '2026-02-25', NULL, 1565.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.90, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (26, 4, '2026-02-26', NULL, 1487.00, 136.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.15, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (27, 4, '2026-02-27', NULL, 1423.00, 376.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.45, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (28, 4, '2026-02-28', NULL, 1675.00, 189.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13.17, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (29, 4, '2026-03-01', NULL, 1446.00, 196.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13.15, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (30, 4, '2026-03-02', NULL, 1617.00, 136.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.50, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (31, 4, '2026-03-03', NULL, 1383.00, 279.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13.78, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (32, 4, '2026-03-04', NULL, 1652.00, 313.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.32, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (33, 4, '2026-03-05', NULL, 1473.00, 158.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.13, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (34, 4, '2026-03-06', NULL, 1479.00, 67.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.03, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (35, 4, '2026-03-07', NULL, 1540.00, 136.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.55, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (36, 4, '2026-03-08', NULL, 1479.00, 285.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.82, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (37, 4, '2026-03-09', NULL, 1564.00, 425.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.48, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (38, 4, '2026-03-10', NULL, 1335.00, 101.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.92, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (39, 4, '2026-03-11', NULL, 1483.00, 156.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12.80, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (40, 4, '2026-03-12', NULL, 1521.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13.45, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (41, 4, '2026-03-13', NULL, 1466.00, 234.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.87, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (42, 4, '2026-03-14', NULL, 1240.00, 292.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.37, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (43, 4, '2026-03-15', NULL, 1404.00, 269.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13.12, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (44, 4, '2026-03-16', NULL, 1461.00, 204.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12.78, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (45, 4, '2026-03-17', NULL, 1463.00, 86.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12.45, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (46, 4, '2026-03-18', NULL, 1509.00, 300.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.77, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (47, 4, '2026-03-19', NULL, 1665.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12.75, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (48, 4, '2026-03-20', NULL, 1758.00, 92.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14.37, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (49, 4, '2026-03-21', NULL, 1392.00, 213.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.13, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (50, 4, '2026-03-22', NULL, 1651.00, 353.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14.10, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (51, 4, '2026-03-23', NULL, 1461.00, 292.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.00, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (52, 4, '2026-03-24', NULL, 1628.00, 341.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11.13, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (53, 4, '2026-03-25', NULL, 1319.00, 195.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12.63, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (54, 4, '2026-03-26', NULL, 1570.00, 150.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12.93, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (55, 4, '2026-03-27', NULL, 1558.00, 174.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.53, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (56, 4, '2026-03-28', NULL, 1501.00, 141.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.78, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (57, 4, '2026-03-29', NULL, 1378.00, 240.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.75, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (58, 4, '2026-03-30', NULL, 1515.00, 108.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.92, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (59, 4, '2026-03-31', NULL, 1734.00, 162.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13.95, 0, 'normal', '2026-04-04 15:09:13', '2026-04-03 15:58:10');
INSERT INTO `daily_summary` VALUES (64, 4, '2026-04-05', NULL, 10.00, 0.00, NULL, NULL, NULL, 0.00, NULL, 0.00, NULL, '2026-04-05 02:53:36', '2026-04-05 02:53:36', 0.00, NULL, 0.25, 0, 'normal', '2026-04-05 02:53:35', '2026-04-05 02:53:35');

-- ----------------------------
-- Table structure for diet_record
-- ----------------------------
DROP TABLE IF EXISTS `diet_record`;
CREATE TABLE `diet_record`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `meal_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `record_date` date NOT NULL,
  `meal_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `food_id` bigint UNSIGNED NULL DEFAULT NULL,
  `food_name_snapshot` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_snapshot` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `gi_level_snapshot` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `amount` decimal(12, 2) NULL DEFAULT NULL,
  `amount_unit` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `weight_g` decimal(12, 2) NULL DEFAULT NULL,
  `calories_total` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `carb_total_g` decimal(12, 2) NULL DEFAULT NULL,
  `protein_total_g` decimal(12, 2) NULL DEFAULT NULL,
  `fat_total_g` decimal(12, 2) NULL DEFAULT NULL,
  `source` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual' COMMENT 'search/custom/photo/manual',
  `record_time` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_diet_meal`(`meal_id` ASC) USING BTREE,
  INDEX `idx_diet_user_date`(`user_id` ASC, `record_date` ASC) USING BTREE,
  INDEX `fk_diet_food`(`food_id` ASC) USING BTREE,
  CONSTRAINT `fk_diet_food` FOREIGN KEY (`food_id`) REFERENCES `food` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_diet_meal` FOREIGN KEY (`meal_id`) REFERENCES `meal_record` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_diet_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1025 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of diet_record
-- ----------------------------
INSERT INTO `diet_record` VALUES (1, 1, 4, '2026-02-01', 'breakfast', NULL, '燕麦粥', NULL, NULL, 197.00, 'g', NULL, 178.00, NULL, NULL, NULL, 'manual', '2026-02-01 07:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (2, 1, 4, '2026-02-01', 'breakfast', NULL, '鸡蛋', NULL, NULL, 104.00, 'g', NULL, 172.00, NULL, NULL, NULL, 'manual', '2026-02-01 07:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (3, 1, 4, '2026-02-01', 'breakfast', NULL, '牛奶', NULL, NULL, 182.00, 'ml', NULL, 106.00, NULL, NULL, NULL, 'manual', '2026-02-01 07:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (4, 2, 4, '2026-02-01', 'lunch', NULL, '米饭', NULL, NULL, 207.00, 'g', NULL, 314.00, NULL, NULL, NULL, 'manual', '2026-02-01 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (5, 2, 4, '2026-02-01', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 139.00, NULL, NULL, NULL, 'manual', '2026-02-01 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (6, 2, 4, '2026-02-01', 'lunch', NULL, '青菜', NULL, NULL, 87.00, 'g', NULL, 29.00, NULL, NULL, NULL, 'manual', '2026-02-01 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (7, 2, 4, '2026-02-01', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 262.00, 'ml', NULL, 99.00, NULL, NULL, NULL, 'manual', '2026-02-01 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (8, 3, 4, '2026-02-01', 'dinner', NULL, '杂粮粥', NULL, NULL, 259.00, 'g', NULL, 181.00, NULL, NULL, NULL, 'manual', '2026-02-01 18:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (9, 3, 4, '2026-02-01', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 140.00, 'g', NULL, 188.00, NULL, NULL, NULL, 'manual', '2026-02-01 18:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (10, 3, 4, '2026-02-01', 'dinner', NULL, '豆腐汤', NULL, NULL, 363.00, 'ml', NULL, 77.00, NULL, NULL, NULL, 'manual', '2026-02-01 18:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (11, 4, 4, '2026-02-01', 'snack', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 103.00, NULL, NULL, NULL, 'manual', '2026-02-01 21:07:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (12, 5, 4, '2026-02-02', 'breakfast', NULL, '燕麦粥', NULL, NULL, 245.00, 'g', NULL, 179.00, NULL, NULL, NULL, 'manual', '2026-02-02 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (13, 5, 4, '2026-02-02', 'breakfast', NULL, '鸡蛋', NULL, NULL, 101.00, 'g', NULL, 145.00, NULL, NULL, NULL, 'manual', '2026-02-02 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (14, 5, 4, '2026-02-02', 'breakfast', NULL, '牛奶', NULL, NULL, 237.00, 'ml', NULL, 100.00, NULL, NULL, NULL, 'manual', '2026-02-02 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (15, 6, 4, '2026-02-02', 'lunch', NULL, '米饭', NULL, NULL, 169.00, 'g', NULL, 278.00, NULL, NULL, NULL, 'manual', '2026-02-02 12:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (16, 6, 4, '2026-02-02', 'lunch', NULL, '清蒸鲈鱼', NULL, NULL, 200.00, 'g', NULL, 192.00, NULL, NULL, NULL, 'manual', '2026-02-02 12:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (17, 6, 4, '2026-02-02', 'lunch', NULL, '青菜', NULL, NULL, 135.00, 'g', NULL, 27.00, NULL, NULL, NULL, 'manual', '2026-02-02 12:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (18, 7, 4, '2026-02-02', 'dinner', NULL, '杂粮粥', NULL, NULL, 233.00, 'g', NULL, 169.00, NULL, NULL, NULL, 'manual', '2026-02-02 18:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (19, 7, 4, '2026-02-02', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 174.00, 'g', NULL, 210.00, NULL, NULL, NULL, 'manual', '2026-02-02 18:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (20, 7, 4, '2026-02-02', 'dinner', NULL, '豆腐汤', NULL, NULL, 327.00, 'ml', NULL, 107.00, NULL, NULL, NULL, 'manual', '2026-02-02 18:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (21, 8, 4, '2026-02-03', 'breakfast', NULL, '燕麦粥', NULL, NULL, 220.00, 'g', NULL, 146.00, NULL, NULL, NULL, 'manual', '2026-02-03 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (22, 8, 4, '2026-02-03', 'breakfast', NULL, '鸡蛋', NULL, NULL, 98.00, 'g', NULL, 171.00, NULL, NULL, NULL, 'manual', '2026-02-03 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (23, 9, 4, '2026-02-03', 'lunch', NULL, '米饭', NULL, NULL, 206.00, 'g', NULL, 278.00, NULL, NULL, NULL, 'manual', '2026-02-03 12:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (24, 9, 4, '2026-02-03', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 143.00, NULL, NULL, NULL, 'manual', '2026-02-03 12:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (25, 9, 4, '2026-02-03', 'lunch', NULL, '青菜', NULL, NULL, 136.00, 'g', NULL, 48.00, NULL, NULL, NULL, 'manual', '2026-02-03 12:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (26, 9, 4, '2026-02-03', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 311.00, 'ml', NULL, 70.00, NULL, NULL, NULL, 'manual', '2026-02-03 12:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (27, 10, 4, '2026-02-03', 'dinner', NULL, '杂粮粥', NULL, NULL, 295.00, 'g', NULL, 185.00, NULL, NULL, NULL, 'manual', '2026-02-03 18:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (28, 10, 4, '2026-02-03', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 171.00, 'g', NULL, 204.00, NULL, NULL, NULL, 'manual', '2026-02-03 18:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (29, 10, 4, '2026-02-03', 'dinner', NULL, '豆腐汤', NULL, NULL, 352.00, 'ml', NULL, 97.00, NULL, NULL, NULL, 'manual', '2026-02-03 18:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (30, 11, 4, '2026-02-04', 'breakfast', NULL, '燕麦粥', NULL, NULL, 213.00, 'g', NULL, 166.00, NULL, NULL, NULL, 'manual', '2026-02-04 07:41:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (31, 11, 4, '2026-02-04', 'breakfast', NULL, '鸡蛋', NULL, NULL, 84.00, 'g', NULL, 171.00, NULL, NULL, NULL, 'manual', '2026-02-04 07:41:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (32, 12, 4, '2026-02-04', 'lunch', NULL, '米饭', NULL, NULL, 170.00, 'g', NULL, 248.00, NULL, NULL, NULL, 'manual', '2026-02-04 12:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (33, 12, 4, '2026-02-04', 'lunch', NULL, '青椒肉丝', NULL, NULL, 150.00, 'g', NULL, 240.00, NULL, NULL, NULL, 'manual', '2026-02-04 12:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (34, 12, 4, '2026-02-04', 'lunch', NULL, '青菜', NULL, NULL, 97.00, 'g', NULL, 55.00, NULL, NULL, NULL, 'manual', '2026-02-04 12:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (35, 12, 4, '2026-02-04', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 267.00, 'ml', NULL, 94.00, NULL, NULL, NULL, 'manual', '2026-02-04 12:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (36, 13, 4, '2026-02-04', 'dinner', NULL, '荞麦面', NULL, NULL, 235.00, 'g', NULL, 187.00, NULL, NULL, NULL, 'manual', '2026-02-04 18:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (37, 13, 4, '2026-02-04', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 120.00, 'g', NULL, 171.00, NULL, NULL, NULL, 'manual', '2026-02-04 18:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (38, 13, 4, '2026-02-04', 'dinner', NULL, '豆腐汤', NULL, NULL, 329.00, 'ml', NULL, 74.00, NULL, NULL, NULL, 'manual', '2026-02-04 18:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (39, 14, 4, '2026-02-05', 'breakfast', NULL, '燕麦粥', NULL, NULL, 212.00, 'g', NULL, 152.00, NULL, NULL, NULL, 'manual', '2026-02-05 07:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (40, 14, 4, '2026-02-05', 'breakfast', NULL, '鸡蛋', NULL, NULL, 91.00, 'g', NULL, 146.00, NULL, NULL, NULL, 'manual', '2026-02-05 07:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (41, 15, 4, '2026-02-05', 'lunch', NULL, '米饭', NULL, NULL, 167.00, 'g', NULL, 275.00, NULL, NULL, NULL, 'manual', '2026-02-05 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (42, 15, 4, '2026-02-05', 'lunch', NULL, '蒜蓉西兰花', NULL, NULL, 200.00, 'g', NULL, 114.00, NULL, NULL, NULL, 'manual', '2026-02-05 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (43, 15, 4, '2026-02-05', 'lunch', NULL, '青菜', NULL, NULL, 107.00, 'g', NULL, 40.00, NULL, NULL, NULL, 'manual', '2026-02-05 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (44, 15, 4, '2026-02-05', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 306.00, 'ml', NULL, 64.00, NULL, NULL, NULL, 'manual', '2026-02-05 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (45, 16, 4, '2026-02-05', 'dinner', NULL, '杂粮粥', NULL, NULL, 255.00, 'g', NULL, 153.00, NULL, NULL, NULL, 'manual', '2026-02-05 18:23:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (46, 16, 4, '2026-02-05', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 152.00, 'g', NULL, 163.00, NULL, NULL, NULL, 'manual', '2026-02-05 18:23:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (47, 17, 4, '2026-02-05', 'snack', NULL, '苹果', NULL, NULL, 120.00, 'g', NULL, 97.00, NULL, NULL, NULL, 'manual', '2026-02-05 16:31:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (48, 18, 4, '2026-02-06', 'breakfast', NULL, '燕麦粥', NULL, NULL, 240.00, 'g', NULL, 163.00, NULL, NULL, NULL, 'manual', '2026-02-06 07:41:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (49, 18, 4, '2026-02-06', 'breakfast', NULL, '鸡蛋', NULL, NULL, 99.00, 'g', NULL, 156.00, NULL, NULL, NULL, 'manual', '2026-02-06 07:41:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (50, 19, 4, '2026-02-06', 'lunch', NULL, '米饭', NULL, NULL, 208.00, 'g', NULL, 227.00, NULL, NULL, NULL, 'manual', '2026-02-06 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (51, 19, 4, '2026-02-06', 'lunch', NULL, '麻婆豆腐', NULL, NULL, 200.00, 'g', NULL, 183.00, NULL, NULL, NULL, 'manual', '2026-02-06 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (52, 19, 4, '2026-02-06', 'lunch', NULL, '青菜', NULL, NULL, 113.00, 'g', NULL, 54.00, NULL, NULL, NULL, 'manual', '2026-02-06 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (53, 20, 4, '2026-02-06', 'dinner', NULL, '荞麦面', NULL, NULL, 228.00, 'g', NULL, 200.00, NULL, NULL, NULL, 'manual', '2026-02-06 18:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (54, 20, 4, '2026-02-06', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 194.00, 'g', NULL, 188.00, NULL, NULL, NULL, 'manual', '2026-02-06 18:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (55, 21, 4, '2026-02-06', 'snack', NULL, '香蕉', NULL, NULL, 100.00, 'g', NULL, 79.00, NULL, NULL, NULL, 'manual', '2026-02-06 21:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (56, 21, 4, '2026-02-06', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 96.00, NULL, NULL, NULL, 'manual', '2026-02-06 20:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (57, 22, 4, '2026-02-07', 'breakfast', NULL, '燕麦粥', NULL, NULL, 205.00, 'g', NULL, 181.00, NULL, NULL, NULL, 'manual', '2026-02-07 07:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (58, 22, 4, '2026-02-07', 'breakfast', NULL, '鸡蛋', NULL, NULL, 98.00, 'g', NULL, 179.00, NULL, NULL, NULL, 'manual', '2026-02-07 07:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (59, 22, 4, '2026-02-07', 'breakfast', NULL, '牛奶', NULL, NULL, 221.00, 'ml', NULL, 120.00, NULL, NULL, NULL, 'manual', '2026-02-07 07:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (60, 23, 4, '2026-02-07', 'lunch', NULL, '米饭', NULL, NULL, 220.00, 'g', NULL, 258.00, NULL, NULL, NULL, 'manual', '2026-02-07 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (61, 23, 4, '2026-02-07', 'lunch', NULL, '清蒸鲈鱼', NULL, NULL, 200.00, 'g', NULL, 168.00, NULL, NULL, NULL, 'manual', '2026-02-07 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (62, 23, 4, '2026-02-07', 'lunch', NULL, '青菜', NULL, NULL, 117.00, 'g', NULL, 51.00, NULL, NULL, NULL, 'manual', '2026-02-07 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (63, 23, 4, '2026-02-07', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 278.00, 'ml', NULL, 77.00, NULL, NULL, NULL, 'manual', '2026-02-07 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (64, 24, 4, '2026-02-07', 'dinner', NULL, '荞麦面', NULL, NULL, 260.00, 'g', NULL, 189.00, NULL, NULL, NULL, 'manual', '2026-02-07 18:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (65, 24, 4, '2026-02-07', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 124.00, 'g', NULL, 208.00, NULL, NULL, NULL, 'manual', '2026-02-07 18:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (66, 24, 4, '2026-02-07', 'dinner', NULL, '豆腐汤', NULL, NULL, 357.00, 'ml', NULL, 90.00, NULL, NULL, NULL, 'manual', '2026-02-07 18:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (67, 25, 4, '2026-02-07', 'snack', NULL, '香蕉', NULL, NULL, 100.00, 'g', NULL, 108.00, NULL, NULL, NULL, 'manual', '2026-02-07 15:51:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (68, 25, 4, '2026-02-07', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 90.00, NULL, NULL, NULL, 'manual', '2026-02-07 20:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (69, 26, 4, '2026-02-08', 'breakfast', NULL, '燕麦粥', NULL, NULL, 209.00, 'g', NULL, 174.00, NULL, NULL, NULL, 'manual', '2026-02-08 07:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (70, 26, 4, '2026-02-08', 'breakfast', NULL, '鸡蛋', NULL, NULL, 103.00, 'g', NULL, 145.00, NULL, NULL, NULL, 'manual', '2026-02-08 07:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (71, 26, 4, '2026-02-08', 'breakfast', NULL, '牛奶', NULL, NULL, 250.00, 'ml', NULL, 97.00, NULL, NULL, NULL, 'manual', '2026-02-08 07:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (72, 27, 4, '2026-02-08', 'lunch', NULL, '米饭', NULL, NULL, 212.00, 'g', NULL, 226.00, NULL, NULL, NULL, 'manual', '2026-02-08 12:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (73, 27, 4, '2026-02-08', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 178.00, NULL, NULL, NULL, 'manual', '2026-02-08 12:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (74, 27, 4, '2026-02-08', 'lunch', NULL, '青菜', NULL, NULL, 127.00, 'g', NULL, 31.00, NULL, NULL, NULL, 'manual', '2026-02-08 12:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (75, 27, 4, '2026-02-08', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 349.00, 'ml', NULL, 68.00, NULL, NULL, NULL, 'manual', '2026-02-08 12:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (76, 28, 4, '2026-02-08', 'dinner', NULL, '荞麦面', NULL, NULL, 235.00, 'g', NULL, 236.00, NULL, NULL, NULL, 'manual', '2026-02-08 18:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (77, 28, 4, '2026-02-08', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 124.00, 'g', NULL, 189.00, NULL, NULL, NULL, 'manual', '2026-02-08 18:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (78, 28, 4, '2026-02-08', 'dinner', NULL, '豆腐汤', NULL, NULL, 308.00, 'ml', NULL, 85.00, NULL, NULL, NULL, 'manual', '2026-02-08 18:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (79, 29, 4, '2026-02-08', 'snack', NULL, '香蕉', NULL, NULL, 100.00, 'g', NULL, 75.00, NULL, NULL, NULL, 'manual', '2026-02-08 15:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (80, 30, 4, '2026-02-09', 'breakfast', NULL, '燕麦粥', NULL, NULL, 206.00, 'g', NULL, 153.00, NULL, NULL, NULL, 'manual', '2026-02-09 07:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (81, 30, 4, '2026-02-09', 'breakfast', NULL, '鸡蛋', NULL, NULL, 103.00, 'g', NULL, 162.00, NULL, NULL, NULL, 'manual', '2026-02-09 07:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (82, 30, 4, '2026-02-09', 'breakfast', NULL, '牛奶', NULL, NULL, 188.00, 'ml', NULL, 97.00, NULL, NULL, NULL, 'manual', '2026-02-09 07:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (83, 31, 4, '2026-02-09', 'lunch', NULL, '米饭', NULL, NULL, 212.00, 'g', NULL, 319.00, NULL, NULL, NULL, 'manual', '2026-02-09 12:07:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (84, 31, 4, '2026-02-09', 'lunch', NULL, '清蒸鲈鱼', NULL, NULL, 200.00, 'g', NULL, 184.00, NULL, NULL, NULL, 'manual', '2026-02-09 12:07:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (85, 31, 4, '2026-02-09', 'lunch', NULL, '青菜', NULL, NULL, 134.00, 'g', NULL, 26.00, NULL, NULL, NULL, 'manual', '2026-02-09 12:07:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (86, 32, 4, '2026-02-09', 'dinner', NULL, '杂粮粥', NULL, NULL, 243.00, 'g', NULL, 171.00, NULL, NULL, NULL, 'manual', '2026-02-09 18:23:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (87, 32, 4, '2026-02-09', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 178.00, 'g', NULL, 198.00, NULL, NULL, NULL, 'manual', '2026-02-09 18:23:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (88, 32, 4, '2026-02-09', 'dinner', NULL, '豆腐汤', NULL, NULL, 298.00, 'ml', NULL, 108.00, NULL, NULL, NULL, 'manual', '2026-02-09 18:23:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (89, 33, 4, '2026-02-09', 'snack', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 99.00, NULL, NULL, NULL, 'manual', '2026-02-09 16:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (90, 34, 4, '2026-02-10', 'breakfast', NULL, '燕麦粥', NULL, NULL, 214.00, 'g', NULL, 148.00, NULL, NULL, NULL, 'manual', '2026-02-10 07:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (91, 34, 4, '2026-02-10', 'breakfast', NULL, '鸡蛋', NULL, NULL, 104.00, 'g', NULL, 163.00, NULL, NULL, NULL, 'manual', '2026-02-10 07:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (92, 34, 4, '2026-02-10', 'breakfast', NULL, '牛奶', NULL, NULL, 225.00, 'ml', NULL, 126.00, NULL, NULL, NULL, 'manual', '2026-02-10 07:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (93, 35, 4, '2026-02-10', 'lunch', NULL, '米饭', NULL, NULL, 238.00, 'g', NULL, 243.00, NULL, NULL, NULL, 'manual', '2026-02-10 12:24:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (94, 35, 4, '2026-02-10', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 232.00, NULL, NULL, NULL, 'manual', '2026-02-10 12:24:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (95, 35, 4, '2026-02-10', 'lunch', NULL, '青菜', NULL, NULL, 145.00, 'g', NULL, 51.00, NULL, NULL, NULL, 'manual', '2026-02-10 12:24:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (96, 36, 4, '2026-02-10', 'dinner', NULL, '荞麦面', NULL, NULL, 229.00, 'g', NULL, 184.00, NULL, NULL, NULL, 'manual', '2026-02-10 18:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (97, 36, 4, '2026-02-10', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 196.00, 'g', NULL, 169.00, NULL, NULL, NULL, 'manual', '2026-02-10 18:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (98, 37, 4, '2026-02-10', 'snack', NULL, '坚果', NULL, NULL, 30.00, 'g', NULL, 151.00, NULL, NULL, NULL, 'manual', '2026-02-10 10:49:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (99, 38, 4, '2026-02-11', 'breakfast', NULL, '燕麦粥', NULL, NULL, 196.00, 'g', NULL, 163.00, NULL, NULL, NULL, 'manual', '2026-02-11 07:31:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (100, 38, 4, '2026-02-11', 'breakfast', NULL, '鸡蛋', NULL, NULL, 99.00, 'g', NULL, 164.00, NULL, NULL, NULL, 'manual', '2026-02-11 07:31:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (101, 39, 4, '2026-02-11', 'lunch', NULL, '米饭', NULL, NULL, 213.00, 'g', NULL, 296.00, NULL, NULL, NULL, 'manual', '2026-02-11 12:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (102, 39, 4, '2026-02-11', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 264.00, NULL, NULL, NULL, 'manual', '2026-02-11 12:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (103, 39, 4, '2026-02-11', 'lunch', NULL, '青菜', NULL, NULL, 150.00, 'g', NULL, 54.00, NULL, NULL, NULL, 'manual', '2026-02-11 12:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (104, 39, 4, '2026-02-11', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 275.00, 'ml', NULL, 65.00, NULL, NULL, NULL, 'manual', '2026-02-11 12:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (105, 40, 4, '2026-02-11', 'dinner', NULL, '杂粮粥', NULL, NULL, 300.00, 'g', NULL, 137.00, NULL, NULL, NULL, 'manual', '2026-02-11 18:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (106, 40, 4, '2026-02-11', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 140.00, 'g', NULL, 198.00, NULL, NULL, NULL, 'manual', '2026-02-11 18:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (107, 40, 4, '2026-02-11', 'dinner', NULL, '豆腐汤', NULL, NULL, 326.00, 'ml', NULL, 114.00, NULL, NULL, NULL, 'manual', '2026-02-11 18:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (108, 41, 4, '2026-02-11', 'snack', NULL, '坚果', NULL, NULL, 30.00, 'g', NULL, 180.00, NULL, NULL, NULL, 'manual', '2026-02-11 10:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (109, 42, 4, '2026-02-12', 'breakfast', NULL, '燕麦粥', NULL, NULL, 210.00, 'g', NULL, 166.00, NULL, NULL, NULL, 'manual', '2026-02-12 07:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (110, 42, 4, '2026-02-12', 'breakfast', NULL, '鸡蛋', NULL, NULL, 119.00, 'g', NULL, 162.00, NULL, NULL, NULL, 'manual', '2026-02-12 07:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (111, 42, 4, '2026-02-12', 'breakfast', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 105.00, NULL, NULL, NULL, 'manual', '2026-02-12 07:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (112, 43, 4, '2026-02-12', 'lunch', NULL, '米饭', NULL, NULL, 190.00, 'g', NULL, 288.00, NULL, NULL, NULL, 'manual', '2026-02-12 12:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (113, 43, 4, '2026-02-12', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 245.00, NULL, NULL, NULL, 'manual', '2026-02-12 12:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (114, 43, 4, '2026-02-12', 'lunch', NULL, '青菜', NULL, NULL, 111.00, 'g', NULL, 26.00, NULL, NULL, NULL, 'manual', '2026-02-12 12:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (115, 44, 4, '2026-02-12', 'dinner', NULL, '杂粮粥', NULL, NULL, 259.00, 'g', NULL, 147.00, NULL, NULL, NULL, 'manual', '2026-02-12 18:06:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (116, 44, 4, '2026-02-12', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 168.00, 'g', NULL, 166.00, NULL, NULL, NULL, 'manual', '2026-02-12 18:06:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (117, 44, 4, '2026-02-12', 'dinner', NULL, '豆腐汤', NULL, NULL, 362.00, 'ml', NULL, 86.00, NULL, NULL, NULL, 'manual', '2026-02-12 18:06:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (118, 45, 4, '2026-02-12', 'snack', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 119.00, NULL, NULL, NULL, 'manual', '2026-02-12 21:54:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (119, 46, 4, '2026-02-13', 'breakfast', NULL, '燕麦粥', NULL, NULL, 240.00, 'g', NULL, 161.00, NULL, NULL, NULL, 'manual', '2026-02-13 07:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (120, 46, 4, '2026-02-13', 'breakfast', NULL, '鸡蛋', NULL, NULL, 109.00, 'g', NULL, 159.00, NULL, NULL, NULL, 'manual', '2026-02-13 07:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (121, 46, 4, '2026-02-13', 'breakfast', NULL, '牛奶', NULL, NULL, 216.00, 'ml', NULL, 110.00, NULL, NULL, NULL, 'manual', '2026-02-13 07:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (122, 47, 4, '2026-02-13', 'lunch', NULL, '米饭', NULL, NULL, 162.00, 'g', NULL, 277.00, NULL, NULL, NULL, 'manual', '2026-02-13 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (123, 47, 4, '2026-02-13', 'lunch', NULL, '青椒肉丝', NULL, NULL, 150.00, 'g', NULL, 203.00, NULL, NULL, NULL, 'manual', '2026-02-13 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (124, 47, 4, '2026-02-13', 'lunch', NULL, '青菜', NULL, NULL, 99.00, 'g', NULL, 43.00, NULL, NULL, NULL, 'manual', '2026-02-13 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (125, 48, 4, '2026-02-13', 'dinner', NULL, '荞麦面', NULL, NULL, 180.00, 'g', NULL, 233.00, NULL, NULL, NULL, 'manual', '2026-02-13 18:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (126, 48, 4, '2026-02-13', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 165.00, 'g', NULL, 169.00, NULL, NULL, NULL, 'manual', '2026-02-13 18:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (127, 49, 4, '2026-02-13', 'snack', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 116.00, NULL, NULL, NULL, 'manual', '2026-02-13 16:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (128, 50, 4, '2026-02-14', 'breakfast', NULL, '燕麦粥', NULL, NULL, 208.00, 'g', NULL, 153.00, NULL, NULL, NULL, 'manual', '2026-02-14 07:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (129, 50, 4, '2026-02-14', 'breakfast', NULL, '鸡蛋', NULL, NULL, 96.00, 'g', NULL, 176.00, NULL, NULL, NULL, 'manual', '2026-02-14 07:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (130, 51, 4, '2026-02-14', 'lunch', NULL, '米饭', NULL, NULL, 233.00, 'g', NULL, 261.00, NULL, NULL, NULL, 'manual', '2026-02-14 12:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (131, 51, 4, '2026-02-14', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 224.00, NULL, NULL, NULL, 'manual', '2026-02-14 12:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (132, 51, 4, '2026-02-14', 'lunch', NULL, '青菜', NULL, NULL, 105.00, 'g', NULL, 55.00, NULL, NULL, NULL, 'manual', '2026-02-14 12:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (133, 52, 4, '2026-02-14', 'dinner', NULL, '荞麦面', NULL, NULL, 260.00, 'g', NULL, 200.00, NULL, NULL, NULL, 'manual', '2026-02-14 18:06:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (134, 52, 4, '2026-02-14', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 186.00, 'g', NULL, 168.00, NULL, NULL, NULL, 'manual', '2026-02-14 18:06:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (135, 52, 4, '2026-02-14', 'dinner', NULL, '豆腐汤', NULL, NULL, 352.00, 'ml', NULL, 79.00, NULL, NULL, NULL, 'manual', '2026-02-14 18:06:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (136, 53, 4, '2026-02-14', 'snack', NULL, '坚果', NULL, NULL, 30.00, 'g', NULL, 155.00, NULL, NULL, NULL, 'manual', '2026-02-14 15:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (137, 54, 4, '2026-02-15', 'breakfast', NULL, '燕麦粥', NULL, NULL, 212.00, 'g', NULL, 209.00, NULL, NULL, NULL, 'manual', '2026-02-15 07:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (138, 54, 4, '2026-02-15', 'breakfast', NULL, '鸡蛋', NULL, NULL, 114.00, 'g', NULL, 159.00, NULL, NULL, NULL, 'manual', '2026-02-15 07:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (139, 54, 4, '2026-02-15', 'breakfast', NULL, '牛奶', NULL, NULL, 188.00, 'ml', NULL, 109.00, NULL, NULL, NULL, 'manual', '2026-02-15 07:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (140, 55, 4, '2026-02-15', 'lunch', NULL, '米饭', NULL, NULL, 165.00, 'g', NULL, 223.00, NULL, NULL, NULL, 'manual', '2026-02-15 12:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (141, 55, 4, '2026-02-15', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 235.00, NULL, NULL, NULL, 'manual', '2026-02-15 12:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (142, 55, 4, '2026-02-15', 'lunch', NULL, '青菜', NULL, NULL, 134.00, 'g', NULL, 31.00, NULL, NULL, NULL, 'manual', '2026-02-15 12:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (143, 56, 4, '2026-02-15', 'dinner', NULL, '荞麦面', NULL, NULL, 228.00, 'g', NULL, 202.00, NULL, NULL, NULL, 'manual', '2026-02-15 18:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (144, 56, 4, '2026-02-15', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 143.00, 'g', NULL, 207.00, NULL, NULL, NULL, 'manual', '2026-02-15 18:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (145, 57, 4, '2026-02-16', 'breakfast', NULL, '燕麦粥', NULL, NULL, 256.00, 'g', NULL, 209.00, NULL, NULL, NULL, 'manual', '2026-02-16 07:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (146, 57, 4, '2026-02-16', 'breakfast', NULL, '鸡蛋', NULL, NULL, 117.00, 'g', NULL, 166.00, NULL, NULL, NULL, 'manual', '2026-02-16 07:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (147, 57, 4, '2026-02-16', 'breakfast', NULL, '牛奶', NULL, NULL, 246.00, 'ml', NULL, 90.00, NULL, NULL, NULL, 'manual', '2026-02-16 07:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (148, 58, 4, '2026-02-16', 'lunch', NULL, '米饭', NULL, NULL, 207.00, 'g', NULL, 223.00, NULL, NULL, NULL, 'manual', '2026-02-16 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (149, 58, 4, '2026-02-16', 'lunch', NULL, '清蒸鲈鱼', NULL, NULL, 200.00, 'g', NULL, 188.00, NULL, NULL, NULL, 'manual', '2026-02-16 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (150, 58, 4, '2026-02-16', 'lunch', NULL, '青菜', NULL, NULL, 124.00, 'g', NULL, 52.00, NULL, NULL, NULL, 'manual', '2026-02-16 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (151, 58, 4, '2026-02-16', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 344.00, 'ml', NULL, 77.00, NULL, NULL, NULL, 'manual', '2026-02-16 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (152, 59, 4, '2026-02-16', 'dinner', NULL, '杂粮粥', NULL, NULL, 227.00, 'g', NULL, 170.00, NULL, NULL, NULL, 'manual', '2026-02-16 18:24:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (153, 59, 4, '2026-02-16', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 164.00, 'g', NULL, 155.00, NULL, NULL, NULL, 'manual', '2026-02-16 18:24:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (154, 60, 4, '2026-02-17', 'breakfast', NULL, '燕麦粥', NULL, NULL, 198.00, 'g', NULL, 203.00, NULL, NULL, NULL, 'manual', '2026-02-17 07:23:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (155, 60, 4, '2026-02-17', 'breakfast', NULL, '鸡蛋', NULL, NULL, 118.00, 'g', NULL, 161.00, NULL, NULL, NULL, 'manual', '2026-02-17 07:23:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (156, 60, 4, '2026-02-17', 'breakfast', NULL, '牛奶', NULL, NULL, 227.00, 'ml', NULL, 126.00, NULL, NULL, NULL, 'manual', '2026-02-17 07:23:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (157, 61, 4, '2026-02-17', 'lunch', NULL, '米饭', NULL, NULL, 168.00, 'g', NULL, 240.00, NULL, NULL, NULL, 'manual', '2026-02-17 12:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (158, 61, 4, '2026-02-17', 'lunch', NULL, '青椒肉丝', NULL, NULL, 150.00, 'g', NULL, 199.00, NULL, NULL, NULL, 'manual', '2026-02-17 12:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (159, 61, 4, '2026-02-17', 'lunch', NULL, '青菜', NULL, NULL, 144.00, 'g', NULL, 50.00, NULL, NULL, NULL, 'manual', '2026-02-17 12:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (160, 61, 4, '2026-02-17', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 337.00, 'ml', NULL, 84.00, NULL, NULL, NULL, 'manual', '2026-02-17 12:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (161, 62, 4, '2026-02-17', 'dinner', NULL, '荞麦面', NULL, NULL, 226.00, 'g', NULL, 240.00, NULL, NULL, NULL, 'manual', '2026-02-17 18:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (162, 62, 4, '2026-02-17', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 148.00, 'g', NULL, 172.00, NULL, NULL, NULL, 'manual', '2026-02-17 18:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (163, 62, 4, '2026-02-17', 'dinner', NULL, '豆腐汤', NULL, NULL, 326.00, 'ml', NULL, 105.00, NULL, NULL, NULL, 'manual', '2026-02-17 18:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (164, 63, 4, '2026-02-17', 'snack', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 112.00, NULL, NULL, NULL, 'manual', '2026-02-17 10:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (165, 64, 4, '2026-02-18', 'breakfast', NULL, '燕麦粥', NULL, NULL, 255.00, 'g', NULL, 142.00, NULL, NULL, NULL, 'manual', '2026-02-18 07:11:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (166, 64, 4, '2026-02-18', 'breakfast', NULL, '鸡蛋', NULL, NULL, 94.00, 'g', NULL, 164.00, NULL, NULL, NULL, 'manual', '2026-02-18 07:11:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (167, 64, 4, '2026-02-18', 'breakfast', NULL, '牛奶', NULL, NULL, 230.00, 'ml', NULL, 124.00, NULL, NULL, NULL, 'manual', '2026-02-18 07:11:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (168, 65, 4, '2026-02-18', 'lunch', NULL, '米饭', NULL, NULL, 226.00, 'g', NULL, 245.00, NULL, NULL, NULL, 'manual', '2026-02-18 12:27:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (169, 65, 4, '2026-02-18', 'lunch', NULL, '麻婆豆腐', NULL, NULL, 200.00, 'g', NULL, 189.00, NULL, NULL, NULL, 'manual', '2026-02-18 12:27:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (170, 65, 4, '2026-02-18', 'lunch', NULL, '青菜', NULL, NULL, 125.00, 'g', NULL, 46.00, NULL, NULL, NULL, 'manual', '2026-02-18 12:27:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (171, 65, 4, '2026-02-18', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 298.00, 'ml', NULL, 64.00, NULL, NULL, NULL, 'manual', '2026-02-18 12:27:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (172, 66, 4, '2026-02-18', 'dinner', NULL, '杂粮粥', NULL, NULL, 261.00, 'g', NULL, 198.00, NULL, NULL, NULL, 'manual', '2026-02-18 18:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (173, 66, 4, '2026-02-18', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 123.00, 'g', NULL, 151.00, NULL, NULL, NULL, 'manual', '2026-02-18 18:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (174, 66, 4, '2026-02-18', 'dinner', NULL, '豆腐汤', NULL, NULL, 321.00, 'ml', NULL, 95.00, NULL, NULL, NULL, 'manual', '2026-02-18 18:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (175, 67, 4, '2026-02-18', 'snack', NULL, '苹果', NULL, NULL, 120.00, 'g', NULL, 67.00, NULL, NULL, NULL, 'manual', '2026-02-18 10:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (176, 68, 4, '2026-02-19', 'breakfast', NULL, '燕麦粥', NULL, NULL, 252.00, 'g', NULL, 171.00, NULL, NULL, NULL, 'manual', '2026-02-19 07:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (177, 68, 4, '2026-02-19', 'breakfast', NULL, '鸡蛋', NULL, NULL, 105.00, 'g', NULL, 158.00, NULL, NULL, NULL, 'manual', '2026-02-19 07:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (178, 68, 4, '2026-02-19', 'breakfast', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 116.00, NULL, NULL, NULL, 'manual', '2026-02-19 07:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (179, 69, 4, '2026-02-19', 'lunch', NULL, '米饭', NULL, NULL, 234.00, 'g', NULL, 263.00, NULL, NULL, NULL, 'manual', '2026-02-19 12:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (180, 69, 4, '2026-02-19', 'lunch', NULL, '青椒肉丝', NULL, NULL, 150.00, 'g', NULL, 197.00, NULL, NULL, NULL, 'manual', '2026-02-19 12:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (181, 69, 4, '2026-02-19', 'lunch', NULL, '青菜', NULL, NULL, 149.00, 'g', NULL, 52.00, NULL, NULL, NULL, 'manual', '2026-02-19 12:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (182, 70, 4, '2026-02-19', 'dinner', NULL, '荞麦面', NULL, NULL, 206.00, 'g', NULL, 227.00, NULL, NULL, NULL, 'manual', '2026-02-19 18:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (183, 70, 4, '2026-02-19', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 165.00, 'g', NULL, 200.00, NULL, NULL, NULL, 'manual', '2026-02-19 18:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (184, 70, 4, '2026-02-19', 'dinner', NULL, '豆腐汤', NULL, NULL, 318.00, 'ml', NULL, 76.00, NULL, NULL, NULL, 'manual', '2026-02-19 18:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (185, 71, 4, '2026-02-20', 'breakfast', NULL, '燕麦粥', NULL, NULL, 238.00, 'g', NULL, 198.00, NULL, NULL, NULL, 'manual', '2026-02-20 07:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (186, 71, 4, '2026-02-20', 'breakfast', NULL, '鸡蛋', NULL, NULL, 109.00, 'g', NULL, 154.00, NULL, NULL, NULL, 'manual', '2026-02-20 07:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (187, 71, 4, '2026-02-20', 'breakfast', NULL, '牛奶', NULL, NULL, 212.00, 'ml', NULL, 112.00, NULL, NULL, NULL, 'manual', '2026-02-20 07:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (188, 72, 4, '2026-02-20', 'lunch', NULL, '米饭', NULL, NULL, 169.00, 'g', NULL, 288.00, NULL, NULL, NULL, 'manual', '2026-02-20 12:00:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (189, 72, 4, '2026-02-20', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 227.00, NULL, NULL, NULL, 'manual', '2026-02-20 12:00:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (190, 72, 4, '2026-02-20', 'lunch', NULL, '青菜', NULL, NULL, 98.00, 'g', NULL, 45.00, NULL, NULL, NULL, 'manual', '2026-02-20 12:00:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (191, 72, 4, '2026-02-20', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 350.00, 'ml', NULL, 65.00, NULL, NULL, NULL, 'manual', '2026-02-20 12:00:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (192, 73, 4, '2026-02-20', 'dinner', NULL, '荞麦面', NULL, NULL, 232.00, 'g', NULL, 211.00, NULL, NULL, NULL, 'manual', '2026-02-20 18:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (193, 73, 4, '2026-02-20', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 177.00, 'g', NULL, 204.00, NULL, NULL, NULL, 'manual', '2026-02-20 18:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (194, 74, 4, '2026-02-21', 'breakfast', NULL, '燕麦粥', NULL, NULL, 239.00, 'g', NULL, 185.00, NULL, NULL, NULL, 'manual', '2026-02-21 07:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (195, 74, 4, '2026-02-21', 'breakfast', NULL, '鸡蛋', NULL, NULL, 98.00, 'g', NULL, 161.00, NULL, NULL, NULL, 'manual', '2026-02-21 07:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (196, 74, 4, '2026-02-21', 'breakfast', NULL, '牛奶', NULL, NULL, 192.00, 'ml', NULL, 120.00, NULL, NULL, NULL, 'manual', '2026-02-21 07:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (197, 75, 4, '2026-02-21', 'lunch', NULL, '米饭', NULL, NULL, 167.00, 'g', NULL, 230.00, NULL, NULL, NULL, 'manual', '2026-02-21 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (198, 75, 4, '2026-02-21', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 228.00, NULL, NULL, NULL, 'manual', '2026-02-21 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (199, 75, 4, '2026-02-21', 'lunch', NULL, '青菜', NULL, NULL, 80.00, 'g', NULL, 42.00, NULL, NULL, NULL, 'manual', '2026-02-21 12:25:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (200, 76, 4, '2026-02-21', 'dinner', NULL, '荞麦面', NULL, NULL, 230.00, 'g', NULL, 231.00, NULL, NULL, NULL, 'manual', '2026-02-21 18:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (201, 76, 4, '2026-02-21', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 140.00, 'g', NULL, 180.00, NULL, NULL, NULL, 'manual', '2026-02-21 18:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (202, 76, 4, '2026-02-21', 'dinner', NULL, '豆腐汤', NULL, NULL, 297.00, 'ml', NULL, 114.00, NULL, NULL, NULL, 'manual', '2026-02-21 18:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (203, 77, 4, '2026-02-22', 'breakfast', NULL, '燕麦粥', NULL, NULL, 223.00, 'g', NULL, 190.00, NULL, NULL, NULL, 'manual', '2026-02-22 07:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (204, 77, 4, '2026-02-22', 'breakfast', NULL, '鸡蛋', NULL, NULL, 87.00, 'g', NULL, 159.00, NULL, NULL, NULL, 'manual', '2026-02-22 07:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (205, 77, 4, '2026-02-22', 'breakfast', NULL, '牛奶', NULL, NULL, 192.00, 'ml', NULL, 106.00, NULL, NULL, NULL, 'manual', '2026-02-22 07:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (206, 78, 4, '2026-02-22', 'lunch', NULL, '米饭', NULL, NULL, 219.00, 'g', NULL, 287.00, NULL, NULL, NULL, 'manual', '2026-02-22 12:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (207, 78, 4, '2026-02-22', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 262.00, NULL, NULL, NULL, 'manual', '2026-02-22 12:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (208, 78, 4, '2026-02-22', 'lunch', NULL, '青菜', NULL, NULL, 127.00, 'g', NULL, 48.00, NULL, NULL, NULL, 'manual', '2026-02-22 12:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (209, 79, 4, '2026-02-22', 'dinner', NULL, '荞麦面', NULL, NULL, 194.00, 'g', NULL, 204.00, NULL, NULL, NULL, 'manual', '2026-02-22 18:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (210, 79, 4, '2026-02-22', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 153.00, 'g', NULL, 185.00, NULL, NULL, NULL, 'manual', '2026-02-22 18:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (211, 79, 4, '2026-02-22', 'dinner', NULL, '豆腐汤', NULL, NULL, 370.00, 'ml', NULL, 94.00, NULL, NULL, NULL, 'manual', '2026-02-22 18:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (212, 80, 4, '2026-02-22', 'snack', NULL, '香蕉', NULL, NULL, 100.00, 'g', NULL, 75.00, NULL, NULL, NULL, 'manual', '2026-02-22 16:41:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (213, 81, 4, '2026-02-23', 'breakfast', NULL, '燕麦粥', NULL, NULL, 248.00, 'g', NULL, 172.00, NULL, NULL, NULL, 'manual', '2026-02-23 07:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (214, 81, 4, '2026-02-23', 'breakfast', NULL, '鸡蛋', NULL, NULL, 88.00, 'g', NULL, 177.00, NULL, NULL, NULL, 'manual', '2026-02-23 07:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (215, 81, 4, '2026-02-23', 'breakfast', NULL, '牛奶', NULL, NULL, 239.00, 'ml', NULL, 97.00, NULL, NULL, NULL, 'manual', '2026-02-23 07:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (216, 82, 4, '2026-02-23', 'lunch', NULL, '米饭', NULL, NULL, 162.00, 'g', NULL, 277.00, NULL, NULL, NULL, 'manual', '2026-02-23 12:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (217, 82, 4, '2026-02-23', 'lunch', NULL, '蒜蓉西兰花', NULL, NULL, 200.00, 'g', NULL, 80.00, NULL, NULL, NULL, 'manual', '2026-02-23 12:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (218, 82, 4, '2026-02-23', 'lunch', NULL, '青菜', NULL, NULL, 109.00, 'g', NULL, 27.00, NULL, NULL, NULL, 'manual', '2026-02-23 12:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (219, 82, 4, '2026-02-23', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 257.00, 'ml', NULL, 91.00, NULL, NULL, NULL, 'manual', '2026-02-23 12:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (220, 83, 4, '2026-02-23', 'dinner', NULL, '荞麦面', NULL, NULL, 200.00, 'g', NULL, 201.00, NULL, NULL, NULL, 'manual', '2026-02-23 18:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (221, 83, 4, '2026-02-23', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 132.00, 'g', NULL, 164.00, NULL, NULL, NULL, 'manual', '2026-02-23 18:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (222, 83, 4, '2026-02-23', 'dinner', NULL, '豆腐汤', NULL, NULL, 348.00, 'ml', NULL, 104.00, NULL, NULL, NULL, 'manual', '2026-02-23 18:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (223, 84, 4, '2026-02-23', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 100.00, NULL, NULL, NULL, 'manual', '2026-02-23 20:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (224, 85, 4, '2026-02-24', 'breakfast', NULL, '燕麦粥', NULL, NULL, 198.00, 'g', NULL, 174.00, NULL, NULL, NULL, 'manual', '2026-02-24 07:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (225, 85, 4, '2026-02-24', 'breakfast', NULL, '鸡蛋', NULL, NULL, 100.00, 'g', NULL, 168.00, NULL, NULL, NULL, 'manual', '2026-02-24 07:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (226, 85, 4, '2026-02-24', 'breakfast', NULL, '牛奶', NULL, NULL, 192.00, 'ml', NULL, 95.00, NULL, NULL, NULL, 'manual', '2026-02-24 07:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (227, 86, 4, '2026-02-24', 'lunch', NULL, '米饭', NULL, NULL, 160.00, 'g', NULL, 237.00, NULL, NULL, NULL, 'manual', '2026-02-24 12:07:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (228, 86, 4, '2026-02-24', 'lunch', NULL, '麻婆豆腐', NULL, NULL, 200.00, 'g', NULL, 196.00, NULL, NULL, NULL, 'manual', '2026-02-24 12:07:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (229, 86, 4, '2026-02-24', 'lunch', NULL, '青菜', NULL, NULL, 143.00, 'g', NULL, 50.00, NULL, NULL, NULL, 'manual', '2026-02-24 12:07:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (230, 87, 4, '2026-02-24', 'dinner', NULL, '荞麦面', NULL, NULL, 180.00, 'g', NULL, 187.00, NULL, NULL, NULL, 'manual', '2026-02-24 18:48:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (231, 87, 4, '2026-02-24', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 137.00, 'g', NULL, 186.00, NULL, NULL, NULL, 'manual', '2026-02-24 18:48:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (232, 87, 4, '2026-02-24', 'dinner', NULL, '豆腐汤', NULL, NULL, 375.00, 'ml', NULL, 117.00, NULL, NULL, NULL, 'manual', '2026-02-24 18:48:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (233, 88, 4, '2026-02-24', 'snack', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 95.00, NULL, NULL, NULL, 'manual', '2026-02-24 16:09:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (234, 88, 4, '2026-02-24', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 85.00, NULL, NULL, NULL, 'manual', '2026-02-24 20:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (235, 89, 4, '2026-02-25', 'breakfast', NULL, '燕麦粥', NULL, NULL, 196.00, 'g', NULL, 148.00, NULL, NULL, NULL, 'manual', '2026-02-25 07:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (236, 89, 4, '2026-02-25', 'breakfast', NULL, '鸡蛋', NULL, NULL, 91.00, 'g', NULL, 154.00, NULL, NULL, NULL, 'manual', '2026-02-25 07:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (237, 89, 4, '2026-02-25', 'breakfast', NULL, '牛奶', NULL, NULL, 225.00, 'ml', NULL, 107.00, NULL, NULL, NULL, 'manual', '2026-02-25 07:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (238, 90, 4, '2026-02-25', 'lunch', NULL, '米饭', NULL, NULL, 214.00, 'g', NULL, 239.00, NULL, NULL, NULL, 'manual', '2026-02-25 12:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (239, 90, 4, '2026-02-25', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 165.00, NULL, NULL, NULL, 'manual', '2026-02-25 12:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (240, 90, 4, '2026-02-25', 'lunch', NULL, '青菜', NULL, NULL, 140.00, 'g', NULL, 29.00, NULL, NULL, NULL, 'manual', '2026-02-25 12:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (241, 90, 4, '2026-02-25', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 255.00, 'ml', NULL, 81.00, NULL, NULL, NULL, 'manual', '2026-02-25 12:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (242, 91, 4, '2026-02-25', 'dinner', NULL, '杂粮粥', NULL, NULL, 246.00, 'g', NULL, 157.00, NULL, NULL, NULL, 'manual', '2026-02-25 18:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (243, 91, 4, '2026-02-25', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 167.00, 'g', NULL, 192.00, NULL, NULL, NULL, 'manual', '2026-02-25 18:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (244, 91, 4, '2026-02-25', 'dinner', NULL, '豆腐汤', NULL, NULL, 293.00, 'ml', NULL, 119.00, NULL, NULL, NULL, 'manual', '2026-02-25 18:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (245, 92, 4, '2026-02-25', 'snack', NULL, '坚果', NULL, NULL, 30.00, 'g', NULL, 174.00, NULL, NULL, NULL, 'manual', '2026-02-25 15:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (246, 93, 4, '2026-02-26', 'breakfast', NULL, '燕麦粥', NULL, NULL, 183.00, 'g', NULL, 187.00, NULL, NULL, NULL, 'manual', '2026-02-26 07:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (247, 93, 4, '2026-02-26', 'breakfast', NULL, '鸡蛋', NULL, NULL, 85.00, 'g', NULL, 154.00, NULL, NULL, NULL, 'manual', '2026-02-26 07:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (248, 93, 4, '2026-02-26', 'breakfast', NULL, '牛奶', NULL, NULL, 201.00, 'ml', NULL, 112.00, NULL, NULL, NULL, 'manual', '2026-02-26 07:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (249, 94, 4, '2026-02-26', 'lunch', NULL, '米饭', NULL, NULL, 207.00, 'g', NULL, 279.00, NULL, NULL, NULL, 'manual', '2026-02-26 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (250, 94, 4, '2026-02-26', 'lunch', NULL, '清蒸鲈鱼', NULL, NULL, 200.00, 'g', NULL, 178.00, NULL, NULL, NULL, 'manual', '2026-02-26 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (251, 94, 4, '2026-02-26', 'lunch', NULL, '青菜', NULL, NULL, 131.00, 'g', NULL, 28.00, NULL, NULL, NULL, 'manual', '2026-02-26 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (252, 94, 4, '2026-02-26', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 266.00, 'ml', NULL, 86.00, NULL, NULL, NULL, 'manual', '2026-02-26 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (253, 95, 4, '2026-02-26', 'dinner', NULL, '杂粮粥', NULL, NULL, 224.00, 'g', NULL, 167.00, NULL, NULL, NULL, 'manual', '2026-02-26 18:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (254, 95, 4, '2026-02-26', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 123.00, 'g', NULL, 196.00, NULL, NULL, NULL, 'manual', '2026-02-26 18:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (255, 96, 4, '2026-02-26', 'snack', NULL, '酸奶', NULL, NULL, 100.00, 'g', NULL, 100.00, NULL, NULL, NULL, 'manual', '2026-02-26 10:48:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (256, 97, 4, '2026-02-27', 'breakfast', NULL, '燕麦粥', NULL, NULL, 198.00, 'g', NULL, 196.00, NULL, NULL, NULL, 'manual', '2026-02-27 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (257, 97, 4, '2026-02-27', 'breakfast', NULL, '鸡蛋', NULL, NULL, 80.00, 'g', NULL, 155.00, NULL, NULL, NULL, 'manual', '2026-02-27 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (258, 97, 4, '2026-02-27', 'breakfast', NULL, '牛奶', NULL, NULL, 214.00, 'ml', NULL, 111.00, NULL, NULL, NULL, 'manual', '2026-02-27 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (259, 98, 4, '2026-02-27', 'lunch', NULL, '米饭', NULL, NULL, 190.00, 'g', NULL, 316.00, NULL, NULL, NULL, 'manual', '2026-02-27 12:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (260, 98, 4, '2026-02-27', 'lunch', NULL, '蒜蓉西兰花', NULL, NULL, 200.00, 'g', NULL, 104.00, NULL, NULL, NULL, 'manual', '2026-02-27 12:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (261, 98, 4, '2026-02-27', 'lunch', NULL, '青菜', NULL, NULL, 135.00, 'g', NULL, 52.00, NULL, NULL, NULL, 'manual', '2026-02-27 12:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (262, 99, 4, '2026-02-27', 'dinner', NULL, '荞麦面', NULL, NULL, 232.00, 'g', NULL, 172.00, NULL, NULL, NULL, 'manual', '2026-02-27 18:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (263, 99, 4, '2026-02-27', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 187.00, 'g', NULL, 210.00, NULL, NULL, NULL, 'manual', '2026-02-27 18:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (264, 99, 4, '2026-02-27', 'dinner', NULL, '豆腐汤', NULL, NULL, 287.00, 'ml', NULL, 107.00, NULL, NULL, NULL, 'manual', '2026-02-27 18:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (265, 100, 4, '2026-02-28', 'breakfast', NULL, '燕麦粥', NULL, NULL, 220.00, 'g', NULL, 193.00, NULL, NULL, NULL, 'manual', '2026-02-28 07:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (266, 100, 4, '2026-02-28', 'breakfast', NULL, '鸡蛋', NULL, NULL, 97.00, 'g', NULL, 175.00, NULL, NULL, NULL, 'manual', '2026-02-28 07:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (267, 100, 4, '2026-02-28', 'breakfast', NULL, '牛奶', NULL, NULL, 236.00, 'ml', NULL, 96.00, NULL, NULL, NULL, 'manual', '2026-02-28 07:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (268, 101, 4, '2026-02-28', 'lunch', NULL, '米饭', NULL, NULL, 233.00, 'g', NULL, 307.00, NULL, NULL, NULL, 'manual', '2026-02-28 12:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (269, 101, 4, '2026-02-28', 'lunch', NULL, '青椒肉丝', NULL, NULL, 150.00, 'g', NULL, 244.00, NULL, NULL, NULL, 'manual', '2026-02-28 12:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (270, 101, 4, '2026-02-28', 'lunch', NULL, '青菜', NULL, NULL, 140.00, 'g', NULL, 29.00, NULL, NULL, NULL, 'manual', '2026-02-28 12:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (271, 102, 4, '2026-02-28', 'dinner', NULL, '荞麦面', NULL, NULL, 247.00, 'g', NULL, 201.00, NULL, NULL, NULL, 'manual', '2026-02-28 18:42:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (272, 102, 4, '2026-02-28', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 191.00, 'g', NULL, 158.00, NULL, NULL, NULL, 'manual', '2026-02-28 18:42:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (273, 102, 4, '2026-02-28', 'dinner', NULL, '豆腐汤', NULL, NULL, 327.00, 'ml', NULL, 102.00, NULL, NULL, NULL, 'manual', '2026-02-28 18:42:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (274, 103, 4, '2026-02-28', 'snack', NULL, '香蕉', NULL, NULL, 100.00, 'g', NULL, 76.00, NULL, NULL, NULL, 'manual', '2026-02-28 15:29:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (275, 103, 4, '2026-02-28', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 94.00, NULL, NULL, NULL, 'manual', '2026-02-28 20:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (276, 104, 4, '2026-03-01', 'breakfast', NULL, '燕麦粥', NULL, NULL, 204.00, 'g', NULL, 162.00, NULL, NULL, NULL, 'manual', '2026-03-01 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (277, 104, 4, '2026-03-01', 'breakfast', NULL, '鸡蛋', NULL, NULL, 120.00, 'g', NULL, 153.00, NULL, NULL, NULL, 'manual', '2026-03-01 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (278, 104, 4, '2026-03-01', 'breakfast', NULL, '牛奶', NULL, NULL, 226.00, 'ml', NULL, 100.00, NULL, NULL, NULL, 'manual', '2026-03-01 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (279, 105, 4, '2026-03-01', 'lunch', NULL, '米饭', NULL, NULL, 160.00, 'g', NULL, 276.00, NULL, NULL, NULL, 'manual', '2026-03-01 12:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (280, 105, 4, '2026-03-01', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 263.00, NULL, NULL, NULL, 'manual', '2026-03-01 12:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (281, 105, 4, '2026-03-01', 'lunch', NULL, '青菜', NULL, NULL, 128.00, 'g', NULL, 40.00, NULL, NULL, NULL, 'manual', '2026-03-01 12:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (282, 106, 4, '2026-03-01', 'dinner', NULL, '杂粮粥', NULL, NULL, 280.00, 'g', NULL, 168.00, NULL, NULL, NULL, 'manual', '2026-03-01 18:09:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (283, 106, 4, '2026-03-01', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 148.00, 'g', NULL, 206.00, NULL, NULL, NULL, 'manual', '2026-03-01 18:09:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (284, 107, 4, '2026-03-01', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 78.00, NULL, NULL, NULL, 'manual', '2026-03-01 20:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (285, 108, 4, '2026-03-02', 'breakfast', NULL, '燕麦粥', NULL, NULL, 202.00, 'g', NULL, 197.00, NULL, NULL, NULL, 'manual', '2026-03-02 07:20:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (286, 108, 4, '2026-03-02', 'breakfast', NULL, '鸡蛋', NULL, NULL, 109.00, 'g', NULL, 141.00, NULL, NULL, NULL, 'manual', '2026-03-02 07:20:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (287, 108, 4, '2026-03-02', 'breakfast', NULL, '牛奶', NULL, NULL, 242.00, 'ml', NULL, 112.00, NULL, NULL, NULL, 'manual', '2026-03-02 07:20:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (288, 109, 4, '2026-03-02', 'lunch', NULL, '米饭', NULL, NULL, 185.00, 'g', NULL, 258.00, NULL, NULL, NULL, 'manual', '2026-03-02 12:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (289, 109, 4, '2026-03-02', 'lunch', NULL, '麻婆豆腐', NULL, NULL, 200.00, 'g', NULL, 205.00, NULL, NULL, NULL, 'manual', '2026-03-02 12:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (290, 109, 4, '2026-03-02', 'lunch', NULL, '青菜', NULL, NULL, 111.00, 'g', NULL, 40.00, NULL, NULL, NULL, 'manual', '2026-03-02 12:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (291, 109, 4, '2026-03-02', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 299.00, 'ml', NULL, 91.00, NULL, NULL, NULL, 'manual', '2026-03-02 12:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (292, 110, 4, '2026-03-02', 'dinner', NULL, '杂粮粥', NULL, NULL, 269.00, 'g', NULL, 171.00, NULL, NULL, NULL, 'manual', '2026-03-02 18:50:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (293, 110, 4, '2026-03-02', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 124.00, 'g', NULL, 180.00, NULL, NULL, NULL, 'manual', '2026-03-02 18:50:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (294, 110, 4, '2026-03-02', 'dinner', NULL, '豆腐汤', NULL, NULL, 335.00, 'ml', NULL, 80.00, NULL, NULL, NULL, 'manual', '2026-03-02 18:50:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (295, 111, 4, '2026-03-02', 'snack', NULL, '坚果', NULL, NULL, 30.00, 'g', NULL, 142.00, NULL, NULL, NULL, 'manual', '2026-03-02 16:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (296, 112, 4, '2026-03-03', 'breakfast', NULL, '燕麦粥', NULL, NULL, 185.00, 'g', NULL, 200.00, NULL, NULL, NULL, 'manual', '2026-03-03 07:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (297, 112, 4, '2026-03-03', 'breakfast', NULL, '鸡蛋', NULL, NULL, 117.00, 'g', NULL, 163.00, NULL, NULL, NULL, 'manual', '2026-03-03 07:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (298, 113, 4, '2026-03-03', 'lunch', NULL, '米饭', NULL, NULL, 177.00, 'g', NULL, 222.00, NULL, NULL, NULL, 'manual', '2026-03-03 12:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (299, 113, 4, '2026-03-03', 'lunch', NULL, '蒜蓉西兰花', NULL, NULL, 200.00, 'g', NULL, 91.00, NULL, NULL, NULL, 'manual', '2026-03-03 12:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (300, 113, 4, '2026-03-03', 'lunch', NULL, '青菜', NULL, NULL, 109.00, 'g', NULL, 32.00, NULL, NULL, NULL, 'manual', '2026-03-03 12:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (301, 113, 4, '2026-03-03', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 250.00, 'ml', NULL, 89.00, NULL, NULL, NULL, 'manual', '2026-03-03 12:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (302, 114, 4, '2026-03-03', 'dinner', NULL, '荞麦面', NULL, NULL, 218.00, 'g', NULL, 177.00, NULL, NULL, NULL, 'manual', '2026-03-03 18:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (303, 114, 4, '2026-03-03', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 140.00, 'g', NULL, 196.00, NULL, NULL, NULL, 'manual', '2026-03-03 18:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (304, 114, 4, '2026-03-03', 'dinner', NULL, '豆腐汤', NULL, NULL, 296.00, 'ml', NULL, 91.00, NULL, NULL, NULL, 'manual', '2026-03-03 18:30:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (305, 115, 4, '2026-03-03', 'snack', NULL, '酸奶', NULL, NULL, 100.00, 'g', NULL, 122.00, NULL, NULL, NULL, 'manual', '2026-03-03 21:06:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (306, 116, 4, '2026-03-04', 'breakfast', NULL, '燕麦粥', NULL, NULL, 222.00, 'g', NULL, 185.00, NULL, NULL, NULL, 'manual', '2026-03-04 07:45:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (307, 116, 4, '2026-03-04', 'breakfast', NULL, '鸡蛋', NULL, NULL, 109.00, 'g', NULL, 142.00, NULL, NULL, NULL, 'manual', '2026-03-04 07:45:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (308, 116, 4, '2026-03-04', 'breakfast', NULL, '牛奶', NULL, NULL, 218.00, 'ml', NULL, 103.00, NULL, NULL, NULL, 'manual', '2026-03-04 07:45:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (309, 117, 4, '2026-03-04', 'lunch', NULL, '米饭', NULL, NULL, 212.00, 'g', NULL, 289.00, NULL, NULL, NULL, 'manual', '2026-03-04 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (310, 117, 4, '2026-03-04', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 250.00, NULL, NULL, NULL, 'manual', '2026-03-04 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (311, 117, 4, '2026-03-04', 'lunch', NULL, '青菜', NULL, NULL, 105.00, 'g', NULL, 32.00, NULL, NULL, NULL, 'manual', '2026-03-04 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (312, 117, 4, '2026-03-04', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 251.00, 'ml', NULL, 96.00, NULL, NULL, NULL, 'manual', '2026-03-04 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (313, 118, 4, '2026-03-04', 'dinner', NULL, '杂粮粥', NULL, NULL, 238.00, 'g', NULL, 172.00, NULL, NULL, NULL, 'manual', '2026-03-04 18:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (314, 118, 4, '2026-03-04', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 187.00, 'g', NULL, 218.00, NULL, NULL, NULL, 'manual', '2026-03-04 18:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (315, 119, 4, '2026-03-04', 'snack', NULL, '坚果', NULL, NULL, 30.00, 'g', NULL, 165.00, NULL, NULL, NULL, 'manual', '2026-03-04 16:45:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (316, 120, 4, '2026-03-05', 'breakfast', NULL, '燕麦粥', NULL, NULL, 219.00, 'g', NULL, 204.00, NULL, NULL, NULL, 'manual', '2026-03-05 07:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (317, 120, 4, '2026-03-05', 'breakfast', NULL, '鸡蛋', NULL, NULL, 96.00, 'g', NULL, 158.00, NULL, NULL, NULL, 'manual', '2026-03-05 07:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (318, 121, 4, '2026-03-05', 'lunch', NULL, '米饭', NULL, NULL, 211.00, 'g', NULL, 273.00, NULL, NULL, NULL, 'manual', '2026-03-05 12:13:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (319, 121, 4, '2026-03-05', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 177.00, NULL, NULL, NULL, 'manual', '2026-03-05 12:13:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (320, 121, 4, '2026-03-05', 'lunch', NULL, '青菜', NULL, NULL, 96.00, 'g', NULL, 27.00, NULL, NULL, NULL, 'manual', '2026-03-05 12:13:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (321, 121, 4, '2026-03-05', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 326.00, 'ml', NULL, 64.00, NULL, NULL, NULL, 'manual', '2026-03-05 12:13:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (322, 122, 4, '2026-03-05', 'dinner', NULL, '荞麦面', NULL, NULL, 185.00, 'g', NULL, 208.00, NULL, NULL, NULL, 'manual', '2026-03-05 18:44:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (323, 122, 4, '2026-03-05', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 162.00, 'g', NULL, 197.00, NULL, NULL, NULL, 'manual', '2026-03-05 18:44:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (324, 122, 4, '2026-03-05', 'dinner', NULL, '豆腐汤', NULL, NULL, 304.00, 'ml', NULL, 81.00, NULL, NULL, NULL, 'manual', '2026-03-05 18:44:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (325, 123, 4, '2026-03-05', 'snack', NULL, '苹果', NULL, NULL, 120.00, 'g', NULL, 84.00, NULL, NULL, NULL, 'manual', '2026-03-05 15:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (326, 124, 4, '2026-03-06', 'breakfast', NULL, '燕麦粥', NULL, NULL, 223.00, 'g', NULL, 141.00, NULL, NULL, NULL, 'manual', '2026-03-06 07:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (327, 124, 4, '2026-03-06', 'breakfast', NULL, '鸡蛋', NULL, NULL, 115.00, 'g', NULL, 146.00, NULL, NULL, NULL, 'manual', '2026-03-06 07:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (328, 124, 4, '2026-03-06', 'breakfast', NULL, '牛奶', NULL, NULL, 217.00, 'ml', NULL, 120.00, NULL, NULL, NULL, 'manual', '2026-03-06 07:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (329, 125, 4, '2026-03-06', 'lunch', NULL, '米饭', NULL, NULL, 188.00, 'g', NULL, 259.00, NULL, NULL, NULL, 'manual', '2026-03-06 12:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (330, 125, 4, '2026-03-06', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 257.00, NULL, NULL, NULL, 'manual', '2026-03-06 12:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (331, 125, 4, '2026-03-06', 'lunch', NULL, '青菜', NULL, NULL, 115.00, 'g', NULL, 47.00, NULL, NULL, NULL, 'manual', '2026-03-06 12:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (332, 125, 4, '2026-03-06', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 324.00, 'ml', NULL, 90.00, NULL, NULL, NULL, 'manual', '2026-03-06 12:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (333, 126, 4, '2026-03-06', 'dinner', NULL, '杂粮粥', NULL, NULL, 240.00, 'g', NULL, 150.00, NULL, NULL, NULL, 'manual', '2026-03-06 18:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (334, 126, 4, '2026-03-06', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 122.00, 'g', NULL, 189.00, NULL, NULL, NULL, 'manual', '2026-03-06 18:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (335, 126, 4, '2026-03-06', 'dinner', NULL, '豆腐汤', NULL, NULL, 341.00, 'ml', NULL, 80.00, NULL, NULL, NULL, 'manual', '2026-03-06 18:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (336, 127, 4, '2026-03-07', 'breakfast', NULL, '燕麦粥', NULL, NULL, 242.00, 'g', NULL, 140.00, NULL, NULL, NULL, 'manual', '2026-03-07 07:11:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (337, 127, 4, '2026-03-07', 'breakfast', NULL, '鸡蛋', NULL, NULL, 107.00, 'g', NULL, 173.00, NULL, NULL, NULL, 'manual', '2026-03-07 07:11:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (338, 127, 4, '2026-03-07', 'breakfast', NULL, '牛奶', NULL, NULL, 242.00, 'ml', NULL, 121.00, NULL, NULL, NULL, 'manual', '2026-03-07 07:11:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (339, 128, 4, '2026-03-07', 'lunch', NULL, '米饭', NULL, NULL, 224.00, 'g', NULL, 250.00, NULL, NULL, NULL, 'manual', '2026-03-07 12:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (340, 128, 4, '2026-03-07', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 176.00, NULL, NULL, NULL, 'manual', '2026-03-07 12:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (341, 128, 4, '2026-03-07', 'lunch', NULL, '青菜', NULL, NULL, 82.00, 'g', NULL, 30.00, NULL, NULL, NULL, 'manual', '2026-03-07 12:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (342, 128, 4, '2026-03-07', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 286.00, 'ml', NULL, 79.00, NULL, NULL, NULL, 'manual', '2026-03-07 12:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (343, 129, 4, '2026-03-07', 'dinner', NULL, '荞麦面', NULL, NULL, 193.00, 'g', NULL, 191.00, NULL, NULL, NULL, 'manual', '2026-03-07 18:44:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (344, 129, 4, '2026-03-07', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 131.00, 'g', NULL, 207.00, NULL, NULL, NULL, 'manual', '2026-03-07 18:44:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (345, 129, 4, '2026-03-07', 'dinner', NULL, '豆腐汤', NULL, NULL, 348.00, 'ml', NULL, 108.00, NULL, NULL, NULL, 'manual', '2026-03-07 18:44:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (346, 130, 4, '2026-03-07', 'snack', NULL, '苹果', NULL, NULL, 120.00, 'g', NULL, 65.00, NULL, NULL, NULL, 'manual', '2026-03-07 15:55:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (347, 131, 4, '2026-03-08', 'breakfast', NULL, '燕麦粥', NULL, NULL, 184.00, 'g', NULL, 159.00, NULL, NULL, NULL, 'manual', '2026-03-08 07:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (348, 131, 4, '2026-03-08', 'breakfast', NULL, '鸡蛋', NULL, NULL, 111.00, 'g', NULL, 173.00, NULL, NULL, NULL, 'manual', '2026-03-08 07:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (349, 132, 4, '2026-03-08', 'lunch', NULL, '米饭', NULL, NULL, 169.00, 'g', NULL, 301.00, NULL, NULL, NULL, 'manual', '2026-03-08 12:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (350, 132, 4, '2026-03-08', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 221.00, NULL, NULL, NULL, 'manual', '2026-03-08 12:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (351, 132, 4, '2026-03-08', 'lunch', NULL, '青菜', NULL, NULL, 89.00, 'g', NULL, 54.00, NULL, NULL, NULL, 'manual', '2026-03-08 12:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (352, 133, 4, '2026-03-08', 'dinner', NULL, '杂粮粥', NULL, NULL, 213.00, 'g', NULL, 188.00, NULL, NULL, NULL, 'manual', '2026-03-08 18:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (353, 133, 4, '2026-03-08', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 147.00, 'g', NULL, 198.00, NULL, NULL, NULL, 'manual', '2026-03-08 18:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (354, 133, 4, '2026-03-08', 'dinner', NULL, '豆腐汤', NULL, NULL, 363.00, 'ml', NULL, 91.00, NULL, NULL, NULL, 'manual', '2026-03-08 18:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (355, 134, 4, '2026-03-08', 'snack', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 94.00, NULL, NULL, NULL, 'manual', '2026-03-08 16:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (356, 135, 4, '2026-03-09', 'breakfast', NULL, '燕麦粥', NULL, NULL, 249.00, 'g', NULL, 184.00, NULL, NULL, NULL, 'manual', '2026-03-09 07:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (357, 135, 4, '2026-03-09', 'breakfast', NULL, '鸡蛋', NULL, NULL, 92.00, 'g', NULL, 165.00, NULL, NULL, NULL, 'manual', '2026-03-09 07:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (358, 135, 4, '2026-03-09', 'breakfast', NULL, '牛奶', NULL, NULL, 190.00, 'ml', NULL, 120.00, NULL, NULL, NULL, 'manual', '2026-03-09 07:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (359, 136, 4, '2026-03-09', 'lunch', NULL, '米饭', NULL, NULL, 179.00, 'g', NULL, 229.00, NULL, NULL, NULL, 'manual', '2026-03-09 12:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (360, 136, 4, '2026-03-09', 'lunch', NULL, '青椒肉丝', NULL, NULL, 150.00, 'g', NULL, 206.00, NULL, NULL, NULL, 'manual', '2026-03-09 12:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (361, 136, 4, '2026-03-09', 'lunch', NULL, '青菜', NULL, NULL, 116.00, 'g', NULL, 25.00, NULL, NULL, NULL, 'manual', '2026-03-09 12:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (362, 137, 4, '2026-03-09', 'dinner', NULL, '杂粮粥', NULL, NULL, 225.00, 'g', NULL, 156.00, NULL, NULL, NULL, 'manual', '2026-03-09 18:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (363, 137, 4, '2026-03-09', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 155.00, 'g', NULL, 208.00, NULL, NULL, NULL, 'manual', '2026-03-09 18:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (364, 137, 4, '2026-03-09', 'dinner', NULL, '豆腐汤', NULL, NULL, 284.00, 'ml', NULL, 97.00, NULL, NULL, NULL, 'manual', '2026-03-09 18:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (365, 138, 4, '2026-03-09', 'snack', NULL, '坚果', NULL, NULL, 30.00, 'g', NULL, 174.00, NULL, NULL, NULL, 'manual', '2026-03-09 16:45:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (366, 139, 4, '2026-03-10', 'breakfast', NULL, '燕麦粥', NULL, NULL, 195.00, 'g', NULL, 154.00, NULL, NULL, NULL, 'manual', '2026-03-10 07:23:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (367, 139, 4, '2026-03-10', 'breakfast', NULL, '鸡蛋', NULL, NULL, 96.00, 'g', NULL, 145.00, NULL, NULL, NULL, 'manual', '2026-03-10 07:23:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (368, 140, 4, '2026-03-10', 'lunch', NULL, '米饭', NULL, NULL, 167.00, 'g', NULL, 254.00, NULL, NULL, NULL, 'manual', '2026-03-10 12:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (369, 140, 4, '2026-03-10', 'lunch', NULL, '麻婆豆腐', NULL, NULL, 200.00, 'g', NULL, 177.00, NULL, NULL, NULL, 'manual', '2026-03-10 12:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (370, 140, 4, '2026-03-10', 'lunch', NULL, '青菜', NULL, NULL, 86.00, 'g', NULL, 35.00, NULL, NULL, NULL, 'manual', '2026-03-10 12:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (371, 141, 4, '2026-03-10', 'dinner', NULL, '杂粮粥', NULL, NULL, 293.00, 'g', NULL, 148.00, NULL, NULL, NULL, 'manual', '2026-03-10 18:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (372, 141, 4, '2026-03-10', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 160.00, 'g', NULL, 208.00, NULL, NULL, NULL, 'manual', '2026-03-10 18:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (373, 141, 4, '2026-03-10', 'dinner', NULL, '豆腐汤', NULL, NULL, 343.00, 'ml', NULL, 119.00, NULL, NULL, NULL, 'manual', '2026-03-10 18:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (374, 142, 4, '2026-03-10', 'snack', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 95.00, NULL, NULL, NULL, 'manual', '2026-03-10 10:27:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (375, 143, 4, '2026-03-11', 'breakfast', NULL, '燕麦粥', NULL, NULL, 188.00, 'g', NULL, 203.00, NULL, NULL, NULL, 'manual', '2026-03-11 07:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (376, 143, 4, '2026-03-11', 'breakfast', NULL, '鸡蛋', NULL, NULL, 114.00, 'g', NULL, 144.00, NULL, NULL, NULL, 'manual', '2026-03-11 07:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (377, 144, 4, '2026-03-11', 'lunch', NULL, '米饭', NULL, NULL, 204.00, 'g', NULL, 317.00, NULL, NULL, NULL, 'manual', '2026-03-11 12:20:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (378, 144, 4, '2026-03-11', 'lunch', NULL, '青椒肉丝', NULL, NULL, 150.00, 'g', NULL, 235.00, NULL, NULL, NULL, 'manual', '2026-03-11 12:20:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (379, 144, 4, '2026-03-11', 'lunch', NULL, '青菜', NULL, NULL, 109.00, 'g', NULL, 40.00, NULL, NULL, NULL, 'manual', '2026-03-11 12:20:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (380, 144, 4, '2026-03-11', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 343.00, 'ml', NULL, 97.00, NULL, NULL, NULL, 'manual', '2026-03-11 12:20:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (381, 145, 4, '2026-03-11', 'dinner', NULL, '荞麦面', NULL, NULL, 242.00, 'g', NULL, 174.00, NULL, NULL, NULL, 'manual', '2026-03-11 18:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (382, 145, 4, '2026-03-11', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 160.00, 'g', NULL, 198.00, NULL, NULL, NULL, 'manual', '2026-03-11 18:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (383, 146, 4, '2026-03-11', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 75.00, NULL, NULL, NULL, 'manual', '2026-03-11 20:20:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (384, 147, 4, '2026-03-12', 'breakfast', NULL, '燕麦粥', NULL, NULL, 198.00, 'g', NULL, 194.00, NULL, NULL, NULL, 'manual', '2026-03-12 07:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (385, 147, 4, '2026-03-12', 'breakfast', NULL, '鸡蛋', NULL, NULL, 109.00, 'g', NULL, 156.00, NULL, NULL, NULL, 'manual', '2026-03-12 07:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (386, 147, 4, '2026-03-12', 'breakfast', NULL, '牛奶', NULL, NULL, 207.00, 'ml', NULL, 91.00, NULL, NULL, NULL, 'manual', '2026-03-12 07:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (387, 148, 4, '2026-03-12', 'lunch', NULL, '米饭', NULL, NULL, 177.00, 'g', NULL, 229.00, NULL, NULL, NULL, 'manual', '2026-03-12 12:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (388, 148, 4, '2026-03-12', 'lunch', NULL, '蒜蓉西兰花', NULL, NULL, 200.00, 'g', NULL, 114.00, NULL, NULL, NULL, 'manual', '2026-03-12 12:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (389, 148, 4, '2026-03-12', 'lunch', NULL, '青菜', NULL, NULL, 142.00, 'g', NULL, 55.00, NULL, NULL, NULL, 'manual', '2026-03-12 12:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (390, 149, 4, '2026-03-12', 'dinner', NULL, '杂粮粥', NULL, NULL, 248.00, 'g', NULL, 177.00, NULL, NULL, NULL, 'manual', '2026-03-12 18:16:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (391, 149, 4, '2026-03-12', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 164.00, 'g', NULL, 207.00, NULL, NULL, NULL, 'manual', '2026-03-12 18:16:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (392, 149, 4, '2026-03-12', 'dinner', NULL, '豆腐汤', NULL, NULL, 323.00, 'ml', NULL, 81.00, NULL, NULL, NULL, 'manual', '2026-03-12 18:16:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (393, 150, 4, '2026-03-12', 'snack', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 128.00, NULL, NULL, NULL, 'manual', '2026-03-12 21:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (394, 150, 4, '2026-03-12', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 89.00, NULL, NULL, NULL, 'manual', '2026-03-12 20:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (395, 151, 4, '2026-03-13', 'breakfast', NULL, '燕麦粥', NULL, NULL, 182.00, 'g', NULL, 152.00, NULL, NULL, NULL, 'manual', '2026-03-13 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (396, 151, 4, '2026-03-13', 'breakfast', NULL, '鸡蛋', NULL, NULL, 110.00, 'g', NULL, 146.00, NULL, NULL, NULL, 'manual', '2026-03-13 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (397, 151, 4, '2026-03-13', 'breakfast', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 119.00, NULL, NULL, NULL, 'manual', '2026-03-13 07:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (398, 152, 4, '2026-03-13', 'lunch', NULL, '米饭', NULL, NULL, 202.00, 'g', NULL, 241.00, NULL, NULL, NULL, 'manual', '2026-03-13 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (399, 152, 4, '2026-03-13', 'lunch', NULL, '清蒸鲈鱼', NULL, NULL, 200.00, 'g', NULL, 172.00, NULL, NULL, NULL, 'manual', '2026-03-13 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (400, 152, 4, '2026-03-13', 'lunch', NULL, '青菜', NULL, NULL, 120.00, 'g', NULL, 47.00, NULL, NULL, NULL, 'manual', '2026-03-13 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (401, 152, 4, '2026-03-13', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 261.00, 'ml', NULL, 74.00, NULL, NULL, NULL, 'manual', '2026-03-13 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (402, 153, 4, '2026-03-13', 'dinner', NULL, '杂粮粥', NULL, NULL, 231.00, 'g', NULL, 181.00, NULL, NULL, NULL, 'manual', '2026-03-13 18:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (403, 153, 4, '2026-03-13', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 197.00, 'g', NULL, 215.00, NULL, NULL, NULL, 'manual', '2026-03-13 18:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (404, 153, 4, '2026-03-13', 'dinner', NULL, '豆腐汤', NULL, NULL, 280.00, 'ml', NULL, 119.00, NULL, NULL, NULL, 'manual', '2026-03-13 18:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (405, 154, 4, '2026-03-14', 'breakfast', NULL, '燕麦粥', NULL, NULL, 184.00, 'g', NULL, 194.00, NULL, NULL, NULL, 'manual', '2026-03-14 07:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (406, 154, 4, '2026-03-14', 'breakfast', NULL, '鸡蛋', NULL, NULL, 105.00, 'g', NULL, 162.00, NULL, NULL, NULL, 'manual', '2026-03-14 07:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (407, 155, 4, '2026-03-14', 'lunch', NULL, '米饭', NULL, NULL, 202.00, 'g', NULL, 320.00, NULL, NULL, NULL, 'manual', '2026-03-14 12:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (408, 155, 4, '2026-03-14', 'lunch', NULL, '清蒸鲈鱼', NULL, NULL, 200.00, 'g', NULL, 165.00, NULL, NULL, NULL, 'manual', '2026-03-14 12:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (409, 155, 4, '2026-03-14', 'lunch', NULL, '青菜', NULL, NULL, 84.00, 'g', NULL, 52.00, NULL, NULL, NULL, 'manual', '2026-03-14 12:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (410, 156, 4, '2026-03-14', 'dinner', NULL, '荞麦面', NULL, NULL, 196.00, 'g', NULL, 194.00, NULL, NULL, NULL, 'manual', '2026-03-14 18:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (411, 156, 4, '2026-03-14', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 195.00, 'g', NULL, 153.00, NULL, NULL, NULL, 'manual', '2026-03-14 18:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (412, 157, 4, '2026-03-15', 'breakfast', NULL, '燕麦粥', NULL, NULL, 224.00, 'g', NULL, 145.00, NULL, NULL, NULL, 'manual', '2026-03-15 07:31:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (413, 157, 4, '2026-03-15', 'breakfast', NULL, '鸡蛋', NULL, NULL, 111.00, 'g', NULL, 162.00, NULL, NULL, NULL, 'manual', '2026-03-15 07:31:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (414, 157, 4, '2026-03-15', 'breakfast', NULL, '牛奶', NULL, NULL, 250.00, 'ml', NULL, 97.00, NULL, NULL, NULL, 'manual', '2026-03-15 07:31:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (415, 158, 4, '2026-03-15', 'lunch', NULL, '米饭', NULL, NULL, 207.00, 'g', NULL, 240.00, NULL, NULL, NULL, 'manual', '2026-03-15 12:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (416, 158, 4, '2026-03-15', 'lunch', NULL, '青椒肉丝', NULL, NULL, 150.00, 'g', NULL, 195.00, NULL, NULL, NULL, 'manual', '2026-03-15 12:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (417, 158, 4, '2026-03-15', 'lunch', NULL, '青菜', NULL, NULL, 107.00, 'g', NULL, 32.00, NULL, NULL, NULL, 'manual', '2026-03-15 12:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (418, 158, 4, '2026-03-15', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 263.00, 'ml', NULL, 65.00, NULL, NULL, NULL, 'manual', '2026-03-15 12:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (419, 159, 4, '2026-03-15', 'dinner', NULL, '杂粮粥', NULL, NULL, 214.00, 'g', NULL, 183.00, NULL, NULL, NULL, 'manual', '2026-03-15 18:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (420, 159, 4, '2026-03-15', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 142.00, 'g', NULL, 200.00, NULL, NULL, NULL, 'manual', '2026-03-15 18:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (421, 160, 4, '2026-03-15', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 85.00, NULL, NULL, NULL, 'manual', '2026-03-15 20:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (422, 161, 4, '2026-03-16', 'breakfast', NULL, '燕麦粥', NULL, NULL, 190.00, 'g', NULL, 152.00, NULL, NULL, NULL, 'manual', '2026-03-16 07:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (423, 161, 4, '2026-03-16', 'breakfast', NULL, '鸡蛋', NULL, NULL, 91.00, 'g', NULL, 178.00, NULL, NULL, NULL, 'manual', '2026-03-16 07:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (424, 161, 4, '2026-03-16', 'breakfast', NULL, '牛奶', NULL, NULL, 230.00, 'ml', NULL, 91.00, NULL, NULL, NULL, 'manual', '2026-03-16 07:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (425, 162, 4, '2026-03-16', 'lunch', NULL, '米饭', NULL, NULL, 235.00, 'g', NULL, 252.00, NULL, NULL, NULL, 'manual', '2026-03-16 12:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (426, 162, 4, '2026-03-16', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 226.00, NULL, NULL, NULL, 'manual', '2026-03-16 12:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (427, 162, 4, '2026-03-16', 'lunch', NULL, '青菜', NULL, NULL, 88.00, 'g', NULL, 30.00, NULL, NULL, NULL, 'manual', '2026-03-16 12:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (428, 162, 4, '2026-03-16', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 318.00, 'ml', NULL, 71.00, NULL, NULL, NULL, 'manual', '2026-03-16 12:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (429, 163, 4, '2026-03-16', 'dinner', NULL, '荞麦面', NULL, NULL, 221.00, 'g', NULL, 204.00, NULL, NULL, NULL, 'manual', '2026-03-16 18:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (430, 163, 4, '2026-03-16', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 192.00, 'g', NULL, 158.00, NULL, NULL, NULL, 'manual', '2026-03-16 18:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (431, 164, 4, '2026-03-16', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 99.00, NULL, NULL, NULL, 'manual', '2026-03-16 20:13:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (432, 165, 4, '2026-03-17', 'breakfast', NULL, '燕麦粥', NULL, NULL, 201.00, 'g', NULL, 217.00, NULL, NULL, NULL, 'manual', '2026-03-17 07:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (433, 165, 4, '2026-03-17', 'breakfast', NULL, '鸡蛋', NULL, NULL, 93.00, 'g', NULL, 170.00, NULL, NULL, NULL, 'manual', '2026-03-17 07:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (434, 165, 4, '2026-03-17', 'breakfast', NULL, '牛奶', NULL, NULL, 227.00, 'ml', NULL, 116.00, NULL, NULL, NULL, 'manual', '2026-03-17 07:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (435, 166, 4, '2026-03-17', 'lunch', NULL, '米饭', NULL, NULL, 205.00, 'g', NULL, 239.00, NULL, NULL, NULL, 'manual', '2026-03-17 12:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (436, 166, 4, '2026-03-17', 'lunch', NULL, '蒜蓉西兰花', NULL, NULL, 200.00, 'g', NULL, 88.00, NULL, NULL, NULL, 'manual', '2026-03-17 12:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (437, 166, 4, '2026-03-17', 'lunch', NULL, '青菜', NULL, NULL, 130.00, 'g', NULL, 36.00, NULL, NULL, NULL, 'manual', '2026-03-17 12:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (438, 167, 4, '2026-03-17', 'dinner', NULL, '杂粮粥', NULL, NULL, 202.00, 'g', NULL, 184.00, NULL, NULL, NULL, 'manual', '2026-03-17 18:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (439, 167, 4, '2026-03-17', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 165.00, 'g', NULL, 210.00, NULL, NULL, NULL, 'manual', '2026-03-17 18:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (440, 167, 4, '2026-03-17', 'dinner', NULL, '豆腐汤', NULL, NULL, 355.00, 'ml', NULL, 103.00, NULL, NULL, NULL, 'manual', '2026-03-17 18:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (441, 168, 4, '2026-03-17', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 100.00, NULL, NULL, NULL, 'manual', '2026-03-17 20:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (442, 169, 4, '2026-03-18', 'breakfast', NULL, '燕麦粥', NULL, NULL, 205.00, 'g', NULL, 202.00, NULL, NULL, NULL, 'manual', '2026-03-18 07:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (443, 169, 4, '2026-03-18', 'breakfast', NULL, '鸡蛋', NULL, NULL, 113.00, 'g', NULL, 163.00, NULL, NULL, NULL, 'manual', '2026-03-18 07:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (444, 169, 4, '2026-03-18', 'breakfast', NULL, '牛奶', NULL, NULL, 230.00, 'ml', NULL, 92.00, NULL, NULL, NULL, 'manual', '2026-03-18 07:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (445, 170, 4, '2026-03-18', 'lunch', NULL, '米饭', NULL, NULL, 181.00, 'g', NULL, 278.00, NULL, NULL, NULL, 'manual', '2026-03-18 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (446, 170, 4, '2026-03-18', 'lunch', NULL, '清蒸鲈鱼', NULL, NULL, 200.00, 'g', NULL, 159.00, NULL, NULL, NULL, 'manual', '2026-03-18 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (447, 170, 4, '2026-03-18', 'lunch', NULL, '青菜', NULL, NULL, 116.00, 'g', NULL, 32.00, NULL, NULL, NULL, 'manual', '2026-03-18 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (448, 170, 4, '2026-03-18', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 251.00, 'ml', NULL, 68.00, NULL, NULL, NULL, 'manual', '2026-03-18 12:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (449, 171, 4, '2026-03-18', 'dinner', NULL, '杂粮粥', NULL, NULL, 247.00, 'g', NULL, 151.00, NULL, NULL, NULL, 'manual', '2026-03-18 18:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (450, 171, 4, '2026-03-18', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 134.00, 'g', NULL, 179.00, NULL, NULL, NULL, 'manual', '2026-03-18 18:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (451, 171, 4, '2026-03-18', 'dinner', NULL, '豆腐汤', NULL, NULL, 376.00, 'ml', NULL, 109.00, NULL, NULL, NULL, 'manual', '2026-03-18 18:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (452, 172, 4, '2026-03-18', 'snack', NULL, '香蕉', NULL, NULL, 100.00, 'g', NULL, 76.00, NULL, NULL, NULL, 'manual', '2026-03-18 15:53:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (453, 173, 4, '2026-03-19', 'breakfast', NULL, '燕麦粥', NULL, NULL, 182.00, 'g', NULL, 166.00, NULL, NULL, NULL, 'manual', '2026-03-19 07:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (454, 173, 4, '2026-03-19', 'breakfast', NULL, '鸡蛋', NULL, NULL, 109.00, 'g', NULL, 168.00, NULL, NULL, NULL, 'manual', '2026-03-19 07:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (455, 173, 4, '2026-03-19', 'breakfast', NULL, '牛奶', NULL, NULL, 182.00, 'ml', NULL, 110.00, NULL, NULL, NULL, 'manual', '2026-03-19 07:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (456, 174, 4, '2026-03-19', 'lunch', NULL, '米饭', NULL, NULL, 174.00, 'g', NULL, 262.00, NULL, NULL, NULL, 'manual', '2026-03-19 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (457, 174, 4, '2026-03-19', 'lunch', NULL, '麻婆豆腐', NULL, NULL, 200.00, 'g', NULL, 193.00, NULL, NULL, NULL, 'manual', '2026-03-19 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (458, 174, 4, '2026-03-19', 'lunch', NULL, '青菜', NULL, NULL, 139.00, 'g', NULL, 54.00, NULL, NULL, NULL, 'manual', '2026-03-19 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (459, 175, 4, '2026-03-19', 'dinner', NULL, '杂粮粥', NULL, NULL, 231.00, 'g', NULL, 169.00, NULL, NULL, NULL, 'manual', '2026-03-19 18:24:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (460, 175, 4, '2026-03-19', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 159.00, 'g', NULL, 217.00, NULL, NULL, NULL, 'manual', '2026-03-19 18:24:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (461, 175, 4, '2026-03-19', 'dinner', NULL, '豆腐汤', NULL, NULL, 303.00, 'ml', NULL, 117.00, NULL, NULL, NULL, 'manual', '2026-03-19 18:24:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (462, 176, 4, '2026-03-19', 'snack', NULL, '酸奶', NULL, NULL, 100.00, 'g', NULL, 133.00, NULL, NULL, NULL, 'manual', '2026-03-19 10:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (463, 176, 4, '2026-03-19', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 76.00, NULL, NULL, NULL, 'manual', '2026-03-19 20:24:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (464, 177, 4, '2026-03-20', 'breakfast', NULL, '燕麦粥', NULL, NULL, 257.00, 'g', NULL, 197.00, NULL, NULL, NULL, 'manual', '2026-03-20 07:33:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (465, 177, 4, '2026-03-20', 'breakfast', NULL, '鸡蛋', NULL, NULL, 116.00, 'g', NULL, 143.00, NULL, NULL, NULL, 'manual', '2026-03-20 07:33:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (466, 177, 4, '2026-03-20', 'breakfast', NULL, '牛奶', NULL, NULL, 202.00, 'ml', NULL, 127.00, NULL, NULL, NULL, 'manual', '2026-03-20 07:33:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (467, 178, 4, '2026-03-20', 'lunch', NULL, '米饭', NULL, NULL, 168.00, 'g', NULL, 283.00, NULL, NULL, NULL, 'manual', '2026-03-20 12:00:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (468, 178, 4, '2026-03-20', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 263.00, NULL, NULL, NULL, 'manual', '2026-03-20 12:00:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (469, 178, 4, '2026-03-20', 'lunch', NULL, '青菜', NULL, NULL, 120.00, 'g', NULL, 37.00, NULL, NULL, NULL, 'manual', '2026-03-20 12:00:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (470, 178, 4, '2026-03-20', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 337.00, 'ml', NULL, 97.00, NULL, NULL, NULL, 'manual', '2026-03-20 12:00:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (471, 179, 4, '2026-03-20', 'dinner', NULL, '荞麦面', NULL, NULL, 214.00, 'g', NULL, 218.00, NULL, NULL, NULL, 'manual', '2026-03-20 18:07:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (472, 179, 4, '2026-03-20', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 135.00, 'g', NULL, 186.00, NULL, NULL, NULL, 'manual', '2026-03-20 18:07:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (473, 179, 4, '2026-03-20', 'dinner', NULL, '豆腐汤', NULL, NULL, 346.00, 'ml', NULL, 114.00, NULL, NULL, NULL, 'manual', '2026-03-20 18:07:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (474, 180, 4, '2026-03-20', 'snack', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 93.00, NULL, NULL, NULL, 'manual', '2026-03-20 21:55:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (475, 181, 4, '2026-03-21', 'breakfast', NULL, '燕麦粥', NULL, NULL, 220.00, 'g', NULL, 197.00, NULL, NULL, NULL, 'manual', '2026-03-21 07:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (476, 181, 4, '2026-03-21', 'breakfast', NULL, '鸡蛋', NULL, NULL, 110.00, 'g', NULL, 142.00, NULL, NULL, NULL, 'manual', '2026-03-21 07:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (477, 182, 4, '2026-03-21', 'lunch', NULL, '米饭', NULL, NULL, 196.00, 'g', NULL, 302.00, NULL, NULL, NULL, 'manual', '2026-03-21 12:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (478, 182, 4, '2026-03-21', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 141.00, NULL, NULL, NULL, 'manual', '2026-03-21 12:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (479, 182, 4, '2026-03-21', 'lunch', NULL, '青菜', NULL, NULL, 102.00, 'g', NULL, 55.00, NULL, NULL, NULL, 'manual', '2026-03-21 12:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (480, 182, 4, '2026-03-21', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 299.00, 'ml', NULL, 84.00, NULL, NULL, NULL, 'manual', '2026-03-21 12:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (481, 183, 4, '2026-03-21', 'dinner', NULL, '荞麦面', NULL, NULL, 214.00, 'g', NULL, 239.00, NULL, NULL, NULL, 'manual', '2026-03-21 18:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (482, 183, 4, '2026-03-21', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 166.00, 'g', NULL, 152.00, NULL, NULL, NULL, 'manual', '2026-03-21 18:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (483, 183, 4, '2026-03-21', 'dinner', NULL, '豆腐汤', NULL, NULL, 292.00, 'ml', NULL, 80.00, NULL, NULL, NULL, 'manual', '2026-03-21 18:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (484, 184, 4, '2026-03-22', 'breakfast', NULL, '燕麦粥', NULL, NULL, 235.00, 'g', NULL, 156.00, NULL, NULL, NULL, 'manual', '2026-03-22 07:16:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (485, 184, 4, '2026-03-22', 'breakfast', NULL, '鸡蛋', NULL, NULL, 101.00, 'g', NULL, 145.00, NULL, NULL, NULL, 'manual', '2026-03-22 07:16:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (486, 184, 4, '2026-03-22', 'breakfast', NULL, '牛奶', NULL, NULL, 199.00, 'ml', NULL, 129.00, NULL, NULL, NULL, 'manual', '2026-03-22 07:16:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (487, 185, 4, '2026-03-22', 'lunch', NULL, '米饭', NULL, NULL, 168.00, 'g', NULL, 290.00, NULL, NULL, NULL, 'manual', '2026-03-22 12:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (488, 185, 4, '2026-03-22', 'lunch', NULL, '青椒肉丝', NULL, NULL, 150.00, 'g', NULL, 217.00, NULL, NULL, NULL, 'manual', '2026-03-22 12:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (489, 185, 4, '2026-03-22', 'lunch', NULL, '青菜', NULL, NULL, 107.00, 'g', NULL, 44.00, NULL, NULL, NULL, 'manual', '2026-03-22 12:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (490, 185, 4, '2026-03-22', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 312.00, 'ml', NULL, 99.00, NULL, NULL, NULL, 'manual', '2026-03-22 12:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (491, 186, 4, '2026-03-22', 'dinner', NULL, '杂粮粥', NULL, NULL, 300.00, 'g', NULL, 165.00, NULL, NULL, NULL, 'manual', '2026-03-22 18:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (492, 186, 4, '2026-03-22', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 174.00, 'g', NULL, 151.00, NULL, NULL, NULL, 'manual', '2026-03-22 18:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (493, 186, 4, '2026-03-22', 'dinner', NULL, '豆腐汤', NULL, NULL, 286.00, 'ml', NULL, 115.00, NULL, NULL, NULL, 'manual', '2026-03-22 18:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (494, 187, 4, '2026-03-22', 'snack', NULL, '酸奶', NULL, NULL, 100.00, 'g', NULL, 140.00, NULL, NULL, NULL, 'manual', '2026-03-22 21:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (495, 188, 4, '2026-03-23', 'breakfast', NULL, '燕麦粥', NULL, NULL, 209.00, 'g', NULL, 172.00, NULL, NULL, NULL, 'manual', '2026-03-23 07:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (496, 188, 4, '2026-03-23', 'breakfast', NULL, '鸡蛋', NULL, NULL, 114.00, 'g', NULL, 153.00, NULL, NULL, NULL, 'manual', '2026-03-23 07:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (497, 188, 4, '2026-03-23', 'breakfast', NULL, '牛奶', NULL, NULL, 224.00, 'ml', NULL, 92.00, NULL, NULL, NULL, 'manual', '2026-03-23 07:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (498, 189, 4, '2026-03-23', 'lunch', NULL, '米饭', NULL, NULL, 177.00, 'g', NULL, 317.00, NULL, NULL, NULL, 'manual', '2026-03-23 12:29:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (499, 189, 4, '2026-03-23', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 182.00, NULL, NULL, NULL, 'manual', '2026-03-23 12:29:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (500, 189, 4, '2026-03-23', 'lunch', NULL, '青菜', NULL, NULL, 104.00, 'g', NULL, 46.00, NULL, NULL, NULL, 'manual', '2026-03-23 12:29:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (501, 190, 4, '2026-03-23', 'dinner', NULL, '荞麦面', NULL, NULL, 204.00, 'g', NULL, 231.00, NULL, NULL, NULL, 'manual', '2026-03-23 18:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (502, 190, 4, '2026-03-23', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 142.00, 'g', NULL, 176.00, NULL, NULL, NULL, 'manual', '2026-03-23 18:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (503, 191, 4, '2026-03-23', 'snack', NULL, '牛奶', NULL, NULL, 200.00, 'ml', NULL, 92.00, NULL, NULL, NULL, 'manual', '2026-03-23 15:54:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (504, 192, 4, '2026-03-24', 'breakfast', NULL, '燕麦粥', NULL, NULL, 219.00, 'g', NULL, 212.00, NULL, NULL, NULL, 'manual', '2026-03-24 07:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (505, 192, 4, '2026-03-24', 'breakfast', NULL, '鸡蛋', NULL, NULL, 81.00, 'g', NULL, 174.00, NULL, NULL, NULL, 'manual', '2026-03-24 07:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (506, 192, 4, '2026-03-24', 'breakfast', NULL, '牛奶', NULL, NULL, 233.00, 'ml', NULL, 91.00, NULL, NULL, NULL, 'manual', '2026-03-24 07:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (507, 193, 4, '2026-03-24', 'lunch', NULL, '米饭', NULL, NULL, 230.00, 'g', NULL, 276.00, NULL, NULL, NULL, 'manual', '2026-03-24 12:31:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (508, 193, 4, '2026-03-24', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 154.00, NULL, NULL, NULL, 'manual', '2026-03-24 12:31:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (509, 193, 4, '2026-03-24', 'lunch', NULL, '青菜', NULL, NULL, 105.00, 'g', NULL, 26.00, NULL, NULL, NULL, 'manual', '2026-03-24 12:31:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (510, 193, 4, '2026-03-24', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 327.00, 'ml', NULL, 83.00, NULL, NULL, NULL, 'manual', '2026-03-24 12:31:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (511, 194, 4, '2026-03-24', 'dinner', NULL, '荞麦面', NULL, NULL, 249.00, 'g', NULL, 222.00, NULL, NULL, NULL, 'manual', '2026-03-24 18:27:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (512, 194, 4, '2026-03-24', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 128.00, 'g', NULL, 157.00, NULL, NULL, NULL, 'manual', '2026-03-24 18:27:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (513, 194, 4, '2026-03-24', 'dinner', NULL, '豆腐汤', NULL, NULL, 357.00, 'ml', NULL, 93.00, NULL, NULL, NULL, 'manual', '2026-03-24 18:27:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (514, 195, 4, '2026-03-24', 'snack', NULL, '酸奶', NULL, NULL, 100.00, 'g', NULL, 140.00, NULL, NULL, NULL, 'manual', '2026-03-24 16:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (515, 196, 4, '2026-03-25', 'breakfast', NULL, '燕麦粥', NULL, NULL, 210.00, 'g', NULL, 162.00, NULL, NULL, NULL, 'manual', '2026-03-25 07:33:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (516, 196, 4, '2026-03-25', 'breakfast', NULL, '鸡蛋', NULL, NULL, 86.00, 'g', NULL, 145.00, NULL, NULL, NULL, 'manual', '2026-03-25 07:33:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (517, 197, 4, '2026-03-25', 'lunch', NULL, '米饭', NULL, NULL, 189.00, 'g', NULL, 283.00, NULL, NULL, NULL, 'manual', '2026-03-25 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (518, 197, 4, '2026-03-25', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 138.00, NULL, NULL, NULL, 'manual', '2026-03-25 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (519, 197, 4, '2026-03-25', 'lunch', NULL, '青菜', NULL, NULL, 93.00, 'g', NULL, 47.00, NULL, NULL, NULL, 'manual', '2026-03-25 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (520, 197, 4, '2026-03-25', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 320.00, 'ml', NULL, 60.00, NULL, NULL, NULL, 'manual', '2026-03-25 12:01:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (521, 198, 4, '2026-03-25', 'dinner', NULL, '杂粮粥', NULL, NULL, 240.00, 'g', NULL, 134.00, NULL, NULL, NULL, 'manual', '2026-03-25 18:09:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (522, 198, 4, '2026-03-25', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 175.00, 'g', NULL, 156.00, NULL, NULL, NULL, 'manual', '2026-03-25 18:09:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (523, 198, 4, '2026-03-25', 'dinner', NULL, '豆腐汤', NULL, NULL, 358.00, 'ml', NULL, 110.00, NULL, NULL, NULL, 'manual', '2026-03-25 18:09:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (524, 199, 4, '2026-03-25', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 84.00, NULL, NULL, NULL, 'manual', '2026-03-25 20:11:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (525, 200, 4, '2026-03-26', 'breakfast', NULL, '燕麦粥', NULL, NULL, 229.00, 'g', NULL, 158.00, NULL, NULL, NULL, 'manual', '2026-03-26 07:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (526, 200, 4, '2026-03-26', 'breakfast', NULL, '鸡蛋', NULL, NULL, 88.00, 'g', NULL, 179.00, NULL, NULL, NULL, 'manual', '2026-03-26 07:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (527, 200, 4, '2026-03-26', 'breakfast', NULL, '牛奶', NULL, NULL, 249.00, 'ml', NULL, 101.00, NULL, NULL, NULL, 'manual', '2026-03-26 07:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (528, 201, 4, '2026-03-26', 'lunch', NULL, '米饭', NULL, NULL, 175.00, 'g', NULL, 319.00, NULL, NULL, NULL, 'manual', '2026-03-26 12:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (529, 201, 4, '2026-03-26', 'lunch', NULL, '蒜蓉西兰花', NULL, NULL, 200.00, 'g', NULL, 104.00, NULL, NULL, NULL, 'manual', '2026-03-26 12:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (530, 201, 4, '2026-03-26', 'lunch', NULL, '青菜', NULL, NULL, 134.00, 'g', NULL, 42.00, NULL, NULL, NULL, 'manual', '2026-03-26 12:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (531, 201, 4, '2026-03-26', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 291.00, 'ml', NULL, 68.00, NULL, NULL, NULL, 'manual', '2026-03-26 12:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (532, 202, 4, '2026-03-26', 'dinner', NULL, '杂粮粥', NULL, NULL, 268.00, 'g', NULL, 187.00, NULL, NULL, NULL, 'manual', '2026-03-26 18:44:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (533, 202, 4, '2026-03-26', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 180.00, 'g', NULL, 158.00, NULL, NULL, NULL, 'manual', '2026-03-26 18:44:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (534, 203, 4, '2026-03-26', 'snack', NULL, '坚果', NULL, NULL, 30.00, 'g', NULL, 155.00, NULL, NULL, NULL, 'manual', '2026-03-26 10:44:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (535, 203, 4, '2026-03-26', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 99.00, NULL, NULL, NULL, 'manual', '2026-03-26 20:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (536, 204, 4, '2026-03-27', 'breakfast', NULL, '燕麦粥', NULL, NULL, 236.00, 'g', NULL, 199.00, NULL, NULL, NULL, 'manual', '2026-03-27 07:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (537, 204, 4, '2026-03-27', 'breakfast', NULL, '鸡蛋', NULL, NULL, 103.00, 'g', NULL, 172.00, NULL, NULL, NULL, 'manual', '2026-03-27 07:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (538, 204, 4, '2026-03-27', 'breakfast', NULL, '牛奶', NULL, NULL, 184.00, 'ml', NULL, 124.00, NULL, NULL, NULL, 'manual', '2026-03-27 07:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (539, 205, 4, '2026-03-27', 'lunch', NULL, '米饭', NULL, NULL, 183.00, 'g', NULL, 287.00, NULL, NULL, NULL, 'manual', '2026-03-27 12:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (540, 205, 4, '2026-03-27', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 174.00, NULL, NULL, NULL, 'manual', '2026-03-27 12:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (541, 205, 4, '2026-03-27', 'lunch', NULL, '青菜', NULL, NULL, 90.00, 'g', NULL, 51.00, NULL, NULL, NULL, 'manual', '2026-03-27 12:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (542, 205, 4, '2026-03-27', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 287.00, 'ml', NULL, 82.00, NULL, NULL, NULL, 'manual', '2026-03-27 12:22:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (543, 206, 4, '2026-03-27', 'dinner', NULL, '荞麦面', NULL, NULL, 202.00, 'g', NULL, 195.00, NULL, NULL, NULL, 'manual', '2026-03-27 18:06:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (544, 206, 4, '2026-03-27', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 161.00, 'g', NULL, 178.00, NULL, NULL, NULL, 'manual', '2026-03-27 18:06:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (545, 206, 4, '2026-03-27', 'dinner', NULL, '豆腐汤', NULL, NULL, 378.00, 'ml', NULL, 96.00, NULL, NULL, NULL, 'manual', '2026-03-27 18:06:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (546, 207, 4, '2026-03-28', 'breakfast', NULL, '燕麦粥', NULL, NULL, 242.00, 'g', NULL, 217.00, NULL, NULL, NULL, 'manual', '2026-03-28 07:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (547, 207, 4, '2026-03-28', 'breakfast', NULL, '鸡蛋', NULL, NULL, 114.00, 'g', NULL, 165.00, NULL, NULL, NULL, 'manual', '2026-03-28 07:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (548, 207, 4, '2026-03-28', 'breakfast', NULL, '牛奶', NULL, NULL, 240.00, 'ml', NULL, 128.00, NULL, NULL, NULL, 'manual', '2026-03-28 07:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (549, 208, 4, '2026-03-28', 'lunch', NULL, '米饭', NULL, NULL, 162.00, 'g', NULL, 307.00, NULL, NULL, NULL, 'manual', '2026-03-28 12:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (550, 208, 4, '2026-03-28', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 242.00, NULL, NULL, NULL, 'manual', '2026-03-28 12:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (551, 208, 4, '2026-03-28', 'lunch', NULL, '青菜', NULL, NULL, 100.00, 'g', NULL, 30.00, NULL, NULL, NULL, 'manual', '2026-03-28 12:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (552, 208, 4, '2026-03-28', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 251.00, 'ml', NULL, 60.00, NULL, NULL, NULL, 'manual', '2026-03-28 12:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (553, 209, 4, '2026-03-28', 'dinner', NULL, '杂粮粥', NULL, NULL, 251.00, 'g', NULL, 151.00, NULL, NULL, NULL, 'manual', '2026-03-28 18:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (554, 209, 4, '2026-03-28', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 193.00, 'g', NULL, 201.00, NULL, NULL, NULL, 'manual', '2026-03-28 18:08:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (555, 210, 4, '2026-03-29', 'breakfast', NULL, '燕麦粥', NULL, NULL, 223.00, 'g', NULL, 167.00, NULL, NULL, NULL, 'manual', '2026-03-29 07:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (556, 210, 4, '2026-03-29', 'breakfast', NULL, '鸡蛋', NULL, NULL, 105.00, 'g', NULL, 168.00, NULL, NULL, NULL, 'manual', '2026-03-29 07:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (557, 210, 4, '2026-03-29', 'breakfast', NULL, '牛奶', NULL, NULL, 211.00, 'ml', NULL, 104.00, NULL, NULL, NULL, 'manual', '2026-03-29 07:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (558, 211, 4, '2026-03-29', 'lunch', NULL, '米饭', NULL, NULL, 204.00, 'g', NULL, 262.00, NULL, NULL, NULL, 'manual', '2026-03-29 12:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (559, 211, 4, '2026-03-29', 'lunch', NULL, '番茄炒蛋', NULL, NULL, 180.00, 'g', NULL, 163.00, NULL, NULL, NULL, 'manual', '2026-03-29 12:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (560, 211, 4, '2026-03-29', 'lunch', NULL, '青菜', NULL, NULL, 117.00, 'g', NULL, 48.00, NULL, NULL, NULL, 'manual', '2026-03-29 12:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (561, 212, 4, '2026-03-29', 'dinner', NULL, '杂粮粥', NULL, NULL, 216.00, 'g', NULL, 190.00, NULL, NULL, NULL, 'manual', '2026-03-29 18:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (562, 212, 4, '2026-03-29', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 188.00, 'g', NULL, 198.00, NULL, NULL, NULL, 'manual', '2026-03-29 18:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (563, 213, 4, '2026-03-29', 'snack', NULL, '苹果', NULL, NULL, 120.00, 'g', NULL, 78.00, NULL, NULL, NULL, 'manual', '2026-03-29 10:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (564, 214, 4, '2026-03-30', 'breakfast', NULL, '燕麦粥', NULL, NULL, 244.00, 'g', NULL, 194.00, NULL, NULL, NULL, 'manual', '2026-03-30 07:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (565, 214, 4, '2026-03-30', 'breakfast', NULL, '鸡蛋', NULL, NULL, 119.00, 'g', NULL, 174.00, NULL, NULL, NULL, 'manual', '2026-03-30 07:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (566, 214, 4, '2026-03-30', 'breakfast', NULL, '牛奶', NULL, NULL, 234.00, 'ml', NULL, 95.00, NULL, NULL, NULL, 'manual', '2026-03-30 07:15:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (567, 215, 4, '2026-03-30', 'lunch', NULL, '米饭', NULL, NULL, 235.00, 'g', NULL, 253.00, NULL, NULL, NULL, 'manual', '2026-03-30 12:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (568, 215, 4, '2026-03-30', 'lunch', NULL, '清蒸鲈鱼', NULL, NULL, 200.00, 'g', NULL, 199.00, NULL, NULL, NULL, 'manual', '2026-03-30 12:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (569, 215, 4, '2026-03-30', 'lunch', NULL, '青菜', NULL, NULL, 129.00, 'g', NULL, 51.00, NULL, NULL, NULL, 'manual', '2026-03-30 12:02:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (570, 216, 4, '2026-03-30', 'dinner', NULL, '杂粮粥', NULL, NULL, 207.00, 'g', NULL, 179.00, NULL, NULL, NULL, 'manual', '2026-03-30 18:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (571, 216, 4, '2026-03-30', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 186.00, 'g', NULL, 211.00, NULL, NULL, NULL, 'manual', '2026-03-30 18:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (572, 216, 4, '2026-03-30', 'dinner', NULL, '豆腐汤', NULL, NULL, 354.00, 'ml', NULL, 79.00, NULL, NULL, NULL, 'manual', '2026-03-30 18:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (573, 217, 4, '2026-03-30', 'snack', NULL, '香蕉', NULL, NULL, 100.00, 'g', NULL, 80.00, NULL, NULL, NULL, 'manual', '2026-03-30 10:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (574, 218, 4, '2026-03-31', 'breakfast', NULL, '燕麦粥', NULL, NULL, 243.00, 'g', NULL, 143.00, NULL, NULL, NULL, 'manual', '2026-03-31 07:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (575, 218, 4, '2026-03-31', 'breakfast', NULL, '鸡蛋', NULL, NULL, 111.00, 'g', NULL, 159.00, NULL, NULL, NULL, 'manual', '2026-03-31 07:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (576, 218, 4, '2026-03-31', 'breakfast', NULL, '牛奶', NULL, NULL, 193.00, 'ml', NULL, 126.00, NULL, NULL, NULL, 'manual', '2026-03-31 07:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (577, 219, 4, '2026-03-31', 'lunch', NULL, '米饭', NULL, NULL, 214.00, 'g', NULL, 279.00, NULL, NULL, NULL, 'manual', '2026-03-31 12:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (578, 219, 4, '2026-03-31', 'lunch', NULL, '宫保鸡丁', NULL, NULL, 160.00, 'g', NULL, 253.00, NULL, NULL, NULL, 'manual', '2026-03-31 12:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (579, 219, 4, '2026-03-31', 'lunch', NULL, '青菜', NULL, NULL, 87.00, 'g', NULL, 37.00, NULL, NULL, NULL, 'manual', '2026-03-31 12:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (580, 219, 4, '2026-03-31', 'lunch', NULL, '紫菜蛋汤', NULL, NULL, 270.00, 'ml', NULL, 75.00, NULL, NULL, NULL, 'manual', '2026-03-31 12:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (581, 220, 4, '2026-03-31', 'dinner', NULL, '杂粮粥', NULL, NULL, 252.00, 'g', NULL, 195.00, NULL, NULL, NULL, 'manual', '2026-03-31 18:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (582, 220, 4, '2026-03-31', 'dinner', NULL, '鸡胸肉沙拉', NULL, NULL, 134.00, 'g', NULL, 183.00, NULL, NULL, NULL, 'manual', '2026-03-31 18:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (583, 220, 4, '2026-03-31', 'dinner', NULL, '豆腐汤', NULL, NULL, 374.00, 'ml', NULL, 80.00, NULL, NULL, NULL, 'manual', '2026-03-31 18:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (584, 221, 4, '2026-03-31', 'snack', NULL, '酸奶', NULL, NULL, 100.00, 'g', NULL, 124.00, NULL, NULL, NULL, 'manual', '2026-03-31 21:33:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (585, 221, 4, '2026-03-31', 'snack', NULL, '无糖酸奶', NULL, NULL, 150.00, 'g', NULL, 80.00, NULL, NULL, NULL, 'manual', '2026-03-31 20:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:52');
INSERT INTO `diet_record` VALUES (1024, 256, 4, '2026-04-05', 'snack', NULL, '拿铁咖啡', NULL, 'low', NULL, NULL, NULL, 10.00, NULL, NULL, NULL, 'photo', '2026-04-05 02:53:36', '2026-04-05 02:53:35', '2026-04-05 02:53:35');

-- ----------------------------
-- Table structure for food
-- ----------------------------
DROP TABLE IF EXISTS `food`;
CREATE TABLE `food`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `creator_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `category_id` bigint UNSIGNED NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `gi_level` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'low/mid/high',
  `calories_per_100g` decimal(10, 2) NOT NULL,
  `calories_per_unit` decimal(10, 2) NULL DEFAULT NULL,
  `unit_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `standard_weight_g` decimal(10, 2) NULL DEFAULT NULL,
  `edible_portion_rate` decimal(6, 2) NULL DEFAULT NULL COMMENT '可食部率 %',
  `carb_per_100g` decimal(10, 2) NULL DEFAULT NULL,
  `protein_per_100g` decimal(10, 2) NULL DEFAULT NULL,
  `fat_per_100g` decimal(10, 2) NULL DEFAULT NULL,
  `keywords` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_custom` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_food_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_food_creator`(`creator_user_id` ASC) USING BTREE,
  CONSTRAINT `fk_food_category` FOREIGN KEY (`category_id`) REFERENCES `food_category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 993 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of food
-- ----------------------------
INSERT INTO `food` VALUES (1, NULL, 1, '白米饭', NULL, NULL, 263.90, NULL, '100g', 100.00, 100.00, 49.00, 7.50, 2.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (2, NULL, 1, '糙米饭', NULL, NULL, 274.60, NULL, '100g', 100.00, 100.00, 51.00, 7.80, 2.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (3, NULL, 1, '二米饭', NULL, NULL, 296.40, NULL, '100g', 100.00, 100.00, 55.10, 8.50, 3.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (4, NULL, 1, '紫米饭', NULL, NULL, 289.00, NULL, '100g', 100.00, 100.00, 53.70, 8.30, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (5, NULL, 1, '燕麦饭', NULL, NULL, 267.60, NULL, '100g', 100.00, 100.00, 49.70, 7.60, 2.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (6, NULL, 1, '藜麦饭', NULL, NULL, 285.40, NULL, '100g', 100.00, 100.00, 53.00, 8.20, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (7, NULL, 1, '小米饭', NULL, NULL, 253.80, NULL, '100g', 100.00, 100.00, 47.10, 7.30, 2.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (8, NULL, 1, '黑米饭', NULL, NULL, 301.80, NULL, '100g', 100.00, 100.00, 56.10, 8.60, 3.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (9, NULL, 1, '糯米饭', NULL, NULL, 302.00, NULL, '100g', 100.00, 100.00, 56.10, 8.60, 3.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (10, NULL, 1, '蛋炒饭', NULL, NULL, 297.90, NULL, '100g', 100.00, 100.00, 55.30, 8.50, 3.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (11, NULL, 1, '扬州炒饭', NULL, NULL, 294.40, NULL, '100g', 100.00, 100.00, 54.70, 8.40, 3.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (12, NULL, 1, '腊肠煲仔饭', NULL, NULL, 311.20, NULL, '100g', 100.00, 100.00, 57.80, 8.90, 3.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (13, NULL, 1, '卤肉饭', NULL, NULL, 279.90, NULL, '100g', 100.00, 100.00, 52.00, 8.00, 3.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (14, NULL, 1, '鸡排饭', NULL, NULL, 259.00, NULL, '100g', 100.00, 100.00, 48.10, 7.40, 2.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (15, NULL, 1, '肥牛饭', NULL, NULL, 275.70, NULL, '100g', 100.00, 100.00, 51.20, 7.90, 3.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (16, NULL, 1, '鳗鱼饭', NULL, NULL, 269.70, NULL, '100g', 100.00, 100.00, 50.10, 7.70, 2.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (17, NULL, 1, '寿司饭', NULL, NULL, 276.80, NULL, '100g', 100.00, 100.00, 51.40, 7.90, 3.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (18, NULL, 1, '石锅拌饭', NULL, NULL, 282.20, NULL, '100g', 100.00, 100.00, 52.40, 8.10, 3.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (19, NULL, 1, '炒河粉', NULL, NULL, 255.30, NULL, '100g', 100.00, 100.00, 47.40, 7.30, 2.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (20, NULL, 1, '炒米粉', NULL, NULL, 263.30, NULL, '100g', 100.00, 100.00, 48.90, 7.50, 2.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (21, NULL, 1, '炒面', NULL, NULL, 305.90, NULL, '100g', 100.00, 100.00, 56.80, 8.70, 3.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (22, NULL, 1, '葱油拌面', NULL, NULL, 257.80, NULL, '100g', 100.00, 100.00, 47.90, 7.40, 2.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (23, NULL, 1, '炸酱面', NULL, NULL, 278.70, NULL, '100g', 100.00, 100.00, 51.80, 8.00, 3.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (24, NULL, 1, '牛肉面', NULL, NULL, 264.50, NULL, '100g', 100.00, 100.00, 49.10, 7.60, 2.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (25, NULL, 1, '热干面', NULL, NULL, 279.20, NULL, '100g', 100.00, 100.00, 51.80, 8.00, 3.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (26, NULL, 1, '刀削面', NULL, NULL, 293.60, NULL, '100g', 100.00, 100.00, 54.50, 8.40, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (27, NULL, 1, '螺蛳粉', NULL, NULL, 279.90, NULL, '100g', 100.00, 100.00, 52.00, 8.00, 3.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (28, NULL, 1, '酸辣粉', NULL, NULL, 308.90, NULL, '100g', 100.00, 100.00, 57.40, 8.80, 3.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (29, NULL, 1, '米线', NULL, NULL, 289.90, NULL, '100g', 100.00, 100.00, 53.80, 8.30, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (30, NULL, 1, '凉皮', NULL, NULL, 289.70, NULL, '100g', 100.00, 100.00, 53.80, 8.30, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (31, NULL, 1, '全麦吐司', NULL, NULL, 292.00, NULL, '100g', 100.00, 100.00, 54.20, 8.30, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (32, NULL, 1, '手抓饼', NULL, NULL, 312.80, NULL, '100g', 100.00, 100.00, 58.10, 8.90, 3.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (33, NULL, 2, '燕麦片', NULL, NULL, 321.80, NULL, '100g', 100.00, 100.00, 58.50, 8.80, 3.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (34, NULL, 2, '黑麦片', NULL, NULL, 367.10, NULL, '100g', 100.00, 100.00, 66.80, 10.00, 3.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (35, NULL, 2, '荞麦米', NULL, NULL, 320.20, NULL, '100g', 100.00, 100.00, 58.20, 8.70, 3.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (36, NULL, 2, '高粱米', NULL, NULL, 361.00, NULL, '100g', 100.00, 100.00, 65.60, 9.80, 3.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (37, NULL, 2, '薏仁米', NULL, NULL, 294.80, NULL, '100g', 100.00, 100.00, 53.60, 8.00, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (38, NULL, 2, '红米', NULL, NULL, 346.50, NULL, '100g', 100.00, 100.00, 63.00, 9.50, 3.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (39, NULL, 2, '黑米', NULL, NULL, 312.00, NULL, '100g', 100.00, 100.00, 56.70, 8.50, 3.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (40, NULL, 2, '青稞米', NULL, NULL, 314.70, NULL, '100g', 100.00, 100.00, 57.20, 8.60, 3.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (41, NULL, 2, '小麦胚芽', NULL, NULL, 352.00, NULL, '100g', 100.00, 100.00, 64.00, 9.60, 3.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (42, NULL, 2, '藜麦粒', NULL, NULL, 298.90, NULL, '100g', 100.00, 100.00, 54.30, 8.20, 3.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (43, NULL, 2, '糙米', NULL, NULL, 302.90, NULL, '100g', 100.00, 100.00, 55.10, 8.30, 3.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (44, NULL, 2, '胚芽米', NULL, NULL, 290.90, NULL, '100g', 100.00, 100.00, 52.90, 7.90, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (45, NULL, 2, '玉米糁', NULL, NULL, 293.00, NULL, '100g', 100.00, 100.00, 53.30, 8.00, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (46, NULL, 2, '小米', NULL, NULL, 294.20, NULL, '100g', 100.00, 100.00, 53.50, 8.00, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (47, NULL, 2, '大黄米', NULL, NULL, 319.70, NULL, '100g', 100.00, 100.00, 58.10, 8.70, 3.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (48, NULL, 2, '紫糯米', NULL, NULL, 325.30, NULL, '100g', 100.00, 100.00, 59.10, 8.90, 3.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (49, NULL, 2, '血糯米', NULL, NULL, 339.40, NULL, '100g', 100.00, 100.00, 61.70, 9.30, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (50, NULL, 2, '野米', NULL, NULL, 295.40, NULL, '100g', 100.00, 100.00, 53.70, 8.10, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (51, NULL, 2, '大麦仁', NULL, NULL, 290.50, NULL, '100g', 100.00, 100.00, 52.80, 7.90, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (52, NULL, 2, '小麦仁', NULL, NULL, 299.10, NULL, '100g', 100.00, 100.00, 54.40, 8.20, 3.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (53, NULL, 2, '鹰嘴豆', NULL, NULL, 337.10, NULL, '100g', 100.00, 100.00, 61.30, 9.20, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (54, NULL, 2, '红小豆', NULL, NULL, 326.50, NULL, '100g', 100.00, 100.00, 59.40, 8.90, 3.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (55, NULL, 2, '绿豆', NULL, NULL, 301.70, NULL, '100g', 100.00, 100.00, 54.90, 8.20, 3.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (56, NULL, 2, '黑豆', NULL, NULL, 355.50, NULL, '100g', 100.00, 100.00, 64.60, 9.70, 3.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (57, NULL, 2, '花芸豆', NULL, NULL, 345.60, NULL, '100g', 100.00, 100.00, 62.80, 9.40, 3.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (58, NULL, 2, '白芸豆', NULL, NULL, 332.90, NULL, '100g', 100.00, 100.00, 60.50, 9.10, 3.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (59, NULL, 2, '扁豆', NULL, NULL, 348.40, NULL, '100g', 100.00, 100.00, 63.30, 9.50, 3.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (60, NULL, 2, '蚕豆', NULL, NULL, 330.10, NULL, '100g', 100.00, 100.00, 60.00, 9.00, 3.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (61, NULL, 2, '豌豆', NULL, NULL, 338.80, NULL, '100g', 100.00, 100.00, 61.60, 9.20, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (62, NULL, 2, '豇豆', NULL, NULL, 332.30, NULL, '100g', 100.00, 100.00, 60.40, 9.10, 3.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (63, NULL, 2, '芡实粒', NULL, NULL, 292.60, NULL, '100g', 100.00, 100.00, 53.20, 8.00, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (64, NULL, 2, '莲子米', NULL, NULL, 321.50, NULL, '100g', 100.00, 100.00, 58.50, 8.80, 3.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (65, NULL, 3, '猪里脊', NULL, NULL, 191.80, NULL, '100g', 100.00, 100.00, 1.00, 21.10, 11.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (66, NULL, 3, '猪五花肉', NULL, NULL, 189.50, NULL, '100g', 100.00, 100.00, 0.90, 20.80, 11.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (67, NULL, 3, '猪梅花肉', NULL, NULL, 218.40, NULL, '100g', 100.00, 100.00, 1.10, 24.00, 13.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (68, NULL, 3, '猪排骨', NULL, NULL, 213.60, NULL, '100g', 100.00, 100.00, 1.10, 23.50, 12.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (69, NULL, 3, '猪蹄', NULL, NULL, 177.10, NULL, '100g', 100.00, 100.00, 0.90, 19.50, 10.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (70, NULL, 3, '猪肝', NULL, NULL, 193.20, NULL, '100g', 100.00, 100.00, 1.00, 21.20, 11.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (71, NULL, 3, '猪心', NULL, NULL, 179.50, NULL, '100g', 100.00, 100.00, 0.90, 19.70, 10.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (72, NULL, 3, '猪肚', NULL, NULL, 191.60, NULL, '100g', 100.00, 100.00, 1.00, 21.10, 11.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (73, NULL, 3, '猪腰', NULL, NULL, 182.50, NULL, '100g', 100.00, 100.00, 0.90, 20.10, 11.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (74, NULL, 3, '肥肠', NULL, NULL, 211.80, NULL, '100g', 100.00, 100.00, 1.10, 23.30, 12.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (75, NULL, 3, '牛腩', NULL, NULL, 184.70, NULL, '100g', 100.00, 100.00, 0.90, 20.30, 11.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (76, NULL, 3, '牛腱', NULL, NULL, 185.50, NULL, '100g', 100.00, 100.00, 0.90, 20.40, 11.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (77, NULL, 3, '牛排', NULL, NULL, 183.40, NULL, '100g', 100.00, 100.00, 0.90, 20.20, 11.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (78, NULL, 3, '肥牛卷', NULL, NULL, 223.50, NULL, '100g', 100.00, 100.00, 1.10, 24.60, 13.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (79, NULL, 3, '牛舌', NULL, NULL, 221.30, NULL, '100g', 100.00, 100.00, 1.10, 24.30, 13.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (80, NULL, 3, '牛百叶', NULL, NULL, 183.50, NULL, '100g', 100.00, 100.00, 0.90, 20.20, 11.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (81, NULL, 3, '羊排', NULL, NULL, 181.70, NULL, '100g', 100.00, 100.00, 0.90, 20.00, 10.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (82, NULL, 3, '羊腿肉', NULL, NULL, 222.70, NULL, '100g', 100.00, 100.00, 1.10, 24.50, 13.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (83, NULL, 3, '羊蝎子', NULL, NULL, 194.10, NULL, '100g', 100.00, 100.00, 1.00, 21.30, 11.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (84, NULL, 3, '羊肉串肉', NULL, NULL, 199.30, NULL, '100g', 100.00, 100.00, 1.00, 21.90, 12.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (85, NULL, 3, '培根', NULL, NULL, 195.10, NULL, '100g', 100.00, 100.00, 1.00, 21.50, 11.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (86, NULL, 3, '火腿片', NULL, NULL, 214.60, NULL, '100g', 100.00, 100.00, 1.10, 23.60, 12.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (87, NULL, 3, '腊肠', NULL, NULL, 215.00, NULL, '100g', 100.00, 100.00, 1.10, 23.60, 12.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (88, NULL, 3, '腊肉', NULL, NULL, 205.20, NULL, '100g', 100.00, 100.00, 1.00, 22.60, 12.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (89, NULL, 3, '酱肘子', NULL, NULL, 187.40, NULL, '100g', 100.00, 100.00, 0.90, 20.60, 11.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (90, NULL, 3, '蒜泥白肉', NULL, NULL, 197.10, NULL, '100g', 100.00, 100.00, 1.00, 21.70, 11.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (91, NULL, 3, '回锅肉', NULL, NULL, 200.90, NULL, '100g', 100.00, 100.00, 1.00, 22.10, 12.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (92, NULL, 3, '东坡肉', NULL, NULL, 222.90, NULL, '100g', 100.00, 100.00, 1.10, 24.50, 13.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (93, NULL, 3, '糖醋里脊', NULL, NULL, 207.10, NULL, '100g', 100.00, 100.00, 1.00, 22.80, 12.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (94, NULL, 3, '小炒肉', NULL, NULL, 215.10, NULL, '100g', 100.00, 100.00, 1.10, 23.70, 12.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (95, NULL, 3, '酱牛肉', NULL, NULL, 221.70, NULL, '100g', 100.00, 100.00, 1.10, 24.40, 13.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (96, NULL, 3, '卤牛肉', NULL, NULL, 188.00, NULL, '100g', 100.00, 100.00, 0.90, 20.70, 11.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (97, NULL, 4, '鸡胸肉', NULL, NULL, 172.00, NULL, '100g', 100.00, 100.00, 2.00, 23.60, 7.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (98, NULL, 4, '鸡腿肉', NULL, NULL, 192.30, NULL, '100g', 100.00, 100.00, 2.20, 26.40, 8.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (99, NULL, 4, '鸡翅中', NULL, NULL, 173.30, NULL, '100g', 100.00, 100.00, 2.00, 23.80, 7.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (100, NULL, 4, '鸡翅根', NULL, NULL, 189.70, NULL, '100g', 100.00, 100.00, 2.20, 26.00, 8.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (101, NULL, 4, '鸡爪', NULL, NULL, 167.30, NULL, '100g', 100.00, 100.00, 1.90, 22.90, 7.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (102, NULL, 4, '鸡胗', NULL, NULL, 193.90, NULL, '100g', 100.00, 100.00, 2.20, 26.60, 8.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (103, NULL, 4, '鸡心', NULL, NULL, 167.90, NULL, '100g', 100.00, 100.00, 1.90, 23.00, 7.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (104, NULL, 4, '整鸡', NULL, NULL, 177.40, NULL, '100g', 100.00, 100.00, 2.00, 24.30, 8.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (105, NULL, 4, '乌鸡', NULL, NULL, 184.00, NULL, '100g', 100.00, 100.00, 2.10, 25.20, 8.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (106, NULL, 4, '鸭胸', NULL, NULL, 190.90, NULL, '100g', 100.00, 100.00, 2.20, 26.20, 8.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (107, NULL, 4, '鸭腿', NULL, NULL, 191.30, NULL, '100g', 100.00, 100.00, 2.20, 26.20, 8.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (108, NULL, 4, '鸭翅', NULL, NULL, 186.30, NULL, '100g', 100.00, 100.00, 2.10, 25.50, 8.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (109, NULL, 4, '鸭掌', NULL, NULL, 169.00, NULL, '100g', 100.00, 100.00, 1.90, 23.20, 7.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (110, NULL, 4, '老鸭', NULL, NULL, 157.70, NULL, '100g', 100.00, 100.00, 1.80, 21.60, 7.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (111, NULL, 4, '鹅胸', NULL, NULL, 181.70, NULL, '100g', 100.00, 100.00, 2.10, 24.90, 8.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (112, NULL, 4, '鹅腿', NULL, NULL, 194.90, NULL, '100g', 100.00, 100.00, 2.20, 26.70, 8.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (113, NULL, 4, '鸽子肉', NULL, NULL, 188.70, NULL, '100g', 100.00, 100.00, 2.20, 25.90, 8.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (114, NULL, 4, '鹌鹑', NULL, NULL, 193.50, NULL, '100g', 100.00, 100.00, 2.20, 26.50, 8.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (115, NULL, 4, '火鸡胸', NULL, NULL, 184.80, NULL, '100g', 100.00, 100.00, 2.10, 25.30, 8.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (116, NULL, 4, '口水鸡', NULL, NULL, 186.00, NULL, '100g', 100.00, 100.00, 2.10, 25.50, 8.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (117, NULL, 4, '白切鸡', NULL, NULL, 192.90, NULL, '100g', 100.00, 100.00, 2.20, 26.50, 8.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (118, NULL, 4, '盐焗鸡', NULL, NULL, 186.90, NULL, '100g', 100.00, 100.00, 2.10, 25.60, 8.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (119, NULL, 4, '辣子鸡丁', NULL, NULL, 183.00, NULL, '100g', 100.00, 100.00, 2.10, 25.10, 8.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (120, NULL, 4, '宫保鸡丁', NULL, NULL, 189.90, NULL, '100g', 100.00, 100.00, 2.20, 26.00, 8.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (121, NULL, 4, '黄焖鸡', NULL, NULL, 162.00, NULL, '100g', 100.00, 100.00, 1.90, 22.20, 7.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (122, NULL, 4, '可乐鸡翅', NULL, NULL, 166.70, NULL, '100g', 100.00, 100.00, 1.90, 22.90, 7.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (123, NULL, 4, '照烧鸡腿', NULL, NULL, 178.50, NULL, '100g', 100.00, 100.00, 2.00, 24.50, 8.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (124, NULL, 4, '香酥鸭', NULL, NULL, 168.60, NULL, '100g', 100.00, 100.00, 1.90, 23.10, 7.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (125, NULL, 4, '啤酒鸭', NULL, NULL, 194.60, NULL, '100g', 100.00, 100.00, 2.20, 26.70, 8.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (126, NULL, 4, '姜母鸭', NULL, NULL, 192.00, NULL, '100g', 100.00, 100.00, 2.20, 26.30, 8.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (127, NULL, 4, '烧鹅', NULL, NULL, 177.50, NULL, '100g', 100.00, 100.00, 2.00, 24.30, 8.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (128, NULL, 4, '卤鸭脖', NULL, NULL, 170.20, NULL, '100g', 100.00, 100.00, 1.90, 23.30, 7.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (129, NULL, 5, '午餐肉', NULL, NULL, 262.70, NULL, '100g', 100.00, 100.00, 8.10, 14.10, 20.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (130, NULL, 5, '火腿肠', NULL, NULL, 259.50, NULL, '100g', 100.00, 100.00, 8.00, 14.00, 20.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (131, NULL, 5, '脆皮肠', NULL, NULL, 266.80, NULL, '100g', 100.00, 100.00, 8.20, 14.40, 20.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (132, NULL, 5, '台湾烤肠', NULL, NULL, 280.60, NULL, '100g', 100.00, 100.00, 8.60, 15.10, 21.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (133, NULL, 5, '广味腊肠', NULL, NULL, 257.20, NULL, '100g', 100.00, 100.00, 7.90, 13.90, 19.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (134, NULL, 5, '香肠', NULL, NULL, 283.30, NULL, '100g', 100.00, 100.00, 8.70, 15.30, 21.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (135, NULL, 5, '血肠', NULL, NULL, 254.50, NULL, '100g', 100.00, 100.00, 7.80, 13.70, 19.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (136, NULL, 5, '红肠', NULL, NULL, 258.20, NULL, '100g', 100.00, 100.00, 7.90, 13.90, 19.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (137, NULL, 5, '哈尔滨红肠', NULL, NULL, 275.60, NULL, '100g', 100.00, 100.00, 8.50, 14.80, 21.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (138, NULL, 5, '培根碎', NULL, NULL, 242.10, NULL, '100g', 100.00, 100.00, 7.50, 13.00, 18.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (139, NULL, 5, '火腿丁', NULL, NULL, 262.30, NULL, '100g', 100.00, 100.00, 8.10, 14.10, 20.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (140, NULL, 5, '肉松', NULL, NULL, 267.70, NULL, '100g', 100.00, 100.00, 8.20, 14.40, 20.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (141, NULL, 5, '肉脯', NULL, NULL, 260.40, NULL, '100g', 100.00, 100.00, 8.00, 14.00, 20.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (142, NULL, 5, '牛肉干', NULL, NULL, 244.50, NULL, '100g', 100.00, 100.00, 7.50, 13.20, 18.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (143, NULL, 5, '猪肉脯', NULL, NULL, 271.90, NULL, '100g', 100.00, 100.00, 8.40, 14.60, 20.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (144, NULL, 5, '鸡肉肠', NULL, NULL, 231.70, NULL, '100g', 100.00, 100.00, 7.10, 12.50, 17.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (145, NULL, 5, '鱼肠', NULL, NULL, 272.80, NULL, '100g', 100.00, 100.00, 8.40, 14.70, 21.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (146, NULL, 5, '蟹棒', NULL, NULL, 230.80, NULL, '100g', 100.00, 100.00, 7.10, 12.40, 17.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (147, NULL, 5, '仿蟹柳', NULL, NULL, 263.80, NULL, '100g', 100.00, 100.00, 8.10, 14.20, 20.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (148, NULL, 5, '鱼豆腐串料', NULL, NULL, 239.20, NULL, '100g', 100.00, 100.00, 7.40, 12.90, 18.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (149, NULL, 5, '贡丸', NULL, NULL, 245.00, NULL, '100g', 100.00, 100.00, 7.50, 13.20, 18.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (150, NULL, 5, '冷鲜撒尿丸', NULL, NULL, 265.30, NULL, '100g', 100.00, 100.00, 8.20, 14.30, 20.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (151, NULL, 5, '关东煮包心丸', NULL, NULL, 267.30, NULL, '100g', 100.00, 100.00, 8.20, 14.40, 20.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (152, NULL, 5, '虾滑丸', NULL, NULL, 285.90, NULL, '100g', 100.00, 100.00, 8.80, 15.40, 22.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (153, NULL, 5, '甜不辣', NULL, NULL, 287.80, NULL, '100g', 100.00, 100.00, 8.90, 15.50, 22.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (154, NULL, 5, '燕饺', NULL, NULL, 230.90, NULL, '100g', 100.00, 100.00, 7.10, 12.40, 17.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (155, NULL, 5, '速冻蛋饺', NULL, NULL, 240.70, NULL, '100g', 100.00, 100.00, 7.40, 13.00, 18.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (156, NULL, 5, '午餐肉罐头', NULL, NULL, 233.00, NULL, '100g', 100.00, 100.00, 7.20, 12.50, 17.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (157, NULL, 5, '咸肉', NULL, NULL, 271.10, NULL, '100g', 100.00, 100.00, 8.30, 14.60, 20.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (158, NULL, 5, '风肉', NULL, NULL, 262.40, NULL, '100g', 100.00, 100.00, 8.10, 14.10, 20.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (159, NULL, 5, '酱排骨罐头', NULL, NULL, 290.70, NULL, '100g', 100.00, 100.00, 8.90, 15.70, 22.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (160, NULL, 5, '卤汁牛肉罐头', NULL, NULL, 284.40, NULL, '100g', 100.00, 100.00, 8.80, 15.30, 21.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (161, NULL, 6, '鸡蛋', NULL, NULL, 137.50, NULL, '100g', 100.00, 100.00, 1.80, 11.90, 9.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (162, NULL, 6, '鸭蛋', NULL, NULL, 133.30, NULL, '100g', 100.00, 100.00, 1.80, 11.60, 8.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (163, NULL, 6, '鹌鹑蛋', NULL, NULL, 163.50, NULL, '100g', 100.00, 100.00, 2.20, 14.20, 10.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (164, NULL, 6, '皮蛋', NULL, NULL, 159.10, NULL, '100g', 100.00, 100.00, 2.10, 13.80, 10.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (165, NULL, 6, '咸鸭蛋', NULL, NULL, 165.90, NULL, '100g', 100.00, 100.00, 2.20, 14.40, 11.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (166, NULL, 6, '鸽子蛋', NULL, NULL, 148.50, NULL, '100g', 100.00, 100.00, 2.00, 12.90, 9.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (167, NULL, 6, '鹅蛋', NULL, NULL, 162.10, NULL, '100g', 100.00, 100.00, 2.20, 14.10, 10.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (168, NULL, 6, '荷包蛋', NULL, NULL, 165.60, NULL, '100g', 100.00, 100.00, 2.20, 14.40, 11.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (169, NULL, 6, '水煮蛋', NULL, NULL, 139.60, NULL, '100g', 100.00, 100.00, 1.90, 12.10, 9.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (170, NULL, 6, '茶叶蛋', NULL, NULL, 147.80, NULL, '100g', 100.00, 100.00, 2.00, 12.80, 9.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (171, NULL, 6, '溏心蛋', NULL, NULL, 157.20, NULL, '100g', 100.00, 100.00, 2.10, 13.60, 10.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (172, NULL, 6, '蒸蛋羹', NULL, NULL, 133.10, NULL, '100g', 100.00, 100.00, 1.80, 11.50, 8.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (173, NULL, 6, '番茄炒蛋', NULL, NULL, 152.00, NULL, '100g', 100.00, 100.00, 2.00, 13.20, 10.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (174, NULL, 6, '韭菜炒蛋', NULL, NULL, 136.80, NULL, '100g', 100.00, 100.00, 1.80, 11.90, 9.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (175, NULL, 6, '苦瓜炒蛋', NULL, NULL, 159.10, NULL, '100g', 100.00, 100.00, 2.10, 13.80, 10.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (176, NULL, 6, '洋葱炒蛋', NULL, NULL, 166.20, NULL, '100g', 100.00, 100.00, 2.20, 14.40, 11.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (177, NULL, 6, '虾仁滑蛋', NULL, NULL, 163.30, NULL, '100g', 100.00, 100.00, 2.20, 14.20, 10.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (178, NULL, 6, '蛋花汤', NULL, NULL, 137.00, NULL, '100g', 100.00, 100.00, 1.80, 11.90, 9.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (179, NULL, 6, '厚蛋烧', NULL, NULL, 149.50, NULL, '100g', 100.00, 100.00, 2.00, 13.00, 10.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (180, NULL, 6, '玉子烧', NULL, NULL, 164.50, NULL, '100g', 100.00, 100.00, 2.20, 14.30, 11.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (181, NULL, 6, '苏格兰蛋', NULL, NULL, 158.60, NULL, '100g', 100.00, 100.00, 2.10, 13.70, 10.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (182, NULL, 6, '虎皮蛋', NULL, NULL, 157.60, NULL, '100g', 100.00, 100.00, 2.10, 13.70, 10.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (183, NULL, 6, '卤蛋', NULL, NULL, 162.10, NULL, '100g', 100.00, 100.00, 2.20, 14.10, 10.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (184, NULL, 6, '铁蛋', NULL, NULL, 146.30, NULL, '100g', 100.00, 100.00, 2.00, 12.70, 9.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (185, NULL, 6, '变蛋', NULL, NULL, 164.70, NULL, '100g', 100.00, 100.00, 2.20, 14.30, 11.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (186, NULL, 6, '毛蛋', NULL, NULL, 136.50, NULL, '100g', 100.00, 100.00, 1.80, 11.80, 9.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (187, NULL, 6, '蛋饺', NULL, NULL, 152.30, NULL, '100g', 100.00, 100.00, 2.00, 13.20, 10.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (188, NULL, 6, '蛋卷', NULL, NULL, 143.30, NULL, '100g', 100.00, 100.00, 1.90, 12.40, 9.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (189, NULL, 6, '鸡蛋布丁', NULL, NULL, 154.20, NULL, '100g', 100.00, 100.00, 2.10, 13.40, 10.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (190, NULL, 6, '蛋奶炖', NULL, NULL, 150.00, NULL, '100g', 100.00, 100.00, 2.00, 13.00, 10.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (191, NULL, 6, '蛋包饭', NULL, NULL, 164.20, NULL, '100g', 100.00, 100.00, 2.20, 14.20, 10.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (192, NULL, 6, '蛋挞芯', NULL, NULL, 153.60, NULL, '100g', 100.00, 100.00, 2.00, 13.30, 10.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (193, NULL, 7, '全脂牛奶', NULL, NULL, 65.90, NULL, '100g', 100.00, 100.00, 5.10, 3.60, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (194, NULL, 7, '脱脂牛奶', NULL, NULL, 58.50, NULL, '100g', 100.00, 100.00, 4.50, 3.20, 3.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (195, NULL, 7, '低脂牛奶', NULL, NULL, 70.60, NULL, '100g', 100.00, 100.00, 5.40, 3.80, 3.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (196, NULL, 7, '鲜牛奶', NULL, NULL, 69.80, NULL, '100g', 100.00, 100.00, 5.40, 3.80, 3.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (197, NULL, 7, '水牛奶', NULL, NULL, 57.70, NULL, '100ml', NULL, 100.00, 4.40, 3.10, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (198, NULL, 7, '羊奶', NULL, NULL, 61.00, NULL, '100g', 100.00, 100.00, 4.70, 3.30, 3.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (199, NULL, 7, '酸奶', NULL, NULL, 61.50, NULL, '100ml', NULL, 100.00, 4.70, 3.30, 3.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (200, NULL, 7, '希腊酸奶', NULL, NULL, 71.90, NULL, '100ml', NULL, 100.00, 5.50, 3.90, 3.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (201, NULL, 7, '老酸奶', NULL, NULL, 68.20, NULL, '100ml', NULL, 100.00, 5.20, 3.70, 3.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (202, NULL, 7, '风味酸奶', NULL, NULL, 61.50, NULL, '100g', 100.00, 100.00, 4.70, 3.30, 3.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (203, NULL, 7, '奶酪片', NULL, NULL, 57.90, NULL, '100ml', NULL, 100.00, 4.50, 3.10, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (204, NULL, 7, '马苏里拉', NULL, NULL, 63.70, NULL, '100g', 100.00, 100.00, 4.90, 3.40, 3.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (205, NULL, 7, '切达奶酪', NULL, NULL, 66.40, NULL, '100g', 100.00, 100.00, 5.10, 3.60, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (206, NULL, 7, '奶油奶酪', NULL, NULL, 65.60, NULL, '100g', 100.00, 100.00, 5.00, 3.50, 3.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (207, NULL, 7, '炼乳', NULL, NULL, 65.30, NULL, '100ml', NULL, 100.00, 5.00, 3.50, 3.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (208, NULL, 7, '淡奶油', NULL, NULL, 63.30, NULL, '100ml', NULL, 100.00, 4.90, 3.40, 3.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (209, NULL, 7, '黄油', NULL, NULL, 71.40, NULL, '100g', 100.00, 100.00, 5.50, 3.80, 3.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (210, NULL, 7, '奶豆腐', NULL, NULL, 63.40, NULL, '100ml', NULL, 100.00, 4.90, 3.40, 3.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (211, NULL, 7, '双皮奶', NULL, NULL, 68.60, NULL, '100g', 100.00, 100.00, 5.30, 3.70, 3.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (212, NULL, 7, '姜撞奶', NULL, NULL, 70.50, NULL, '100ml', NULL, 100.00, 5.40, 3.80, 3.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (213, NULL, 7, '奶茶', NULL, NULL, 65.40, NULL, '100g', 100.00, 100.00, 5.00, 3.50, 3.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (214, NULL, 7, '奶昔', NULL, NULL, 67.70, NULL, '100g', 100.00, 100.00, 5.20, 3.60, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (215, NULL, 7, '芝士奶盖', NULL, NULL, 72.10, NULL, '100g', 100.00, 100.00, 5.50, 3.90, 3.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (216, NULL, 7, '牛奶布丁', NULL, NULL, 60.40, NULL, '100ml', NULL, 100.00, 4.60, 3.30, 3.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (217, NULL, 7, '奶粉冲饮', NULL, NULL, 62.40, NULL, '100g', 100.00, 100.00, 4.80, 3.40, 3.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (218, NULL, 7, '冰博克', NULL, NULL, 63.00, NULL, '100g', 100.00, 100.00, 4.80, 3.40, 3.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (219, NULL, 7, '酪乳', NULL, NULL, 57.40, NULL, '100ml', NULL, 100.00, 4.40, 3.10, 3.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (220, NULL, 7, '开菲尔', NULL, NULL, 68.60, NULL, '100ml', NULL, 100.00, 5.30, 3.70, 3.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (221, NULL, 7, '酸奶疙瘩', NULL, NULL, 61.30, NULL, '100ml', NULL, 100.00, 4.70, 3.30, 3.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (222, NULL, 7, '乳扇', NULL, NULL, 69.80, NULL, '100ml', NULL, 100.00, 5.40, 3.80, 3.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (223, NULL, 7, '奶皮子', NULL, NULL, 65.30, NULL, '100ml', NULL, 100.00, 5.00, 3.50, 3.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (224, NULL, 7, '奶嚼口', NULL, NULL, 61.00, NULL, '100ml', NULL, 100.00, 4.70, 3.30, 3.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (225, NULL, 8, '苹果', NULL, NULL, 58.40, NULL, '100g', 100.00, 100.00, 13.80, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (226, NULL, 8, '青苹果', NULL, NULL, 60.40, NULL, '100g', 100.00, 100.00, 14.30, 0.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (227, NULL, 8, '香蕉', NULL, NULL, 57.80, NULL, '100g', 100.00, 100.00, 13.70, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (228, NULL, 8, '芭蕉', NULL, NULL, 60.60, NULL, '100g', 100.00, 100.00, 14.30, 0.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (229, NULL, 8, '橙子', NULL, NULL, 51.50, NULL, '100g', 100.00, 100.00, 12.20, 0.70, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (230, NULL, 8, '血橙', NULL, NULL, 57.10, NULL, '100g', 100.00, 100.00, 13.50, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (231, NULL, 8, '柚子', NULL, NULL, 59.60, NULL, '100g', 100.00, 100.00, 14.10, 0.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (232, NULL, 8, '葡萄柚', NULL, NULL, 58.60, NULL, '100g', 100.00, 100.00, 13.90, 0.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (233, NULL, 8, '柠檬', NULL, NULL, 55.70, NULL, '100g', 100.00, 100.00, 13.20, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (234, NULL, 8, '青柠', NULL, NULL, 48.70, NULL, '100g', 100.00, 100.00, 11.50, 0.70, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (235, NULL, 8, '西瓜', NULL, NULL, 48.80, NULL, '100g', 100.00, 100.00, 11.50, 0.70, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (236, NULL, 8, '哈密瓜', NULL, NULL, 60.00, NULL, '100g', 100.00, 100.00, 14.20, 0.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (237, NULL, 8, '甜瓜', NULL, NULL, 56.90, NULL, '100g', 100.00, 100.00, 13.50, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (238, NULL, 8, '香瓜', NULL, NULL, 52.00, NULL, '100g', 100.00, 100.00, 12.30, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (239, NULL, 8, '草莓', NULL, NULL, 51.50, NULL, '100g', 100.00, 100.00, 12.20, 0.70, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (240, NULL, 8, '蓝莓', NULL, NULL, 52.90, NULL, '100g', 100.00, 100.00, 12.50, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (241, NULL, 8, '黑莓', NULL, NULL, 61.20, NULL, '100g', 100.00, 100.00, 14.50, 0.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (242, NULL, 8, '树莓', NULL, NULL, 60.40, NULL, '100g', 100.00, 100.00, 14.30, 0.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (243, NULL, 8, '樱桃', NULL, NULL, 49.40, NULL, '100g', 100.00, 100.00, 11.70, 0.70, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (244, NULL, 8, '车厘子', NULL, NULL, 56.00, NULL, '100g', 100.00, 100.00, 13.20, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (245, NULL, 8, '葡萄', NULL, NULL, 51.40, NULL, '100g', 100.00, 100.00, 12.20, 0.70, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (246, NULL, 8, '提子', NULL, NULL, 53.70, NULL, '100g', 100.00, 100.00, 12.70, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (247, NULL, 8, '猕猴桃', NULL, NULL, 54.60, NULL, '100g', 100.00, 100.00, 12.90, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (248, NULL, 8, '火龙果', NULL, NULL, 50.30, NULL, '100g', 100.00, 100.00, 11.90, 0.70, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (249, NULL, 8, '芒果', NULL, NULL, 52.80, NULL, '100g', 100.00, 100.00, 12.50, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (250, NULL, 8, '木瓜', NULL, NULL, 59.00, NULL, '100g', 100.00, 100.00, 13.90, 0.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (251, NULL, 8, '菠萝', NULL, NULL, 58.60, NULL, '100g', 100.00, 100.00, 13.90, 0.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (252, NULL, 8, '凤梨', NULL, NULL, 59.80, NULL, '100g', 100.00, 100.00, 14.10, 0.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (253, NULL, 8, '榴莲', NULL, NULL, 60.20, NULL, '100g', 100.00, 100.00, 14.20, 0.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (254, NULL, 8, '山竹', NULL, NULL, 50.80, NULL, '100g', 100.00, 100.00, 12.00, 0.70, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (255, NULL, 8, '荔枝', NULL, NULL, 57.60, NULL, '100g', 100.00, 100.00, 13.60, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (256, NULL, 8, '龙眼', NULL, NULL, 55.30, NULL, '100g', 100.00, 100.00, 13.10, 0.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (257, NULL, 9, '生菜', NULL, NULL, 24.10, NULL, '100g', 100.00, 100.00, 4.40, 2.20, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (258, NULL, 9, '菠菜', NULL, NULL, 20.50, NULL, '100g', 100.00, 100.00, 3.70, 1.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (259, NULL, 9, '油菜', NULL, NULL, 23.10, NULL, '100g', 100.00, 100.00, 4.20, 2.10, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (260, NULL, 9, '小白菜', NULL, NULL, 20.40, NULL, '100g', 100.00, 100.00, 3.70, 1.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (261, NULL, 9, '大白菜', NULL, NULL, 19.40, NULL, '100g', 100.00, 100.00, 3.50, 1.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (262, NULL, 9, '娃娃菜', NULL, NULL, 20.70, NULL, '100g', 100.00, 100.00, 3.80, 1.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (263, NULL, 9, '芹菜', NULL, NULL, 20.00, NULL, '100g', 100.00, 100.00, 3.60, 1.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (264, NULL, 9, '西芹', NULL, NULL, 21.30, NULL, '100g', 100.00, 100.00, 3.90, 1.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (265, NULL, 9, '韭菜', NULL, NULL, 22.60, NULL, '100g', 100.00, 100.00, 4.10, 2.10, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (266, NULL, 9, '芥蓝', NULL, NULL, 21.20, NULL, '100g', 100.00, 100.00, 3.90, 1.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (267, NULL, 9, '菜心', NULL, NULL, 22.50, NULL, '100g', 100.00, 100.00, 4.10, 2.00, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (268, NULL, 9, '空心菜', NULL, NULL, 22.80, NULL, '100g', 100.00, 100.00, 4.10, 2.10, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (269, NULL, 9, '木耳菜', NULL, NULL, 23.30, NULL, '100g', 100.00, 100.00, 4.20, 2.10, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (270, NULL, 9, '番薯叶', NULL, NULL, 20.10, NULL, '100g', 100.00, 100.00, 3.70, 1.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (271, NULL, 9, '油麦菜', NULL, NULL, 23.90, NULL, '100g', 100.00, 100.00, 4.30, 2.20, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (272, NULL, 9, '茼蒿', NULL, NULL, 19.90, NULL, '100g', 100.00, 100.00, 3.60, 1.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (273, NULL, 9, '香菜', NULL, NULL, 21.20, NULL, '100g', 100.00, 100.00, 3.90, 1.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (274, NULL, 9, '茴香苗', NULL, NULL, 20.30, NULL, '100g', 100.00, 100.00, 3.70, 1.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (275, NULL, 9, '豌豆苗', NULL, NULL, 19.60, NULL, '100g', 100.00, 100.00, 3.60, 1.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (276, NULL, 9, '萝卜缨', NULL, NULL, 20.40, NULL, '100g', 100.00, 100.00, 3.70, 1.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (277, NULL, 9, '苦菊', NULL, NULL, 19.70, NULL, '100g', 100.00, 100.00, 3.60, 1.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (278, NULL, 9, '芝麻菜', NULL, NULL, 22.00, NULL, '100g', 100.00, 100.00, 4.00, 2.00, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (279, NULL, 9, '羽衣甘蓝', NULL, NULL, 24.00, NULL, '100g', 100.00, 100.00, 4.40, 2.20, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (280, NULL, 9, '球茎甘蓝', NULL, NULL, 19.50, NULL, '100g', 100.00, 100.00, 3.60, 1.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (281, NULL, 9, '花椰菜', NULL, NULL, 21.90, NULL, '100g', 100.00, 100.00, 4.00, 2.00, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (282, NULL, 9, '西兰花', NULL, NULL, 20.70, NULL, '100g', 100.00, 100.00, 3.80, 1.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (283, NULL, 9, '黄花菜', NULL, NULL, 20.70, NULL, '100g', 100.00, 100.00, 3.80, 1.90, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (284, NULL, 9, '槐花', NULL, NULL, 21.70, NULL, '100g', 100.00, 100.00, 4.00, 2.00, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (285, NULL, 9, '南瓜花', NULL, NULL, 22.40, NULL, '100g', 100.00, 100.00, 4.10, 2.00, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (286, NULL, 9, '朝鲜蓟', NULL, NULL, 22.70, NULL, '100g', 100.00, 100.00, 4.10, 2.10, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (287, NULL, 9, '西洋菜', NULL, NULL, 19.70, NULL, '100g', 100.00, 100.00, 3.60, 1.80, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (288, NULL, 9, '荠菜', NULL, NULL, 24.40, NULL, '100g', 100.00, 100.00, 4.40, 2.20, 0.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (289, NULL, 10, '番茄', NULL, NULL, 38.80, NULL, '100g', 100.00, 100.00, 7.80, 1.70, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (290, NULL, 10, '黄瓜', NULL, NULL, 31.50, NULL, '100g', 100.00, 100.00, 6.30, 1.30, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (291, NULL, 10, '茄子', NULL, NULL, 38.20, NULL, '100g', 100.00, 100.00, 7.60, 1.60, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (292, NULL, 10, '青椒', NULL, NULL, 37.10, NULL, '100g', 100.00, 100.00, 7.40, 1.60, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (293, NULL, 10, '尖椒', NULL, NULL, 33.70, NULL, '100g', 100.00, 100.00, 6.70, 1.40, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (294, NULL, 10, '彩椒', NULL, NULL, 37.10, NULL, '100g', 100.00, 100.00, 7.40, 1.60, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (295, NULL, 10, '土豆', NULL, NULL, 36.70, NULL, '100g', 100.00, 100.00, 7.30, 1.60, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (296, NULL, 10, '红薯', NULL, NULL, 38.80, NULL, '100g', 100.00, 100.00, 7.80, 1.70, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (297, NULL, 10, '紫薯', NULL, NULL, 31.00, NULL, '100g', 100.00, 100.00, 6.20, 1.30, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (298, NULL, 10, '山药', NULL, NULL, 33.30, NULL, '100g', 100.00, 100.00, 6.70, 1.40, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (299, NULL, 10, '莲藕', NULL, NULL, 31.90, NULL, '100g', 100.00, 100.00, 6.40, 1.40, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (300, NULL, 10, '芋头', NULL, NULL, 34.30, NULL, '100g', 100.00, 100.00, 6.90, 1.50, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (301, NULL, 10, '魔芋', NULL, NULL, 31.60, NULL, '100g', 100.00, 100.00, 6.30, 1.40, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (302, NULL, 10, '白萝卜', NULL, NULL, 32.00, NULL, '100g', 100.00, 100.00, 6.40, 1.40, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (303, NULL, 10, '胡萝卜', NULL, NULL, 38.30, NULL, '100g', 100.00, 100.00, 7.70, 1.60, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (304, NULL, 10, '青萝卜', NULL, NULL, 32.80, NULL, '100g', 100.00, 100.00, 6.60, 1.40, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (305, NULL, 10, '樱桃萝卜', NULL, NULL, 35.50, NULL, '100g', 100.00, 100.00, 7.10, 1.50, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (306, NULL, 10, '洋葱', NULL, NULL, 35.10, NULL, '100g', 100.00, 100.00, 7.00, 1.50, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (307, NULL, 10, '大葱', NULL, NULL, 35.80, NULL, '100g', 100.00, 100.00, 7.20, 1.50, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (308, NULL, 10, '大蒜', NULL, NULL, 38.20, NULL, '100g', 100.00, 100.00, 7.60, 1.60, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (309, NULL, 10, '生姜', NULL, NULL, 34.70, NULL, '100g', 100.00, 100.00, 6.90, 1.50, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (310, NULL, 10, '芦笋', NULL, NULL, 38.10, NULL, '100g', 100.00, 100.00, 7.60, 1.60, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (311, NULL, 10, '莴笋', NULL, NULL, 35.30, NULL, '100g', 100.00, 100.00, 7.10, 1.50, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (312, NULL, 10, '竹笋', NULL, NULL, 34.20, NULL, '100g', 100.00, 100.00, 6.80, 1.50, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (313, NULL, 10, '玉米笋', NULL, NULL, 34.30, NULL, '100g', 100.00, 100.00, 6.90, 1.50, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (314, NULL, 10, '秋葵', NULL, NULL, 37.40, NULL, '100g', 100.00, 100.00, 7.50, 1.60, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (315, NULL, 10, '冬瓜', NULL, NULL, 37.60, NULL, '100g', 100.00, 100.00, 7.50, 1.60, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (316, NULL, 10, '南瓜', NULL, NULL, 37.00, NULL, '100g', 100.00, 100.00, 7.40, 1.60, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (317, NULL, 10, '丝瓜', NULL, NULL, 39.00, NULL, '100g', 100.00, 100.00, 7.80, 1.70, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (318, NULL, 10, '苦瓜', NULL, NULL, 35.70, NULL, '100g', 100.00, 100.00, 7.10, 1.50, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (319, NULL, 10, '佛手瓜', NULL, NULL, 37.40, NULL, '100g', 100.00, 100.00, 7.50, 1.60, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (320, NULL, 10, '菱角', NULL, NULL, 31.70, NULL, '100g', 100.00, 100.00, 6.30, 1.40, 0.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (321, NULL, 11, '金针菇', NULL, NULL, 27.90, NULL, '100g', 100.00, 100.00, 4.70, 2.80, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (322, NULL, 11, '香菇', NULL, NULL, 28.50, NULL, '100g', 100.00, 100.00, 4.70, 2.80, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (323, NULL, 11, '平菇', NULL, NULL, 28.80, NULL, '100g', 100.00, 100.00, 4.80, 2.90, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (324, NULL, 11, '杏鲍菇', NULL, NULL, 29.90, NULL, '100g', 100.00, 100.00, 5.00, 3.00, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (325, NULL, 11, '口蘑', NULL, NULL, 32.80, NULL, '100g', 100.00, 100.00, 5.50, 3.30, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (326, NULL, 11, '白玉菇', NULL, NULL, 31.80, NULL, '100g', 100.00, 100.00, 5.30, 3.20, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (327, NULL, 11, '蟹味菇', NULL, NULL, 27.60, NULL, '100g', 100.00, 100.00, 4.60, 2.80, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (328, NULL, 11, '茶树菇', NULL, NULL, 31.90, NULL, '100g', 100.00, 100.00, 5.30, 3.20, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (329, NULL, 11, '猴头菇', NULL, NULL, 33.40, NULL, '100g', 100.00, 100.00, 5.60, 3.30, 0.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (330, NULL, 11, '木耳', NULL, NULL, 29.20, NULL, '100g', 100.00, 100.00, 4.90, 2.90, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (331, NULL, 11, '银耳', NULL, NULL, 32.80, NULL, '100g', 100.00, 100.00, 5.50, 3.30, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (332, NULL, 11, '竹荪', NULL, NULL, 26.80, NULL, '100g', 100.00, 100.00, 4.50, 2.70, 0.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (333, NULL, 11, '羊肚菌', NULL, NULL, 27.50, NULL, '100g', 100.00, 100.00, 4.60, 2.80, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (334, NULL, 11, '牛肝菌', NULL, NULL, 27.90, NULL, '100g', 100.00, 100.00, 4.70, 2.80, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (335, NULL, 11, '鸡枞菌', NULL, NULL, 33.40, NULL, '100g', 100.00, 100.00, 5.60, 3.30, 0.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (336, NULL, 11, '松茸', NULL, NULL, 29.30, NULL, '100g', 100.00, 100.00, 4.90, 2.90, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (337, NULL, 11, '海带', NULL, NULL, 33.50, NULL, '100g', 100.00, 100.00, 5.60, 3.40, 0.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (338, NULL, 11, '紫菜', NULL, NULL, 27.50, NULL, '100g', 100.00, 100.00, 4.60, 2.70, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (339, NULL, 11, '裙带菜', NULL, NULL, 28.90, NULL, '100g', 100.00, 100.00, 4.80, 2.90, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (340, NULL, 11, '海白菜', NULL, NULL, 31.50, NULL, '100g', 100.00, 100.00, 5.20, 3.10, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (341, NULL, 11, '石花菜', NULL, NULL, 27.60, NULL, '100g', 100.00, 100.00, 4.60, 2.80, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (342, NULL, 11, '龙须菜', NULL, NULL, 28.70, NULL, '100g', 100.00, 100.00, 4.80, 2.90, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (343, NULL, 11, '发菜', NULL, NULL, 31.50, NULL, '100g', 100.00, 100.00, 5.30, 3.20, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (344, NULL, 11, '葛仙米', NULL, NULL, 30.50, NULL, '100g', 100.00, 100.00, 5.10, 3.00, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (345, NULL, 11, '螺旋藻粉', NULL, NULL, 32.80, NULL, '100g', 100.00, 100.00, 5.50, 3.30, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (346, NULL, 11, '昆布', NULL, NULL, 30.70, NULL, '100g', 100.00, 100.00, 5.10, 3.10, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (347, NULL, 11, '海茸', NULL, NULL, 26.60, NULL, '100g', 100.00, 100.00, 4.40, 2.70, 0.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (348, NULL, 11, '海带头', NULL, NULL, 27.70, NULL, '100g', 100.00, 100.00, 4.60, 2.80, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (349, NULL, 11, '海带结', NULL, NULL, 32.40, NULL, '100g', 100.00, 100.00, 5.40, 3.20, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (350, NULL, 11, '海蜇皮', NULL, NULL, 30.50, NULL, '100g', 100.00, 100.00, 5.10, 3.00, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (351, NULL, 11, '海蜇头', NULL, NULL, 26.60, NULL, '100g', 100.00, 100.00, 4.40, 2.70, 0.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (352, NULL, 11, '江蓠', NULL, NULL, 28.60, NULL, '100g', 100.00, 100.00, 4.80, 2.90, 0.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (353, NULL, 12, '嫩豆腐', NULL, NULL, 85.80, NULL, '100g', 100.00, 100.00, 3.60, 9.00, 4.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (354, NULL, 12, '老豆腐', NULL, NULL, 103.70, NULL, '100g', 100.00, 100.00, 4.40, 10.90, 5.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (355, NULL, 12, '内酯豆腐', NULL, NULL, 96.30, NULL, '100g', 100.00, 100.00, 4.10, 10.10, 5.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (356, NULL, 12, '冻豆腐', NULL, NULL, 105.10, NULL, '100g', 100.00, 100.00, 4.40, 11.10, 5.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (357, NULL, 12, '豆腐泡', NULL, NULL, 101.10, NULL, '100g', 100.00, 100.00, 4.30, 10.60, 5.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (358, NULL, 12, '鲜豆皮', NULL, NULL, 104.70, NULL, '100g', 100.00, 100.00, 4.40, 11.00, 5.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (359, NULL, 12, '千张', NULL, NULL, 85.70, NULL, '100g', 100.00, 100.00, 3.60, 9.00, 4.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (360, NULL, 12, '腐竹段', NULL, NULL, 96.50, NULL, '100g', 100.00, 100.00, 4.10, 10.20, 5.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (361, NULL, 12, '素鸡', NULL, NULL, 97.10, NULL, '100g', 100.00, 100.00, 4.10, 10.20, 5.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (362, NULL, 12, '素火腿', NULL, NULL, 101.30, NULL, '100g', 100.00, 100.00, 4.30, 10.70, 5.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (363, NULL, 12, '豆浆', NULL, NULL, 90.70, NULL, '100g', 100.00, 100.00, 3.80, 9.60, 4.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (364, NULL, 12, '无糖豆浆', NULL, NULL, 100.00, NULL, '100g', 100.00, 100.00, 4.20, 10.50, 5.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (365, NULL, 12, '黑豆豆浆', NULL, NULL, 85.60, NULL, '100g', 100.00, 100.00, 3.60, 9.00, 4.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (366, NULL, 12, '豆腐脑', NULL, NULL, 91.70, NULL, '100g', 100.00, 100.00, 3.90, 9.70, 4.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (367, NULL, 12, '咸豆花', NULL, NULL, 99.30, NULL, '100g', 100.00, 100.00, 4.20, 10.50, 5.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (368, NULL, 12, '甜豆花', NULL, NULL, 83.80, NULL, '100g', 100.00, 100.00, 3.50, 8.80, 4.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (369, NULL, 12, '鲜腐竹', NULL, NULL, 97.20, NULL, '100g', 100.00, 100.00, 4.10, 10.20, 5.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (370, NULL, 12, '油豆腐', NULL, NULL, 100.70, NULL, '100g', 100.00, 100.00, 4.20, 10.60, 5.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (371, NULL, 12, '兰花干', NULL, NULL, 96.00, NULL, '100g', 100.00, 100.00, 4.00, 10.10, 5.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (372, NULL, 12, '豆皮卷', NULL, NULL, 96.40, NULL, '100g', 100.00, 100.00, 4.10, 10.10, 5.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (373, NULL, 12, '腐竹结', NULL, NULL, 100.10, NULL, '100g', 100.00, 100.00, 4.20, 10.50, 5.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (374, NULL, 12, '豆腐丸子', NULL, NULL, 87.60, NULL, '100g', 100.00, 100.00, 3.70, 9.20, 4.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (375, NULL, 12, '天贝鲜品', NULL, NULL, 98.60, NULL, '100g', 100.00, 100.00, 4.10, 10.40, 5.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (376, NULL, 12, '豆花鱼底料豆花', NULL, NULL, 103.70, NULL, '100g', 100.00, 100.00, 4.40, 10.90, 5.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (377, NULL, 12, '嫩豆干', NULL, NULL, 90.40, NULL, '100g', 100.00, 100.00, 3.80, 9.50, 4.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (378, NULL, 12, '五香豆干', NULL, NULL, 105.80, NULL, '100g', 100.00, 100.00, 4.50, 11.10, 5.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (379, NULL, 12, '茶干', NULL, NULL, 98.50, NULL, '100g', 100.00, 100.00, 4.10, 10.40, 5.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (380, NULL, 12, '白干', NULL, NULL, 85.50, NULL, '100g', 100.00, 100.00, 3.60, 9.00, 4.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (381, NULL, 12, '素肥肠', NULL, NULL, 95.30, NULL, '100g', 100.00, 100.00, 4.00, 10.00, 5.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (382, NULL, 12, '素肚', NULL, NULL, 86.30, NULL, '100g', 100.00, 100.00, 3.60, 9.10, 4.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (383, NULL, 12, '素腰花', NULL, NULL, 88.40, NULL, '100g', 100.00, 100.00, 3.70, 9.30, 4.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (384, NULL, 12, '豆纤丝', NULL, NULL, 90.40, NULL, '100g', 100.00, 100.00, 3.80, 9.50, 4.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (385, NULL, 13, '干黄豆', NULL, NULL, 410.30, NULL, '100g', 100.00, 100.00, 43.20, 37.80, 13.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (386, NULL, 13, '干黑豆', NULL, NULL, 350.00, NULL, '100g', 100.00, 100.00, 36.80, 32.20, 11.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (387, NULL, 13, '干绿豆', NULL, NULL, 368.10, NULL, '100g', 100.00, 100.00, 38.80, 33.90, 11.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (388, NULL, 13, '干红豆', NULL, NULL, 403.30, NULL, '100g', 100.00, 100.00, 42.50, 37.10, 12.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (389, NULL, 13, '干芸豆', NULL, NULL, 419.70, NULL, '100g', 100.00, 100.00, 44.20, 38.70, 13.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (390, NULL, 13, '干扁豆', NULL, NULL, 381.90, NULL, '100g', 100.00, 100.00, 40.20, 35.20, 12.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (391, NULL, 13, '干蚕豆', NULL, NULL, 392.80, NULL, '100g', 100.00, 100.00, 41.30, 36.20, 12.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (392, NULL, 13, '腐竹干', NULL, NULL, 345.40, NULL, '100g', 100.00, 100.00, 36.40, 31.80, 10.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (393, NULL, 13, '豆皮干', NULL, NULL, 409.70, NULL, '100g', 100.00, 100.00, 43.10, 37.70, 12.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (394, NULL, 13, '面筋', NULL, NULL, 340.60, NULL, '100g', 100.00, 100.00, 35.90, 31.40, 10.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (395, NULL, 13, '烤麸', NULL, NULL, 411.30, NULL, '100g', 100.00, 100.00, 43.30, 37.90, 13.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (396, NULL, 13, '油面筋', NULL, NULL, 387.40, NULL, '100g', 100.00, 100.00, 40.80, 35.70, 12.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (397, NULL, 13, '素鸡干', NULL, NULL, 366.10, NULL, '100g', 100.00, 100.00, 38.50, 33.70, 11.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (398, NULL, 13, '豆筋棍', NULL, NULL, 390.70, NULL, '100g', 100.00, 100.00, 41.10, 36.00, 12.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (399, NULL, 13, '豆丝', NULL, NULL, 352.20, NULL, '100g', 100.00, 100.00, 37.10, 32.40, 11.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (400, NULL, 13, '豆结', NULL, NULL, 369.50, NULL, '100g', 100.00, 100.00, 38.90, 34.00, 11.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (401, NULL, 13, '纳豆', NULL, NULL, 398.40, NULL, '100g', 100.00, 100.00, 41.90, 36.70, 12.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (402, NULL, 13, '豆豉', NULL, NULL, 351.40, NULL, '100g', 100.00, 100.00, 37.00, 32.40, 11.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (403, NULL, 13, '味噌', NULL, NULL, 359.90, NULL, '100g', 100.00, 100.00, 37.90, 33.10, 11.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (404, NULL, 13, '豆瓣酱', NULL, NULL, 354.40, NULL, '100g', 100.00, 100.00, 37.30, 32.60, 11.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (405, NULL, 13, '黄豆酱', NULL, NULL, 408.30, NULL, '100g', 100.00, 100.00, 43.00, 37.60, 12.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (406, NULL, 13, '甜面酱', NULL, NULL, 380.40, NULL, '100g', 100.00, 100.00, 40.00, 35.00, 12.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (407, NULL, 13, '豆腐乳', NULL, NULL, 393.70, NULL, '100g', 100.00, 100.00, 41.40, 36.30, 12.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (408, NULL, 13, '臭豆腐乳', NULL, NULL, 381.20, NULL, '100g', 100.00, 100.00, 40.10, 35.10, 12.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (409, NULL, 13, '素肉干', NULL, NULL, 383.50, NULL, '100g', 100.00, 100.00, 40.40, 35.30, 12.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (410, NULL, 13, '蛋白干', NULL, NULL, 382.90, NULL, '100g', 100.00, 100.00, 40.30, 35.30, 12.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (411, NULL, 13, '组织蛋白', NULL, NULL, 414.10, NULL, '100g', 100.00, 100.00, 43.60, 38.10, 13.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (412, NULL, 13, '拉丝蛋白', NULL, NULL, 423.90, NULL, '100g', 100.00, 100.00, 44.60, 39.00, 13.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (413, NULL, 13, '豆奶粉', NULL, NULL, 391.50, NULL, '100g', 100.00, 100.00, 41.20, 36.10, 12.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (414, NULL, 13, '黑豆浆粉', NULL, NULL, 368.70, NULL, '100g', 100.00, 100.00, 38.80, 34.00, 11.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (415, NULL, 13, '青豆仁干', NULL, NULL, 335.00, NULL, '100g', 100.00, 100.00, 35.30, 30.90, 10.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (416, NULL, 13, '豌豆仁干', NULL, NULL, 419.60, NULL, '100g', 100.00, 100.00, 44.20, 38.60, 13.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (417, NULL, 14, '核桃', NULL, NULL, 645.60, NULL, '100g', 100.00, 100.00, 22.30, 20.00, 55.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (418, NULL, 14, '碧根果', NULL, NULL, 609.50, NULL, '100g', 100.00, 100.00, 21.00, 18.90, 52.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (419, NULL, 14, '夏威夷果', NULL, NULL, 621.00, NULL, '100g', 100.00, 100.00, 21.40, 19.30, 53.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (420, NULL, 14, '巴旦木', NULL, NULL, 541.70, NULL, '100g', 100.00, 100.00, 18.70, 16.80, 46.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (421, NULL, 14, '杏仁', NULL, NULL, 575.40, NULL, '100g', 100.00, 100.00, 19.80, 17.90, 49.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (422, NULL, 14, '腰果', NULL, NULL, 563.00, NULL, '100g', 100.00, 100.00, 19.40, 17.50, 48.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (423, NULL, 14, '开心果', NULL, NULL, 542.60, NULL, '100g', 100.00, 100.00, 18.70, 16.80, 46.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (424, NULL, 14, '松子', NULL, NULL, 567.50, NULL, '100g', 100.00, 100.00, 19.60, 17.60, 48.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (425, NULL, 14, '榛子', NULL, NULL, 548.00, NULL, '100g', 100.00, 100.00, 18.90, 17.00, 47.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (426, NULL, 14, '板栗', NULL, NULL, 529.30, NULL, '100g', 100.00, 100.00, 18.30, 16.40, 45.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (427, NULL, 14, '花生', NULL, NULL, 625.40, NULL, '100g', 100.00, 100.00, 21.60, 19.40, 53.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (428, NULL, 14, '南瓜子', NULL, NULL, 550.40, NULL, '100g', 100.00, 100.00, 19.00, 17.10, 47.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (429, NULL, 14, '葵花籽', NULL, NULL, 638.50, NULL, '100g', 100.00, 100.00, 22.00, 19.80, 55.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (430, NULL, 14, '西瓜子', NULL, NULL, 573.20, NULL, '100g', 100.00, 100.00, 19.80, 17.80, 49.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (431, NULL, 14, '芝麻', NULL, NULL, 528.90, NULL, '100g', 100.00, 100.00, 18.20, 16.40, 45.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (432, NULL, 14, '奇亚籽', NULL, NULL, 556.00, NULL, '100g', 100.00, 100.00, 19.20, 17.30, 47.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (433, NULL, 14, '亚麻籽', NULL, NULL, 515.80, NULL, '100g', 100.00, 100.00, 17.80, 16.00, 44.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (434, NULL, 14, '火麻仁', NULL, NULL, 631.20, NULL, '100g', 100.00, 100.00, 21.80, 19.60, 54.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (435, NULL, 14, '葡萄籽', NULL, NULL, 565.00, NULL, '100g', 100.00, 100.00, 19.50, 17.50, 48.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (436, NULL, 14, '莲子', NULL, NULL, 530.60, NULL, '100g', 100.00, 100.00, 18.30, 16.50, 45.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (437, NULL, 14, '芡实', NULL, NULL, 528.40, NULL, '100g', 100.00, 100.00, 18.20, 16.40, 45.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (438, NULL, 14, '混合坚果', NULL, NULL, 541.70, NULL, '100g', 100.00, 100.00, 18.70, 16.80, 46.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (439, NULL, 14, '盐焗腰果', NULL, NULL, 639.20, NULL, '100g', 100.00, 100.00, 22.00, 19.80, 55.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (440, NULL, 14, '琥珀核桃', NULL, NULL, 584.00, NULL, '100g', 100.00, 100.00, 20.10, 18.10, 50.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (441, NULL, 14, '五香花生', NULL, NULL, 616.20, NULL, '100g', 100.00, 100.00, 21.20, 19.10, 53.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (442, NULL, 14, '焦糖杏仁', NULL, NULL, 512.10, NULL, '100g', 100.00, 100.00, 17.70, 15.90, 44.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (443, NULL, 14, '椰枣', NULL, NULL, 557.40, NULL, '100g', 100.00, 100.00, 19.20, 17.30, 48.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (444, NULL, 14, '山核桃', NULL, NULL, 579.00, NULL, '100g', 100.00, 100.00, 20.00, 18.00, 49.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (445, NULL, 14, '香榧', NULL, NULL, 598.80, NULL, '100g', 100.00, 100.00, 20.60, 18.60, 51.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (446, NULL, 14, '鲍鱼果', NULL, NULL, 512.30, NULL, '100g', 100.00, 100.00, 17.70, 15.90, 44.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (447, NULL, 14, '霹雳果', NULL, NULL, 645.40, NULL, '100g', 100.00, 100.00, 22.30, 20.00, 55.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (448, NULL, 14, '炭烧腰果', NULL, NULL, 528.30, NULL, '100g', 100.00, 100.00, 18.20, 16.40, 45.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (449, NULL, 15, '鲫鱼', NULL, NULL, 116.20, NULL, '100g', 100.00, 100.00, 0.00, 18.60, 3.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (450, NULL, 15, '鲤鱼', NULL, NULL, 131.30, NULL, '100g', 100.00, 100.00, 0.00, 21.00, 4.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (451, NULL, 15, '草鱼', NULL, NULL, 138.10, NULL, '100g', 100.00, 100.00, 0.00, 22.10, 4.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (452, NULL, 15, '青鱼', NULL, NULL, 136.40, NULL, '100g', 100.00, 100.00, 0.00, 21.80, 4.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (453, NULL, 15, '鲢鱼', NULL, NULL, 131.00, NULL, '100g', 100.00, 100.00, 0.00, 21.00, 4.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (454, NULL, 15, '鳙鱼', NULL, NULL, 113.10, NULL, '100g', 100.00, 100.00, 0.00, 18.10, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (455, NULL, 15, '黑鱼', NULL, NULL, 122.30, NULL, '100g', 100.00, 100.00, 0.00, 19.60, 3.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (456, NULL, 15, '鳜鱼', NULL, NULL, 131.90, NULL, '100g', 100.00, 100.00, 0.00, 21.10, 4.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (457, NULL, 15, '鲶鱼', NULL, NULL, 118.50, NULL, '100g', 100.00, 100.00, 0.00, 19.00, 3.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (458, NULL, 15, '黄颡鱼', NULL, NULL, 117.90, NULL, '100g', 100.00, 100.00, 0.00, 18.90, 3.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (459, NULL, 15, '武昌鱼', NULL, NULL, 114.10, NULL, '100g', 100.00, 100.00, 0.00, 18.30, 3.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (460, NULL, 15, '白条鱼', NULL, NULL, 130.20, NULL, '100g', 100.00, 100.00, 0.00, 20.80, 4.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (461, NULL, 15, '翘嘴鲌', NULL, NULL, 126.40, NULL, '100g', 100.00, 100.00, 0.00, 20.20, 4.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (462, NULL, 15, '鲈鱼淡', NULL, NULL, 112.90, NULL, '100g', 100.00, 100.00, 0.00, 18.10, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (463, NULL, 15, '鳗鱼淡', NULL, NULL, 112.00, NULL, '100g', 100.00, 100.00, 0.00, 17.90, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (464, NULL, 15, '泥鳅', NULL, NULL, 115.10, NULL, '100g', 100.00, 100.00, 0.00, 18.40, 3.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (465, NULL, 15, '黄鳝', NULL, NULL, 131.30, NULL, '100g', 100.00, 100.00, 0.00, 21.00, 4.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (466, NULL, 15, '白鳝', NULL, NULL, 120.70, NULL, '100g', 100.00, 100.00, 0.00, 19.30, 3.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (467, NULL, 15, '鲟鱼肉', NULL, NULL, 137.40, NULL, '100g', 100.00, 100.00, 0.00, 22.00, 4.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (468, NULL, 15, '虹鳟', NULL, NULL, 123.70, NULL, '100g', 100.00, 100.00, 0.00, 19.80, 4.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (469, NULL, 15, '罗非鱼', NULL, NULL, 110.40, NULL, '100g', 100.00, 100.00, 0.00, 17.70, 3.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (470, NULL, 15, '淡水鲈鱼', NULL, NULL, 130.10, NULL, '100g', 100.00, 100.00, 0.00, 20.80, 4.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (471, NULL, 15, '太阳鱼', NULL, NULL, 121.40, NULL, '100g', 100.00, 100.00, 0.00, 19.40, 3.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (472, NULL, 15, '军鱼', NULL, NULL, 138.80, NULL, '100g', 100.00, 100.00, 0.00, 22.20, 4.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (473, NULL, 15, '鲮鱼', NULL, NULL, 111.50, NULL, '100g', 100.00, 100.00, 0.00, 17.80, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (474, NULL, 15, '银鱼', NULL, NULL, 130.90, NULL, '100g', 100.00, 100.00, 0.00, 20.90, 4.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (475, NULL, 15, '刀鱼江鲜', NULL, NULL, 112.60, NULL, '100g', 100.00, 100.00, 0.00, 18.00, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (476, NULL, 15, '河豚处理品', NULL, NULL, 132.70, NULL, '100g', 100.00, 100.00, 0.00, 21.20, 4.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (477, NULL, 15, '胖头鱼头', NULL, NULL, 127.60, NULL, '100g', 100.00, 100.00, 0.00, 20.40, 4.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (478, NULL, 15, '鲤鱼籽', NULL, NULL, 116.40, NULL, '100g', 100.00, 100.00, 0.00, 18.60, 3.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (479, NULL, 15, '鲫鱼汤料鱼', NULL, NULL, 112.90, NULL, '100g', 100.00, 100.00, 0.00, 18.10, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (480, NULL, 15, '草鱼块', NULL, NULL, 112.90, NULL, '100g', 100.00, 100.00, 0.00, 18.10, 3.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (481, NULL, 16, '三文鱼', NULL, NULL, 141.50, NULL, '100g', 100.00, 100.00, 0.00, 19.20, 6.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (482, NULL, 16, '鳕鱼', NULL, NULL, 162.40, NULL, '100g', 100.00, 100.00, 0.00, 22.00, 7.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (483, NULL, 16, '带鱼', NULL, NULL, 149.20, NULL, '100g', 100.00, 100.00, 0.00, 20.20, 6.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (484, NULL, 16, '黄鱼', NULL, NULL, 144.20, NULL, '100g', 100.00, 100.00, 0.00, 19.50, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (485, NULL, 16, '海鲈鱼', NULL, NULL, 168.20, NULL, '100g', 100.00, 100.00, 0.00, 22.80, 7.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (486, NULL, 16, '石斑鱼', NULL, NULL, 166.90, NULL, '100g', 100.00, 100.00, 0.00, 22.60, 7.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (487, NULL, 16, '比目鱼', NULL, NULL, 152.70, NULL, '100g', 100.00, 100.00, 0.00, 20.70, 6.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (488, NULL, 16, '多宝鱼', NULL, NULL, 149.70, NULL, '100g', 100.00, 100.00, 0.00, 20.30, 6.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (489, NULL, 16, '巴沙鱼', NULL, NULL, 151.10, NULL, '100g', 100.00, 100.00, 0.00, 20.50, 6.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (490, NULL, 16, '龙利鱼', NULL, NULL, 152.20, NULL, '100g', 100.00, 100.00, 0.00, 20.60, 6.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (491, NULL, 16, '金枪鱼', NULL, NULL, 171.90, NULL, '100g', 100.00, 100.00, 0.00, 23.30, 7.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (492, NULL, 16, '鲭鱼', NULL, NULL, 143.10, NULL, '100g', 100.00, 100.00, 0.00, 19.40, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (493, NULL, 16, '秋刀鱼', NULL, NULL, 141.20, NULL, '100g', 100.00, 100.00, 0.00, 19.10, 6.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (494, NULL, 16, '沙丁鱼', NULL, NULL, 138.90, NULL, '100g', 100.00, 100.00, 0.00, 18.80, 6.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (495, NULL, 16, '马鲛鱼', NULL, NULL, 167.40, NULL, '100g', 100.00, 100.00, 0.00, 22.70, 7.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (496, NULL, 16, '鲳鱼', NULL, NULL, 163.60, NULL, '100g', 100.00, 100.00, 0.00, 22.20, 7.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (497, NULL, 16, '红衫鱼', NULL, NULL, 144.70, NULL, '100g', 100.00, 100.00, 0.00, 19.60, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (498, NULL, 16, '剥皮鱼', NULL, NULL, 157.20, NULL, '100g', 100.00, 100.00, 0.00, 21.30, 7.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (499, NULL, 16, '魔鬼鱼', NULL, NULL, 173.40, NULL, '100g', 100.00, 100.00, 0.00, 23.50, 7.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (500, NULL, 16, '银鲳', NULL, NULL, 159.10, NULL, '100g', 100.00, 100.00, 0.00, 21.60, 7.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (501, NULL, 16, '金鲳鱼', NULL, NULL, 149.30, NULL, '100g', 100.00, 100.00, 0.00, 20.20, 6.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (502, NULL, 16, '海鳗鱼', NULL, NULL, 139.00, NULL, '100g', 100.00, 100.00, 0.00, 18.80, 6.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (503, NULL, 16, '河豚海', NULL, NULL, 142.40, NULL, '100g', 100.00, 100.00, 0.00, 19.30, 6.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (504, NULL, 16, '鱼排海', NULL, NULL, 169.90, NULL, '100g', 100.00, 100.00, 0.00, 23.00, 7.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (505, NULL, 16, '鱼头海', NULL, NULL, 144.90, NULL, '100g', 100.00, 100.00, 0.00, 19.60, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (506, NULL, 16, '鱼腩', NULL, NULL, 140.90, NULL, '100g', 100.00, 100.00, 0.00, 19.10, 6.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (507, NULL, 16, '鱼柳', NULL, NULL, 152.40, NULL, '100g', 100.00, 100.00, 0.00, 20.60, 6.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (508, NULL, 16, '鱼滑海', NULL, NULL, 167.20, NULL, '100g', 100.00, 100.00, 0.00, 22.70, 7.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (509, NULL, 16, '鱼丸海', NULL, NULL, 147.60, NULL, '100g', 100.00, 100.00, 0.00, 20.00, 6.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (510, NULL, 16, '鱼皮海', NULL, NULL, 173.00, NULL, '100g', 100.00, 100.00, 0.00, 23.40, 7.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (511, NULL, 16, '凤尾鱼', NULL, NULL, 140.40, NULL, '100g', 100.00, 100.00, 0.00, 19.00, 6.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (512, NULL, 16, '池鱼', NULL, NULL, 145.50, NULL, '100g', 100.00, 100.00, 0.00, 19.70, 6.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (513, NULL, 17, '对虾', NULL, NULL, 86.20, NULL, '100g', 100.00, 100.00, 2.70, 16.30, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (514, NULL, 17, '基围虾', NULL, NULL, 91.80, NULL, '100g', 100.00, 100.00, 2.90, 17.40, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (515, NULL, 17, '明虾', NULL, NULL, 100.20, NULL, '100g', 100.00, 100.00, 3.20, 19.00, 2.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (516, NULL, 17, '北极甜虾', NULL, NULL, 88.40, NULL, '100g', 100.00, 100.00, 2.80, 16.70, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (517, NULL, 17, '小龙虾', NULL, NULL, 103.80, NULL, '100g', 100.00, 100.00, 3.30, 19.70, 2.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (518, NULL, 17, '皮皮虾', NULL, NULL, 87.00, NULL, '100g', 100.00, 100.00, 2.70, 16.50, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (519, NULL, 17, '河虾', NULL, NULL, 88.80, NULL, '100g', 100.00, 100.00, 2.80, 16.80, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (520, NULL, 17, '草虾', NULL, NULL, 93.90, NULL, '100g', 100.00, 100.00, 3.00, 17.80, 2.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (521, NULL, 17, '黑虎虾', NULL, NULL, 93.60, NULL, '100g', 100.00, 100.00, 3.00, 17.70, 2.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (522, NULL, 17, '阿根廷红虾', NULL, NULL, 92.40, NULL, '100g', 100.00, 100.00, 2.90, 17.50, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (523, NULL, 17, '波士顿龙虾', NULL, NULL, 85.50, NULL, '100g', 100.00, 100.00, 2.70, 16.20, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (524, NULL, 17, '青蟹', NULL, NULL, 101.50, NULL, '100g', 100.00, 100.00, 3.20, 19.20, 2.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (525, NULL, 17, '大闸蟹', NULL, NULL, 97.40, NULL, '100g', 100.00, 100.00, 3.10, 18.50, 2.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (526, NULL, 17, '梭子蟹', NULL, NULL, 89.30, NULL, '100g', 100.00, 100.00, 2.80, 16.90, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (527, NULL, 17, '花蟹', NULL, NULL, 105.80, NULL, '100g', 100.00, 100.00, 3.30, 20.10, 2.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (528, NULL, 17, '帝王蟹腿', NULL, NULL, 97.40, NULL, '100g', 100.00, 100.00, 3.10, 18.50, 2.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (529, NULL, 17, '生蚝', NULL, NULL, 87.00, NULL, '100g', 100.00, 100.00, 2.70, 16.50, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (530, NULL, 17, '扇贝', NULL, NULL, 90.00, NULL, '100g', 100.00, 100.00, 2.80, 17.10, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (531, NULL, 17, '蛤蜊', NULL, NULL, 101.60, NULL, '100g', 100.00, 100.00, 3.20, 19.20, 2.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (532, NULL, 17, '花蛤', NULL, NULL, 103.30, NULL, '100g', 100.00, 100.00, 3.30, 19.60, 2.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (533, NULL, 17, '蛏子', NULL, NULL, 90.00, NULL, '100g', 100.00, 100.00, 2.80, 17.10, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (534, NULL, 17, '青口贝', NULL, NULL, 93.10, NULL, '100g', 100.00, 100.00, 2.90, 17.60, 2.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (535, NULL, 17, '海瓜子', NULL, NULL, 85.10, NULL, '100g', 100.00, 100.00, 2.70, 16.10, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (536, NULL, 17, '海螺片', NULL, NULL, 103.00, NULL, '100g', 100.00, 100.00, 3.30, 19.50, 2.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (537, NULL, 17, '鲍鱼', NULL, NULL, 92.10, NULL, '100g', 100.00, 100.00, 2.90, 17.40, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (538, NULL, 17, '象拔蚌', NULL, NULL, 98.30, NULL, '100g', 100.00, 100.00, 3.10, 18.60, 2.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (539, NULL, 17, '北极贝', NULL, NULL, 97.10, NULL, '100g', 100.00, 100.00, 3.10, 18.40, 2.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (540, NULL, 17, '带子', NULL, NULL, 85.00, NULL, '100g', 100.00, 100.00, 2.70, 16.10, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (541, NULL, 17, '海胆黄', NULL, NULL, 84.70, NULL, '100g', 100.00, 100.00, 2.70, 16.10, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (542, NULL, 17, '海参刺参', NULL, NULL, 104.80, NULL, '100g', 100.00, 100.00, 3.30, 19.90, 2.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (543, NULL, 17, '海蜇丝拌虾', NULL, NULL, 91.00, NULL, '100g', 100.00, 100.00, 2.90, 17.20, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (544, NULL, 17, '虾仁仁', NULL, NULL, 90.40, NULL, '100g', 100.00, 100.00, 2.90, 17.10, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (545, NULL, 18, '鱿鱼须', NULL, NULL, 88.70, NULL, '100g', 100.00, 100.00, 4.20, 16.70, 2.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (546, NULL, 18, '鱿鱼圈', NULL, NULL, 86.70, NULL, '100g', 100.00, 100.00, 4.10, 16.30, 2.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (547, NULL, 18, '鱿鱼花', NULL, NULL, 76.20, NULL, '100g', 100.00, 100.00, 3.60, 14.30, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (548, NULL, 18, '整鱿鱼', NULL, NULL, 94.00, NULL, '100g', 100.00, 100.00, 4.40, 17.70, 2.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (549, NULL, 18, '墨鱼仔', NULL, NULL, 88.30, NULL, '100g', 100.00, 100.00, 4.20, 16.60, 2.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (550, NULL, 18, '墨鱼丸', NULL, NULL, 92.30, NULL, '100g', 100.00, 100.00, 4.30, 17.40, 2.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (551, NULL, 18, '墨鱼滑', NULL, NULL, 79.60, NULL, '100g', 100.00, 100.00, 3.70, 15.00, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (552, NULL, 18, '章鱼足', NULL, NULL, 83.30, NULL, '100g', 100.00, 100.00, 3.90, 15.70, 2.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (553, NULL, 18, '小章鱼', NULL, NULL, 83.10, NULL, '100g', 100.00, 100.00, 3.90, 15.60, 2.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (554, NULL, 18, '八爪鱼', NULL, NULL, 81.00, NULL, '100g', 100.00, 100.00, 3.80, 15.30, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (555, NULL, 18, '海兔', NULL, NULL, 82.60, NULL, '100g', 100.00, 100.00, 3.90, 15.60, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (556, NULL, 18, '笔管鱼', NULL, NULL, 81.00, NULL, '100g', 100.00, 100.00, 3.80, 15.20, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (557, NULL, 18, '柔鱼', NULL, NULL, 79.30, NULL, '100g', 100.00, 100.00, 3.70, 14.90, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (558, NULL, 18, '锁管', NULL, NULL, 79.40, NULL, '100g', 100.00, 100.00, 3.70, 14.90, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (559, NULL, 18, '乌贼片', NULL, NULL, 88.00, NULL, '100g', 100.00, 100.00, 4.10, 16.60, 2.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (560, NULL, 18, '花枝丸', NULL, NULL, 92.90, NULL, '100g', 100.00, 100.00, 4.40, 17.50, 2.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (561, NULL, 18, '墨鱼面', NULL, NULL, 83.80, NULL, '100g', 100.00, 100.00, 3.90, 15.80, 2.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (562, NULL, 18, '鱿鱼丝零食料', NULL, NULL, 84.20, NULL, '100g', 100.00, 100.00, 4.00, 15.80, 2.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (563, NULL, 18, '烤鱿鱼板', NULL, NULL, 80.10, NULL, '100g', 100.00, 100.00, 3.80, 15.10, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (564, NULL, 18, '铁板鱿鱼', NULL, NULL, 75.80, NULL, '100g', 100.00, 100.00, 3.60, 14.30, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (565, NULL, 18, '酱爆鱿鱼', NULL, NULL, 83.10, NULL, '100g', 100.00, 100.00, 3.90, 15.60, 2.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (566, NULL, 18, '芥末章鱼', NULL, NULL, 77.50, NULL, '100g', 100.00, 100.00, 3.60, 14.60, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (567, NULL, 18, '章鱼小丸子料', NULL, NULL, 76.80, NULL, '100g', 100.00, 100.00, 3.60, 14.50, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (568, NULL, 18, '墨鱼汁面', NULL, NULL, 83.40, NULL, '100g', 100.00, 100.00, 3.90, 15.70, 2.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (569, NULL, 18, '海鲜拼盘鱿', NULL, NULL, 76.10, NULL, '100g', 100.00, 100.00, 3.60, 14.30, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (570, NULL, 18, '三去鱿鱼', NULL, NULL, 79.30, NULL, '100g', 100.00, 100.00, 3.70, 14.90, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (571, NULL, 18, '开背鱿鱼', NULL, NULL, 89.30, NULL, '100g', 100.00, 100.00, 4.20, 16.80, 2.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (572, NULL, 18, '龙须菜拌鱿', NULL, NULL, 92.90, NULL, '100g', 100.00, 100.00, 4.40, 17.50, 2.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (573, NULL, 18, '紫苏鱿', NULL, NULL, 77.90, NULL, '100g', 100.00, 100.00, 3.70, 14.70, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (574, NULL, 18, '蒜香鱿', NULL, NULL, 78.40, NULL, '100g', 100.00, 100.00, 3.70, 14.80, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (575, NULL, 18, '照烧鱿', NULL, NULL, 75.50, NULL, '100g', 100.00, 100.00, 3.60, 14.20, 1.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (576, NULL, 18, '咖喱鱿', NULL, NULL, 80.60, NULL, '100g', 100.00, 100.00, 3.80, 15.20, 1.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (577, NULL, 19, '排骨汤', NULL, NULL, 56.80, NULL, '100ml', NULL, 100.00, 5.20, 4.10, 2.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (578, NULL, 19, '鸡汤', NULL, NULL, 60.10, NULL, '100ml', NULL, 100.00, 5.50, 4.40, 2.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (579, NULL, 19, '老鸭汤', NULL, NULL, 55.20, NULL, '100ml', NULL, 100.00, 5.00, 4.00, 2.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (580, NULL, 19, '牛腩汤', NULL, NULL, 61.40, NULL, '100ml', NULL, 100.00, 5.60, 4.50, 2.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (581, NULL, 19, '羊肉汤', NULL, NULL, 56.00, NULL, '100g', 100.00, 100.00, 5.10, 4.10, 2.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (582, NULL, 19, '鱼汤白', NULL, NULL, 53.60, NULL, '100ml', NULL, 100.00, 4.90, 3.90, 2.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (583, NULL, 19, '豆腐汤', NULL, NULL, 50.10, NULL, '100ml', NULL, 100.00, 4.60, 3.60, 2.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (584, NULL, 19, '番茄蛋汤', NULL, NULL, 54.30, NULL, '100g', 100.00, 100.00, 4.90, 3.90, 2.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (585, NULL, 19, '紫菜蛋汤', NULL, NULL, 52.80, NULL, '100ml', NULL, 100.00, 4.80, 3.80, 2.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (586, NULL, 19, '冬瓜排骨汤', NULL, NULL, 59.50, NULL, '100g', 100.00, 100.00, 5.40, 4.30, 2.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (587, NULL, 19, '莲藕排骨汤', NULL, NULL, 55.70, NULL, '100g', 100.00, 100.00, 5.10, 4.10, 2.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (588, NULL, 19, '玉米排骨汤', NULL, NULL, 53.90, NULL, '100g', 100.00, 100.00, 4.90, 3.90, 2.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (589, NULL, 19, '猪肚鸡汤', NULL, NULL, 53.20, NULL, '100ml', NULL, 100.00, 4.80, 3.90, 2.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (590, NULL, 19, '花胶鸡汤', NULL, NULL, 56.90, NULL, '100ml', NULL, 100.00, 5.20, 4.10, 2.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (591, NULL, 19, '佛跳墙', NULL, NULL, 55.30, NULL, '100g', 100.00, 100.00, 5.00, 4.00, 2.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (592, NULL, 19, '羊肉泡馍汤', NULL, NULL, 61.00, NULL, '100ml', NULL, 100.00, 5.50, 4.40, 2.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (593, NULL, 19, '酸萝卜老鸭汤', NULL, NULL, 58.70, NULL, '100ml', NULL, 100.00, 5.30, 4.30, 2.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (594, NULL, 19, '山药排骨汤', NULL, NULL, 54.10, NULL, '100g', 100.00, 100.00, 4.90, 3.90, 2.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (595, NULL, 19, '银耳莲子汤', NULL, NULL, 56.30, NULL, '100ml', NULL, 100.00, 5.10, 4.10, 2.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (596, NULL, 19, '绿豆汤', NULL, NULL, 56.00, NULL, '100ml', NULL, 100.00, 5.10, 4.10, 2.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (597, NULL, 19, '红豆汤', NULL, NULL, 52.40, NULL, '100g', 100.00, 100.00, 4.80, 3.80, 2.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (598, NULL, 19, '酒酿圆子汤', NULL, NULL, 54.20, NULL, '100g', 100.00, 100.00, 4.90, 3.90, 2.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (599, NULL, 19, '味噌汤', NULL, NULL, 57.20, NULL, '100ml', NULL, 100.00, 5.20, 4.20, 2.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (600, NULL, 19, '海带排骨汤', NULL, NULL, 55.40, NULL, '100g', 100.00, 100.00, 5.00, 4.00, 2.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (601, NULL, 19, '萝卜牛腩煲', NULL, NULL, 60.90, NULL, '100ml', NULL, 100.00, 5.50, 4.40, 2.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (602, NULL, 19, '黄豆猪蹄汤', NULL, NULL, 60.10, NULL, '100ml', NULL, 100.00, 5.50, 4.40, 2.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (603, NULL, 19, '木瓜鲫鱼汤', NULL, NULL, 50.90, NULL, '100g', 100.00, 100.00, 4.60, 3.70, 2.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (604, NULL, 19, '花旗参鸡汤', NULL, NULL, 58.70, NULL, '100g', 100.00, 100.00, 5.30, 4.30, 2.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (605, NULL, 19, '椰子鸡汤', NULL, NULL, 50.20, NULL, '100g', 100.00, 100.00, 4.60, 3.70, 2.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (606, NULL, 19, '沙参玉竹汤', NULL, NULL, 52.10, NULL, '100ml', NULL, 100.00, 4.70, 3.80, 2.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (607, NULL, 19, '霸王花汤', NULL, NULL, 50.90, NULL, '100ml', NULL, 100.00, 4.60, 3.70, 2.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (608, NULL, 19, '西洋菜猪骨汤', NULL, NULL, 56.90, NULL, '100g', 100.00, 100.00, 5.20, 4.10, 2.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (609, NULL, 20, '白粥', NULL, NULL, 77.80, NULL, '100g', 100.00, 100.00, 14.50, 2.60, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (610, NULL, 20, '小米粥', NULL, NULL, 72.10, NULL, '100g', 100.00, 100.00, 13.40, 2.40, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (611, NULL, 20, '燕麦粥', NULL, NULL, 79.80, NULL, '100g', 100.00, 100.00, 14.90, 2.70, 1.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (612, NULL, 20, '杂粮粥', NULL, NULL, 78.00, NULL, '100g', 100.00, 100.00, 14.60, 2.60, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (613, NULL, 20, '皮蛋瘦肉粥', NULL, NULL, 69.00, NULL, '100g', 100.00, 100.00, 12.90, 2.30, 1.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (614, NULL, 20, '鱼片粥', NULL, NULL, 75.80, NULL, '100g', 100.00, 100.00, 14.10, 2.50, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (615, NULL, 20, '海鲜粥', NULL, NULL, 68.30, NULL, '100g', 100.00, 100.00, 12.70, 2.30, 1.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (616, NULL, 20, '南瓜粥', NULL, NULL, 77.70, NULL, '100g', 100.00, 100.00, 14.50, 2.60, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (617, NULL, 20, '红薯粥', NULL, NULL, 74.60, NULL, '100g', 100.00, 100.00, 13.90, 2.50, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (618, NULL, 20, '绿豆粥', NULL, NULL, 83.30, NULL, '100g', 100.00, 100.00, 15.50, 2.80, 1.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (619, NULL, 20, '红豆粥', NULL, NULL, 81.70, NULL, '100g', 100.00, 100.00, 15.30, 2.70, 1.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (620, NULL, 20, '八宝粥', NULL, NULL, 73.90, NULL, '100g', 100.00, 100.00, 13.80, 2.50, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (621, NULL, 20, '美龄粥', NULL, NULL, 75.50, NULL, '100g', 100.00, 100.00, 14.10, 2.50, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (622, NULL, 20, '青菜粥', NULL, NULL, 78.30, NULL, '100g', 100.00, 100.00, 14.60, 2.60, 1.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (623, NULL, 20, '排骨粥', NULL, NULL, 73.20, NULL, '100g', 100.00, 100.00, 13.70, 2.40, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (624, NULL, 20, '艇仔粥', NULL, NULL, 77.90, NULL, '100g', 100.00, 100.00, 14.50, 2.60, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (625, NULL, 20, '及第粥', NULL, NULL, 77.10, NULL, '100g', 100.00, 100.00, 14.40, 2.60, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (626, NULL, 20, '咸骨粥', NULL, NULL, 76.20, NULL, '100g', 100.00, 100.00, 14.20, 2.50, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (627, NULL, 20, '生滚粥底', NULL, NULL, 70.50, NULL, '100g', 100.00, 100.00, 13.20, 2.40, 1.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (628, NULL, 20, '糊辣汤', NULL, NULL, 79.20, NULL, '100g', 100.00, 100.00, 14.80, 2.60, 1.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (629, NULL, 20, '芝麻糊', NULL, NULL, 68.80, NULL, '100g', 100.00, 100.00, 12.80, 2.30, 1.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (630, NULL, 20, '核桃糊', NULL, NULL, 80.40, NULL, '100g', 100.00, 100.00, 15.00, 2.70, 1.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (631, NULL, 20, '花生糊', NULL, NULL, 74.10, NULL, '100g', 100.00, 100.00, 13.80, 2.50, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (632, NULL, 20, '杏仁糊', NULL, NULL, 73.30, NULL, '100g', 100.00, 100.00, 13.70, 2.40, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (633, NULL, 20, '藕粉', NULL, NULL, 73.90, NULL, '100g', 100.00, 100.00, 13.80, 2.50, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (634, NULL, 20, '葛根粉', NULL, NULL, 79.50, NULL, '100g', 100.00, 100.00, 14.80, 2.60, 1.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (635, NULL, 20, '山药糊', NULL, NULL, 83.50, NULL, '100g', 100.00, 100.00, 15.60, 2.80, 1.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (636, NULL, 20, '玉米糊', NULL, NULL, 76.10, NULL, '100g', 100.00, 100.00, 14.20, 2.50, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (637, NULL, 20, '米稀', NULL, NULL, 78.70, NULL, '100g', 100.00, 100.00, 14.70, 2.60, 1.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (638, NULL, 20, '婴儿米糊', NULL, NULL, 75.50, NULL, '100g', 100.00, 100.00, 14.10, 2.50, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (639, NULL, 20, '代餐粥', NULL, NULL, 77.90, NULL, '100g', 100.00, 100.00, 14.50, 2.60, 1.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (640, NULL, 20, '即食燕麦糊', NULL, NULL, 66.20, NULL, '100g', 100.00, 100.00, 12.40, 2.20, 1.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (641, NULL, 21, '雪花肥牛卷', NULL, NULL, 234.00, NULL, '100g', 100.00, 100.00, 8.90, 15.60, 15.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (642, NULL, 21, '羊肉卷', NULL, NULL, 199.50, NULL, '100g', 100.00, 100.00, 7.60, 13.30, 13.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (643, NULL, 21, '乌鸡卷', NULL, NULL, 221.20, NULL, '100g', 100.00, 100.00, 8.40, 14.70, 14.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (644, NULL, 21, '午餐肉火锅', NULL, NULL, 192.50, NULL, '100g', 100.00, 100.00, 7.30, 12.80, 12.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (645, NULL, 21, '撒尿牛丸', NULL, NULL, 205.20, NULL, '100g', 100.00, 100.00, 7.80, 13.70, 13.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (646, NULL, 21, '包心鱼丸', NULL, NULL, 197.80, NULL, '100g', 100.00, 100.00, 7.50, 13.20, 13.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (647, NULL, 21, '虾滑', NULL, NULL, 232.40, NULL, '100g', 100.00, 100.00, 8.90, 15.50, 15.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (648, NULL, 21, '蟹柳火锅', NULL, NULL, 194.80, NULL, '100g', 100.00, 100.00, 7.40, 13.00, 13.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (649, NULL, 21, '黄喉', NULL, NULL, 208.00, NULL, '100g', 100.00, 100.00, 7.90, 13.90, 13.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (650, NULL, 21, '毛肚', NULL, NULL, 185.40, NULL, '100g', 100.00, 100.00, 7.10, 12.40, 12.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (651, NULL, 21, '百叶', NULL, NULL, 209.00, NULL, '100g', 100.00, 100.00, 8.00, 13.90, 13.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (652, NULL, 21, '鸭肠', NULL, NULL, 203.40, NULL, '100g', 100.00, 100.00, 7.70, 13.60, 13.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (653, NULL, 21, '鹅肠', NULL, NULL, 216.50, NULL, '100g', 100.00, 100.00, 8.20, 14.40, 14.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (654, NULL, 21, '脑花', NULL, NULL, 225.00, NULL, '100g', 100.00, 100.00, 8.60, 15.00, 15.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (655, NULL, 21, '腰片', NULL, NULL, 222.40, NULL, '100g', 100.00, 100.00, 8.50, 14.80, 14.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (656, NULL, 21, '嫩肉片', NULL, NULL, 209.10, NULL, '100g', 100.00, 100.00, 8.00, 13.90, 13.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (657, NULL, 21, '酥肉', NULL, NULL, 188.00, NULL, '100g', 100.00, 100.00, 7.20, 12.50, 12.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (658, NULL, 21, '小郡肝', NULL, NULL, 217.20, NULL, '100g', 100.00, 100.00, 8.30, 14.50, 14.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (659, NULL, 21, '串串牛肉', NULL, NULL, 219.50, NULL, '100g', 100.00, 100.00, 8.40, 14.60, 14.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (660, NULL, 21, '串串郡把', NULL, NULL, 185.00, NULL, '100g', 100.00, 100.00, 7.00, 12.30, 12.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (661, NULL, 21, '火锅宽粉', NULL, NULL, 205.70, NULL, '100g', 100.00, 100.00, 7.80, 13.70, 13.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (662, NULL, 21, '火锅川粉', NULL, NULL, 211.50, NULL, '100g', 100.00, 100.00, 8.10, 14.10, 14.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (663, NULL, 21, '火锅年糕', NULL, NULL, 189.70, NULL, '100g', 100.00, 100.00, 7.20, 12.60, 12.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (664, NULL, 21, '火锅油条', NULL, NULL, 222.60, NULL, '100g', 100.00, 100.00, 8.50, 14.80, 14.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (665, NULL, 21, '火锅腐竹', NULL, NULL, 212.00, NULL, '100g', 100.00, 100.00, 8.10, 14.10, 14.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (666, NULL, 21, '火锅豆皮', NULL, NULL, 201.20, NULL, '100g', 100.00, 100.00, 7.70, 13.40, 13.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (667, NULL, 21, '火锅菌菇拼', NULL, NULL, 214.50, NULL, '100g', 100.00, 100.00, 8.20, 14.30, 14.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (668, NULL, 21, '火锅菠菜', NULL, NULL, 202.70, NULL, '100g', 100.00, 100.00, 7.70, 13.50, 13.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (669, NULL, 21, '火锅茼蒿', NULL, NULL, 190.40, NULL, '100g', 100.00, 100.00, 7.30, 12.70, 12.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (670, NULL, 21, '火锅娃娃菜', NULL, NULL, 187.00, NULL, '100g', 100.00, 100.00, 7.10, 12.50, 12.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (671, NULL, 21, '火锅冻豆腐', NULL, NULL, 211.80, NULL, '100g', 100.00, 100.00, 8.10, 14.10, 14.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (672, NULL, 21, '火锅魔芋结', NULL, NULL, 190.70, NULL, '100g', 100.00, 100.00, 7.30, 12.70, 12.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (673, NULL, 22, '炸鸡腿', NULL, NULL, 272.70, NULL, '100g', 100.00, 100.00, 19.10, 11.50, 17.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (674, NULL, 22, '炸鸡翅', NULL, NULL, 297.50, NULL, '100g', 100.00, 100.00, 20.90, 12.50, 18.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (675, NULL, 22, '炸鸡排', NULL, NULL, 273.10, NULL, '100g', 100.00, 100.00, 19.20, 11.50, 17.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (676, NULL, 22, '炸猪排', NULL, NULL, 296.70, NULL, '100g', 100.00, 100.00, 20.80, 12.50, 18.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (677, NULL, 22, '炸鱼排', NULL, NULL, 262.80, NULL, '100g', 100.00, 100.00, 18.40, 11.10, 16.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (678, NULL, 22, '炸薯条', NULL, NULL, 252.50, NULL, '100g', 100.00, 100.00, 17.70, 10.60, 15.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (679, NULL, 22, '炸洋葱圈', NULL, NULL, 262.60, NULL, '100g', 100.00, 100.00, 18.40, 11.10, 16.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (680, NULL, 22, '炸春卷', NULL, NULL, 289.80, NULL, '100g', 100.00, 100.00, 20.30, 12.20, 18.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (681, NULL, 22, '炸麻花', NULL, NULL, 310.20, NULL, '100g', 100.00, 100.00, 21.80, 13.10, 19.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (682, NULL, 22, '炸油条', NULL, NULL, 297.40, NULL, '100g', 100.00, 100.00, 20.90, 12.50, 18.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (683, NULL, 22, '炸糖糕', NULL, NULL, 315.00, NULL, '100g', 100.00, 100.00, 22.10, 13.30, 19.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (684, NULL, 22, '炸鲜奶', NULL, NULL, 299.80, NULL, '100g', 100.00, 100.00, 21.00, 12.60, 18.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (685, NULL, 22, '炸臭豆腐', NULL, NULL, 305.30, NULL, '100g', 100.00, 100.00, 21.40, 12.90, 19.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (686, NULL, 22, '烤羊肉串', NULL, NULL, 257.40, NULL, '100g', 100.00, 100.00, 18.10, 10.80, 16.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (687, NULL, 22, '烤牛肉串', NULL, NULL, 266.00, NULL, '100g', 100.00, 100.00, 18.70, 11.20, 16.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (688, NULL, 22, '烤五花肉串', NULL, NULL, 274.80, NULL, '100g', 100.00, 100.00, 19.30, 11.60, 17.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (689, NULL, 22, '烤鸡翅串', NULL, NULL, 278.40, NULL, '100g', 100.00, 100.00, 19.50, 11.70, 17.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (690, NULL, 22, '烤生蚝', NULL, NULL, 313.10, NULL, '100g', 100.00, 100.00, 22.00, 13.20, 19.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (691, NULL, 22, '烤茄子', NULL, NULL, 283.90, NULL, '100g', 100.00, 100.00, 19.90, 12.00, 17.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (692, NULL, 22, '烤韭菜', NULL, NULL, 312.10, NULL, '100g', 100.00, 100.00, 21.90, 13.10, 19.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (693, NULL, 22, '烤馒头片', NULL, NULL, 278.90, NULL, '100g', 100.00, 100.00, 19.60, 11.70, 17.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (694, NULL, 22, '烤面筋', NULL, NULL, 259.20, NULL, '100g', 100.00, 100.00, 18.20, 10.90, 16.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (695, NULL, 22, '烤鱿鱼串', NULL, NULL, 313.00, NULL, '100g', 100.00, 100.00, 22.00, 13.20, 19.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (696, NULL, 22, '烤秋刀鱼', NULL, NULL, 294.50, NULL, '100g', 100.00, 100.00, 20.70, 12.40, 18.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (697, NULL, 22, '烤羊腰', NULL, NULL, 268.30, NULL, '100g', 100.00, 100.00, 18.80, 11.30, 16.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (698, NULL, 22, '烤板筋', NULL, NULL, 252.10, NULL, '100g', 100.00, 100.00, 17.70, 10.60, 15.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (699, NULL, 22, '烤鸡心', NULL, NULL, 316.70, NULL, '100g', 100.00, 100.00, 22.20, 13.30, 20.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (700, NULL, 22, '烤猪蹄', NULL, NULL, 288.00, NULL, '100g', 100.00, 100.00, 20.20, 12.10, 18.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (701, NULL, 22, '烤鸭胗', NULL, NULL, 275.80, NULL, '100g', 100.00, 100.00, 19.40, 11.60, 17.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (702, NULL, 22, '铁板牛排', NULL, NULL, 311.30, NULL, '100g', 100.00, 100.00, 21.80, 13.10, 19.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (703, NULL, 22, '夜市铁板鱿', NULL, NULL, 256.20, NULL, '100g', 100.00, 100.00, 18.00, 10.80, 16.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (704, NULL, 22, '香酥鸡柳', NULL, NULL, 311.30, NULL, '100g', 100.00, 100.00, 21.80, 13.10, 19.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (705, NULL, 23, '凯撒沙拉', NULL, NULL, 132.10, NULL, '100g', 100.00, 100.00, 11.30, 11.30, 5.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (706, NULL, 23, '田园沙拉', NULL, NULL, 140.00, NULL, '100g', 100.00, 100.00, 12.00, 12.00, 6.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (707, NULL, 23, '鸡胸肉沙拉', NULL, NULL, 151.00, NULL, '100g', 100.00, 100.00, 12.90, 12.90, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (708, NULL, 23, '金枪鱼沙拉', NULL, NULL, 149.60, NULL, '100g', 100.00, 100.00, 12.80, 12.80, 6.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (709, NULL, 23, '藜麦沙拉', NULL, NULL, 151.30, NULL, '100g', 100.00, 100.00, 13.00, 13.00, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (710, NULL, 23, '牛油果吐司', NULL, NULL, 131.90, NULL, '100g', 100.00, 100.00, 11.30, 11.30, 5.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (711, NULL, 23, '全麦三明治', NULL, NULL, 123.90, NULL, '100g', 100.00, 100.00, 10.60, 10.60, 5.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (712, NULL, 23, '火腿三明治', NULL, NULL, 125.80, NULL, '100g', 100.00, 100.00, 10.80, 10.80, 5.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (713, NULL, 23, '牛肉汉堡', NULL, NULL, 150.70, NULL, '100g', 100.00, 100.00, 12.90, 12.90, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (714, NULL, 23, '鸡肉汉堡', NULL, NULL, 150.40, NULL, '100g', 100.00, 100.00, 12.90, 12.90, 6.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (715, NULL, 23, '意面番茄肉酱', NULL, NULL, 141.10, NULL, '100g', 100.00, 100.00, 12.10, 12.10, 6.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (716, NULL, 23, '意面奶油培根', NULL, NULL, 137.60, NULL, '100g', 100.00, 100.00, 11.80, 11.80, 5.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (717, NULL, 23, '奶油蘑菇汤', NULL, NULL, 147.40, NULL, '100g', 100.00, 100.00, 12.60, 12.60, 6.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (718, NULL, 23, '罗宋汤', NULL, NULL, 134.60, NULL, '100g', 100.00, 100.00, 11.50, 11.50, 5.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (719, NULL, 23, '土豆泥', NULL, NULL, 156.00, NULL, '100g', 100.00, 100.00, 13.40, 13.40, 6.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (720, NULL, 23, '烤时蔬', NULL, NULL, 151.00, NULL, '100g', 100.00, 100.00, 12.90, 12.90, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (721, NULL, 23, '牛排配芦笋', NULL, NULL, 156.40, NULL, '100g', 100.00, 100.00, 13.40, 13.40, 6.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (722, NULL, 23, '鱼排配柠檬', NULL, NULL, 156.50, NULL, '100g', 100.00, 100.00, 13.40, 13.40, 6.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (723, NULL, 23, '能量碗', NULL, NULL, 155.60, NULL, '100g', 100.00, 100.00, 13.30, 13.30, 6.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (724, NULL, 23, '波奇饭', NULL, NULL, 153.10, NULL, '100g', 100.00, 100.00, 13.10, 13.10, 6.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (725, NULL, 23, '墨西哥卷饼', NULL, NULL, 126.20, NULL, '100g', 100.00, 100.00, 10.80, 10.80, 5.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (726, NULL, 23, '塔可饼', NULL, NULL, 128.60, NULL, '100g', 100.00, 100.00, 11.00, 11.00, 5.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (727, NULL, 23, '芝士焗饭', NULL, NULL, 140.10, NULL, '100g', 100.00, 100.00, 12.00, 12.00, 6.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (728, NULL, 23, '焗薯泥', NULL, NULL, 129.20, NULL, '100g', 100.00, 100.00, 11.10, 11.10, 5.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (729, NULL, 23, '法式洋葱汤', NULL, NULL, 123.80, NULL, '100g', 100.00, 100.00, 10.60, 10.60, 5.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (730, NULL, 23, '西班牙海鲜饭', NULL, NULL, 152.10, NULL, '100g', 100.00, 100.00, 13.00, 13.00, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (731, NULL, 23, '希腊沙拉', NULL, NULL, 142.80, NULL, '100g', 100.00, 100.00, 12.20, 12.20, 6.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (732, NULL, 23, '尼斯沙拉', NULL, NULL, 132.90, NULL, '100g', 100.00, 100.00, 11.40, 11.40, 5.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (733, NULL, 23, '华尔道夫沙拉', NULL, NULL, 136.50, NULL, '100g', 100.00, 100.00, 11.70, 11.70, 5.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (734, NULL, 23, '科布沙拉', NULL, NULL, 124.00, NULL, '100g', 100.00, 100.00, 10.60, 10.60, 5.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (735, NULL, 23, '蛋白棒餐', NULL, NULL, 134.80, NULL, '100g', 100.00, 100.00, 11.60, 11.60, 5.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (736, NULL, 23, '代餐奶昔粉餐', NULL, NULL, 131.10, NULL, '100g', 100.00, 100.00, 11.20, 11.20, 5.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (737, NULL, 24, '寿司卷', NULL, NULL, 168.20, NULL, '100g', 100.00, 100.00, 18.40, 11.20, 6.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (738, NULL, 24, '刺身拼盘', NULL, NULL, 176.00, NULL, '100g', 100.00, 100.00, 19.20, 11.70, 6.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (739, NULL, 24, '日式拉面', NULL, NULL, 145.70, NULL, '100g', 100.00, 100.00, 15.90, 9.70, 5.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (740, NULL, 24, '味噌拉面', NULL, NULL, 148.90, NULL, '100g', 100.00, 100.00, 16.20, 9.90, 5.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (741, NULL, 24, '天妇罗虾', NULL, NULL, 165.90, NULL, '100g', 100.00, 100.00, 18.10, 11.10, 6.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (742, NULL, 24, '天妇罗蔬', NULL, NULL, 182.20, NULL, '100g', 100.00, 100.00, 19.90, 12.10, 6.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (743, NULL, 24, '日式咖喱饭', NULL, NULL, 159.50, NULL, '100g', 100.00, 100.00, 17.40, 10.60, 5.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (744, NULL, 24, '亲子丼', NULL, NULL, 172.30, NULL, '100g', 100.00, 100.00, 18.80, 11.50, 6.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (745, NULL, 24, '牛丼', NULL, NULL, 145.60, NULL, '100g', 100.00, 100.00, 15.90, 9.70, 5.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (746, NULL, 24, '猪排饭日式', NULL, NULL, 182.20, NULL, '100g', 100.00, 100.00, 19.90, 12.10, 6.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (747, NULL, 24, '茶泡饭', NULL, NULL, 162.70, NULL, '100g', 100.00, 100.00, 17.80, 10.80, 5.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (748, NULL, 24, '纳豆饭', NULL, NULL, 174.60, NULL, '100g', 100.00, 100.00, 19.00, 11.60, 6.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (749, NULL, 24, '日式汉堡排', NULL, NULL, 173.50, NULL, '100g', 100.00, 100.00, 18.90, 11.60, 6.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (750, NULL, 24, '寿喜烧', NULL, NULL, 166.90, NULL, '100g', 100.00, 100.00, 18.20, 11.10, 6.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (751, NULL, 24, '大阪烧', NULL, NULL, 159.20, NULL, '100g', 100.00, 100.00, 17.40, 10.60, 5.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (752, NULL, 24, '章鱼烧', NULL, NULL, 181.60, NULL, '100g', 100.00, 100.00, 19.80, 12.10, 6.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (753, NULL, 24, '日式土豆炖肉', NULL, NULL, 154.60, NULL, '100g', 100.00, 100.00, 16.90, 10.30, 5.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (754, NULL, 24, '韩式拌饭', NULL, NULL, 169.20, NULL, '100g', 100.00, 100.00, 18.50, 11.30, 6.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (755, NULL, 24, '石锅拌饭韩式', NULL, NULL, 156.80, NULL, '100g', 100.00, 100.00, 17.10, 10.50, 5.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (756, NULL, 24, '韩式冷面', NULL, NULL, 150.80, NULL, '100g', 100.00, 100.00, 16.50, 10.10, 5.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (757, NULL, 24, '韩式炸酱面', NULL, NULL, 171.60, NULL, '100g', 100.00, 100.00, 18.70, 11.40, 6.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (758, NULL, 24, '部队锅', NULL, NULL, 165.50, NULL, '100g', 100.00, 100.00, 18.10, 11.00, 6.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (759, NULL, 24, '韩式烤肉', NULL, NULL, 152.30, NULL, '100g', 100.00, 100.00, 16.60, 10.20, 5.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (760, NULL, 24, '辣炒年糕', NULL, NULL, 151.40, NULL, '100g', 100.00, 100.00, 16.50, 10.10, 5.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (761, NULL, 24, '韩式煎饼', NULL, NULL, 173.60, NULL, '100g', 100.00, 100.00, 18.90, 11.60, 6.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (762, NULL, 24, '泡菜汤', NULL, NULL, 156.20, NULL, '100g', 100.00, 100.00, 17.00, 10.40, 5.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (763, NULL, 24, '大酱汤', NULL, NULL, 169.20, NULL, '100g', 100.00, 100.00, 18.50, 11.30, 6.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (764, NULL, 24, '海带汤韩式', NULL, NULL, 152.50, NULL, '100g', 100.00, 100.00, 16.60, 10.20, 5.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (765, NULL, 24, '参鸡汤', NULL, NULL, 160.60, NULL, '100g', 100.00, 100.00, 17.50, 10.70, 5.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (766, NULL, 24, '韩式鸡爪锅', NULL, NULL, 170.80, NULL, '100g', 100.00, 100.00, 18.60, 11.40, 6.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (767, NULL, 24, '鱼饼串', NULL, NULL, 172.70, NULL, '100g', 100.00, 100.00, 18.80, 11.50, 6.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (768, NULL, 24, '米肠', NULL, NULL, 171.70, NULL, '100g', 100.00, 100.00, 18.70, 11.40, 6.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (769, NULL, 25, '冬阴功汤', NULL, NULL, 141.00, NULL, '100g', 100.00, 100.00, 14.60, 9.70, 6.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (770, NULL, 25, '泰式绿咖喱', NULL, NULL, 158.00, NULL, '100g', 100.00, 100.00, 16.30, 10.90, 7.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (771, NULL, 25, '泰式红咖喱', NULL, NULL, 160.30, NULL, '100g', 100.00, 100.00, 16.60, 11.10, 7.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (772, NULL, 25, '黄咖喱鸡', NULL, NULL, 131.10, NULL, '100g', 100.00, 100.00, 13.60, 9.00, 6.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (773, NULL, 25, '泰式炒河粉', NULL, NULL, 161.10, NULL, '100g', 100.00, 100.00, 16.70, 11.10, 7.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (774, NULL, 25, '芒果糯米饭', NULL, NULL, 136.30, NULL, '100g', 100.00, 100.00, 14.10, 9.40, 6.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (775, NULL, 25, '越南河粉', NULL, NULL, 134.90, NULL, '100g', 100.00, 100.00, 14.00, 9.30, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (776, NULL, 25, '越南春卷', NULL, NULL, 135.20, NULL, '100g', 100.00, 100.00, 14.00, 9.30, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (777, NULL, 25, '老挝米粉', NULL, NULL, 150.20, NULL, '100g', 100.00, 100.00, 15.50, 10.40, 7.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (778, NULL, 25, '新加坡叻沙', NULL, NULL, 145.90, NULL, '100g', 100.00, 100.00, 15.10, 10.10, 7.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (779, NULL, 25, '肉骨茶', NULL, NULL, 142.10, NULL, '100g', 100.00, 100.00, 14.70, 9.80, 6.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (780, NULL, 25, '海南鸡饭', NULL, NULL, 157.60, NULL, '100g', 100.00, 100.00, 16.30, 10.90, 7.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (781, NULL, 25, '印尼炒饭', NULL, NULL, 143.50, NULL, '100g', 100.00, 100.00, 14.80, 9.90, 6.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (782, NULL, 25, '沙爹串', NULL, NULL, 147.50, NULL, '100g', 100.00, 100.00, 15.30, 10.20, 7.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (783, NULL, 25, '椰浆饭', NULL, NULL, 137.70, NULL, '100g', 100.00, 100.00, 14.20, 9.50, 6.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (784, NULL, 25, '巴东牛肉', NULL, NULL, 130.00, NULL, '100g', 100.00, 100.00, 13.40, 9.00, 6.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (785, NULL, 25, '青木瓜沙拉', NULL, NULL, 133.80, NULL, '100g', 100.00, 100.00, 13.80, 9.20, 6.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (786, NULL, 25, '泰式打抛猪', NULL, NULL, 141.70, NULL, '100g', 100.00, 100.00, 14.70, 9.80, 6.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (787, NULL, 25, '柠檬蒸鱼', NULL, NULL, 158.60, NULL, '100g', 100.00, 100.00, 16.40, 10.90, 7.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (788, NULL, 25, '香茅烤鸡', NULL, NULL, 143.60, NULL, '100g', 100.00, 100.00, 14.90, 9.90, 6.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (789, NULL, 25, '越式法棍', NULL, NULL, 143.80, NULL, '100g', 100.00, 100.00, 14.90, 9.90, 6.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (790, NULL, 25, '柬埔寨 amok', NULL, NULL, 148.50, NULL, '100g', 100.00, 100.00, 15.40, 10.20, 7.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (791, NULL, 25, '缅甸茶叶沙拉', NULL, NULL, 145.70, NULL, '100g', 100.00, 100.00, 15.10, 10.00, 7.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (792, NULL, 25, '菲律宾 adobo', NULL, NULL, 136.90, NULL, '100g', 100.00, 100.00, 14.20, 9.40, 6.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (793, NULL, 25, '马来炒面', NULL, NULL, 141.60, NULL, '100g', 100.00, 100.00, 14.60, 9.80, 6.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (794, NULL, 25, '新加坡辣椒蟹', NULL, NULL, 150.20, NULL, '100g', 100.00, 100.00, 15.50, 10.40, 7.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (795, NULL, 25, '泰式奶茶', NULL, NULL, 149.20, NULL, '100g', 100.00, 100.00, 15.40, 10.30, 7.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (796, NULL, 25, '越南滴漏咖啡', NULL, NULL, 155.00, NULL, '100g', 100.00, 100.00, 16.00, 10.70, 7.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (797, NULL, 25, '拉茶', NULL, NULL, 156.30, NULL, '100g', 100.00, 100.00, 16.20, 10.80, 7.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (798, NULL, 25, '珍多冰', NULL, NULL, 138.00, NULL, '100g', 100.00, 100.00, 14.30, 9.50, 6.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (799, NULL, 25, '摩摩喳喳', NULL, NULL, 151.10, NULL, '100g', 100.00, 100.00, 15.60, 10.40, 7.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (800, NULL, 25, '煎蕊', NULL, NULL, 154.70, NULL, '100g', 100.00, 100.00, 16.00, 10.70, 7.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (801, NULL, 26, '戚风蛋糕', NULL, NULL, 398.00, NULL, '100g', 100.00, 100.00, 50.30, 7.30, 18.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (802, NULL, 26, '芝士蛋糕', NULL, NULL, 402.90, NULL, '100g', 100.00, 100.00, 50.90, 7.40, 19.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (803, NULL, 26, '提拉米苏', NULL, NULL, 422.30, NULL, '100g', 100.00, 100.00, 53.30, 7.80, 20.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (804, NULL, 26, '慕斯蛋糕', NULL, NULL, 382.50, NULL, '100g', 100.00, 100.00, 48.30, 7.00, 18.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (805, NULL, 26, '瑞士卷', NULL, NULL, 385.30, NULL, '100g', 100.00, 100.00, 48.70, 7.10, 18.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (806, NULL, 26, '牛角包', NULL, NULL, 410.10, NULL, '100g', 100.00, 100.00, 51.80, 7.60, 19.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (807, NULL, 26, '菠萝包', NULL, NULL, 402.70, NULL, '100g', 100.00, 100.00, 50.90, 7.40, 19.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (808, NULL, 26, '肉松面包', NULL, NULL, 384.70, NULL, '100g', 100.00, 100.00, 48.60, 7.10, 18.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (809, NULL, 26, '吐司切片', NULL, NULL, 347.60, NULL, '100g', 100.00, 100.00, 43.90, 6.40, 16.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (810, NULL, 26, '甜甜圈', NULL, NULL, 415.50, NULL, '100g', 100.00, 100.00, 52.50, 7.70, 19.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (811, NULL, 26, '马卡龙', NULL, NULL, 401.00, NULL, '100g', 100.00, 100.00, 50.70, 7.40, 19.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (812, NULL, 26, '泡芙', NULL, NULL, 356.20, NULL, '100g', 100.00, 100.00, 45.00, 6.60, 16.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (813, NULL, 26, '蛋挞', NULL, NULL, 369.50, NULL, '100g', 100.00, 100.00, 46.70, 6.80, 17.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (814, NULL, 26, '曲奇饼干', NULL, NULL, 354.00, NULL, '100g', 100.00, 100.00, 44.70, 6.50, 16.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (815, NULL, 26, '苏打饼干', NULL, NULL, 373.90, NULL, '100g', 100.00, 100.00, 47.20, 6.90, 17.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (816, NULL, 26, '华夫饼', NULL, NULL, 399.10, NULL, '100g', 100.00, 100.00, 50.40, 7.40, 18.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (817, NULL, 26, '松饼', NULL, NULL, 388.90, NULL, '100g', 100.00, 100.00, 49.10, 7.20, 18.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (818, NULL, 26, '司康饼', NULL, NULL, 381.70, NULL, '100g', 100.00, 100.00, 48.20, 7.00, 18.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (819, NULL, 26, '布朗尼', NULL, NULL, 354.60, NULL, '100g', 100.00, 100.00, 44.80, 6.50, 16.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (820, NULL, 26, '磅蛋糕', NULL, NULL, 405.30, NULL, '100g', 100.00, 100.00, 51.20, 7.50, 19.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (821, NULL, 26, '拿破仑酥', NULL, NULL, 386.30, NULL, '100g', 100.00, 100.00, 48.80, 7.10, 18.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (822, NULL, 26, '蝴蝶酥', NULL, NULL, 415.60, NULL, '100g', 100.00, 100.00, 52.50, 7.70, 19.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (823, NULL, 26, '绿豆糕', NULL, NULL, 397.50, NULL, '100g', 100.00, 100.00, 50.20, 7.30, 18.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (824, NULL, 26, '桂花糕', NULL, NULL, 385.70, NULL, '100g', 100.00, 100.00, 48.70, 7.10, 18.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (825, NULL, 26, '马蹄糕', NULL, NULL, 370.90, NULL, '100g', 100.00, 100.00, 46.80, 6.80, 17.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (826, NULL, 26, '老婆饼', NULL, NULL, 359.10, NULL, '100g', 100.00, 100.00, 45.40, 6.60, 17.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (827, NULL, 26, '蛋黄酥', NULL, NULL, 344.00, NULL, '100g', 100.00, 100.00, 43.40, 6.30, 16.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (828, NULL, 26, '鲜花饼', NULL, NULL, 395.70, NULL, '100g', 100.00, 100.00, 50.00, 7.30, 18.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (829, NULL, 26, '麻花甜', NULL, NULL, 372.80, NULL, '100g', 100.00, 100.00, 47.10, 6.90, 17.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (830, NULL, 26, '沙琪玛', NULL, NULL, 366.20, NULL, '100g', 100.00, 100.00, 46.30, 6.70, 17.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (831, NULL, 26, '月饼广式', NULL, NULL, 371.60, NULL, '100g', 100.00, 100.00, 46.90, 6.80, 17.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (832, NULL, 26, '月饼苏式', NULL, NULL, 387.00, NULL, '100g', 100.00, 100.00, 48.90, 7.10, 18.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (833, NULL, 27, '香草冰淇淋', NULL, NULL, 183.30, NULL, '100g', 100.00, 100.00, 24.40, 2.80, 8.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (834, NULL, 27, '巧克力冰淇淋', NULL, NULL, 212.90, NULL, '100g', 100.00, 100.00, 28.40, 3.30, 9.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (835, NULL, 27, '草莓冰淇淋', NULL, NULL, 193.40, NULL, '100g', 100.00, 100.00, 25.80, 3.00, 8.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (836, NULL, 27, '抹茶冰淇淋', NULL, NULL, 195.00, NULL, '100g', 100.00, 100.00, 26.00, 3.00, 9.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (837, NULL, 27, '芒果冰沙', NULL, NULL, 194.80, NULL, '100g', 100.00, 100.00, 26.00, 3.00, 9.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (838, NULL, 27, '红豆冰', NULL, NULL, 207.90, NULL, '100g', 100.00, 100.00, 27.70, 3.20, 9.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (839, NULL, 27, '绿豆冰', NULL, NULL, 209.10, NULL, '100g', 100.00, 100.00, 27.90, 3.20, 9.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (840, NULL, 27, '冰粉', NULL, NULL, 186.00, NULL, '100g', 100.00, 100.00, 24.80, 2.90, 8.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (841, NULL, 27, '烧仙草', NULL, NULL, 203.00, NULL, '100g', 100.00, 100.00, 27.10, 3.10, 9.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (842, NULL, 27, '四果汤', NULL, NULL, 184.20, NULL, '100g', 100.00, 100.00, 24.60, 2.80, 8.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (843, NULL, 27, '杨枝甘露', NULL, NULL, 173.80, NULL, '100g', 100.00, 100.00, 23.20, 2.70, 8.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (844, NULL, 27, '双皮奶冻', NULL, NULL, 181.60, NULL, '100g', 100.00, 100.00, 24.20, 2.80, 8.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (845, NULL, 27, '奶昔冰', NULL, NULL, 217.00, NULL, '100g', 100.00, 100.00, 28.90, 3.30, 10.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (846, NULL, 27, '雪顶咖啡', NULL, NULL, 203.30, NULL, '100g', 100.00, 100.00, 27.10, 3.10, 9.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (847, NULL, 27, '星冰乐类', NULL, NULL, 171.80, NULL, '100g', 100.00, 100.00, 22.90, 2.60, 7.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (848, NULL, 27, '冰棍奶油', NULL, NULL, 184.20, NULL, '100g', 100.00, 100.00, 24.60, 2.80, 8.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (849, NULL, 27, '老冰棍', NULL, NULL, 173.70, NULL, '100g', 100.00, 100.00, 23.20, 2.70, 8.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (850, NULL, 27, '碎碎冰', NULL, NULL, 189.00, NULL, '100g', 100.00, 100.00, 25.20, 2.90, 8.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (851, NULL, 27, '冰棒水果', NULL, NULL, 215.90, NULL, '100g', 100.00, 100.00, 28.80, 3.30, 10.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (852, NULL, 27, '炒酸奶', NULL, NULL, 215.00, NULL, '100g', 100.00, 100.00, 28.70, 3.30, 9.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (853, NULL, 27, '绵绵冰', NULL, NULL, 191.50, NULL, '100g', 100.00, 100.00, 25.50, 2.90, 8.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (854, NULL, 27, '刨冰红豆', NULL, NULL, 202.80, NULL, '100g', 100.00, 100.00, 27.00, 3.10, 9.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (855, NULL, 27, '刨冰芒果', NULL, NULL, 181.30, NULL, '100g', 100.00, 100.00, 24.20, 2.80, 8.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (856, NULL, 27, '冰淇淋蛋糕', NULL, NULL, 183.40, NULL, '100g', 100.00, 100.00, 24.50, 2.80, 8.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (857, NULL, 27, '雪糕杯', NULL, NULL, 177.70, NULL, '100g', 100.00, 100.00, 23.70, 2.70, 8.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (858, NULL, 27, '圣代', NULL, NULL, 199.50, NULL, '100g', 100.00, 100.00, 26.60, 3.10, 9.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (859, NULL, 27, '甜筒', NULL, NULL, 183.60, NULL, '100g', 100.00, 100.00, 24.50, 2.80, 8.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (860, NULL, 27, '冰砖', NULL, NULL, 216.80, NULL, '100g', 100.00, 100.00, 28.90, 3.30, 10.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (861, NULL, 27, '冰棒巧克力', NULL, NULL, 200.20, NULL, '100g', 100.00, 100.00, 26.70, 3.10, 9.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (862, NULL, 27, '果冻杯', NULL, NULL, 215.10, NULL, '100g', 100.00, 100.00, 28.70, 3.30, 9.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (863, NULL, 27, '布丁冻', NULL, NULL, 176.60, NULL, '100g', 100.00, 100.00, 23.50, 2.70, 8.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (864, NULL, 27, '椰汁西米露', NULL, NULL, 199.50, NULL, '100g', 100.00, 100.00, 26.60, 3.10, 9.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (865, NULL, 28, '矿泉水', NULL, NULL, 40.50, NULL, '100ml', NULL, 100.00, 9.60, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (866, NULL, 28, '苏打水', NULL, NULL, 40.00, NULL, '100ml', NULL, 100.00, 9.50, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (867, NULL, 28, '气泡水', NULL, NULL, 42.30, NULL, '100g', 100.00, 100.00, 10.00, 0.60, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (868, NULL, 28, '柠檬水', NULL, NULL, 42.00, NULL, '100ml', NULL, 100.00, 9.90, 0.60, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (869, NULL, 28, '橙汁', NULL, NULL, 34.60, NULL, '100g', 100.00, 100.00, 8.20, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (870, NULL, 28, '苹果汁', NULL, NULL, 36.10, NULL, '100g', 100.00, 100.00, 8.50, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (871, NULL, 28, '葡萄汁', NULL, NULL, 37.90, NULL, '100g', 100.00, 100.00, 9.00, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (872, NULL, 28, '西柚汁', NULL, NULL, 39.60, NULL, '100g', 100.00, 100.00, 9.40, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (873, NULL, 28, '椰子水', NULL, NULL, 36.20, NULL, '100g', 100.00, 100.00, 8.60, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (874, NULL, 28, '酸梅汤', NULL, NULL, 40.90, NULL, '100ml', NULL, 100.00, 9.70, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (875, NULL, 28, '绿茶', NULL, NULL, 38.30, NULL, '100g', 100.00, 100.00, 9.10, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (876, NULL, 28, '红茶', NULL, NULL, 35.40, NULL, '100ml', NULL, 100.00, 8.40, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (877, NULL, 28, '乌龙茶', NULL, NULL, 34.90, NULL, '100g', 100.00, 100.00, 8.30, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (878, NULL, 28, '普洱茶', NULL, NULL, 38.90, NULL, '100g', 100.00, 100.00, 9.20, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (879, NULL, 28, '茉莉花茶', NULL, NULL, 41.80, NULL, '100g', 100.00, 100.00, 9.90, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (880, NULL, 28, '菊花茶', NULL, NULL, 36.40, NULL, '100ml', NULL, 100.00, 8.60, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (881, NULL, 28, '大麦茶', NULL, NULL, 34.30, NULL, '100g', 100.00, 100.00, 8.10, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (882, NULL, 28, '玉米须茶', NULL, NULL, 38.50, NULL, '100g', 100.00, 100.00, 9.10, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (883, NULL, 28, '黑咖啡', NULL, NULL, 40.30, NULL, '100g', 100.00, 100.00, 9.50, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (884, NULL, 28, '美式咖啡', NULL, NULL, 37.00, NULL, '100g', 100.00, 100.00, 8.80, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (885, NULL, 28, '拿铁', NULL, NULL, 36.60, NULL, '100ml', NULL, 100.00, 8.70, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (886, NULL, 28, '卡布奇诺', NULL, NULL, 33.90, NULL, '100g', 100.00, 100.00, 8.00, 0.40, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (887, NULL, 28, '摩卡', NULL, NULL, 37.90, NULL, '100ml', NULL, 100.00, 9.00, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (888, NULL, 28, '现调奶茶', NULL, NULL, 37.40, NULL, '100g', 100.00, 100.00, 8.90, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (889, NULL, 28, '珍珠奶茶', NULL, NULL, 41.60, NULL, '100ml', NULL, 100.00, 9.80, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (890, NULL, 28, '果茶', NULL, NULL, 41.60, NULL, '100g', 100.00, 100.00, 9.80, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (891, NULL, 28, '柠檬茶', NULL, NULL, 40.50, NULL, '100ml', NULL, 100.00, 9.60, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (892, NULL, 28, '冰红茶', NULL, NULL, 36.00, NULL, '100ml', NULL, 100.00, 8.50, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (893, NULL, 28, '运动饮料', NULL, NULL, 33.50, NULL, '100ml', NULL, 100.00, 7.90, 0.40, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (894, NULL, 28, '电解质水', NULL, NULL, 36.90, NULL, '100g', 100.00, 100.00, 8.70, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (895, NULL, 28, '果蔬汁', NULL, NULL, 33.60, NULL, '100g', 100.00, 100.00, 7.90, 0.40, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (896, NULL, 28, '杏仁奶饮', NULL, NULL, 36.90, NULL, '100ml', NULL, 100.00, 8.70, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (897, NULL, 29, '啤酒淡爽', NULL, NULL, 72.10, NULL, '100ml', NULL, 100.00, 5.10, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (898, NULL, 29, '啤酒纯生', NULL, NULL, 63.00, NULL, '100g', 100.00, 100.00, 4.50, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (899, NULL, 29, '啤酒黑啤', NULL, NULL, 69.30, NULL, '100g', 100.00, 100.00, 5.00, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (900, NULL, 29, '白葡萄酒', NULL, NULL, 70.20, NULL, '100g', 100.00, 100.00, 5.00, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (901, NULL, 29, '红葡萄酒', NULL, NULL, 71.10, NULL, '100ml', NULL, 100.00, 5.10, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (902, NULL, 29, '桃红葡萄酒', NULL, NULL, 63.30, NULL, '100ml', NULL, 100.00, 4.50, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (903, NULL, 29, '香槟', NULL, NULL, 73.80, NULL, '100g', 100.00, 100.00, 5.30, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (904, NULL, 29, '起泡酒', NULL, NULL, 67.40, NULL, '100g', 100.00, 100.00, 4.80, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (905, NULL, 29, '清酒', NULL, NULL, 72.10, NULL, '100ml', NULL, 100.00, 5.20, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (906, NULL, 29, '梅酒', NULL, NULL, 63.80, NULL, '100ml', NULL, 100.00, 4.60, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (907, NULL, 29, '米酒', NULL, NULL, 77.70, NULL, '100g', 100.00, 100.00, 5.60, 0.60, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (908, NULL, 29, '黄酒', NULL, NULL, 71.60, NULL, '100ml', NULL, 100.00, 5.10, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (909, NULL, 29, '花雕酒', NULL, NULL, 73.90, NULL, '100ml', NULL, 100.00, 5.30, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (910, NULL, 29, '青梅酒', NULL, NULL, 78.20, NULL, '100ml', NULL, 100.00, 5.60, 0.60, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (911, NULL, 29, '杨梅酒', NULL, NULL, 75.10, NULL, '100g', 100.00, 100.00, 5.40, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (912, NULL, 29, '桑葚酒', NULL, NULL, 76.20, NULL, '100ml', NULL, 100.00, 5.40, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (913, NULL, 29, '桂花酒', NULL, NULL, 74.50, NULL, '100ml', NULL, 100.00, 5.30, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (914, NULL, 29, '玫瑰酒', NULL, NULL, 70.20, NULL, '100ml', NULL, 100.00, 5.00, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (915, NULL, 29, '鸡尾酒预调', NULL, NULL, 72.50, NULL, '100ml', NULL, 100.00, 5.20, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (916, NULL, 29, '果味啤酒', NULL, NULL, 71.80, NULL, '100ml', NULL, 100.00, 5.10, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (917, NULL, 29, '西打酒', NULL, NULL, 66.60, NULL, '100g', 100.00, 100.00, 4.80, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (918, NULL, 29, '米酒酿', NULL, NULL, 78.00, NULL, '100ml', NULL, 100.00, 5.60, 0.60, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (919, NULL, 29, '甜酒酿', NULL, NULL, 63.10, NULL, '100g', 100.00, 100.00, 4.50, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (920, NULL, 29, '醪糟汁', NULL, NULL, 76.70, NULL, '100g', 100.00, 100.00, 5.50, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (921, NULL, 29, '低度果酒', NULL, NULL, 68.00, NULL, '100g', 100.00, 100.00, 4.90, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (922, NULL, 29, '柚子酒', NULL, NULL, 62.00, NULL, '100ml', NULL, 100.00, 4.40, 0.40, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (923, NULL, 29, '柠檬酒', NULL, NULL, 67.00, NULL, '100g', 100.00, 100.00, 4.80, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (924, NULL, 29, '草莓酒', NULL, NULL, 74.00, NULL, '100ml', NULL, 100.00, 5.30, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (925, NULL, 29, '菠萝酒', NULL, NULL, 63.20, NULL, '100g', 100.00, 100.00, 4.50, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (926, NULL, 29, '椰子酒', NULL, NULL, 70.80, NULL, '100ml', NULL, 100.00, 5.10, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (927, NULL, 29, '无醇啤酒', NULL, NULL, 75.10, NULL, '100g', 100.00, 100.00, 5.40, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (928, NULL, 29, '无醇葡萄酒', NULL, NULL, 75.80, NULL, '100ml', NULL, 100.00, 5.40, 0.50, 0.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (929, NULL, 30, '生抽', NULL, NULL, 160.40, NULL, '100ml', NULL, 100.00, 19.60, 3.60, 7.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (930, NULL, 30, '老抽', NULL, NULL, 173.30, NULL, '100g', 100.00, 100.00, 21.20, 3.90, 7.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (931, NULL, 30, '蚝油', NULL, NULL, 166.30, NULL, '100g', 100.00, 100.00, 20.30, 3.70, 7.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (932, NULL, 30, '香醋', NULL, NULL, 168.90, NULL, '100g', 100.00, 100.00, 20.60, 3.80, 7.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (933, NULL, 30, '陈醋', NULL, NULL, 179.90, NULL, '100ml', NULL, 100.00, 22.00, 4.00, 8.00, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (934, NULL, 30, '米醋', NULL, NULL, 169.50, NULL, '100ml', NULL, 100.00, 20.70, 3.80, 7.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (935, NULL, 30, '料酒', NULL, NULL, 194.30, NULL, '100g', 100.00, 100.00, 23.80, 4.30, 8.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (936, NULL, 30, '番茄酱', NULL, NULL, 174.30, NULL, '100ml', NULL, 100.00, 21.30, 3.90, 7.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (937, NULL, 30, '沙拉酱', NULL, NULL, 183.50, NULL, '100g', 100.00, 100.00, 22.40, 4.10, 8.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (938, NULL, 30, '蛋黄酱', NULL, NULL, 171.50, NULL, '100ml', NULL, 100.00, 21.00, 3.80, 7.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (939, NULL, 30, '辣椒酱', NULL, NULL, 182.90, NULL, '100ml', NULL, 100.00, 22.40, 4.10, 8.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (940, NULL, 30, '蒜蓉酱', NULL, NULL, 184.70, NULL, '100g', 100.00, 100.00, 22.60, 4.10, 8.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (941, NULL, 30, '花椒油', NULL, NULL, 171.70, NULL, '100ml', NULL, 100.00, 21.00, 3.80, 7.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (942, NULL, 30, '芝麻油', NULL, NULL, 158.90, NULL, '100g', 100.00, 100.00, 19.40, 3.50, 7.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (943, NULL, 30, '藤椒油', NULL, NULL, 184.80, NULL, '100g', 100.00, 100.00, 22.60, 4.10, 8.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (944, NULL, 30, '咖喱块', NULL, NULL, 177.30, NULL, '100g', 100.00, 100.00, 21.70, 3.90, 7.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (945, NULL, 30, '火锅底料', NULL, NULL, 190.30, NULL, '100ml', NULL, 100.00, 23.30, 4.20, 8.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (946, NULL, 30, '郫县豆瓣', NULL, NULL, 169.50, NULL, '100ml', NULL, 100.00, 20.70, 3.80, 7.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (947, NULL, 30, '老干妈', NULL, NULL, 201.30, NULL, '100g', 100.00, 100.00, 24.60, 4.50, 8.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (948, NULL, 30, '榨菜丝', NULL, NULL, 177.90, NULL, '100ml', NULL, 100.00, 21.70, 4.00, 7.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (949, NULL, 30, '泡菜韩式', NULL, NULL, 189.00, NULL, '100ml', NULL, 100.00, 23.10, 4.20, 8.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (950, NULL, 30, '酸菜鱼料', NULL, NULL, 160.10, NULL, '100ml', NULL, 100.00, 19.60, 3.60, 7.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (951, NULL, 30, '酸豆角', NULL, NULL, 170.20, NULL, '100ml', NULL, 100.00, 20.80, 3.80, 7.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (952, NULL, 30, '橄榄菜', NULL, NULL, 194.40, NULL, '100g', 100.00, 100.00, 23.80, 4.30, 8.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (953, NULL, 30, '腐乳红', NULL, NULL, 193.90, NULL, '100g', 100.00, 100.00, 23.70, 4.30, 8.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (954, NULL, 30, '腐乳白', NULL, NULL, 190.70, NULL, '100g', 100.00, 100.00, 23.30, 4.20, 8.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (955, NULL, 30, '虾酱', NULL, NULL, 201.30, NULL, '100ml', NULL, 100.00, 24.60, 4.50, 8.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (956, NULL, 30, '蟹酱', NULL, NULL, 195.30, NULL, '100ml', NULL, 100.00, 23.90, 4.30, 8.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (957, NULL, 30, '鱼露', NULL, NULL, 173.90, NULL, '100ml', NULL, 100.00, 21.20, 3.90, 7.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (958, NULL, 30, '柠檬汁调料', NULL, NULL, 159.60, NULL, '100g', 100.00, 100.00, 19.50, 3.50, 7.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (959, NULL, 30, '黑胡椒碎', NULL, NULL, 182.00, NULL, '100g', 100.00, 100.00, 22.20, 4.00, 8.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (960, NULL, 30, '五香粉', NULL, NULL, 186.60, NULL, '100ml', NULL, 100.00, 22.80, 4.10, 8.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (961, NULL, 31, '薯片原味', NULL, NULL, 435.60, NULL, '100g', 100.00, 100.00, 55.70, 8.10, 20.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (962, NULL, 31, '薯片番茄', NULL, NULL, 444.50, NULL, '100g', 100.00, 100.00, 56.90, 8.30, 20.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (963, NULL, 31, '薯片烧烤', NULL, NULL, 406.50, NULL, '100g', 100.00, 100.00, 52.00, 7.60, 18.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (964, NULL, 31, '虾条', NULL, NULL, 442.90, NULL, '100g', 100.00, 100.00, 56.60, 8.20, 20.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (965, NULL, 31, '米饼', NULL, NULL, 414.80, NULL, '100g', 100.00, 100.00, 53.10, 7.70, 19.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (966, NULL, 31, '仙贝', NULL, NULL, 395.70, NULL, '100g', 100.00, 100.00, 50.60, 7.40, 18.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (967, NULL, 31, '锅巴', NULL, NULL, 399.60, NULL, '100g', 100.00, 100.00, 51.10, 7.40, 18.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (968, NULL, 31, '爆米花', NULL, NULL, 428.00, NULL, '100g', 100.00, 100.00, 54.70, 8.00, 19.90, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (969, NULL, 31, '瓜子五香', NULL, NULL, 460.70, NULL, '100g', 100.00, 100.00, 58.90, 8.60, 21.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (970, NULL, 31, '瓜子焦糖', NULL, NULL, 399.00, NULL, '100g', 100.00, 100.00, 51.00, 7.40, 18.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (971, NULL, 31, '牛肉粒', NULL, NULL, 441.20, NULL, '100g', 100.00, 100.00, 56.40, 8.20, 20.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (972, NULL, 31, '猪肉丝', NULL, NULL, 382.10, NULL, '100g', 100.00, 100.00, 48.90, 7.10, 17.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (973, NULL, 31, '鱿鱼丝', NULL, NULL, 475.60, NULL, '100g', 100.00, 100.00, 60.80, 8.80, 22.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (974, NULL, 31, '海苔片', NULL, NULL, 421.40, NULL, '100g', 100.00, 100.00, 53.90, 7.80, 19.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (975, NULL, 31, '海苔卷', NULL, NULL, 443.70, NULL, '100g', 100.00, 100.00, 56.80, 8.30, 20.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (976, NULL, 31, '话梅', NULL, NULL, 397.10, NULL, '100g', 100.00, 100.00, 50.80, 7.40, 18.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (977, NULL, 31, '陈皮梅', NULL, NULL, 435.30, NULL, '100g', 100.00, 100.00, 55.70, 8.10, 20.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (978, NULL, 31, '山楂片', NULL, NULL, 417.20, NULL, '100g', 100.00, 100.00, 53.40, 7.80, 19.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (979, NULL, 31, '果丹皮', NULL, NULL, 439.60, NULL, '100g', 100.00, 100.00, 56.20, 8.20, 20.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (980, NULL, 31, '果冻杯零食', NULL, NULL, 413.90, NULL, '100g', 100.00, 100.00, 52.90, 7.70, 19.20, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (981, NULL, 31, '软糖', NULL, NULL, 388.90, NULL, '100g', 100.00, 100.00, 49.70, 7.20, 18.10, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (982, NULL, 31, '硬糖', NULL, NULL, 394.10, NULL, '100g', 100.00, 100.00, 50.40, 7.30, 18.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (983, NULL, 31, '巧克力块', NULL, NULL, 444.20, NULL, '100g', 100.00, 100.00, 56.80, 8.30, 20.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (984, NULL, 31, '麦丽素', NULL, NULL, 396.40, NULL, '100g', 100.00, 100.00, 50.70, 7.40, 18.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (985, NULL, 31, '威化饼干', NULL, NULL, 436.60, NULL, '100g', 100.00, 100.00, 55.80, 8.10, 20.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (986, NULL, 31, '夹心饼干', NULL, NULL, 395.00, NULL, '100g', 100.00, 100.00, 50.50, 7.30, 18.40, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (987, NULL, 31, '干脆面', NULL, NULL, 480.10, NULL, '100g', 100.00, 100.00, 61.40, 8.90, 22.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (988, NULL, 31, '辣条', NULL, NULL, 445.80, NULL, '100g', 100.00, 100.00, 57.00, 8.30, 20.70, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (989, NULL, 31, '素肉零食', NULL, NULL, 404.50, NULL, '100g', 100.00, 100.00, 51.70, 7.50, 18.80, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (990, NULL, 31, '蔬菜脆片', NULL, NULL, 379.10, NULL, '100g', 100.00, 100.00, 48.50, 7.10, 17.60, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (991, NULL, 31, '香蕉片', NULL, NULL, 436.60, NULL, '100g', 100.00, 100.00, 55.80, 8.10, 20.30, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');
INSERT INTO `food` VALUES (992, NULL, 31, '苹果干', NULL, NULL, 462.60, NULL, '100g', 100.00, 100.00, 59.20, 8.60, 21.50, NULL, 0, 1, '2026-04-02 04:33:38', '2026-04-04 15:08:26');

-- ----------------------------
-- Table structure for food_category
-- ----------------------------
DROP TABLE IF EXISTS `food_category`;
CREATE TABLE `food_category`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint UNSIGNED NULL DEFAULT NULL,
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'common' COMMENT 'system/brand/common/custom',
  `sort_no` int NOT NULL DEFAULT 0,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_food_category_name`(`name` ASC) USING BTREE,
  INDEX `idx_food_category_parent`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of food_category
-- ----------------------------
INSERT INTO `food_category` VALUES (1, '主食', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (2, '杂粮粗粮', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (3, '畜肉类', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (4, '禽肉类', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (5, '加工肉制品', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (6, '蛋类制品', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (7, '牛乳发酵乳', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (8, '新鲜水果', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (9, '叶花菜类', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (10, '根茎茄果', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (11, '菌藻类', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (12, '鲜豆制品', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (13, '干豆面筋', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (14, '树坚果籽', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (15, '淡水鱼鲜', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (16, '海水鱼鲜', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (17, '虾蟹贝类', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (18, '头足软体', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (19, '汤煲炖品', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (20, '粥品糊类', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (21, '火锅串串', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (22, '油炸烧烤', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (23, '西式轻食', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (24, '日韩料理', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (25, '东南亚菜', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (26, '烘焙糕点', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (27, '冷饮冰品', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (28, '即饮茶咖', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (29, '酒类低度', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (30, '酱腌调味', NULL, 'common', 0, 1);
INSERT INTO `food_category` VALUES (31, '休闲零食', NULL, 'common', 0, 1);

-- ----------------------------
-- Table structure for food_library_legacy
-- ----------------------------
DROP TABLE IF EXISTS `food_library_legacy`;
CREATE TABLE `food_library_legacy`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `calories_per_100` decimal(8, 2) NOT NULL,
  `protein` decimal(8, 2) NULL DEFAULT NULL,
  `fat` decimal(8, 2) NULL DEFAULT NULL,
  `carbs` decimal(8, 2) NULL DEFAULT NULL,
  `unit_label` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `category` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_food_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 993 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of food_library_legacy
-- ----------------------------
INSERT INTO `food_library_legacy` VALUES (1, '白米饭', 263.90, 7.50, 2.80, 49.00, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (2, '糙米饭', 274.60, 7.80, 2.90, 51.00, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (3, '二米饭', 296.40, 8.50, 3.20, 55.10, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (4, '紫米饭', 289.00, 8.30, 3.10, 53.70, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (5, '燕麦饭', 267.60, 7.60, 2.90, 49.70, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (6, '藜麦饭', 285.40, 8.20, 3.10, 53.00, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (7, '小米饭', 253.80, 7.30, 2.70, 47.10, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (8, '黑米饭', 301.80, 8.60, 3.20, 56.10, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (9, '糯米饭', 302.00, 8.60, 3.20, 56.10, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (10, '蛋炒饭', 297.90, 8.50, 3.20, 55.30, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (11, '扬州炒饭', 294.40, 8.40, 3.20, 54.70, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (12, '腊肠煲仔饭', 311.20, 8.90, 3.30, 57.80, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (13, '卤肉饭', 279.90, 8.00, 3.00, 52.00, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (14, '鸡排饭', 259.00, 7.40, 2.80, 48.10, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (15, '肥牛饭', 275.70, 7.90, 3.00, 51.20, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (16, '鳗鱼饭', 269.70, 7.70, 2.90, 50.10, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (17, '寿司饭', 276.80, 7.90, 3.00, 51.40, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (18, '石锅拌饭', 282.20, 8.10, 3.00, 52.40, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (19, '炒河粉', 255.30, 7.30, 2.70, 47.40, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (20, '炒米粉', 263.30, 7.50, 2.80, 48.90, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (21, '炒面', 305.90, 8.70, 3.30, 56.80, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (22, '葱油拌面', 257.80, 7.40, 2.80, 47.90, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (23, '炸酱面', 278.70, 8.00, 3.00, 51.80, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (24, '牛肉面', 264.50, 7.60, 2.80, 49.10, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (25, '热干面', 279.20, 8.00, 3.00, 51.80, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (26, '刀削面', 293.60, 8.40, 3.10, 54.50, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (27, '螺蛳粉', 279.90, 8.00, 3.00, 52.00, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (28, '酸辣粉', 308.90, 8.80, 3.30, 57.40, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (29, '米线', 289.90, 8.30, 3.10, 53.80, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (30, '凉皮', 289.70, 8.30, 3.10, 53.80, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (31, '全麦吐司', 292.00, 8.30, 3.10, 54.20, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (32, '手抓饼', 312.80, 8.90, 3.40, 58.10, '100g', '主食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (33, '燕麦片', 321.80, 8.80, 3.40, 58.50, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (34, '黑麦片', 367.10, 10.00, 3.90, 66.80, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (35, '荞麦米', 320.20, 8.70, 3.40, 58.20, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (36, '高粱米', 361.00, 9.80, 3.80, 65.60, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (37, '薏仁米', 294.80, 8.00, 3.10, 53.60, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (38, '红米', 346.50, 9.50, 3.70, 63.00, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (39, '黑米', 312.00, 8.50, 3.30, 56.70, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (40, '青稞米', 314.70, 8.60, 3.30, 57.20, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (41, '小麦胚芽', 352.00, 9.60, 3.70, 64.00, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (42, '藜麦粒', 298.90, 8.20, 3.20, 54.30, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (43, '糙米', 302.90, 8.30, 3.20, 55.10, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (44, '胚芽米', 290.90, 7.90, 3.10, 52.90, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (45, '玉米糁', 293.00, 8.00, 3.10, 53.30, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (46, '小米', 294.20, 8.00, 3.10, 53.50, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (47, '大黄米', 319.70, 8.70, 3.40, 58.10, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (48, '紫糯米', 325.30, 8.90, 3.40, 59.10, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (49, '血糯米', 339.40, 9.30, 3.60, 61.70, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (50, '野米', 295.40, 8.10, 3.10, 53.70, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (51, '大麦仁', 290.50, 7.90, 3.10, 52.80, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (52, '小麦仁', 299.10, 8.20, 3.20, 54.40, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (53, '鹰嘴豆', 337.10, 9.20, 3.60, 61.30, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (54, '红小豆', 326.50, 8.90, 3.50, 59.40, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (55, '绿豆', 301.70, 8.20, 3.20, 54.90, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (56, '黑豆', 355.50, 9.70, 3.80, 64.60, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (57, '花芸豆', 345.60, 9.40, 3.70, 62.80, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (58, '白芸豆', 332.90, 9.10, 3.50, 60.50, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (59, '扁豆', 348.40, 9.50, 3.70, 63.30, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (60, '蚕豆', 330.10, 9.00, 3.50, 60.00, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (61, '豌豆', 338.80, 9.20, 3.60, 61.60, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (62, '豇豆', 332.30, 9.10, 3.50, 60.40, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (63, '芡实粒', 292.60, 8.00, 3.10, 53.20, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (64, '莲子米', 321.50, 8.80, 3.40, 58.50, '100g', '杂粮粗粮', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (65, '猪里脊', 191.80, 21.10, 11.50, 1.00, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (66, '猪五花肉', 189.50, 20.80, 11.40, 0.90, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (67, '猪梅花肉', 218.40, 24.00, 13.10, 1.10, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (68, '猪排骨', 213.60, 23.50, 12.80, 1.10, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (69, '猪蹄', 177.10, 19.50, 10.60, 0.90, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (70, '猪肝', 193.20, 21.20, 11.60, 1.00, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (71, '猪心', 179.50, 19.70, 10.80, 0.90, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (72, '猪肚', 191.60, 21.10, 11.50, 1.00, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (73, '猪腰', 182.50, 20.10, 11.00, 0.90, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (74, '肥肠', 211.80, 23.30, 12.70, 1.10, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (75, '牛腩', 184.70, 20.30, 11.10, 0.90, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (76, '牛腱', 185.50, 20.40, 11.10, 0.90, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (77, '牛排', 183.40, 20.20, 11.00, 0.90, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (78, '肥牛卷', 223.50, 24.60, 13.40, 1.10, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (79, '牛舌', 221.30, 24.30, 13.30, 1.10, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (80, '牛百叶', 183.50, 20.20, 11.00, 0.90, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (81, '羊排', 181.70, 20.00, 10.90, 0.90, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (82, '羊腿肉', 222.70, 24.50, 13.40, 1.10, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (83, '羊蝎子', 194.10, 21.30, 11.60, 1.00, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (84, '羊肉串肉', 199.30, 21.90, 12.00, 1.00, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (85, '培根', 195.10, 21.50, 11.70, 1.00, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (86, '火腿片', 214.60, 23.60, 12.90, 1.10, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (87, '腊肠', 215.00, 23.60, 12.90, 1.10, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (88, '腊肉', 205.20, 22.60, 12.30, 1.00, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (89, '酱肘子', 187.40, 20.60, 11.20, 0.90, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (90, '蒜泥白肉', 197.10, 21.70, 11.80, 1.00, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (91, '回锅肉', 200.90, 22.10, 12.10, 1.00, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (92, '东坡肉', 222.90, 24.50, 13.40, 1.10, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (93, '糖醋里脊', 207.10, 22.80, 12.40, 1.00, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (94, '小炒肉', 215.10, 23.70, 12.90, 1.10, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (95, '酱牛肉', 221.70, 24.40, 13.30, 1.10, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (96, '卤牛肉', 188.00, 20.70, 11.30, 0.90, '100g', '畜肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (97, '鸡胸肉', 172.00, 23.60, 7.90, 2.00, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (98, '鸡腿肉', 192.30, 26.40, 8.80, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (99, '鸡翅中', 173.30, 23.80, 7.90, 2.00, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (100, '鸡翅根', 189.70, 26.00, 8.70, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (101, '鸡爪', 167.30, 22.90, 7.60, 1.90, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (102, '鸡胗', 193.90, 26.60, 8.90, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (103, '鸡心', 167.90, 23.00, 7.70, 1.90, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (104, '整鸡', 177.40, 24.30, 8.10, 2.00, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (105, '乌鸡', 184.00, 25.20, 8.40, 2.10, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (106, '鸭胸', 190.90, 26.20, 8.70, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (107, '鸭腿', 191.30, 26.20, 8.70, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (108, '鸭翅', 186.30, 25.50, 8.50, 2.10, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (109, '鸭掌', 169.00, 23.20, 7.70, 1.90, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (110, '老鸭', 157.70, 21.60, 7.20, 1.80, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (111, '鹅胸', 181.70, 24.90, 8.30, 2.10, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (112, '鹅腿', 194.90, 26.70, 8.90, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (113, '鸽子肉', 188.70, 25.90, 8.60, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (114, '鹌鹑', 193.50, 26.50, 8.80, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (115, '火鸡胸', 184.80, 25.30, 8.40, 2.10, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (116, '口水鸡', 186.00, 25.50, 8.50, 2.10, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (117, '白切鸡', 192.90, 26.50, 8.80, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (118, '盐焗鸡', 186.90, 25.60, 8.50, 2.10, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (119, '辣子鸡丁', 183.00, 25.10, 8.40, 2.10, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (120, '宫保鸡丁', 189.90, 26.00, 8.70, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (121, '黄焖鸡', 162.00, 22.20, 7.40, 1.90, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (122, '可乐鸡翅', 166.70, 22.90, 7.60, 1.90, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (123, '照烧鸡腿', 178.50, 24.50, 8.20, 2.00, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (124, '香酥鸭', 168.60, 23.10, 7.70, 1.90, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (125, '啤酒鸭', 194.60, 26.70, 8.90, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (126, '姜母鸭', 192.00, 26.30, 8.80, 2.20, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (127, '烧鹅', 177.50, 24.30, 8.10, 2.00, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (128, '卤鸭脖', 170.20, 23.30, 7.80, 1.90, '100g', '禽肉类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (129, '午餐肉', 262.70, 14.10, 20.20, 8.10, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (130, '火腿肠', 259.50, 14.00, 20.00, 8.00, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (131, '脆皮肠', 266.80, 14.40, 20.50, 8.20, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (132, '台湾烤肠', 280.60, 15.10, 21.60, 8.60, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (133, '广味腊肠', 257.20, 13.90, 19.80, 7.90, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (134, '香肠', 283.30, 15.30, 21.80, 8.70, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (135, '血肠', 254.50, 13.70, 19.60, 7.80, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (136, '红肠', 258.20, 13.90, 19.90, 7.90, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (137, '哈尔滨红肠', 275.60, 14.80, 21.20, 8.50, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (138, '培根碎', 242.10, 13.00, 18.60, 7.50, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (139, '火腿丁', 262.30, 14.10, 20.20, 8.10, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (140, '肉松', 267.70, 14.40, 20.60, 8.20, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (141, '肉脯', 260.40, 14.00, 20.00, 8.00, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (142, '牛肉干', 244.50, 13.20, 18.80, 7.50, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (143, '猪肉脯', 271.90, 14.60, 20.90, 8.40, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (144, '鸡肉肠', 231.70, 12.50, 17.80, 7.10, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (145, '鱼肠', 272.80, 14.70, 21.00, 8.40, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (146, '蟹棒', 230.80, 12.40, 17.80, 7.10, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (147, '仿蟹柳', 263.80, 14.20, 20.30, 8.10, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (148, '鱼豆腐串料', 239.20, 12.90, 18.40, 7.40, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (149, '贡丸', 245.00, 13.20, 18.80, 7.50, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (150, '冷鲜撒尿丸', 265.30, 14.30, 20.40, 8.20, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (151, '关东煮包心丸', 267.30, 14.40, 20.60, 8.20, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (152, '虾滑丸', 285.90, 15.40, 22.00, 8.80, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (153, '甜不辣', 287.80, 15.50, 22.10, 8.90, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (154, '燕饺', 230.90, 12.40, 17.80, 7.10, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (155, '速冻蛋饺', 240.70, 13.00, 18.50, 7.40, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (156, '午餐肉罐头', 233.00, 12.50, 17.90, 7.20, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (157, '咸肉', 271.10, 14.60, 20.90, 8.30, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (158, '风肉', 262.40, 14.10, 20.20, 8.10, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (159, '酱排骨罐头', 290.70, 15.70, 22.40, 8.90, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (160, '卤汁牛肉罐头', 284.40, 15.30, 21.90, 8.80, '100g', '加工肉制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (161, '鸡蛋', 137.50, 11.90, 9.20, 1.80, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (162, '鸭蛋', 133.30, 11.60, 8.90, 1.80, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (163, '鹌鹑蛋', 163.50, 14.20, 10.90, 2.20, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (164, '皮蛋', 159.10, 13.80, 10.60, 2.10, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (165, '咸鸭蛋', 165.90, 14.40, 11.10, 2.20, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (166, '鸽子蛋', 148.50, 12.90, 9.90, 2.00, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (167, '鹅蛋', 162.10, 14.10, 10.80, 2.20, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (168, '荷包蛋', 165.60, 14.40, 11.00, 2.20, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (169, '水煮蛋', 139.60, 12.10, 9.30, 1.90, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (170, '茶叶蛋', 147.80, 12.80, 9.90, 2.00, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (171, '溏心蛋', 157.20, 13.60, 10.50, 2.10, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (172, '蒸蛋羹', 133.10, 11.50, 8.90, 1.80, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (173, '番茄炒蛋', 152.00, 13.20, 10.10, 2.00, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (174, '韭菜炒蛋', 136.80, 11.90, 9.10, 1.80, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (175, '苦瓜炒蛋', 159.10, 13.80, 10.60, 2.10, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (176, '洋葱炒蛋', 166.20, 14.40, 11.10, 2.20, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (177, '虾仁滑蛋', 163.30, 14.20, 10.90, 2.20, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (178, '蛋花汤', 137.00, 11.90, 9.10, 1.80, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (179, '厚蛋烧', 149.50, 13.00, 10.00, 2.00, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (180, '玉子烧', 164.50, 14.30, 11.00, 2.20, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (181, '苏格兰蛋', 158.60, 13.70, 10.60, 2.10, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (182, '虎皮蛋', 157.60, 13.70, 10.50, 2.10, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (183, '卤蛋', 162.10, 14.10, 10.80, 2.20, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (184, '铁蛋', 146.30, 12.70, 9.80, 2.00, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (185, '变蛋', 164.70, 14.30, 11.00, 2.20, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (186, '毛蛋', 136.50, 11.80, 9.10, 1.80, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (187, '蛋饺', 152.30, 13.20, 10.20, 2.00, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (188, '蛋卷', 143.30, 12.40, 9.60, 1.90, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (189, '鸡蛋布丁', 154.20, 13.40, 10.30, 2.10, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (190, '蛋奶炖', 150.00, 13.00, 10.00, 2.00, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (191, '蛋包饭', 164.20, 14.20, 10.90, 2.20, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (192, '蛋挞芯', 153.60, 13.30, 10.20, 2.00, '100g', '蛋类制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (193, '全脂牛奶', 65.90, 3.60, 3.60, 5.10, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (194, '脱脂牛奶', 58.50, 3.20, 3.20, 4.50, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (195, '低脂牛奶', 70.60, 3.80, 3.80, 5.40, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (196, '鲜牛奶', 69.80, 3.80, 3.80, 5.40, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (197, '水牛奶', 57.70, 3.10, 3.10, 4.40, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (198, '羊奶', 61.00, 3.30, 3.30, 4.70, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (199, '酸奶', 61.50, 3.30, 3.30, 4.70, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (200, '希腊酸奶', 71.90, 3.90, 3.90, 5.50, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (201, '老酸奶', 68.20, 3.70, 3.70, 5.20, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (202, '风味酸奶', 61.50, 3.30, 3.30, 4.70, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (203, '奶酪片', 57.90, 3.10, 3.10, 4.50, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (204, '马苏里拉', 63.70, 3.40, 3.40, 4.90, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (205, '切达奶酪', 66.40, 3.60, 3.60, 5.10, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (206, '奶油奶酪', 65.60, 3.50, 3.50, 5.00, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (207, '炼乳', 65.30, 3.50, 3.50, 5.00, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (208, '淡奶油', 63.30, 3.40, 3.40, 4.90, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (209, '黄油', 71.40, 3.80, 3.80, 5.50, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (210, '奶豆腐', 63.40, 3.40, 3.40, 4.90, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (211, '双皮奶', 68.60, 3.70, 3.70, 5.30, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (212, '姜撞奶', 70.50, 3.80, 3.80, 5.40, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (213, '奶茶', 65.40, 3.50, 3.50, 5.00, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (214, '奶昔', 67.70, 3.60, 3.60, 5.20, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (215, '芝士奶盖', 72.10, 3.90, 3.90, 5.50, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (216, '牛奶布丁', 60.40, 3.30, 3.30, 4.60, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (217, '奶粉冲饮', 62.40, 3.40, 3.40, 4.80, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (218, '冰博克', 63.00, 3.40, 3.40, 4.80, '100g', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (219, '酪乳', 57.40, 3.10, 3.10, 4.40, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (220, '开菲尔', 68.60, 3.70, 3.70, 5.30, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (221, '酸奶疙瘩', 61.30, 3.30, 3.30, 4.70, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (222, '乳扇', 69.80, 3.80, 3.80, 5.40, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (223, '奶皮子', 65.30, 3.50, 3.50, 5.00, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (224, '奶嚼口', 61.00, 3.30, 3.30, 4.70, '100ml', '牛乳发酵乳', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (225, '苹果', 58.40, 0.80, 0.30, 13.80, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (226, '青苹果', 60.40, 0.90, 0.30, 14.30, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (227, '香蕉', 57.80, 0.80, 0.30, 13.70, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (228, '芭蕉', 60.60, 0.90, 0.30, 14.30, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (229, '橙子', 51.50, 0.70, 0.30, 12.20, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (230, '血橙', 57.10, 0.80, 0.30, 13.50, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (231, '柚子', 59.60, 0.90, 0.30, 14.10, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (232, '葡萄柚', 58.60, 0.90, 0.30, 13.90, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (233, '柠檬', 55.70, 0.80, 0.30, 13.20, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (234, '青柠', 48.70, 0.70, 0.30, 11.50, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (235, '西瓜', 48.80, 0.70, 0.30, 11.50, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (236, '哈密瓜', 60.00, 0.90, 0.30, 14.20, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (237, '甜瓜', 56.90, 0.80, 0.30, 13.50, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (238, '香瓜', 52.00, 0.80, 0.30, 12.30, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (239, '草莓', 51.50, 0.70, 0.30, 12.20, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (240, '蓝莓', 52.90, 0.80, 0.30, 12.50, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (241, '黑莓', 61.20, 0.90, 0.30, 14.50, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (242, '树莓', 60.40, 0.90, 0.30, 14.30, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (243, '樱桃', 49.40, 0.70, 0.30, 11.70, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (244, '车厘子', 56.00, 0.80, 0.30, 13.20, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (245, '葡萄', 51.40, 0.70, 0.30, 12.20, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (246, '提子', 53.70, 0.80, 0.30, 12.70, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (247, '猕猴桃', 54.60, 0.80, 0.30, 12.90, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (248, '火龙果', 50.30, 0.70, 0.30, 11.90, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (249, '芒果', 52.80, 0.80, 0.30, 12.50, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (250, '木瓜', 59.00, 0.90, 0.30, 13.90, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (251, '菠萝', 58.60, 0.90, 0.30, 13.90, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (252, '凤梨', 59.80, 0.90, 0.30, 14.10, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (253, '榴莲', 60.20, 0.90, 0.30, 14.20, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (254, '山竹', 50.80, 0.70, 0.30, 12.00, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (255, '荔枝', 57.60, 0.80, 0.30, 13.60, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (256, '龙眼', 55.30, 0.80, 0.30, 13.10, '100g', '新鲜水果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (257, '生菜', 24.10, 2.20, 0.30, 4.40, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (258, '菠菜', 20.50, 1.90, 0.30, 3.70, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (259, '油菜', 23.10, 2.10, 0.30, 4.20, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (260, '小白菜', 20.40, 1.90, 0.30, 3.70, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (261, '大白菜', 19.40, 1.80, 0.30, 3.50, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (262, '娃娃菜', 20.70, 1.90, 0.30, 3.80, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (263, '芹菜', 20.00, 1.80, 0.30, 3.60, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (264, '西芹', 21.30, 1.90, 0.30, 3.90, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (265, '韭菜', 22.60, 2.10, 0.30, 4.10, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (266, '芥蓝', 21.20, 1.90, 0.30, 3.90, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (267, '菜心', 22.50, 2.00, 0.30, 4.10, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (268, '空心菜', 22.80, 2.10, 0.30, 4.10, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (269, '木耳菜', 23.30, 2.10, 0.30, 4.20, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (270, '番薯叶', 20.10, 1.80, 0.30, 3.70, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (271, '油麦菜', 23.90, 2.20, 0.30, 4.30, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (272, '茼蒿', 19.90, 1.80, 0.30, 3.60, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (273, '香菜', 21.20, 1.90, 0.30, 3.90, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (274, '茴香苗', 20.30, 1.80, 0.30, 3.70, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (275, '豌豆苗', 19.60, 1.80, 0.30, 3.60, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (276, '萝卜缨', 20.40, 1.90, 0.30, 3.70, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (277, '苦菊', 19.70, 1.80, 0.30, 3.60, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (278, '芝麻菜', 22.00, 2.00, 0.30, 4.00, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (279, '羽衣甘蓝', 24.00, 2.20, 0.30, 4.40, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (280, '球茎甘蓝', 19.50, 1.80, 0.30, 3.60, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (281, '花椰菜', 21.90, 2.00, 0.30, 4.00, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (282, '西兰花', 20.70, 1.90, 0.30, 3.80, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (283, '黄花菜', 20.70, 1.90, 0.30, 3.80, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (284, '槐花', 21.70, 2.00, 0.30, 4.00, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (285, '南瓜花', 22.40, 2.00, 0.30, 4.10, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (286, '朝鲜蓟', 22.70, 2.10, 0.30, 4.10, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (287, '西洋菜', 19.70, 1.80, 0.30, 3.60, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (288, '荠菜', 24.40, 2.20, 0.30, 4.40, '100g', '叶花菜类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (289, '番茄', 38.80, 1.70, 0.20, 7.80, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (290, '黄瓜', 31.50, 1.30, 0.20, 6.30, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (291, '茄子', 38.20, 1.60, 0.20, 7.60, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (292, '青椒', 37.10, 1.60, 0.20, 7.40, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (293, '尖椒', 33.70, 1.40, 0.20, 6.70, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (294, '彩椒', 37.10, 1.60, 0.20, 7.40, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (295, '土豆', 36.70, 1.60, 0.20, 7.30, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (296, '红薯', 38.80, 1.70, 0.20, 7.80, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (297, '紫薯', 31.00, 1.30, 0.20, 6.20, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (298, '山药', 33.30, 1.40, 0.20, 6.70, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (299, '莲藕', 31.90, 1.40, 0.20, 6.40, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (300, '芋头', 34.30, 1.50, 0.20, 6.90, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (301, '魔芋', 31.60, 1.40, 0.20, 6.30, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (302, '白萝卜', 32.00, 1.40, 0.20, 6.40, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (303, '胡萝卜', 38.30, 1.60, 0.20, 7.70, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (304, '青萝卜', 32.80, 1.40, 0.20, 6.60, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (305, '樱桃萝卜', 35.50, 1.50, 0.20, 7.10, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (306, '洋葱', 35.10, 1.50, 0.20, 7.00, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (307, '大葱', 35.80, 1.50, 0.20, 7.20, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (308, '大蒜', 38.20, 1.60, 0.20, 7.60, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (309, '生姜', 34.70, 1.50, 0.20, 6.90, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (310, '芦笋', 38.10, 1.60, 0.20, 7.60, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (311, '莴笋', 35.30, 1.50, 0.20, 7.10, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (312, '竹笋', 34.20, 1.50, 0.20, 6.80, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (313, '玉米笋', 34.30, 1.50, 0.20, 6.90, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (314, '秋葵', 37.40, 1.60, 0.20, 7.50, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (315, '冬瓜', 37.60, 1.60, 0.20, 7.50, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (316, '南瓜', 37.00, 1.60, 0.20, 7.40, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (317, '丝瓜', 39.00, 1.70, 0.20, 7.80, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (318, '苦瓜', 35.70, 1.50, 0.20, 7.10, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (319, '佛手瓜', 37.40, 1.60, 0.20, 7.50, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (320, '菱角', 31.70, 1.40, 0.20, 6.30, '100g', '根茎茄果', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (321, '金针菇', 27.90, 2.80, 0.50, 4.70, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (322, '香菇', 28.50, 2.80, 0.50, 4.70, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (323, '平菇', 28.80, 2.90, 0.50, 4.80, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (324, '杏鲍菇', 29.90, 3.00, 0.50, 5.00, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (325, '口蘑', 32.80, 3.30, 0.50, 5.50, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (326, '白玉菇', 31.80, 3.20, 0.50, 5.30, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (327, '蟹味菇', 27.60, 2.80, 0.50, 4.60, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (328, '茶树菇', 31.90, 3.20, 0.50, 5.30, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (329, '猴头菇', 33.40, 3.30, 0.60, 5.60, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (330, '木耳', 29.20, 2.90, 0.50, 4.90, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (331, '银耳', 32.80, 3.30, 0.50, 5.50, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (332, '竹荪', 26.80, 2.70, 0.40, 4.50, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (333, '羊肚菌', 27.50, 2.80, 0.50, 4.60, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (334, '牛肝菌', 27.90, 2.80, 0.50, 4.70, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (335, '鸡枞菌', 33.40, 3.30, 0.60, 5.60, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (336, '松茸', 29.30, 2.90, 0.50, 4.90, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (337, '海带', 33.50, 3.40, 0.60, 5.60, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (338, '紫菜', 27.50, 2.70, 0.50, 4.60, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (339, '裙带菜', 28.90, 2.90, 0.50, 4.80, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (340, '海白菜', 31.50, 3.10, 0.50, 5.20, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (341, '石花菜', 27.60, 2.80, 0.50, 4.60, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (342, '龙须菜', 28.70, 2.90, 0.50, 4.80, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (343, '发菜', 31.50, 3.20, 0.50, 5.30, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (344, '葛仙米', 30.50, 3.00, 0.50, 5.10, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (345, '螺旋藻粉', 32.80, 3.30, 0.50, 5.50, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (346, '昆布', 30.70, 3.10, 0.50, 5.10, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (347, '海茸', 26.60, 2.70, 0.40, 4.40, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (348, '海带头', 27.70, 2.80, 0.50, 4.60, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (349, '海带结', 32.40, 3.20, 0.50, 5.40, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (350, '海蜇皮', 30.50, 3.00, 0.50, 5.10, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (351, '海蜇头', 26.60, 2.70, 0.40, 4.40, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (352, '江蓠', 28.60, 2.90, 0.50, 4.80, '100g', '菌藻类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (353, '嫩豆腐', 85.80, 9.00, 4.50, 3.60, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (354, '老豆腐', 103.70, 10.90, 5.50, 4.40, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (355, '内酯豆腐', 96.30, 10.10, 5.10, 4.10, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (356, '冻豆腐', 105.10, 11.10, 5.50, 4.40, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (357, '豆腐泡', 101.10, 10.60, 5.30, 4.30, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (358, '鲜豆皮', 104.70, 11.00, 5.50, 4.40, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (359, '千张', 85.70, 9.00, 4.50, 3.60, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (360, '腐竹段', 96.50, 10.20, 5.10, 4.10, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (361, '素鸡', 97.10, 10.20, 5.10, 4.10, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (362, '素火腿', 101.30, 10.70, 5.30, 4.30, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (363, '豆浆', 90.70, 9.60, 4.80, 3.80, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (364, '无糖豆浆', 100.00, 10.50, 5.30, 4.20, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (365, '黑豆豆浆', 85.60, 9.00, 4.50, 3.60, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (366, '豆腐脑', 91.70, 9.70, 4.80, 3.90, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (367, '咸豆花', 99.30, 10.50, 5.20, 4.20, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (368, '甜豆花', 83.80, 8.80, 4.40, 3.50, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (369, '鲜腐竹', 97.20, 10.20, 5.10, 4.10, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (370, '油豆腐', 100.70, 10.60, 5.30, 4.20, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (371, '兰花干', 96.00, 10.10, 5.10, 4.00, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (372, '豆皮卷', 96.40, 10.10, 5.10, 4.10, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (373, '腐竹结', 100.10, 10.50, 5.30, 4.20, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (374, '豆腐丸子', 87.60, 9.20, 4.60, 3.70, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (375, '天贝鲜品', 98.60, 10.40, 5.20, 4.10, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (376, '豆花鱼底料豆花', 103.70, 10.90, 5.50, 4.40, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (377, '嫩豆干', 90.40, 9.50, 4.80, 3.80, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (378, '五香豆干', 105.80, 11.10, 5.60, 4.50, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (379, '茶干', 98.50, 10.40, 5.20, 4.10, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (380, '白干', 85.50, 9.00, 4.50, 3.60, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (381, '素肥肠', 95.30, 10.00, 5.00, 4.00, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (382, '素肚', 86.30, 9.10, 4.50, 3.60, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (383, '素腰花', 88.40, 9.30, 4.70, 3.70, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (384, '豆纤丝', 90.40, 9.50, 4.80, 3.80, '100g', '鲜豆制品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (385, '干黄豆', 410.30, 37.80, 13.00, 43.20, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (386, '干黑豆', 350.00, 32.20, 11.10, 36.80, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (387, '干绿豆', 368.10, 33.90, 11.60, 38.80, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (388, '干红豆', 403.30, 37.10, 12.70, 42.50, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (389, '干芸豆', 419.70, 38.70, 13.30, 44.20, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (390, '干扁豆', 381.90, 35.20, 12.10, 40.20, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (391, '干蚕豆', 392.80, 36.20, 12.40, 41.30, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (392, '腐竹干', 345.40, 31.80, 10.90, 36.40, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (393, '豆皮干', 409.70, 37.70, 12.90, 43.10, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (394, '面筋', 340.60, 31.40, 10.80, 35.90, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (395, '烤麸', 411.30, 37.90, 13.00, 43.30, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (396, '油面筋', 387.40, 35.70, 12.20, 40.80, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (397, '素鸡干', 366.10, 33.70, 11.60, 38.50, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (398, '豆筋棍', 390.70, 36.00, 12.30, 41.10, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (399, '豆丝', 352.20, 32.40, 11.10, 37.10, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (400, '豆结', 369.50, 34.00, 11.70, 38.90, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (401, '纳豆', 398.40, 36.70, 12.60, 41.90, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (402, '豆豉', 351.40, 32.40, 11.10, 37.00, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (403, '味噌', 359.90, 33.10, 11.40, 37.90, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (404, '豆瓣酱', 354.40, 32.60, 11.20, 37.30, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (405, '黄豆酱', 408.30, 37.60, 12.90, 43.00, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (406, '甜面酱', 380.40, 35.00, 12.00, 40.00, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (407, '豆腐乳', 393.70, 36.30, 12.40, 41.40, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (408, '臭豆腐乳', 381.20, 35.10, 12.00, 40.10, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (409, '素肉干', 383.50, 35.30, 12.10, 40.40, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (410, '蛋白干', 382.90, 35.30, 12.10, 40.30, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (411, '组织蛋白', 414.10, 38.10, 13.10, 43.60, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (412, '拉丝蛋白', 423.90, 39.00, 13.40, 44.60, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (413, '豆奶粉', 391.50, 36.10, 12.40, 41.20, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (414, '黑豆浆粉', 368.70, 34.00, 11.60, 38.80, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (415, '青豆仁干', 335.00, 30.90, 10.60, 35.30, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (416, '豌豆仁干', 419.60, 38.60, 13.20, 44.20, '100g', '干豆面筋', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (417, '核桃', 645.60, 20.00, 55.70, 22.30, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (418, '碧根果', 609.50, 18.90, 52.50, 21.00, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (419, '夏威夷果', 621.00, 19.30, 53.50, 21.40, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (420, '巴旦木', 541.70, 16.80, 46.70, 18.70, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (421, '杏仁', 575.40, 17.90, 49.60, 19.80, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (422, '腰果', 563.00, 17.50, 48.50, 19.40, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (423, '开心果', 542.60, 16.80, 46.80, 18.70, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (424, '松子', 567.50, 17.60, 48.90, 19.60, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (425, '榛子', 548.00, 17.00, 47.20, 18.90, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (426, '板栗', 529.30, 16.40, 45.60, 18.30, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (427, '花生', 625.40, 19.40, 53.90, 21.60, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (428, '南瓜子', 550.40, 17.10, 47.40, 19.00, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (429, '葵花籽', 638.50, 19.80, 55.00, 22.00, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (430, '西瓜子', 573.20, 17.80, 49.40, 19.80, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (431, '芝麻', 528.90, 16.40, 45.60, 18.20, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (432, '奇亚籽', 556.00, 17.30, 47.90, 19.20, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (433, '亚麻籽', 515.80, 16.00, 44.50, 17.80, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (434, '火麻仁', 631.20, 19.60, 54.40, 21.80, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (435, '葡萄籽', 565.00, 17.50, 48.70, 19.50, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (436, '莲子', 530.60, 16.50, 45.70, 18.30, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (437, '芡实', 528.40, 16.40, 45.50, 18.20, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (438, '混合坚果', 541.70, 16.80, 46.70, 18.70, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (439, '盐焗腰果', 639.20, 19.80, 55.10, 22.00, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (440, '琥珀核桃', 584.00, 18.10, 50.30, 20.10, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (441, '五香花生', 616.20, 19.10, 53.10, 21.20, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (442, '焦糖杏仁', 512.10, 15.90, 44.10, 17.70, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (443, '椰枣', 557.40, 17.30, 48.10, 19.20, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (444, '山核桃', 579.00, 18.00, 49.90, 20.00, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (445, '香榧', 598.80, 18.60, 51.60, 20.60, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (446, '鲍鱼果', 512.30, 15.90, 44.20, 17.70, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (447, '霹雳果', 645.40, 20.00, 55.60, 22.30, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (448, '炭烧腰果', 528.30, 16.40, 45.50, 18.20, '100g', '树坚果籽', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (449, '鲫鱼', 116.20, 18.60, 3.70, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (450, '鲤鱼', 131.30, 21.00, 4.20, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (451, '草鱼', 138.10, 22.10, 4.40, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (452, '青鱼', 136.40, 21.80, 4.40, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (453, '鲢鱼', 131.00, 21.00, 4.20, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (454, '鳙鱼', 113.10, 18.10, 3.60, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (455, '黑鱼', 122.30, 19.60, 3.90, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (456, '鳜鱼', 131.90, 21.10, 4.20, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (457, '鲶鱼', 118.50, 19.00, 3.80, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (458, '黄颡鱼', 117.90, 18.90, 3.80, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (459, '武昌鱼', 114.10, 18.30, 3.70, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (460, '白条鱼', 130.20, 20.80, 4.20, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (461, '翘嘴鲌', 126.40, 20.20, 4.00, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (462, '鲈鱼淡', 112.90, 18.10, 3.60, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (463, '鳗鱼淡', 112.00, 17.90, 3.60, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (464, '泥鳅', 115.10, 18.40, 3.70, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (465, '黄鳝', 131.30, 21.00, 4.20, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (466, '白鳝', 120.70, 19.30, 3.90, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (467, '鲟鱼肉', 137.40, 22.00, 4.40, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (468, '虹鳟', 123.70, 19.80, 4.00, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (469, '罗非鱼', 110.40, 17.70, 3.50, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (470, '淡水鲈鱼', 130.10, 20.80, 4.20, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (471, '太阳鱼', 121.40, 19.40, 3.90, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (472, '军鱼', 138.80, 22.20, 4.40, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (473, '鲮鱼', 111.50, 17.80, 3.60, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (474, '银鱼', 130.90, 20.90, 4.20, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (475, '刀鱼江鲜', 112.60, 18.00, 3.60, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (476, '河豚处理品', 132.70, 21.20, 4.20, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (477, '胖头鱼头', 127.60, 20.40, 4.10, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (478, '鲤鱼籽', 116.40, 18.60, 3.70, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (479, '鲫鱼汤料鱼', 112.90, 18.10, 3.60, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (480, '草鱼块', 112.90, 18.10, 3.60, 0.00, '100g', '淡水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (481, '三文鱼', 141.50, 19.20, 6.40, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (482, '鳕鱼', 162.40, 22.00, 7.30, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (483, '带鱼', 149.20, 20.20, 6.70, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (484, '黄鱼', 144.20, 19.50, 6.50, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (485, '海鲈鱼', 168.20, 22.80, 7.60, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (486, '石斑鱼', 166.90, 22.60, 7.50, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (487, '比目鱼', 152.70, 20.70, 6.90, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (488, '多宝鱼', 149.70, 20.30, 6.80, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (489, '巴沙鱼', 151.10, 20.50, 6.80, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (490, '龙利鱼', 152.20, 20.60, 6.90, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (491, '金枪鱼', 171.90, 23.30, 7.80, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (492, '鲭鱼', 143.10, 19.40, 6.50, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (493, '秋刀鱼', 141.20, 19.10, 6.40, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (494, '沙丁鱼', 138.90, 18.80, 6.30, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (495, '马鲛鱼', 167.40, 22.70, 7.60, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (496, '鲳鱼', 163.60, 22.20, 7.40, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (497, '红衫鱼', 144.70, 19.60, 6.50, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (498, '剥皮鱼', 157.20, 21.30, 7.10, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (499, '魔鬼鱼', 173.40, 23.50, 7.80, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (500, '银鲳', 159.10, 21.60, 7.20, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (501, '金鲳鱼', 149.30, 20.20, 6.70, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (502, '海鳗鱼', 139.00, 18.80, 6.30, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (503, '河豚海', 142.40, 19.30, 6.40, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (504, '鱼排海', 169.90, 23.00, 7.70, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (505, '鱼头海', 144.90, 19.60, 6.50, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (506, '鱼腩', 140.90, 19.10, 6.40, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (507, '鱼柳', 152.40, 20.60, 6.90, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (508, '鱼滑海', 167.20, 22.70, 7.60, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (509, '鱼丸海', 147.60, 20.00, 6.70, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (510, '鱼皮海', 173.00, 23.40, 7.80, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (511, '凤尾鱼', 140.40, 19.00, 6.30, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (512, '池鱼', 145.50, 19.70, 6.60, 0.00, '100g', '海水鱼鲜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (513, '对虾', 86.20, 16.30, 1.80, 2.70, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (514, '基围虾', 91.80, 17.40, 1.90, 2.90, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (515, '明虾', 100.20, 19.00, 2.10, 3.20, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (516, '北极甜虾', 88.40, 16.70, 1.90, 2.80, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (517, '小龙虾', 103.80, 19.70, 2.20, 3.30, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (518, '皮皮虾', 87.00, 16.50, 1.80, 2.70, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (519, '河虾', 88.80, 16.80, 1.90, 2.80, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (520, '草虾', 93.90, 17.80, 2.00, 3.00, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (521, '黑虎虾', 93.60, 17.70, 2.00, 3.00, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (522, '阿根廷红虾', 92.40, 17.50, 1.90, 2.90, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (523, '波士顿龙虾', 85.50, 16.20, 1.80, 2.70, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (524, '青蟹', 101.50, 19.20, 2.10, 3.20, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (525, '大闸蟹', 97.40, 18.50, 2.10, 3.10, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (526, '梭子蟹', 89.30, 16.90, 1.90, 2.80, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (527, '花蟹', 105.80, 20.10, 2.20, 3.30, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (528, '帝王蟹腿', 97.40, 18.50, 2.10, 3.10, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (529, '生蚝', 87.00, 16.50, 1.80, 2.70, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (530, '扇贝', 90.00, 17.10, 1.90, 2.80, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (531, '蛤蜊', 101.60, 19.20, 2.10, 3.20, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (532, '花蛤', 103.30, 19.60, 2.20, 3.30, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (533, '蛏子', 90.00, 17.10, 1.90, 2.80, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (534, '青口贝', 93.10, 17.60, 2.00, 2.90, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (535, '海瓜子', 85.10, 16.10, 1.80, 2.70, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (536, '海螺片', 103.00, 19.50, 2.20, 3.30, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (537, '鲍鱼', 92.10, 17.40, 1.90, 2.90, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (538, '象拔蚌', 98.30, 18.60, 2.10, 3.10, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (539, '北极贝', 97.10, 18.40, 2.00, 3.10, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (540, '带子', 85.00, 16.10, 1.80, 2.70, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (541, '海胆黄', 84.70, 16.10, 1.80, 2.70, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (542, '海参刺参', 104.80, 19.90, 2.20, 3.30, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (543, '海蜇丝拌虾', 91.00, 17.20, 1.90, 2.90, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (544, '虾仁仁', 90.40, 17.10, 1.90, 2.90, '100g', '虾蟹贝类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (545, '鱿鱼须', 88.70, 16.70, 2.10, 4.20, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (546, '鱿鱼圈', 86.70, 16.30, 2.00, 4.10, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (547, '鱿鱼花', 76.20, 14.30, 1.80, 3.60, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (548, '整鱿鱼', 94.00, 17.70, 2.20, 4.40, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (549, '墨鱼仔', 88.30, 16.60, 2.10, 4.20, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (550, '墨鱼丸', 92.30, 17.40, 2.20, 4.30, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (551, '墨鱼滑', 79.60, 15.00, 1.90, 3.70, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (552, '章鱼足', 83.30, 15.70, 2.00, 3.90, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (553, '小章鱼', 83.10, 15.60, 2.00, 3.90, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (554, '八爪鱼', 81.00, 15.30, 1.90, 3.80, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (555, '海兔', 82.60, 15.60, 1.90, 3.90, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (556, '笔管鱼', 81.00, 15.20, 1.90, 3.80, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (557, '柔鱼', 79.30, 14.90, 1.90, 3.70, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (558, '锁管', 79.40, 14.90, 1.90, 3.70, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (559, '乌贼片', 88.00, 16.60, 2.10, 4.10, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (560, '花枝丸', 92.90, 17.50, 2.20, 4.40, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (561, '墨鱼面', 83.80, 15.80, 2.00, 3.90, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (562, '鱿鱼丝零食料', 84.20, 15.80, 2.00, 4.00, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (563, '烤鱿鱼板', 80.10, 15.10, 1.90, 3.80, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (564, '铁板鱿鱼', 75.80, 14.30, 1.80, 3.60, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (565, '酱爆鱿鱼', 83.10, 15.60, 2.00, 3.90, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (566, '芥末章鱼', 77.50, 14.60, 1.80, 3.60, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (567, '章鱼小丸子料', 76.80, 14.50, 1.80, 3.60, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (568, '墨鱼汁面', 83.40, 15.70, 2.00, 3.90, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (569, '海鲜拼盘鱿', 76.10, 14.30, 1.80, 3.60, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (570, '三去鱿鱼', 79.30, 14.90, 1.90, 3.70, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (571, '开背鱿鱼', 89.30, 16.80, 2.10, 4.20, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (572, '龙须菜拌鱿', 92.90, 17.50, 2.20, 4.40, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (573, '紫苏鱿', 77.90, 14.70, 1.80, 3.70, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (574, '蒜香鱿', 78.40, 14.80, 1.80, 3.70, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (575, '照烧鱿', 75.50, 14.20, 1.80, 3.60, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (576, '咖喱鱿', 80.60, 15.20, 1.90, 3.80, '100g', '头足软体', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (577, '排骨汤', 56.80, 4.10, 2.60, 5.20, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (578, '鸡汤', 60.10, 4.40, 2.70, 5.50, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (579, '老鸭汤', 55.20, 4.00, 2.50, 5.00, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (580, '牛腩汤', 61.40, 4.50, 2.80, 5.60, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (581, '羊肉汤', 56.00, 4.10, 2.50, 5.10, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (582, '鱼汤白', 53.60, 3.90, 2.40, 4.90, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (583, '豆腐汤', 50.10, 3.60, 2.30, 4.60, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (584, '番茄蛋汤', 54.30, 3.90, 2.50, 4.90, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (585, '紫菜蛋汤', 52.80, 3.80, 2.40, 4.80, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (586, '冬瓜排骨汤', 59.50, 4.30, 2.70, 5.40, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (587, '莲藕排骨汤', 55.70, 4.10, 2.50, 5.10, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (588, '玉米排骨汤', 53.90, 3.90, 2.40, 4.90, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (589, '猪肚鸡汤', 53.20, 3.90, 2.40, 4.80, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (590, '花胶鸡汤', 56.90, 4.10, 2.60, 5.20, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (591, '佛跳墙', 55.30, 4.00, 2.50, 5.00, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (592, '羊肉泡馍汤', 61.00, 4.40, 2.80, 5.50, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (593, '酸萝卜老鸭汤', 58.70, 4.30, 2.70, 5.30, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (594, '山药排骨汤', 54.10, 3.90, 2.50, 4.90, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (595, '银耳莲子汤', 56.30, 4.10, 2.60, 5.10, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (596, '绿豆汤', 56.00, 4.10, 2.50, 5.10, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (597, '红豆汤', 52.40, 3.80, 2.40, 4.80, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (598, '酒酿圆子汤', 54.20, 3.90, 2.50, 4.90, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (599, '味噌汤', 57.20, 4.20, 2.60, 5.20, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (600, '海带排骨汤', 55.40, 4.00, 2.50, 5.00, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (601, '萝卜牛腩煲', 60.90, 4.40, 2.80, 5.50, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (602, '黄豆猪蹄汤', 60.10, 4.40, 2.70, 5.50, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (603, '木瓜鲫鱼汤', 50.90, 3.70, 2.30, 4.60, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (604, '花旗参鸡汤', 58.70, 4.30, 2.70, 5.30, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (605, '椰子鸡汤', 50.20, 3.70, 2.30, 4.60, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (606, '沙参玉竹汤', 52.10, 3.80, 2.40, 4.70, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (607, '霸王花汤', 50.90, 3.70, 2.30, 4.60, '100ml', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (608, '西洋菜猪骨汤', 56.90, 4.10, 2.60, 5.20, '100g', '汤煲炖品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (609, '白粥', 77.80, 2.60, 1.20, 14.50, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (610, '小米粥', 72.10, 2.40, 1.20, 13.40, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (611, '燕麦粥', 79.80, 2.70, 1.30, 14.90, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (612, '杂粮粥', 78.00, 2.60, 1.20, 14.60, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (613, '皮蛋瘦肉粥', 69.00, 2.30, 1.10, 12.90, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (614, '鱼片粥', 75.80, 2.50, 1.20, 14.10, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (615, '海鲜粥', 68.30, 2.30, 1.10, 12.70, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (616, '南瓜粥', 77.70, 2.60, 1.20, 14.50, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (617, '红薯粥', 74.60, 2.50, 1.20, 13.90, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (618, '绿豆粥', 83.30, 2.80, 1.30, 15.50, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (619, '红豆粥', 81.70, 2.70, 1.30, 15.30, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (620, '八宝粥', 73.90, 2.50, 1.20, 13.80, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (621, '美龄粥', 75.50, 2.50, 1.20, 14.10, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (622, '青菜粥', 78.30, 2.60, 1.30, 14.60, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (623, '排骨粥', 73.20, 2.40, 1.20, 13.70, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (624, '艇仔粥', 77.90, 2.60, 1.20, 14.50, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (625, '及第粥', 77.10, 2.60, 1.20, 14.40, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (626, '咸骨粥', 76.20, 2.50, 1.20, 14.20, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (627, '生滚粥底', 70.50, 2.40, 1.10, 13.20, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (628, '糊辣汤', 79.20, 2.60, 1.30, 14.80, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (629, '芝麻糊', 68.80, 2.30, 1.10, 12.80, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (630, '核桃糊', 80.40, 2.70, 1.30, 15.00, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (631, '花生糊', 74.10, 2.50, 1.20, 13.80, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (632, '杏仁糊', 73.30, 2.40, 1.20, 13.70, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (633, '藕粉', 73.90, 2.50, 1.20, 13.80, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (634, '葛根粉', 79.50, 2.60, 1.30, 14.80, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (635, '山药糊', 83.50, 2.80, 1.30, 15.60, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (636, '玉米糊', 76.10, 2.50, 1.20, 14.20, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (637, '米稀', 78.70, 2.60, 1.30, 14.70, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (638, '婴儿米糊', 75.50, 2.50, 1.20, 14.10, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (639, '代餐粥', 77.90, 2.60, 1.20, 14.50, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (640, '即食燕麦糊', 66.20, 2.20, 1.10, 12.40, '100g', '粥品糊类', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (641, '雪花肥牛卷', 234.00, 15.60, 15.60, 8.90, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (642, '羊肉卷', 199.50, 13.30, 13.30, 7.60, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (643, '乌鸡卷', 221.20, 14.70, 14.70, 8.40, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (644, '午餐肉火锅', 192.50, 12.80, 12.80, 7.30, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (645, '撒尿牛丸', 205.20, 13.70, 13.70, 7.80, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (646, '包心鱼丸', 197.80, 13.20, 13.20, 7.50, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (647, '虾滑', 232.40, 15.50, 15.50, 8.90, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (648, '蟹柳火锅', 194.80, 13.00, 13.00, 7.40, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (649, '黄喉', 208.00, 13.90, 13.90, 7.90, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (650, '毛肚', 185.40, 12.40, 12.40, 7.10, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (651, '百叶', 209.00, 13.90, 13.90, 8.00, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (652, '鸭肠', 203.40, 13.60, 13.60, 7.70, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (653, '鹅肠', 216.50, 14.40, 14.40, 8.20, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (654, '脑花', 225.00, 15.00, 15.00, 8.60, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (655, '腰片', 222.40, 14.80, 14.80, 8.50, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (656, '嫩肉片', 209.10, 13.90, 13.90, 8.00, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (657, '酥肉', 188.00, 12.50, 12.50, 7.20, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (658, '小郡肝', 217.20, 14.50, 14.50, 8.30, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (659, '串串牛肉', 219.50, 14.60, 14.60, 8.40, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (660, '串串郡把', 185.00, 12.30, 12.30, 7.00, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (661, '火锅宽粉', 205.70, 13.70, 13.70, 7.80, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (662, '火锅川粉', 211.50, 14.10, 14.10, 8.10, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (663, '火锅年糕', 189.70, 12.60, 12.60, 7.20, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (664, '火锅油条', 222.60, 14.80, 14.80, 8.50, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (665, '火锅腐竹', 212.00, 14.10, 14.10, 8.10, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (666, '火锅豆皮', 201.20, 13.40, 13.40, 7.70, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (667, '火锅菌菇拼', 214.50, 14.30, 14.30, 8.20, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (668, '火锅菠菜', 202.70, 13.50, 13.50, 7.70, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (669, '火锅茼蒿', 190.40, 12.70, 12.70, 7.30, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (670, '火锅娃娃菜', 187.00, 12.50, 12.50, 7.10, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (671, '火锅冻豆腐', 211.80, 14.10, 14.10, 8.10, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (672, '火锅魔芋结', 190.70, 12.70, 12.70, 7.30, '100g', '火锅串串', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (673, '炸鸡腿', 272.70, 11.50, 17.20, 19.10, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (674, '炸鸡翅', 297.50, 12.50, 18.80, 20.90, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (675, '炸鸡排', 273.10, 11.50, 17.20, 19.20, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (676, '炸猪排', 296.70, 12.50, 18.70, 20.80, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (677, '炸鱼排', 262.80, 11.10, 16.60, 18.40, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (678, '炸薯条', 252.50, 10.60, 15.90, 17.70, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (679, '炸洋葱圈', 262.60, 11.10, 16.60, 18.40, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (680, '炸春卷', 289.80, 12.20, 18.30, 20.30, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (681, '炸麻花', 310.20, 13.10, 19.60, 21.80, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (682, '炸油条', 297.40, 12.50, 18.80, 20.90, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (683, '炸糖糕', 315.00, 13.30, 19.90, 22.10, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (684, '炸鲜奶', 299.80, 12.60, 18.90, 21.00, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (685, '炸臭豆腐', 305.30, 12.90, 19.30, 21.40, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (686, '烤羊肉串', 257.40, 10.80, 16.30, 18.10, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (687, '烤牛肉串', 266.00, 11.20, 16.80, 18.70, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (688, '烤五花肉串', 274.80, 11.60, 17.40, 19.30, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (689, '烤鸡翅串', 278.40, 11.70, 17.60, 19.50, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (690, '烤生蚝', 313.10, 13.20, 19.80, 22.00, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (691, '烤茄子', 283.90, 12.00, 17.90, 19.90, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (692, '烤韭菜', 312.10, 13.10, 19.70, 21.90, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (693, '烤馒头片', 278.90, 11.70, 17.60, 19.60, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (694, '烤面筋', 259.20, 10.90, 16.40, 18.20, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (695, '烤鱿鱼串', 313.00, 13.20, 19.80, 22.00, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (696, '烤秋刀鱼', 294.50, 12.40, 18.60, 20.70, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (697, '烤羊腰', 268.30, 11.30, 16.90, 18.80, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (698, '烤板筋', 252.10, 10.60, 15.90, 17.70, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (699, '烤鸡心', 316.70, 13.30, 20.00, 22.20, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (700, '烤猪蹄', 288.00, 12.10, 18.20, 20.20, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (701, '烤鸭胗', 275.80, 11.60, 17.40, 19.40, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (702, '铁板牛排', 311.30, 13.10, 19.70, 21.80, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (703, '夜市铁板鱿', 256.20, 10.80, 16.20, 18.00, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (704, '香酥鸡柳', 311.30, 13.10, 19.70, 21.80, '100g', '油炸烧烤', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (705, '凯撒沙拉', 132.10, 11.30, 5.70, 11.30, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (706, '田园沙拉', 140.00, 12.00, 6.00, 12.00, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (707, '鸡胸肉沙拉', 151.00, 12.90, 6.50, 12.90, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (708, '金枪鱼沙拉', 149.60, 12.80, 6.40, 12.80, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (709, '藜麦沙拉', 151.30, 13.00, 6.50, 13.00, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (710, '牛油果吐司', 131.90, 11.30, 5.70, 11.30, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (711, '全麦三明治', 123.90, 10.60, 5.30, 10.60, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (712, '火腿三明治', 125.80, 10.80, 5.40, 10.80, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (713, '牛肉汉堡', 150.70, 12.90, 6.50, 12.90, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (714, '鸡肉汉堡', 150.40, 12.90, 6.40, 12.90, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (715, '意面番茄肉酱', 141.10, 12.10, 6.00, 12.10, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (716, '意面奶油培根', 137.60, 11.80, 5.90, 11.80, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (717, '奶油蘑菇汤', 147.40, 12.60, 6.30, 12.60, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (718, '罗宋汤', 134.60, 11.50, 5.80, 11.50, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (719, '土豆泥', 156.00, 13.40, 6.70, 13.40, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (720, '烤时蔬', 151.00, 12.90, 6.50, 12.90, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (721, '牛排配芦笋', 156.40, 13.40, 6.70, 13.40, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (722, '鱼排配柠檬', 156.50, 13.40, 6.70, 13.40, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (723, '能量碗', 155.60, 13.30, 6.70, 13.30, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (724, '波奇饭', 153.10, 13.10, 6.60, 13.10, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (725, '墨西哥卷饼', 126.20, 10.80, 5.40, 10.80, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (726, '塔可饼', 128.60, 11.00, 5.50, 11.00, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (727, '芝士焗饭', 140.10, 12.00, 6.00, 12.00, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (728, '焗薯泥', 129.20, 11.10, 5.50, 11.10, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (729, '法式洋葱汤', 123.80, 10.60, 5.30, 10.60, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (730, '西班牙海鲜饭', 152.10, 13.00, 6.50, 13.00, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (731, '希腊沙拉', 142.80, 12.20, 6.10, 12.20, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (732, '尼斯沙拉', 132.90, 11.40, 5.70, 11.40, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (733, '华尔道夫沙拉', 136.50, 11.70, 5.90, 11.70, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (734, '科布沙拉', 124.00, 10.60, 5.30, 10.60, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (735, '蛋白棒餐', 134.80, 11.60, 5.80, 11.60, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (736, '代餐奶昔粉餐', 131.10, 11.20, 5.60, 11.20, '100g', '西式轻食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (737, '寿司卷', 168.20, 11.20, 6.10, 18.40, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (738, '刺身拼盘', 176.00, 11.70, 6.40, 19.20, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (739, '日式拉面', 145.70, 9.70, 5.30, 15.90, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (740, '味噌拉面', 148.90, 9.90, 5.40, 16.20, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (741, '天妇罗虾', 165.90, 11.10, 6.00, 18.10, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (742, '天妇罗蔬', 182.20, 12.10, 6.60, 19.90, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (743, '日式咖喱饭', 159.50, 10.60, 5.80, 17.40, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (744, '亲子丼', 172.30, 11.50, 6.30, 18.80, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (745, '牛丼', 145.60, 9.70, 5.30, 15.90, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (746, '猪排饭日式', 182.20, 12.10, 6.60, 19.90, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (747, '茶泡饭', 162.70, 10.80, 5.90, 17.80, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (748, '纳豆饭', 174.60, 11.60, 6.30, 19.00, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (749, '日式汉堡排', 173.50, 11.60, 6.30, 18.90, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (750, '寿喜烧', 166.90, 11.10, 6.10, 18.20, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (751, '大阪烧', 159.20, 10.60, 5.80, 17.40, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (752, '章鱼烧', 181.60, 12.10, 6.60, 19.80, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (753, '日式土豆炖肉', 154.60, 10.30, 5.60, 16.90, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (754, '韩式拌饭', 169.20, 11.30, 6.20, 18.50, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (755, '石锅拌饭韩式', 156.80, 10.50, 5.70, 17.10, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (756, '韩式冷面', 150.80, 10.10, 5.50, 16.50, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (757, '韩式炸酱面', 171.60, 11.40, 6.20, 18.70, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (758, '部队锅', 165.50, 11.00, 6.00, 18.10, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (759, '韩式烤肉', 152.30, 10.20, 5.50, 16.60, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (760, '辣炒年糕', 151.40, 10.10, 5.50, 16.50, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (761, '韩式煎饼', 173.60, 11.60, 6.30, 18.90, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (762, '泡菜汤', 156.20, 10.40, 5.70, 17.00, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (763, '大酱汤', 169.20, 11.30, 6.20, 18.50, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (764, '海带汤韩式', 152.50, 10.20, 5.50, 16.60, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (765, '参鸡汤', 160.60, 10.70, 5.80, 17.50, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (766, '韩式鸡爪锅', 170.80, 11.40, 6.20, 18.60, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (767, '鱼饼串', 172.70, 11.50, 6.30, 18.80, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (768, '米肠', 171.70, 11.40, 6.20, 18.70, '100g', '日韩料理', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (769, '冬阴功汤', 141.00, 9.70, 6.80, 14.60, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (770, '泰式绿咖喱', 158.00, 10.90, 7.60, 16.30, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (771, '泰式红咖喱', 160.30, 11.10, 7.70, 16.60, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (772, '黄咖喱鸡', 131.10, 9.00, 6.30, 13.60, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (773, '泰式炒河粉', 161.10, 11.10, 7.80, 16.70, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (774, '芒果糯米饭', 136.30, 9.40, 6.60, 14.10, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (775, '越南河粉', 134.90, 9.30, 6.50, 14.00, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (776, '越南春卷', 135.20, 9.30, 6.50, 14.00, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (777, '老挝米粉', 150.20, 10.40, 7.30, 15.50, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (778, '新加坡叻沙', 145.90, 10.10, 7.00, 15.10, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (779, '肉骨茶', 142.10, 9.80, 6.90, 14.70, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (780, '海南鸡饭', 157.60, 10.90, 7.60, 16.30, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (781, '印尼炒饭', 143.50, 9.90, 6.90, 14.80, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (782, '沙爹串', 147.50, 10.20, 7.10, 15.30, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (783, '椰浆饭', 137.70, 9.50, 6.60, 14.20, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (784, '巴东牛肉', 130.00, 9.00, 6.30, 13.40, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (785, '青木瓜沙拉', 133.80, 9.20, 6.50, 13.80, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (786, '泰式打抛猪', 141.70, 9.80, 6.80, 14.70, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (787, '柠檬蒸鱼', 158.60, 10.90, 7.70, 16.40, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (788, '香茅烤鸡', 143.60, 9.90, 6.90, 14.90, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (789, '越式法棍', 143.80, 9.90, 6.90, 14.90, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (790, '柬埔寨 amok', 148.50, 10.20, 7.20, 15.40, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (791, '缅甸茶叶沙拉', 145.70, 10.00, 7.00, 15.10, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (792, '菲律宾 adobo', 136.90, 9.40, 6.60, 14.20, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (793, '马来炒面', 141.60, 9.80, 6.80, 14.60, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (794, '新加坡辣椒蟹', 150.20, 10.40, 7.30, 15.50, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (795, '泰式奶茶', 149.20, 10.30, 7.20, 15.40, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (796, '越南滴漏咖啡', 155.00, 10.70, 7.50, 16.00, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (797, '拉茶', 156.30, 10.80, 7.50, 16.20, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (798, '珍多冰', 138.00, 9.50, 6.70, 14.30, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (799, '摩摩喳喳', 151.10, 10.40, 7.30, 15.60, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (800, '煎蕊', 154.70, 10.70, 7.50, 16.00, '100g', '东南亚菜', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (801, '戚风蛋糕', 398.00, 7.30, 18.90, 50.30, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (802, '芝士蛋糕', 402.90, 7.40, 19.10, 50.90, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (803, '提拉米苏', 422.30, 7.80, 20.00, 53.30, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (804, '慕斯蛋糕', 382.50, 7.00, 18.10, 48.30, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (805, '瑞士卷', 385.30, 7.10, 18.20, 48.70, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (806, '牛角包', 410.10, 7.60, 19.40, 51.80, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (807, '菠萝包', 402.70, 7.40, 19.10, 50.90, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (808, '肉松面包', 384.70, 7.10, 18.20, 48.60, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (809, '吐司切片', 347.60, 6.40, 16.50, 43.90, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (810, '甜甜圈', 415.50, 7.70, 19.70, 52.50, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (811, '马卡龙', 401.00, 7.40, 19.00, 50.70, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (812, '泡芙', 356.20, 6.60, 16.90, 45.00, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (813, '蛋挞', 369.50, 6.80, 17.50, 46.70, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (814, '曲奇饼干', 354.00, 6.50, 16.80, 44.70, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (815, '苏打饼干', 373.90, 6.90, 17.70, 47.20, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (816, '华夫饼', 399.10, 7.40, 18.90, 50.40, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (817, '松饼', 388.90, 7.20, 18.40, 49.10, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (818, '司康饼', 381.70, 7.00, 18.10, 48.20, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (819, '布朗尼', 354.60, 6.50, 16.80, 44.80, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (820, '磅蛋糕', 405.30, 7.50, 19.20, 51.20, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (821, '拿破仑酥', 386.30, 7.10, 18.30, 48.80, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (822, '蝴蝶酥', 415.60, 7.70, 19.70, 52.50, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (823, '绿豆糕', 397.50, 7.30, 18.80, 50.20, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (824, '桂花糕', 385.70, 7.10, 18.30, 48.70, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (825, '马蹄糕', 370.90, 6.80, 17.60, 46.80, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (826, '老婆饼', 359.10, 6.60, 17.00, 45.40, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (827, '蛋黄酥', 344.00, 6.30, 16.30, 43.40, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (828, '鲜花饼', 395.70, 7.30, 18.70, 50.00, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (829, '麻花甜', 372.80, 6.90, 17.70, 47.10, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (830, '沙琪玛', 366.20, 6.70, 17.30, 46.30, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (831, '月饼广式', 371.60, 6.80, 17.60, 46.90, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (832, '月饼苏式', 387.00, 7.10, 18.30, 48.90, '100g', '烘焙糕点', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (833, '香草冰淇淋', 183.30, 2.80, 8.50, 24.40, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (834, '巧克力冰淇淋', 212.90, 3.30, 9.80, 28.40, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (835, '草莓冰淇淋', 193.40, 3.00, 8.90, 25.80, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (836, '抹茶冰淇淋', 195.00, 3.00, 9.00, 26.00, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (837, '芒果冰沙', 194.80, 3.00, 9.00, 26.00, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (838, '红豆冰', 207.90, 3.20, 9.60, 27.70, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (839, '绿豆冰', 209.10, 3.20, 9.60, 27.90, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (840, '冰粉', 186.00, 2.90, 8.60, 24.80, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (841, '烧仙草', 203.00, 3.10, 9.40, 27.10, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (842, '四果汤', 184.20, 2.80, 8.50, 24.60, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (843, '杨枝甘露', 173.80, 2.70, 8.00, 23.20, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (844, '双皮奶冻', 181.60, 2.80, 8.40, 24.20, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (845, '奶昔冰', 217.00, 3.30, 10.00, 28.90, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (846, '雪顶咖啡', 203.30, 3.10, 9.40, 27.10, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (847, '星冰乐类', 171.80, 2.60, 7.90, 22.90, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (848, '冰棍奶油', 184.20, 2.80, 8.50, 24.60, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (849, '老冰棍', 173.70, 2.70, 8.00, 23.20, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (850, '碎碎冰', 189.00, 2.90, 8.70, 25.20, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (851, '冰棒水果', 215.90, 3.30, 10.00, 28.80, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (852, '炒酸奶', 215.00, 3.30, 9.90, 28.70, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (853, '绵绵冰', 191.50, 2.90, 8.80, 25.50, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (854, '刨冰红豆', 202.80, 3.10, 9.40, 27.00, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (855, '刨冰芒果', 181.30, 2.80, 8.40, 24.20, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (856, '冰淇淋蛋糕', 183.40, 2.80, 8.50, 24.50, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (857, '雪糕杯', 177.70, 2.70, 8.20, 23.70, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (858, '圣代', 199.50, 3.10, 9.20, 26.60, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (859, '甜筒', 183.60, 2.80, 8.50, 24.50, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (860, '冰砖', 216.80, 3.30, 10.00, 28.90, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (861, '冰棒巧克力', 200.20, 3.10, 9.20, 26.70, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (862, '果冻杯', 215.10, 3.30, 9.90, 28.70, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (863, '布丁冻', 176.60, 2.70, 8.10, 23.50, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (864, '椰汁西米露', 199.50, 3.10, 9.20, 26.60, '100g', '冷饮冰品', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (865, '矿泉水', 40.50, 0.50, 0.00, 9.60, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (866, '苏打水', 40.00, 0.50, 0.00, 9.50, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (867, '气泡水', 42.30, 0.60, 0.00, 10.00, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (868, '柠檬水', 42.00, 0.60, 0.00, 9.90, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (869, '橙汁', 34.60, 0.50, 0.00, 8.20, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (870, '苹果汁', 36.10, 0.50, 0.00, 8.50, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (871, '葡萄汁', 37.90, 0.50, 0.00, 9.00, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (872, '西柚汁', 39.60, 0.50, 0.00, 9.40, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (873, '椰子水', 36.20, 0.50, 0.00, 8.60, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (874, '酸梅汤', 40.90, 0.50, 0.00, 9.70, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (875, '绿茶', 38.30, 0.50, 0.00, 9.10, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (876, '红茶', 35.40, 0.50, 0.00, 8.40, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (877, '乌龙茶', 34.90, 0.50, 0.00, 8.30, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (878, '普洱茶', 38.90, 0.50, 0.00, 9.20, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (879, '茉莉花茶', 41.80, 0.50, 0.00, 9.90, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (880, '菊花茶', 36.40, 0.50, 0.00, 8.60, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (881, '大麦茶', 34.30, 0.50, 0.00, 8.10, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (882, '玉米须茶', 38.50, 0.50, 0.00, 9.10, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (883, '黑咖啡', 40.30, 0.50, 0.00, 9.50, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (884, '美式咖啡', 37.00, 0.50, 0.00, 8.80, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (885, '拿铁', 36.60, 0.50, 0.00, 8.70, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (886, '卡布奇诺', 33.90, 0.40, 0.00, 8.00, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (887, '摩卡', 37.90, 0.50, 0.00, 9.00, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (888, '现调奶茶', 37.40, 0.50, 0.00, 8.90, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (889, '珍珠奶茶', 41.60, 0.50, 0.00, 9.80, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (890, '果茶', 41.60, 0.50, 0.00, 9.80, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (891, '柠檬茶', 40.50, 0.50, 0.00, 9.60, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (892, '冰红茶', 36.00, 0.50, 0.00, 8.50, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (893, '运动饮料', 33.50, 0.40, 0.00, 7.90, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (894, '电解质水', 36.90, 0.50, 0.00, 8.70, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (895, '果蔬汁', 33.60, 0.40, 0.00, 7.90, '100g', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (896, '杏仁奶饮', 36.90, 0.50, 0.00, 8.70, '100ml', '即饮茶咖', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (897, '啤酒淡爽', 72.10, 0.50, 0.00, 5.10, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (898, '啤酒纯生', 63.00, 0.50, 0.00, 4.50, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (899, '啤酒黑啤', 69.30, 0.50, 0.00, 5.00, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (900, '白葡萄酒', 70.20, 0.50, 0.00, 5.00, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (901, '红葡萄酒', 71.10, 0.50, 0.00, 5.10, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (902, '桃红葡萄酒', 63.30, 0.50, 0.00, 4.50, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (903, '香槟', 73.80, 0.50, 0.00, 5.30, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (904, '起泡酒', 67.40, 0.50, 0.00, 4.80, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (905, '清酒', 72.10, 0.50, 0.00, 5.20, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (906, '梅酒', 63.80, 0.50, 0.00, 4.60, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (907, '米酒', 77.70, 0.60, 0.00, 5.60, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (908, '黄酒', 71.60, 0.50, 0.00, 5.10, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (909, '花雕酒', 73.90, 0.50, 0.00, 5.30, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (910, '青梅酒', 78.20, 0.60, 0.00, 5.60, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (911, '杨梅酒', 75.10, 0.50, 0.00, 5.40, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (912, '桑葚酒', 76.20, 0.50, 0.00, 5.40, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (913, '桂花酒', 74.50, 0.50, 0.00, 5.30, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (914, '玫瑰酒', 70.20, 0.50, 0.00, 5.00, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (915, '鸡尾酒预调', 72.50, 0.50, 0.00, 5.20, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (916, '果味啤酒', 71.80, 0.50, 0.00, 5.10, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (917, '西打酒', 66.60, 0.50, 0.00, 4.80, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (918, '米酒酿', 78.00, 0.60, 0.00, 5.60, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (919, '甜酒酿', 63.10, 0.50, 0.00, 4.50, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (920, '醪糟汁', 76.70, 0.50, 0.00, 5.50, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (921, '低度果酒', 68.00, 0.50, 0.00, 4.90, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (922, '柚子酒', 62.00, 0.40, 0.00, 4.40, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (923, '柠檬酒', 67.00, 0.50, 0.00, 4.80, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (924, '草莓酒', 74.00, 0.50, 0.00, 5.30, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (925, '菠萝酒', 63.20, 0.50, 0.00, 4.50, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (926, '椰子酒', 70.80, 0.50, 0.00, 5.10, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (927, '无醇啤酒', 75.10, 0.50, 0.00, 5.40, '100g', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (928, '无醇葡萄酒', 75.80, 0.50, 0.00, 5.40, '100ml', '酒类低度', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (929, '生抽', 160.40, 3.60, 7.10, 19.60, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (930, '老抽', 173.30, 3.90, 7.70, 21.20, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (931, '蚝油', 166.30, 3.70, 7.40, 20.30, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (932, '香醋', 168.90, 3.80, 7.50, 20.60, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (933, '陈醋', 179.90, 4.00, 8.00, 22.00, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (934, '米醋', 169.50, 3.80, 7.50, 20.70, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (935, '料酒', 194.30, 4.30, 8.60, 23.80, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (936, '番茄酱', 174.30, 3.90, 7.70, 21.30, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (937, '沙拉酱', 183.50, 4.10, 8.20, 22.40, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (938, '蛋黄酱', 171.50, 3.80, 7.60, 21.00, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (939, '辣椒酱', 182.90, 4.10, 8.10, 22.40, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (940, '蒜蓉酱', 184.70, 4.10, 8.20, 22.60, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (941, '花椒油', 171.70, 3.80, 7.60, 21.00, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (942, '芝麻油', 158.90, 3.50, 7.10, 19.40, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (943, '藤椒油', 184.80, 4.10, 8.20, 22.60, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (944, '咖喱块', 177.30, 3.90, 7.90, 21.70, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (945, '火锅底料', 190.30, 4.20, 8.50, 23.30, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (946, '郫县豆瓣', 169.50, 3.80, 7.50, 20.70, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (947, '老干妈', 201.30, 4.50, 8.90, 24.60, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (948, '榨菜丝', 177.90, 4.00, 7.90, 21.70, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (949, '泡菜韩式', 189.00, 4.20, 8.40, 23.10, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (950, '酸菜鱼料', 160.10, 3.60, 7.10, 19.60, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (951, '酸豆角', 170.20, 3.80, 7.60, 20.80, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (952, '橄榄菜', 194.40, 4.30, 8.60, 23.80, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (953, '腐乳红', 193.90, 4.30, 8.60, 23.70, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (954, '腐乳白', 190.70, 4.20, 8.50, 23.30, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (955, '虾酱', 201.30, 4.50, 8.90, 24.60, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (956, '蟹酱', 195.30, 4.30, 8.70, 23.90, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (957, '鱼露', 173.90, 3.90, 7.70, 21.20, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (958, '柠檬汁调料', 159.60, 3.50, 7.10, 19.50, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (959, '黑胡椒碎', 182.00, 4.00, 8.10, 22.20, '100g', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (960, '五香粉', 186.60, 4.10, 8.30, 22.80, '100ml', '酱腌调味', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (961, '薯片原味', 435.60, 8.10, 20.30, 55.70, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (962, '薯片番茄', 444.50, 8.30, 20.70, 56.90, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (963, '薯片烧烤', 406.50, 7.60, 18.90, 52.00, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (964, '虾条', 442.90, 8.20, 20.60, 56.60, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (965, '米饼', 414.80, 7.70, 19.30, 53.10, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (966, '仙贝', 395.70, 7.40, 18.40, 50.60, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (967, '锅巴', 399.60, 7.40, 18.60, 51.10, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (968, '爆米花', 428.00, 8.00, 19.90, 54.70, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (969, '瓜子五香', 460.70, 8.60, 21.40, 58.90, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (970, '瓜子焦糖', 399.00, 7.40, 18.60, 51.00, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (971, '牛肉粒', 441.20, 8.20, 20.50, 56.40, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (972, '猪肉丝', 382.10, 7.10, 17.80, 48.90, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (973, '鱿鱼丝', 475.60, 8.80, 22.10, 60.80, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (974, '海苔片', 421.40, 7.80, 19.60, 53.90, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (975, '海苔卷', 443.70, 8.30, 20.60, 56.80, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (976, '话梅', 397.10, 7.40, 18.50, 50.80, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (977, '陈皮梅', 435.30, 8.10, 20.20, 55.70, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (978, '山楂片', 417.20, 7.80, 19.40, 53.40, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (979, '果丹皮', 439.60, 8.20, 20.40, 56.20, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (980, '果冻杯零食', 413.90, 7.70, 19.20, 52.90, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (981, '软糖', 388.90, 7.20, 18.10, 49.70, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (982, '硬糖', 394.10, 7.30, 18.30, 50.40, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (983, '巧克力块', 444.20, 8.30, 20.70, 56.80, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (984, '麦丽素', 396.40, 7.40, 18.40, 50.70, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (985, '威化饼干', 436.60, 8.10, 20.30, 55.80, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (986, '夹心饼干', 395.00, 7.30, 18.40, 50.50, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (987, '干脆面', 480.10, 8.90, 22.30, 61.40, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (988, '辣条', 445.80, 8.30, 20.70, 57.00, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (989, '素肉零食', 404.50, 7.50, 18.80, 51.70, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (990, '蔬菜脆片', 379.10, 7.10, 17.60, 48.50, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (991, '香蕉片', 436.60, 8.10, 20.30, 55.80, '100g', '休闲零食', '2026-04-02 04:33:38');
INSERT INTO `food_library_legacy` VALUES (992, '苹果干', 462.60, 8.60, 21.50, 59.20, '100g', '休闲零食', '2026-04-02 04:33:38');

-- ----------------------------
-- Table structure for lw_user
-- ----------------------------
DROP TABLE IF EXISTS `lw_user`;
CREATE TABLE `lw_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '微信 openid',
  `unionid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `nickname_source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system_default' COMMENT 'system_default/wx_profile/manual',
  `nickname_authorized` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar_source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system_default',
  `avatar_authorized` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone_bind_status` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `phone_bind_time` datetime NULL DEFAULT NULL,
  `phone_source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'wx_phone',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1,
  `register_source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'wx_miniprogram',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_openid`(`openid` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lw_user
-- ----------------------------
INSERT INTO `lw_user` VALUES (1, 'dev_user_1', NULL, '小明', 'manual', 0, NULL, 'system_default', 0, NULL, 0, NULL, NULL, 1, 'wx_miniprogram', '2026-04-02 04:33:38', '2026-04-03 10:32:50');
INSERT INTO `lw_user` VALUES (4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', '瞿炜', 'manual', 0, '/api/v1/public/avatars/4', 'manual', 0, NULL, 0, NULL, NULL, 1, 'wx_miniprogram', '2026-04-03 01:14:57', '2026-04-03 01:14:57');

-- ----------------------------
-- Table structure for meal_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `meal_evaluation`;
CREATE TABLE `meal_evaluation`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `meal_id` bigint UNSIGNED NOT NULL,
  `record_date` date NOT NULL,
  `meal_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_calories` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `score_level` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '优秀/良好/欠佳',
  `advantage_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `disadvantage_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `suggestion_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_meal_eval_user`(`user_id` ASC, `record_date` ASC) USING BTREE,
  INDEX `fk_meal_eval_meal`(`meal_id` ASC) USING BTREE,
  CONSTRAINT `fk_meal_eval_meal` FOREIGN KEY (`meal_id`) REFERENCES `meal_record` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_meal_eval_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of meal_evaluation
-- ----------------------------

-- ----------------------------
-- Table structure for meal_photo_recognition
-- ----------------------------
DROP TABLE IF EXISTS `meal_photo_recognition`;
CREATE TABLE `meal_photo_recognition`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `meal_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `recommended_meal_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '服务端按时间规则推荐的餐别：breakfast/lunch/dinner/snack',
  `confirmed_meal_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户确认写入时锁定的餐别（与 meal_record / diet_record 一致）',
  `record_date` date NOT NULL,
  `source` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'camera' COMMENT 'camera/album',
  `image_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `recognized_food_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '识别结果主展示名称快照；多条食物时完整结构仍以 parsed_result_json 为准',
  `confirmed_food_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户确认或编辑后的主食物名称快照（与写入 diet_record 展示一致）',
  `recognized_calories` decimal(12, 2) NULL DEFAULT NULL COMMENT '识别出的基准热量（千卡），写入前快照',
  `confirmed_calories` decimal(12, 2) NULL DEFAULT NULL COMMENT '用户确认写入的最终热量（千卡），与明细汇总一致',
  `recommended_eat_ratio` decimal(6, 4) NULL DEFAULT NULL COMMENT '推荐食用比例，建议存 0~1（如 1.0000 表示 100%）',
  `confirmed_eat_ratio` decimal(6, 4) NULL DEFAULT NULL COMMENT '用户确认的食用比例 0~1，与食用比例滑杆一致',
  `badge_progress_percent` decimal(5, 2) NULL DEFAULT NULL COMMENT '热量徽章/圆环展示的摄入相对预算百分比 0~100，用于还原当时 UI',
  `recognize_status` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'uploading' COMMENT 'uploading/recognizing/success/fail',
  `confirm_status` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'none' COMMENT '确认流状态：none 未进入确认/pending_confirm 待用户确认/confirmed 已写入/aborted 用户放弃',
  `confirmed_at` datetime NULL DEFAULT NULL COMMENT '用户点击确定或「添加到某餐」并成功写入餐次的时间',
  `meal_record_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '确认写入后关联的 meal_record.id',
  `diet_record_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '仅一条明细或代表行时指向 diet_record.id；多条时请用 meal_record_id 反查 diet_record',
  `vendor` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'aliyun',
  `vendor_request_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `raw_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `parsed_result_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `result_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'candidate_foods/keyword_only/failed',
  `error_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `error_message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_photo_recog_user_date`(`user_id` ASC, `record_date` ASC, `recognize_status` ASC) USING BTREE,
  INDEX `idx_photo_recog_meal_record`(`meal_record_id` ASC) USING BTREE,
  INDEX `idx_photo_recog_confirm`(`user_id` ASC, `confirm_status` ASC, `record_date` ASC) USING BTREE,
  INDEX `idx_photo_recog_confirmed_at`(`confirmed_at` ASC) USING BTREE,
  INDEX `fk_photo_recog_diet_record`(`diet_record_id` ASC) USING BTREE,
  CONSTRAINT `fk_photo_recog_diet_record` FOREIGN KEY (`diet_record_id`) REFERENCES `diet_record` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_photo_recog_meal_record` FOREIGN KEY (`meal_record_id`) REFERENCES `meal_record` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_photo_recog_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of meal_photo_recognition
-- ----------------------------
INSERT INTO `meal_photo_recognition` VALUES (1, 4, 'dinner', 'snack', 'snack', '2026-04-05', 'album', NULL, '拿铁咖啡', '拿铁咖啡', 0.00, 10.00, 1.0000, 1.0000, 0.40, 'success', 'confirmed', '2026-04-05 02:53:36', 256, 1024, 'aliyun', NULL, '{\"data\":{\"count\":1,\"items\":[{\"calory\":72,\"name\":\"拿铁咖啡\"}]},\"msg\":\"成功\",\"success\":true,\"code\":200,\"taskNo\":\"548406818205564343587254\"}', '[{\"lineId\":\"1\",\"foodName\":\"拿铁咖啡\",\"calories\":0,\"giLabel\":\"低 GI\"}]', 'candidate_foods', NULL, NULL, '2026-04-05 02:53:03', '2026-04-05 02:53:07');

-- ----------------------------
-- Table structure for meal_record
-- ----------------------------
DROP TABLE IF EXISTS `meal_record`;
CREATE TABLE `meal_record`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `record_date` date NOT NULL,
  `meal_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'breakfast/lunch/dinner/snack',
  `total_calories` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `total_carb_g` decimal(12, 2) NULL DEFAULT NULL,
  `total_protein_g` decimal(12, 2) NULL DEFAULT NULL,
  `total_fat_g` decimal(12, 2) NULL DEFAULT NULL,
  `food_count` int NOT NULL DEFAULT 0,
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft' COMMENT 'draft/submitted',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_meal_user_date_type`(`user_id` ASC, `record_date` ASC, `meal_type` ASC) USING BTREE,
  CONSTRAINT `fk_meal_record_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 257 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of meal_record
-- ----------------------------
INSERT INTO `meal_record` VALUES (1, 4, '2026-02-01', 'breakfast', 456.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (2, 4, '2026-02-01', 'lunch', 581.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (3, 4, '2026-02-01', 'dinner', 446.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (4, 4, '2026-02-01', 'snack', 103.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (5, 4, '2026-02-02', 'breakfast', 424.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (6, 4, '2026-02-02', 'lunch', 497.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (7, 4, '2026-02-02', 'dinner', 486.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (8, 4, '2026-02-03', 'breakfast', 317.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (9, 4, '2026-02-03', 'lunch', 539.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (10, 4, '2026-02-03', 'dinner', 486.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (11, 4, '2026-02-04', 'breakfast', 337.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (12, 4, '2026-02-04', 'lunch', 637.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (13, 4, '2026-02-04', 'dinner', 432.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (14, 4, '2026-02-05', 'breakfast', 298.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (15, 4, '2026-02-05', 'lunch', 493.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (16, 4, '2026-02-05', 'dinner', 316.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (17, 4, '2026-02-05', 'snack', 97.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (18, 4, '2026-02-06', 'breakfast', 319.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (19, 4, '2026-02-06', 'lunch', 464.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (20, 4, '2026-02-06', 'dinner', 388.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (21, 4, '2026-02-06', 'snack', 175.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (22, 4, '2026-02-07', 'breakfast', 480.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (23, 4, '2026-02-07', 'lunch', 554.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (24, 4, '2026-02-07', 'dinner', 487.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (25, 4, '2026-02-07', 'snack', 198.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (26, 4, '2026-02-08', 'breakfast', 416.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (27, 4, '2026-02-08', 'lunch', 503.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (28, 4, '2026-02-08', 'dinner', 510.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (29, 4, '2026-02-08', 'snack', 75.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (30, 4, '2026-02-09', 'breakfast', 412.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (31, 4, '2026-02-09', 'lunch', 529.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (32, 4, '2026-02-09', 'dinner', 477.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (33, 4, '2026-02-09', 'snack', 99.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (34, 4, '2026-02-10', 'breakfast', 437.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (35, 4, '2026-02-10', 'lunch', 526.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (36, 4, '2026-02-10', 'dinner', 353.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (37, 4, '2026-02-10', 'snack', 151.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (38, 4, '2026-02-11', 'breakfast', 327.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (39, 4, '2026-02-11', 'lunch', 679.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (40, 4, '2026-02-11', 'dinner', 449.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (41, 4, '2026-02-11', 'snack', 180.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (42, 4, '2026-02-12', 'breakfast', 433.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (43, 4, '2026-02-12', 'lunch', 559.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (44, 4, '2026-02-12', 'dinner', 399.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (45, 4, '2026-02-12', 'snack', 119.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (46, 4, '2026-02-13', 'breakfast', 430.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (47, 4, '2026-02-13', 'lunch', 523.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (48, 4, '2026-02-13', 'dinner', 402.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (49, 4, '2026-02-13', 'snack', 116.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (50, 4, '2026-02-14', 'breakfast', 329.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (51, 4, '2026-02-14', 'lunch', 540.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (52, 4, '2026-02-14', 'dinner', 447.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (53, 4, '2026-02-14', 'snack', 155.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (54, 4, '2026-02-15', 'breakfast', 477.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (55, 4, '2026-02-15', 'lunch', 489.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (56, 4, '2026-02-15', 'dinner', 409.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (57, 4, '2026-02-16', 'breakfast', 465.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (58, 4, '2026-02-16', 'lunch', 540.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (59, 4, '2026-02-16', 'dinner', 325.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (60, 4, '2026-02-17', 'breakfast', 490.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (61, 4, '2026-02-17', 'lunch', 573.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (62, 4, '2026-02-17', 'dinner', 517.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (63, 4, '2026-02-17', 'snack', 112.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (64, 4, '2026-02-18', 'breakfast', 430.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (65, 4, '2026-02-18', 'lunch', 544.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (66, 4, '2026-02-18', 'dinner', 444.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (67, 4, '2026-02-18', 'snack', 67.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (68, 4, '2026-02-19', 'breakfast', 445.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (69, 4, '2026-02-19', 'lunch', 512.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (70, 4, '2026-02-19', 'dinner', 503.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (71, 4, '2026-02-20', 'breakfast', 464.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (72, 4, '2026-02-20', 'lunch', 625.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (73, 4, '2026-02-20', 'dinner', 415.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (74, 4, '2026-02-21', 'breakfast', 466.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (75, 4, '2026-02-21', 'lunch', 500.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (76, 4, '2026-02-21', 'dinner', 525.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (77, 4, '2026-02-22', 'breakfast', 455.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (78, 4, '2026-02-22', 'lunch', 597.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (79, 4, '2026-02-22', 'dinner', 483.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (80, 4, '2026-02-22', 'snack', 75.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (81, 4, '2026-02-23', 'breakfast', 446.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (82, 4, '2026-02-23', 'lunch', 475.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (83, 4, '2026-02-23', 'dinner', 469.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (84, 4, '2026-02-23', 'snack', 100.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (85, 4, '2026-02-24', 'breakfast', 437.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (86, 4, '2026-02-24', 'lunch', 483.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (87, 4, '2026-02-24', 'dinner', 490.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (88, 4, '2026-02-24', 'snack', 180.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (89, 4, '2026-02-25', 'breakfast', 409.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (90, 4, '2026-02-25', 'lunch', 514.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (91, 4, '2026-02-25', 'dinner', 468.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (92, 4, '2026-02-25', 'snack', 174.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (93, 4, '2026-02-26', 'breakfast', 453.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (94, 4, '2026-02-26', 'lunch', 571.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (95, 4, '2026-02-26', 'dinner', 363.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (96, 4, '2026-02-26', 'snack', 100.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (97, 4, '2026-02-27', 'breakfast', 462.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (98, 4, '2026-02-27', 'lunch', 472.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (99, 4, '2026-02-27', 'dinner', 489.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (100, 4, '2026-02-28', 'breakfast', 464.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (101, 4, '2026-02-28', 'lunch', 580.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (102, 4, '2026-02-28', 'dinner', 461.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (103, 4, '2026-02-28', 'snack', 170.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (104, 4, '2026-03-01', 'breakfast', 415.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (105, 4, '2026-03-01', 'lunch', 579.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (106, 4, '2026-03-01', 'dinner', 374.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (107, 4, '2026-03-01', 'snack', 78.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (108, 4, '2026-03-02', 'breakfast', 450.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (109, 4, '2026-03-02', 'lunch', 594.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (110, 4, '2026-03-02', 'dinner', 431.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (111, 4, '2026-03-02', 'snack', 142.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (112, 4, '2026-03-03', 'breakfast', 363.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (113, 4, '2026-03-03', 'lunch', 434.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (114, 4, '2026-03-03', 'dinner', 464.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (115, 4, '2026-03-03', 'snack', 122.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (116, 4, '2026-03-04', 'breakfast', 430.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (117, 4, '2026-03-04', 'lunch', 667.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (118, 4, '2026-03-04', 'dinner', 390.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (119, 4, '2026-03-04', 'snack', 165.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (120, 4, '2026-03-05', 'breakfast', 362.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (121, 4, '2026-03-05', 'lunch', 541.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (122, 4, '2026-03-05', 'dinner', 486.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (123, 4, '2026-03-05', 'snack', 84.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (124, 4, '2026-03-06', 'breakfast', 407.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (125, 4, '2026-03-06', 'lunch', 653.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (126, 4, '2026-03-06', 'dinner', 419.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (127, 4, '2026-03-07', 'breakfast', 434.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (128, 4, '2026-03-07', 'lunch', 535.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (129, 4, '2026-03-07', 'dinner', 506.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (130, 4, '2026-03-07', 'snack', 65.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (131, 4, '2026-03-08', 'breakfast', 332.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (132, 4, '2026-03-08', 'lunch', 576.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (133, 4, '2026-03-08', 'dinner', 477.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (134, 4, '2026-03-08', 'snack', 94.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (135, 4, '2026-03-09', 'breakfast', 469.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (136, 4, '2026-03-09', 'lunch', 460.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (137, 4, '2026-03-09', 'dinner', 461.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (138, 4, '2026-03-09', 'snack', 174.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (139, 4, '2026-03-10', 'breakfast', 299.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (140, 4, '2026-03-10', 'lunch', 466.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (141, 4, '2026-03-10', 'dinner', 475.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (142, 4, '2026-03-10', 'snack', 95.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (143, 4, '2026-03-11', 'breakfast', 347.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (144, 4, '2026-03-11', 'lunch', 689.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (145, 4, '2026-03-11', 'dinner', 372.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (146, 4, '2026-03-11', 'snack', 75.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (147, 4, '2026-03-12', 'breakfast', 441.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (148, 4, '2026-03-12', 'lunch', 398.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (149, 4, '2026-03-12', 'dinner', 465.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (150, 4, '2026-03-12', 'snack', 217.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (151, 4, '2026-03-13', 'breakfast', 417.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (152, 4, '2026-03-13', 'lunch', 534.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (153, 4, '2026-03-13', 'dinner', 515.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (154, 4, '2026-03-14', 'breakfast', 356.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (155, 4, '2026-03-14', 'lunch', 537.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (156, 4, '2026-03-14', 'dinner', 347.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (157, 4, '2026-03-15', 'breakfast', 404.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (158, 4, '2026-03-15', 'lunch', 532.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (159, 4, '2026-03-15', 'dinner', 383.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (160, 4, '2026-03-15', 'snack', 85.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (161, 4, '2026-03-16', 'breakfast', 421.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (162, 4, '2026-03-16', 'lunch', 579.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (163, 4, '2026-03-16', 'dinner', 362.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (164, 4, '2026-03-16', 'snack', 99.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (165, 4, '2026-03-17', 'breakfast', 503.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (166, 4, '2026-03-17', 'lunch', 363.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (167, 4, '2026-03-17', 'dinner', 497.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (168, 4, '2026-03-17', 'snack', 100.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (169, 4, '2026-03-18', 'breakfast', 457.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (170, 4, '2026-03-18', 'lunch', 537.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (171, 4, '2026-03-18', 'dinner', 439.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (172, 4, '2026-03-18', 'snack', 76.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (173, 4, '2026-03-19', 'breakfast', 444.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (174, 4, '2026-03-19', 'lunch', 509.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (175, 4, '2026-03-19', 'dinner', 503.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (176, 4, '2026-03-19', 'snack', 209.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (177, 4, '2026-03-20', 'breakfast', 467.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (178, 4, '2026-03-20', 'lunch', 680.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (179, 4, '2026-03-20', 'dinner', 518.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (180, 4, '2026-03-20', 'snack', 93.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (181, 4, '2026-03-21', 'breakfast', 339.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (182, 4, '2026-03-21', 'lunch', 582.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (183, 4, '2026-03-21', 'dinner', 471.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (184, 4, '2026-03-22', 'breakfast', 430.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (185, 4, '2026-03-22', 'lunch', 650.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (186, 4, '2026-03-22', 'dinner', 431.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (187, 4, '2026-03-22', 'snack', 140.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (188, 4, '2026-03-23', 'breakfast', 417.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (189, 4, '2026-03-23', 'lunch', 545.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (190, 4, '2026-03-23', 'dinner', 407.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (191, 4, '2026-03-23', 'snack', 92.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (192, 4, '2026-03-24', 'breakfast', 477.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (193, 4, '2026-03-24', 'lunch', 539.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (194, 4, '2026-03-24', 'dinner', 472.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (195, 4, '2026-03-24', 'snack', 140.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (196, 4, '2026-03-25', 'breakfast', 307.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (197, 4, '2026-03-25', 'lunch', 528.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (198, 4, '2026-03-25', 'dinner', 400.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (199, 4, '2026-03-25', 'snack', 84.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (200, 4, '2026-03-26', 'breakfast', 438.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (201, 4, '2026-03-26', 'lunch', 533.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (202, 4, '2026-03-26', 'dinner', 345.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (203, 4, '2026-03-26', 'snack', 254.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (204, 4, '2026-03-27', 'breakfast', 495.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (205, 4, '2026-03-27', 'lunch', 594.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (206, 4, '2026-03-27', 'dinner', 469.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (207, 4, '2026-03-28', 'breakfast', 510.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (208, 4, '2026-03-28', 'lunch', 639.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (209, 4, '2026-03-28', 'dinner', 352.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (210, 4, '2026-03-29', 'breakfast', 439.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (211, 4, '2026-03-29', 'lunch', 473.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (212, 4, '2026-03-29', 'dinner', 388.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (213, 4, '2026-03-29', 'snack', 78.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (214, 4, '2026-03-30', 'breakfast', 463.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (215, 4, '2026-03-30', 'lunch', 503.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (216, 4, '2026-03-30', 'dinner', 469.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (217, 4, '2026-03-30', 'snack', 80.00, 0.00, 0.00, 0.00, 1, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (218, 4, '2026-03-31', 'breakfast', 428.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (219, 4, '2026-03-31', 'lunch', 644.00, 0.00, 0.00, 0.00, 4, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (220, 4, '2026-03-31', 'dinner', 458.00, 0.00, 0.00, 0.00, 3, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (221, 4, '2026-03-31', 'snack', 204.00, 0.00, 0.00, 0.00, 2, 'submitted', '2026-04-02 04:33:38', '2026-04-02 04:33:38');
INSERT INTO `meal_record` VALUES (256, 4, '2026-04-05', 'snack', 10.00, NULL, NULL, NULL, 1, 'submitted', '2026-04-05 02:53:35', '2026-04-05 02:53:35');

-- ----------------------------
-- Table structure for meal_record_legacy
-- ----------------------------
DROP TABLE IF EXISTS `meal_record_legacy`;
CREATE TABLE `meal_record_legacy`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `meal_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'breakfast/lunch/dinner/snack',
  `food_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `calories` int UNSIGNED NOT NULL,
  `protein_g` decimal(8, 2) NULL DEFAULT NULL COMMENT '蛋白质克',
  `fat_g` decimal(8, 2) NULL DEFAULT NULL COMMENT '脂肪克',
  `carbs_g` decimal(8, 2) NULL DEFAULT NULL COMMENT '碳水克',
  `amount_value` decimal(10, 2) NULL DEFAULT NULL,
  `amount_unit` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'g/ml 等',
  `recorded_at` datetime NOT NULL,
  `food_library_id` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_meal_user_time`(`user_id` ASC, `recorded_at` ASC) USING BTREE,
  CONSTRAINT `fk_meal_legacy_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 586 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of meal_record_legacy
-- ----------------------------
INSERT INTO `meal_record_legacy` VALUES (1, 4, 'breakfast', '燕麦粥', 178, NULL, NULL, NULL, 197.00, 'g', '2026-02-01 07:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (2, 4, 'breakfast', '鸡蛋', 172, NULL, NULL, NULL, 104.00, 'g', '2026-02-01 07:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (3, 4, 'breakfast', '牛奶', 106, NULL, NULL, NULL, 182.00, 'ml', '2026-02-01 07:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (4, 4, 'lunch', '米饭', 314, NULL, NULL, NULL, 207.00, 'g', '2026-02-01 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (5, 4, 'lunch', '番茄炒蛋', 139, NULL, NULL, NULL, 180.00, 'g', '2026-02-01 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (6, 4, 'lunch', '青菜', 29, NULL, NULL, NULL, 87.00, 'g', '2026-02-01 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (7, 4, 'lunch', '紫菜蛋汤', 99, NULL, NULL, NULL, 262.00, 'ml', '2026-02-01 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (8, 4, 'dinner', '杂粮粥', 181, NULL, NULL, NULL, 259.00, 'g', '2026-02-01 18:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (9, 4, 'dinner', '鸡胸肉沙拉', 188, NULL, NULL, NULL, 140.00, 'g', '2026-02-01 18:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (10, 4, 'dinner', '豆腐汤', 77, NULL, NULL, NULL, 363.00, 'ml', '2026-02-01 18:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (11, 4, 'snack', '牛奶', 103, NULL, NULL, NULL, 200.00, 'ml', '2026-02-01 21:07:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (12, 4, 'breakfast', '燕麦粥', 179, NULL, NULL, NULL, 245.00, 'g', '2026-02-02 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (13, 4, 'breakfast', '鸡蛋', 145, NULL, NULL, NULL, 101.00, 'g', '2026-02-02 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (14, 4, 'breakfast', '牛奶', 100, NULL, NULL, NULL, 237.00, 'ml', '2026-02-02 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (15, 4, 'lunch', '米饭', 278, NULL, NULL, NULL, 169.00, 'g', '2026-02-02 12:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (16, 4, 'lunch', '清蒸鲈鱼', 192, NULL, NULL, NULL, 200.00, 'g', '2026-02-02 12:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (17, 4, 'lunch', '青菜', 27, NULL, NULL, NULL, 135.00, 'g', '2026-02-02 12:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (18, 4, 'dinner', '杂粮粥', 169, NULL, NULL, NULL, 233.00, 'g', '2026-02-02 18:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (19, 4, 'dinner', '鸡胸肉沙拉', 210, NULL, NULL, NULL, 174.00, 'g', '2026-02-02 18:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (20, 4, 'dinner', '豆腐汤', 107, NULL, NULL, NULL, 327.00, 'ml', '2026-02-02 18:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (21, 4, 'breakfast', '燕麦粥', 146, NULL, NULL, NULL, 220.00, 'g', '2026-02-03 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (22, 4, 'breakfast', '鸡蛋', 171, NULL, NULL, NULL, 98.00, 'g', '2026-02-03 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (23, 4, 'lunch', '米饭', 278, NULL, NULL, NULL, 206.00, 'g', '2026-02-03 12:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (24, 4, 'lunch', '番茄炒蛋', 143, NULL, NULL, NULL, 180.00, 'g', '2026-02-03 12:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (25, 4, 'lunch', '青菜', 48, NULL, NULL, NULL, 136.00, 'g', '2026-02-03 12:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (26, 4, 'lunch', '紫菜蛋汤', 70, NULL, NULL, NULL, 311.00, 'ml', '2026-02-03 12:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (27, 4, 'dinner', '杂粮粥', 185, NULL, NULL, NULL, 295.00, 'g', '2026-02-03 18:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (28, 4, 'dinner', '鸡胸肉沙拉', 204, NULL, NULL, NULL, 171.00, 'g', '2026-02-03 18:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (29, 4, 'dinner', '豆腐汤', 97, NULL, NULL, NULL, 352.00, 'ml', '2026-02-03 18:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (30, 4, 'breakfast', '燕麦粥', 166, NULL, NULL, NULL, 213.00, 'g', '2026-02-04 07:41:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (31, 4, 'breakfast', '鸡蛋', 171, NULL, NULL, NULL, 84.00, 'g', '2026-02-04 07:41:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (32, 4, 'lunch', '米饭', 248, NULL, NULL, NULL, 170.00, 'g', '2026-02-04 12:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (33, 4, 'lunch', '青椒肉丝', 240, NULL, NULL, NULL, 150.00, 'g', '2026-02-04 12:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (34, 4, 'lunch', '青菜', 55, NULL, NULL, NULL, 97.00, 'g', '2026-02-04 12:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (35, 4, 'lunch', '紫菜蛋汤', 94, NULL, NULL, NULL, 267.00, 'ml', '2026-02-04 12:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (36, 4, 'dinner', '荞麦面', 187, NULL, NULL, NULL, 235.00, 'g', '2026-02-04 18:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (37, 4, 'dinner', '鸡胸肉沙拉', 171, NULL, NULL, NULL, 120.00, 'g', '2026-02-04 18:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (38, 4, 'dinner', '豆腐汤', 74, NULL, NULL, NULL, 329.00, 'ml', '2026-02-04 18:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (39, 4, 'breakfast', '燕麦粥', 152, NULL, NULL, NULL, 212.00, 'g', '2026-02-05 07:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (40, 4, 'breakfast', '鸡蛋', 146, NULL, NULL, NULL, 91.00, 'g', '2026-02-05 07:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (41, 4, 'lunch', '米饭', 275, NULL, NULL, NULL, 167.00, 'g', '2026-02-05 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (42, 4, 'lunch', '蒜蓉西兰花', 114, NULL, NULL, NULL, 200.00, 'g', '2026-02-05 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (43, 4, 'lunch', '青菜', 40, NULL, NULL, NULL, 107.00, 'g', '2026-02-05 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (44, 4, 'lunch', '紫菜蛋汤', 64, NULL, NULL, NULL, 306.00, 'ml', '2026-02-05 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (45, 4, 'dinner', '杂粮粥', 153, NULL, NULL, NULL, 255.00, 'g', '2026-02-05 18:23:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (46, 4, 'dinner', '鸡胸肉沙拉', 163, NULL, NULL, NULL, 152.00, 'g', '2026-02-05 18:23:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (47, 4, 'snack', '苹果', 97, NULL, NULL, NULL, 120.00, 'g', '2026-02-05 16:31:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (48, 4, 'breakfast', '燕麦粥', 163, NULL, NULL, NULL, 240.00, 'g', '2026-02-06 07:41:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (49, 4, 'breakfast', '鸡蛋', 156, NULL, NULL, NULL, 99.00, 'g', '2026-02-06 07:41:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (50, 4, 'lunch', '米饭', 227, NULL, NULL, NULL, 208.00, 'g', '2026-02-06 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (51, 4, 'lunch', '麻婆豆腐', 183, NULL, NULL, NULL, 200.00, 'g', '2026-02-06 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (52, 4, 'lunch', '青菜', 54, NULL, NULL, NULL, 113.00, 'g', '2026-02-06 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (53, 4, 'dinner', '荞麦面', 200, NULL, NULL, NULL, 228.00, 'g', '2026-02-06 18:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (54, 4, 'dinner', '鸡胸肉沙拉', 188, NULL, NULL, NULL, 194.00, 'g', '2026-02-06 18:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (55, 4, 'snack', '香蕉', 79, NULL, NULL, NULL, 100.00, 'g', '2026-02-06 21:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (56, 4, 'snack', '无糖酸奶', 96, NULL, NULL, NULL, 150.00, 'g', '2026-02-06 20:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (57, 4, 'breakfast', '燕麦粥', 181, NULL, NULL, NULL, 205.00, 'g', '2026-02-07 07:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (58, 4, 'breakfast', '鸡蛋', 179, NULL, NULL, NULL, 98.00, 'g', '2026-02-07 07:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (59, 4, 'breakfast', '牛奶', 120, NULL, NULL, NULL, 221.00, 'ml', '2026-02-07 07:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (60, 4, 'lunch', '米饭', 258, NULL, NULL, NULL, 220.00, 'g', '2026-02-07 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (61, 4, 'lunch', '清蒸鲈鱼', 168, NULL, NULL, NULL, 200.00, 'g', '2026-02-07 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (62, 4, 'lunch', '青菜', 51, NULL, NULL, NULL, 117.00, 'g', '2026-02-07 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (63, 4, 'lunch', '紫菜蛋汤', 77, NULL, NULL, NULL, 278.00, 'ml', '2026-02-07 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (64, 4, 'dinner', '荞麦面', 189, NULL, NULL, NULL, 260.00, 'g', '2026-02-07 18:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (65, 4, 'dinner', '鸡胸肉沙拉', 208, NULL, NULL, NULL, 124.00, 'g', '2026-02-07 18:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (66, 4, 'dinner', '豆腐汤', 90, NULL, NULL, NULL, 357.00, 'ml', '2026-02-07 18:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (67, 4, 'snack', '香蕉', 108, NULL, NULL, NULL, 100.00, 'g', '2026-02-07 15:51:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (68, 4, 'snack', '无糖酸奶', 90, NULL, NULL, NULL, 150.00, 'g', '2026-02-07 20:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (69, 4, 'breakfast', '燕麦粥', 174, NULL, NULL, NULL, 209.00, 'g', '2026-02-08 07:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (70, 4, 'breakfast', '鸡蛋', 145, NULL, NULL, NULL, 103.00, 'g', '2026-02-08 07:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (71, 4, 'breakfast', '牛奶', 97, NULL, NULL, NULL, 250.00, 'ml', '2026-02-08 07:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (72, 4, 'lunch', '米饭', 226, NULL, NULL, NULL, 212.00, 'g', '2026-02-08 12:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (73, 4, 'lunch', '番茄炒蛋', 178, NULL, NULL, NULL, 180.00, 'g', '2026-02-08 12:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (74, 4, 'lunch', '青菜', 31, NULL, NULL, NULL, 127.00, 'g', '2026-02-08 12:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (75, 4, 'lunch', '紫菜蛋汤', 68, NULL, NULL, NULL, 349.00, 'ml', '2026-02-08 12:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (76, 4, 'dinner', '荞麦面', 236, NULL, NULL, NULL, 235.00, 'g', '2026-02-08 18:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (77, 4, 'dinner', '鸡胸肉沙拉', 189, NULL, NULL, NULL, 124.00, 'g', '2026-02-08 18:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (78, 4, 'dinner', '豆腐汤', 85, NULL, NULL, NULL, 308.00, 'ml', '2026-02-08 18:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (79, 4, 'snack', '香蕉', 75, NULL, NULL, NULL, 100.00, 'g', '2026-02-08 15:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (80, 4, 'breakfast', '燕麦粥', 153, NULL, NULL, NULL, 206.00, 'g', '2026-02-09 07:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (81, 4, 'breakfast', '鸡蛋', 162, NULL, NULL, NULL, 103.00, 'g', '2026-02-09 07:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (82, 4, 'breakfast', '牛奶', 97, NULL, NULL, NULL, 188.00, 'ml', '2026-02-09 07:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (83, 4, 'lunch', '米饭', 319, NULL, NULL, NULL, 212.00, 'g', '2026-02-09 12:07:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (84, 4, 'lunch', '清蒸鲈鱼', 184, NULL, NULL, NULL, 200.00, 'g', '2026-02-09 12:07:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (85, 4, 'lunch', '青菜', 26, NULL, NULL, NULL, 134.00, 'g', '2026-02-09 12:07:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (86, 4, 'dinner', '杂粮粥', 171, NULL, NULL, NULL, 243.00, 'g', '2026-02-09 18:23:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (87, 4, 'dinner', '鸡胸肉沙拉', 198, NULL, NULL, NULL, 178.00, 'g', '2026-02-09 18:23:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (88, 4, 'dinner', '豆腐汤', 108, NULL, NULL, NULL, 298.00, 'ml', '2026-02-09 18:23:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (89, 4, 'snack', '牛奶', 99, NULL, NULL, NULL, 200.00, 'ml', '2026-02-09 16:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (90, 4, 'breakfast', '燕麦粥', 148, NULL, NULL, NULL, 214.00, 'g', '2026-02-10 07:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (91, 4, 'breakfast', '鸡蛋', 163, NULL, NULL, NULL, 104.00, 'g', '2026-02-10 07:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (92, 4, 'breakfast', '牛奶', 126, NULL, NULL, NULL, 225.00, 'ml', '2026-02-10 07:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (93, 4, 'lunch', '米饭', 243, NULL, NULL, NULL, 238.00, 'g', '2026-02-10 12:24:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (94, 4, 'lunch', '宫保鸡丁', 232, NULL, NULL, NULL, 160.00, 'g', '2026-02-10 12:24:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (95, 4, 'lunch', '青菜', 51, NULL, NULL, NULL, 145.00, 'g', '2026-02-10 12:24:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (96, 4, 'dinner', '荞麦面', 184, NULL, NULL, NULL, 229.00, 'g', '2026-02-10 18:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (97, 4, 'dinner', '鸡胸肉沙拉', 169, NULL, NULL, NULL, 196.00, 'g', '2026-02-10 18:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (98, 4, 'snack', '坚果', 151, NULL, NULL, NULL, 30.00, 'g', '2026-02-10 10:49:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (99, 4, 'breakfast', '燕麦粥', 163, NULL, NULL, NULL, 196.00, 'g', '2026-02-11 07:31:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (100, 4, 'breakfast', '鸡蛋', 164, NULL, NULL, NULL, 99.00, 'g', '2026-02-11 07:31:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (101, 4, 'lunch', '米饭', 296, NULL, NULL, NULL, 213.00, 'g', '2026-02-11 12:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (102, 4, 'lunch', '宫保鸡丁', 264, NULL, NULL, NULL, 160.00, 'g', '2026-02-11 12:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (103, 4, 'lunch', '青菜', 54, NULL, NULL, NULL, 150.00, 'g', '2026-02-11 12:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (104, 4, 'lunch', '紫菜蛋汤', 65, NULL, NULL, NULL, 275.00, 'ml', '2026-02-11 12:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (105, 4, 'dinner', '杂粮粥', 137, NULL, NULL, NULL, 300.00, 'g', '2026-02-11 18:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (106, 4, 'dinner', '鸡胸肉沙拉', 198, NULL, NULL, NULL, 140.00, 'g', '2026-02-11 18:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (107, 4, 'dinner', '豆腐汤', 114, NULL, NULL, NULL, 326.00, 'ml', '2026-02-11 18:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (108, 4, 'snack', '坚果', 180, NULL, NULL, NULL, 30.00, 'g', '2026-02-11 10:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (109, 4, 'breakfast', '燕麦粥', 166, NULL, NULL, NULL, 210.00, 'g', '2026-02-12 07:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (110, 4, 'breakfast', '鸡蛋', 162, NULL, NULL, NULL, 119.00, 'g', '2026-02-12 07:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (111, 4, 'breakfast', '牛奶', 105, NULL, NULL, NULL, 200.00, 'ml', '2026-02-12 07:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (112, 4, 'lunch', '米饭', 288, NULL, NULL, NULL, 190.00, 'g', '2026-02-12 12:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (113, 4, 'lunch', '宫保鸡丁', 245, NULL, NULL, NULL, 160.00, 'g', '2026-02-12 12:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (114, 4, 'lunch', '青菜', 26, NULL, NULL, NULL, 111.00, 'g', '2026-02-12 12:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (115, 4, 'dinner', '杂粮粥', 147, NULL, NULL, NULL, 259.00, 'g', '2026-02-12 18:06:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (116, 4, 'dinner', '鸡胸肉沙拉', 166, NULL, NULL, NULL, 168.00, 'g', '2026-02-12 18:06:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (117, 4, 'dinner', '豆腐汤', 86, NULL, NULL, NULL, 362.00, 'ml', '2026-02-12 18:06:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (118, 4, 'snack', '牛奶', 119, NULL, NULL, NULL, 200.00, 'ml', '2026-02-12 21:54:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (119, 4, 'breakfast', '燕麦粥', 161, NULL, NULL, NULL, 240.00, 'g', '2026-02-13 07:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (120, 4, 'breakfast', '鸡蛋', 159, NULL, NULL, NULL, 109.00, 'g', '2026-02-13 07:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (121, 4, 'breakfast', '牛奶', 110, NULL, NULL, NULL, 216.00, 'ml', '2026-02-13 07:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (122, 4, 'lunch', '米饭', 277, NULL, NULL, NULL, 162.00, 'g', '2026-02-13 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (123, 4, 'lunch', '青椒肉丝', 203, NULL, NULL, NULL, 150.00, 'g', '2026-02-13 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (124, 4, 'lunch', '青菜', 43, NULL, NULL, NULL, 99.00, 'g', '2026-02-13 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (125, 4, 'dinner', '荞麦面', 233, NULL, NULL, NULL, 180.00, 'g', '2026-02-13 18:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (126, 4, 'dinner', '鸡胸肉沙拉', 169, NULL, NULL, NULL, 165.00, 'g', '2026-02-13 18:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (127, 4, 'snack', '牛奶', 116, NULL, NULL, NULL, 200.00, 'ml', '2026-02-13 16:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (128, 4, 'breakfast', '燕麦粥', 153, NULL, NULL, NULL, 208.00, 'g', '2026-02-14 07:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (129, 4, 'breakfast', '鸡蛋', 176, NULL, NULL, NULL, 96.00, 'g', '2026-02-14 07:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (130, 4, 'lunch', '米饭', 261, NULL, NULL, NULL, 233.00, 'g', '2026-02-14 12:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (131, 4, 'lunch', '宫保鸡丁', 224, NULL, NULL, NULL, 160.00, 'g', '2026-02-14 12:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (132, 4, 'lunch', '青菜', 55, NULL, NULL, NULL, 105.00, 'g', '2026-02-14 12:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (133, 4, 'dinner', '荞麦面', 200, NULL, NULL, NULL, 260.00, 'g', '2026-02-14 18:06:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (134, 4, 'dinner', '鸡胸肉沙拉', 168, NULL, NULL, NULL, 186.00, 'g', '2026-02-14 18:06:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (135, 4, 'dinner', '豆腐汤', 79, NULL, NULL, NULL, 352.00, 'ml', '2026-02-14 18:06:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (136, 4, 'snack', '坚果', 155, NULL, NULL, NULL, 30.00, 'g', '2026-02-14 15:46:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (137, 4, 'breakfast', '燕麦粥', 209, NULL, NULL, NULL, 212.00, 'g', '2026-02-15 07:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (138, 4, 'breakfast', '鸡蛋', 159, NULL, NULL, NULL, 114.00, 'g', '2026-02-15 07:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (139, 4, 'breakfast', '牛奶', 109, NULL, NULL, NULL, 188.00, 'ml', '2026-02-15 07:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (140, 4, 'lunch', '米饭', 223, NULL, NULL, NULL, 165.00, 'g', '2026-02-15 12:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (141, 4, 'lunch', '宫保鸡丁', 235, NULL, NULL, NULL, 160.00, 'g', '2026-02-15 12:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (142, 4, 'lunch', '青菜', 31, NULL, NULL, NULL, 134.00, 'g', '2026-02-15 12:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (143, 4, 'dinner', '荞麦面', 202, NULL, NULL, NULL, 228.00, 'g', '2026-02-15 18:46:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (144, 4, 'dinner', '鸡胸肉沙拉', 207, NULL, NULL, NULL, 143.00, 'g', '2026-02-15 18:46:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (145, 4, 'breakfast', '燕麦粥', 209, NULL, NULL, NULL, 256.00, 'g', '2026-02-16 07:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (146, 4, 'breakfast', '鸡蛋', 166, NULL, NULL, NULL, 117.00, 'g', '2026-02-16 07:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (147, 4, 'breakfast', '牛奶', 90, NULL, NULL, NULL, 246.00, 'ml', '2026-02-16 07:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (148, 4, 'lunch', '米饭', 223, NULL, NULL, NULL, 207.00, 'g', '2026-02-16 12:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (149, 4, 'lunch', '清蒸鲈鱼', 188, NULL, NULL, NULL, 200.00, 'g', '2026-02-16 12:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (150, 4, 'lunch', '青菜', 52, NULL, NULL, NULL, 124.00, 'g', '2026-02-16 12:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (151, 4, 'lunch', '紫菜蛋汤', 77, NULL, NULL, NULL, 344.00, 'ml', '2026-02-16 12:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (152, 4, 'dinner', '杂粮粥', 170, NULL, NULL, NULL, 227.00, 'g', '2026-02-16 18:24:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (153, 4, 'dinner', '鸡胸肉沙拉', 155, NULL, NULL, NULL, 164.00, 'g', '2026-02-16 18:24:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (154, 4, 'breakfast', '燕麦粥', 203, NULL, NULL, NULL, 198.00, 'g', '2026-02-17 07:23:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (155, 4, 'breakfast', '鸡蛋', 161, NULL, NULL, NULL, 118.00, 'g', '2026-02-17 07:23:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (156, 4, 'breakfast', '牛奶', 126, NULL, NULL, NULL, 227.00, 'ml', '2026-02-17 07:23:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (157, 4, 'lunch', '米饭', 240, NULL, NULL, NULL, 168.00, 'g', '2026-02-17 12:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (158, 4, 'lunch', '青椒肉丝', 199, NULL, NULL, NULL, 150.00, 'g', '2026-02-17 12:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (159, 4, 'lunch', '青菜', 50, NULL, NULL, NULL, 144.00, 'g', '2026-02-17 12:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (160, 4, 'lunch', '紫菜蛋汤', 84, NULL, NULL, NULL, 337.00, 'ml', '2026-02-17 12:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (161, 4, 'dinner', '荞麦面', 240, NULL, NULL, NULL, 226.00, 'g', '2026-02-17 18:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (162, 4, 'dinner', '鸡胸肉沙拉', 172, NULL, NULL, NULL, 148.00, 'g', '2026-02-17 18:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (163, 4, 'dinner', '豆腐汤', 105, NULL, NULL, NULL, 326.00, 'ml', '2026-02-17 18:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (164, 4, 'snack', '牛奶', 112, NULL, NULL, NULL, 200.00, 'ml', '2026-02-17 10:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (165, 4, 'breakfast', '燕麦粥', 142, NULL, NULL, NULL, 255.00, 'g', '2026-02-18 07:11:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (166, 4, 'breakfast', '鸡蛋', 164, NULL, NULL, NULL, 94.00, 'g', '2026-02-18 07:11:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (167, 4, 'breakfast', '牛奶', 124, NULL, NULL, NULL, 230.00, 'ml', '2026-02-18 07:11:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (168, 4, 'lunch', '米饭', 245, NULL, NULL, NULL, 226.00, 'g', '2026-02-18 12:27:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (169, 4, 'lunch', '麻婆豆腐', 189, NULL, NULL, NULL, 200.00, 'g', '2026-02-18 12:27:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (170, 4, 'lunch', '青菜', 46, NULL, NULL, NULL, 125.00, 'g', '2026-02-18 12:27:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (171, 4, 'lunch', '紫菜蛋汤', 64, NULL, NULL, NULL, 298.00, 'ml', '2026-02-18 12:27:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (172, 4, 'dinner', '杂粮粥', 198, NULL, NULL, NULL, 261.00, 'g', '2026-02-18 18:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (173, 4, 'dinner', '鸡胸肉沙拉', 151, NULL, NULL, NULL, 123.00, 'g', '2026-02-18 18:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (174, 4, 'dinner', '豆腐汤', 95, NULL, NULL, NULL, 321.00, 'ml', '2026-02-18 18:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (175, 4, 'snack', '苹果', 67, NULL, NULL, NULL, 120.00, 'g', '2026-02-18 10:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (176, 4, 'breakfast', '燕麦粥', 171, NULL, NULL, NULL, 252.00, 'g', '2026-02-19 07:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (177, 4, 'breakfast', '鸡蛋', 158, NULL, NULL, NULL, 105.00, 'g', '2026-02-19 07:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (178, 4, 'breakfast', '牛奶', 116, NULL, NULL, NULL, 200.00, 'ml', '2026-02-19 07:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (179, 4, 'lunch', '米饭', 263, NULL, NULL, NULL, 234.00, 'g', '2026-02-19 12:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (180, 4, 'lunch', '青椒肉丝', 197, NULL, NULL, NULL, 150.00, 'g', '2026-02-19 12:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (181, 4, 'lunch', '青菜', 52, NULL, NULL, NULL, 149.00, 'g', '2026-02-19 12:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (182, 4, 'dinner', '荞麦面', 227, NULL, NULL, NULL, 206.00, 'g', '2026-02-19 18:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (183, 4, 'dinner', '鸡胸肉沙拉', 200, NULL, NULL, NULL, 165.00, 'g', '2026-02-19 18:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (184, 4, 'dinner', '豆腐汤', 76, NULL, NULL, NULL, 318.00, 'ml', '2026-02-19 18:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (185, 4, 'breakfast', '燕麦粥', 198, NULL, NULL, NULL, 238.00, 'g', '2026-02-20 07:43:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (186, 4, 'breakfast', '鸡蛋', 154, NULL, NULL, NULL, 109.00, 'g', '2026-02-20 07:43:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (187, 4, 'breakfast', '牛奶', 112, NULL, NULL, NULL, 212.00, 'ml', '2026-02-20 07:43:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (188, 4, 'lunch', '米饭', 288, NULL, NULL, NULL, 169.00, 'g', '2026-02-20 12:00:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (189, 4, 'lunch', '宫保鸡丁', 227, NULL, NULL, NULL, 160.00, 'g', '2026-02-20 12:00:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (190, 4, 'lunch', '青菜', 45, NULL, NULL, NULL, 98.00, 'g', '2026-02-20 12:00:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (191, 4, 'lunch', '紫菜蛋汤', 65, NULL, NULL, NULL, 350.00, 'ml', '2026-02-20 12:00:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (192, 4, 'dinner', '荞麦面', 211, NULL, NULL, NULL, 232.00, 'g', '2026-02-20 18:35:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (193, 4, 'dinner', '鸡胸肉沙拉', 204, NULL, NULL, NULL, 177.00, 'g', '2026-02-20 18:35:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (194, 4, 'breakfast', '燕麦粥', 185, NULL, NULL, NULL, 239.00, 'g', '2026-02-21 07:43:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (195, 4, 'breakfast', '鸡蛋', 161, NULL, NULL, NULL, 98.00, 'g', '2026-02-21 07:43:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (196, 4, 'breakfast', '牛奶', 120, NULL, NULL, NULL, 192.00, 'ml', '2026-02-21 07:43:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (197, 4, 'lunch', '米饭', 230, NULL, NULL, NULL, 167.00, 'g', '2026-02-21 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (198, 4, 'lunch', '宫保鸡丁', 228, NULL, NULL, NULL, 160.00, 'g', '2026-02-21 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (199, 4, 'lunch', '青菜', 42, NULL, NULL, NULL, 80.00, 'g', '2026-02-21 12:25:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (200, 4, 'dinner', '荞麦面', 231, NULL, NULL, NULL, 230.00, 'g', '2026-02-21 18:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (201, 4, 'dinner', '鸡胸肉沙拉', 180, NULL, NULL, NULL, 140.00, 'g', '2026-02-21 18:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (202, 4, 'dinner', '豆腐汤', 114, NULL, NULL, NULL, 297.00, 'ml', '2026-02-21 18:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (203, 4, 'breakfast', '燕麦粥', 190, NULL, NULL, NULL, 223.00, 'g', '2026-02-22 07:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (204, 4, 'breakfast', '鸡蛋', 159, NULL, NULL, NULL, 87.00, 'g', '2026-02-22 07:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (205, 4, 'breakfast', '牛奶', 106, NULL, NULL, NULL, 192.00, 'ml', '2026-02-22 07:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (206, 4, 'lunch', '米饭', 287, NULL, NULL, NULL, 219.00, 'g', '2026-02-22 12:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (207, 4, 'lunch', '宫保鸡丁', 262, NULL, NULL, NULL, 160.00, 'g', '2026-02-22 12:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (208, 4, 'lunch', '青菜', 48, NULL, NULL, NULL, 127.00, 'g', '2026-02-22 12:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (209, 4, 'dinner', '荞麦面', 204, NULL, NULL, NULL, 194.00, 'g', '2026-02-22 18:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (210, 4, 'dinner', '鸡胸肉沙拉', 185, NULL, NULL, NULL, 153.00, 'g', '2026-02-22 18:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (211, 4, 'dinner', '豆腐汤', 94, NULL, NULL, NULL, 370.00, 'ml', '2026-02-22 18:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (212, 4, 'snack', '香蕉', 75, NULL, NULL, NULL, 100.00, 'g', '2026-02-22 16:41:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (213, 4, 'breakfast', '燕麦粥', 172, NULL, NULL, NULL, 248.00, 'g', '2026-02-23 07:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (214, 4, 'breakfast', '鸡蛋', 177, NULL, NULL, NULL, 88.00, 'g', '2026-02-23 07:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (215, 4, 'breakfast', '牛奶', 97, NULL, NULL, NULL, 239.00, 'ml', '2026-02-23 07:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (216, 4, 'lunch', '米饭', 277, NULL, NULL, NULL, 162.00, 'g', '2026-02-23 12:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (217, 4, 'lunch', '蒜蓉西兰花', 80, NULL, NULL, NULL, 200.00, 'g', '2026-02-23 12:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (218, 4, 'lunch', '青菜', 27, NULL, NULL, NULL, 109.00, 'g', '2026-02-23 12:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (219, 4, 'lunch', '紫菜蛋汤', 91, NULL, NULL, NULL, 257.00, 'ml', '2026-02-23 12:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (220, 4, 'dinner', '荞麦面', 201, NULL, NULL, NULL, 200.00, 'g', '2026-02-23 18:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (221, 4, 'dinner', '鸡胸肉沙拉', 164, NULL, NULL, NULL, 132.00, 'g', '2026-02-23 18:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (222, 4, 'dinner', '豆腐汤', 104, NULL, NULL, NULL, 348.00, 'ml', '2026-02-23 18:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (223, 4, 'snack', '无糖酸奶', 100, NULL, NULL, NULL, 150.00, 'g', '2026-02-23 20:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (224, 4, 'breakfast', '燕麦粥', 174, NULL, NULL, NULL, 198.00, 'g', '2026-02-24 07:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (225, 4, 'breakfast', '鸡蛋', 168, NULL, NULL, NULL, 100.00, 'g', '2026-02-24 07:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (226, 4, 'breakfast', '牛奶', 95, NULL, NULL, NULL, 192.00, 'ml', '2026-02-24 07:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (227, 4, 'lunch', '米饭', 237, NULL, NULL, NULL, 160.00, 'g', '2026-02-24 12:07:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (228, 4, 'lunch', '麻婆豆腐', 196, NULL, NULL, NULL, 200.00, 'g', '2026-02-24 12:07:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (229, 4, 'lunch', '青菜', 50, NULL, NULL, NULL, 143.00, 'g', '2026-02-24 12:07:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (230, 4, 'dinner', '荞麦面', 187, NULL, NULL, NULL, 180.00, 'g', '2026-02-24 18:48:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (231, 4, 'dinner', '鸡胸肉沙拉', 186, NULL, NULL, NULL, 137.00, 'g', '2026-02-24 18:48:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (232, 4, 'dinner', '豆腐汤', 117, NULL, NULL, NULL, 375.00, 'ml', '2026-02-24 18:48:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (233, 4, 'snack', '牛奶', 95, NULL, NULL, NULL, 200.00, 'ml', '2026-02-24 16:09:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (234, 4, 'snack', '无糖酸奶', 85, NULL, NULL, NULL, 150.00, 'g', '2026-02-24 20:35:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (235, 4, 'breakfast', '燕麦粥', 148, NULL, NULL, NULL, 196.00, 'g', '2026-02-25 07:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (236, 4, 'breakfast', '鸡蛋', 154, NULL, NULL, NULL, 91.00, 'g', '2026-02-25 07:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (237, 4, 'breakfast', '牛奶', 107, NULL, NULL, NULL, 225.00, 'ml', '2026-02-25 07:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (238, 4, 'lunch', '米饭', 239, NULL, NULL, NULL, 214.00, 'g', '2026-02-25 12:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (239, 4, 'lunch', '番茄炒蛋', 165, NULL, NULL, NULL, 180.00, 'g', '2026-02-25 12:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (240, 4, 'lunch', '青菜', 29, NULL, NULL, NULL, 140.00, 'g', '2026-02-25 12:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (241, 4, 'lunch', '紫菜蛋汤', 81, NULL, NULL, NULL, 255.00, 'ml', '2026-02-25 12:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (242, 4, 'dinner', '杂粮粥', 157, NULL, NULL, NULL, 246.00, 'g', '2026-02-25 18:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (243, 4, 'dinner', '鸡胸肉沙拉', 192, NULL, NULL, NULL, 167.00, 'g', '2026-02-25 18:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (244, 4, 'dinner', '豆腐汤', 119, NULL, NULL, NULL, 293.00, 'ml', '2026-02-25 18:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (245, 4, 'snack', '坚果', 174, NULL, NULL, NULL, 30.00, 'g', '2026-02-25 15:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (246, 4, 'breakfast', '燕麦粥', 187, NULL, NULL, NULL, 183.00, 'g', '2026-02-26 07:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (247, 4, 'breakfast', '鸡蛋', 154, NULL, NULL, NULL, 85.00, 'g', '2026-02-26 07:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (248, 4, 'breakfast', '牛奶', 112, NULL, NULL, NULL, 201.00, 'ml', '2026-02-26 07:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (249, 4, 'lunch', '米饭', 279, NULL, NULL, NULL, 207.00, 'g', '2026-02-26 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (250, 4, 'lunch', '清蒸鲈鱼', 178, NULL, NULL, NULL, 200.00, 'g', '2026-02-26 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (251, 4, 'lunch', '青菜', 28, NULL, NULL, NULL, 131.00, 'g', '2026-02-26 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (252, 4, 'lunch', '紫菜蛋汤', 86, NULL, NULL, NULL, 266.00, 'ml', '2026-02-26 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (253, 4, 'dinner', '杂粮粥', 167, NULL, NULL, NULL, 224.00, 'g', '2026-02-26 18:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (254, 4, 'dinner', '鸡胸肉沙拉', 196, NULL, NULL, NULL, 123.00, 'g', '2026-02-26 18:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (255, 4, 'snack', '酸奶', 100, NULL, NULL, NULL, 100.00, 'g', '2026-02-26 10:48:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (256, 4, 'breakfast', '燕麦粥', 196, NULL, NULL, NULL, 198.00, 'g', '2026-02-27 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (257, 4, 'breakfast', '鸡蛋', 155, NULL, NULL, NULL, 80.00, 'g', '2026-02-27 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (258, 4, 'breakfast', '牛奶', 111, NULL, NULL, NULL, 214.00, 'ml', '2026-02-27 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (259, 4, 'lunch', '米饭', 316, NULL, NULL, NULL, 190.00, 'g', '2026-02-27 12:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (260, 4, 'lunch', '蒜蓉西兰花', 104, NULL, NULL, NULL, 200.00, 'g', '2026-02-27 12:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (261, 4, 'lunch', '青菜', 52, NULL, NULL, NULL, 135.00, 'g', '2026-02-27 12:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (262, 4, 'dinner', '荞麦面', 172, NULL, NULL, NULL, 232.00, 'g', '2026-02-27 18:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (263, 4, 'dinner', '鸡胸肉沙拉', 210, NULL, NULL, NULL, 187.00, 'g', '2026-02-27 18:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (264, 4, 'dinner', '豆腐汤', 107, NULL, NULL, NULL, 287.00, 'ml', '2026-02-27 18:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (265, 4, 'breakfast', '燕麦粥', 193, NULL, NULL, NULL, 220.00, 'g', '2026-02-28 07:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (266, 4, 'breakfast', '鸡蛋', 175, NULL, NULL, NULL, 97.00, 'g', '2026-02-28 07:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (267, 4, 'breakfast', '牛奶', 96, NULL, NULL, NULL, 236.00, 'ml', '2026-02-28 07:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (268, 4, 'lunch', '米饭', 307, NULL, NULL, NULL, 233.00, 'g', '2026-02-28 12:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (269, 4, 'lunch', '青椒肉丝', 244, NULL, NULL, NULL, 150.00, 'g', '2026-02-28 12:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (270, 4, 'lunch', '青菜', 29, NULL, NULL, NULL, 140.00, 'g', '2026-02-28 12:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (271, 4, 'dinner', '荞麦面', 201, NULL, NULL, NULL, 247.00, 'g', '2026-02-28 18:42:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (272, 4, 'dinner', '鸡胸肉沙拉', 158, NULL, NULL, NULL, 191.00, 'g', '2026-02-28 18:42:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (273, 4, 'dinner', '豆腐汤', 102, NULL, NULL, NULL, 327.00, 'ml', '2026-02-28 18:42:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (274, 4, 'snack', '香蕉', 76, NULL, NULL, NULL, 100.00, 'g', '2026-02-28 15:29:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (275, 4, 'snack', '无糖酸奶', 94, NULL, NULL, NULL, 150.00, 'g', '2026-02-28 20:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (276, 4, 'breakfast', '燕麦粥', 162, NULL, NULL, NULL, 204.00, 'g', '2026-03-01 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (277, 4, 'breakfast', '鸡蛋', 153, NULL, NULL, NULL, 120.00, 'g', '2026-03-01 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (278, 4, 'breakfast', '牛奶', 100, NULL, NULL, NULL, 226.00, 'ml', '2026-03-01 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (279, 4, 'lunch', '米饭', 276, NULL, NULL, NULL, 160.00, 'g', '2026-03-01 12:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (280, 4, 'lunch', '宫保鸡丁', 263, NULL, NULL, NULL, 160.00, 'g', '2026-03-01 12:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (281, 4, 'lunch', '青菜', 40, NULL, NULL, NULL, 128.00, 'g', '2026-03-01 12:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (282, 4, 'dinner', '杂粮粥', 168, NULL, NULL, NULL, 280.00, 'g', '2026-03-01 18:09:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (283, 4, 'dinner', '鸡胸肉沙拉', 206, NULL, NULL, NULL, 148.00, 'g', '2026-03-01 18:09:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (284, 4, 'snack', '无糖酸奶', 78, NULL, NULL, NULL, 150.00, 'g', '2026-03-01 20:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (285, 4, 'breakfast', '燕麦粥', 197, NULL, NULL, NULL, 202.00, 'g', '2026-03-02 07:20:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (286, 4, 'breakfast', '鸡蛋', 141, NULL, NULL, NULL, 109.00, 'g', '2026-03-02 07:20:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (287, 4, 'breakfast', '牛奶', 112, NULL, NULL, NULL, 242.00, 'ml', '2026-03-02 07:20:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (288, 4, 'lunch', '米饭', 258, NULL, NULL, NULL, 185.00, 'g', '2026-03-02 12:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (289, 4, 'lunch', '麻婆豆腐', 205, NULL, NULL, NULL, 200.00, 'g', '2026-03-02 12:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (290, 4, 'lunch', '青菜', 40, NULL, NULL, NULL, 111.00, 'g', '2026-03-02 12:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (291, 4, 'lunch', '紫菜蛋汤', 91, NULL, NULL, NULL, 299.00, 'ml', '2026-03-02 12:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (292, 4, 'dinner', '杂粮粥', 171, NULL, NULL, NULL, 269.00, 'g', '2026-03-02 18:50:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (293, 4, 'dinner', '鸡胸肉沙拉', 180, NULL, NULL, NULL, 124.00, 'g', '2026-03-02 18:50:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (294, 4, 'dinner', '豆腐汤', 80, NULL, NULL, NULL, 335.00, 'ml', '2026-03-02 18:50:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (295, 4, 'snack', '坚果', 142, NULL, NULL, NULL, 30.00, 'g', '2026-03-02 16:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (296, 4, 'breakfast', '燕麦粥', 200, NULL, NULL, NULL, 185.00, 'g', '2026-03-03 07:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (297, 4, 'breakfast', '鸡蛋', 163, NULL, NULL, NULL, 117.00, 'g', '2026-03-03 07:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (298, 4, 'lunch', '米饭', 222, NULL, NULL, NULL, 177.00, 'g', '2026-03-03 12:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (299, 4, 'lunch', '蒜蓉西兰花', 91, NULL, NULL, NULL, 200.00, 'g', '2026-03-03 12:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (300, 4, 'lunch', '青菜', 32, NULL, NULL, NULL, 109.00, 'g', '2026-03-03 12:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (301, 4, 'lunch', '紫菜蛋汤', 89, NULL, NULL, NULL, 250.00, 'ml', '2026-03-03 12:40:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (302, 4, 'dinner', '荞麦面', 177, NULL, NULL, NULL, 218.00, 'g', '2026-03-03 18:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (303, 4, 'dinner', '鸡胸肉沙拉', 196, NULL, NULL, NULL, 140.00, 'g', '2026-03-03 18:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (304, 4, 'dinner', '豆腐汤', 91, NULL, NULL, NULL, 296.00, 'ml', '2026-03-03 18:30:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (305, 4, 'snack', '酸奶', 122, NULL, NULL, NULL, 100.00, 'g', '2026-03-03 21:06:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (306, 4, 'breakfast', '燕麦粥', 185, NULL, NULL, NULL, 222.00, 'g', '2026-03-04 07:45:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (307, 4, 'breakfast', '鸡蛋', 142, NULL, NULL, NULL, 109.00, 'g', '2026-03-04 07:45:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (308, 4, 'breakfast', '牛奶', 103, NULL, NULL, NULL, 218.00, 'ml', '2026-03-04 07:45:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (309, 4, 'lunch', '米饭', 289, NULL, NULL, NULL, 212.00, 'g', '2026-03-04 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (310, 4, 'lunch', '宫保鸡丁', 250, NULL, NULL, NULL, 160.00, 'g', '2026-03-04 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (311, 4, 'lunch', '青菜', 32, NULL, NULL, NULL, 105.00, 'g', '2026-03-04 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (312, 4, 'lunch', '紫菜蛋汤', 96, NULL, NULL, NULL, 251.00, 'ml', '2026-03-04 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (313, 4, 'dinner', '杂粮粥', 172, NULL, NULL, NULL, 238.00, 'g', '2026-03-04 18:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (314, 4, 'dinner', '鸡胸肉沙拉', 218, NULL, NULL, NULL, 187.00, 'g', '2026-03-04 18:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (315, 4, 'snack', '坚果', 165, NULL, NULL, NULL, 30.00, 'g', '2026-03-04 16:45:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (316, 4, 'breakfast', '燕麦粥', 204, NULL, NULL, NULL, 219.00, 'g', '2026-03-05 07:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (317, 4, 'breakfast', '鸡蛋', 158, NULL, NULL, NULL, 96.00, 'g', '2026-03-05 07:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (318, 4, 'lunch', '米饭', 273, NULL, NULL, NULL, 211.00, 'g', '2026-03-05 12:13:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (319, 4, 'lunch', '番茄炒蛋', 177, NULL, NULL, NULL, 180.00, 'g', '2026-03-05 12:13:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (320, 4, 'lunch', '青菜', 27, NULL, NULL, NULL, 96.00, 'g', '2026-03-05 12:13:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (321, 4, 'lunch', '紫菜蛋汤', 64, NULL, NULL, NULL, 326.00, 'ml', '2026-03-05 12:13:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (322, 4, 'dinner', '荞麦面', 208, NULL, NULL, NULL, 185.00, 'g', '2026-03-05 18:44:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (323, 4, 'dinner', '鸡胸肉沙拉', 197, NULL, NULL, NULL, 162.00, 'g', '2026-03-05 18:44:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (324, 4, 'dinner', '豆腐汤', 81, NULL, NULL, NULL, 304.00, 'ml', '2026-03-05 18:44:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (325, 4, 'snack', '苹果', 84, NULL, NULL, NULL, 120.00, 'g', '2026-03-05 15:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (326, 4, 'breakfast', '燕麦粥', 141, NULL, NULL, NULL, 223.00, 'g', '2026-03-06 07:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (327, 4, 'breakfast', '鸡蛋', 146, NULL, NULL, NULL, 115.00, 'g', '2026-03-06 07:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (328, 4, 'breakfast', '牛奶', 120, NULL, NULL, NULL, 217.00, 'ml', '2026-03-06 07:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (329, 4, 'lunch', '米饭', 259, NULL, NULL, NULL, 188.00, 'g', '2026-03-06 12:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (330, 4, 'lunch', '宫保鸡丁', 257, NULL, NULL, NULL, 160.00, 'g', '2026-03-06 12:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (331, 4, 'lunch', '青菜', 47, NULL, NULL, NULL, 115.00, 'g', '2026-03-06 12:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (332, 4, 'lunch', '紫菜蛋汤', 90, NULL, NULL, NULL, 324.00, 'ml', '2026-03-06 12:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (333, 4, 'dinner', '杂粮粥', 150, NULL, NULL, NULL, 240.00, 'g', '2026-03-06 18:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (334, 4, 'dinner', '鸡胸肉沙拉', 189, NULL, NULL, NULL, 122.00, 'g', '2026-03-06 18:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (335, 4, 'dinner', '豆腐汤', 80, NULL, NULL, NULL, 341.00, 'ml', '2026-03-06 18:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (336, 4, 'breakfast', '燕麦粥', 140, NULL, NULL, NULL, 242.00, 'g', '2026-03-07 07:11:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (337, 4, 'breakfast', '鸡蛋', 173, NULL, NULL, NULL, 107.00, 'g', '2026-03-07 07:11:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (338, 4, 'breakfast', '牛奶', 121, NULL, NULL, NULL, 242.00, 'ml', '2026-03-07 07:11:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (339, 4, 'lunch', '米饭', 250, NULL, NULL, NULL, 224.00, 'g', '2026-03-07 12:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (340, 4, 'lunch', '番茄炒蛋', 176, NULL, NULL, NULL, 180.00, 'g', '2026-03-07 12:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (341, 4, 'lunch', '青菜', 30, NULL, NULL, NULL, 82.00, 'g', '2026-03-07 12:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (342, 4, 'lunch', '紫菜蛋汤', 79, NULL, NULL, NULL, 286.00, 'ml', '2026-03-07 12:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (343, 4, 'dinner', '荞麦面', 191, NULL, NULL, NULL, 193.00, 'g', '2026-03-07 18:44:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (344, 4, 'dinner', '鸡胸肉沙拉', 207, NULL, NULL, NULL, 131.00, 'g', '2026-03-07 18:44:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (345, 4, 'dinner', '豆腐汤', 108, NULL, NULL, NULL, 348.00, 'ml', '2026-03-07 18:44:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (346, 4, 'snack', '苹果', 65, NULL, NULL, NULL, 120.00, 'g', '2026-03-07 15:55:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (347, 4, 'breakfast', '燕麦粥', 159, NULL, NULL, NULL, 184.00, 'g', '2026-03-08 07:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (348, 4, 'breakfast', '鸡蛋', 173, NULL, NULL, NULL, 111.00, 'g', '2026-03-08 07:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (349, 4, 'lunch', '米饭', 301, NULL, NULL, NULL, 169.00, 'g', '2026-03-08 12:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (350, 4, 'lunch', '宫保鸡丁', 221, NULL, NULL, NULL, 160.00, 'g', '2026-03-08 12:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (351, 4, 'lunch', '青菜', 54, NULL, NULL, NULL, 89.00, 'g', '2026-03-08 12:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (352, 4, 'dinner', '杂粮粥', 188, NULL, NULL, NULL, 213.00, 'g', '2026-03-08 18:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (353, 4, 'dinner', '鸡胸肉沙拉', 198, NULL, NULL, NULL, 147.00, 'g', '2026-03-08 18:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (354, 4, 'dinner', '豆腐汤', 91, NULL, NULL, NULL, 363.00, 'ml', '2026-03-08 18:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (355, 4, 'snack', '牛奶', 94, NULL, NULL, NULL, 200.00, 'ml', '2026-03-08 16:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (356, 4, 'breakfast', '燕麦粥', 184, NULL, NULL, NULL, 249.00, 'g', '2026-03-09 07:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (357, 4, 'breakfast', '鸡蛋', 165, NULL, NULL, NULL, 92.00, 'g', '2026-03-09 07:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (358, 4, 'breakfast', '牛奶', 120, NULL, NULL, NULL, 190.00, 'ml', '2026-03-09 07:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (359, 4, 'lunch', '米饭', 229, NULL, NULL, NULL, 179.00, 'g', '2026-03-09 12:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (360, 4, 'lunch', '青椒肉丝', 206, NULL, NULL, NULL, 150.00, 'g', '2026-03-09 12:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (361, 4, 'lunch', '青菜', 25, NULL, NULL, NULL, 116.00, 'g', '2026-03-09 12:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (362, 4, 'dinner', '杂粮粥', 156, NULL, NULL, NULL, 225.00, 'g', '2026-03-09 18:46:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (363, 4, 'dinner', '鸡胸肉沙拉', 208, NULL, NULL, NULL, 155.00, 'g', '2026-03-09 18:46:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (364, 4, 'dinner', '豆腐汤', 97, NULL, NULL, NULL, 284.00, 'ml', '2026-03-09 18:46:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (365, 4, 'snack', '坚果', 174, NULL, NULL, NULL, 30.00, 'g', '2026-03-09 16:45:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (366, 4, 'breakfast', '燕麦粥', 154, NULL, NULL, NULL, 195.00, 'g', '2026-03-10 07:23:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (367, 4, 'breakfast', '鸡蛋', 145, NULL, NULL, NULL, 96.00, 'g', '2026-03-10 07:23:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (368, 4, 'lunch', '米饭', 254, NULL, NULL, NULL, 167.00, 'g', '2026-03-10 12:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (369, 4, 'lunch', '麻婆豆腐', 177, NULL, NULL, NULL, 200.00, 'g', '2026-03-10 12:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (370, 4, 'lunch', '青菜', 35, NULL, NULL, NULL, 86.00, 'g', '2026-03-10 12:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (371, 4, 'dinner', '杂粮粥', 148, NULL, NULL, NULL, 293.00, 'g', '2026-03-10 18:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (372, 4, 'dinner', '鸡胸肉沙拉', 208, NULL, NULL, NULL, 160.00, 'g', '2026-03-10 18:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (373, 4, 'dinner', '豆腐汤', 119, NULL, NULL, NULL, 343.00, 'ml', '2026-03-10 18:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (374, 4, 'snack', '牛奶', 95, NULL, NULL, NULL, 200.00, 'ml', '2026-03-10 10:27:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (375, 4, 'breakfast', '燕麦粥', 203, NULL, NULL, NULL, 188.00, 'g', '2026-03-11 07:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (376, 4, 'breakfast', '鸡蛋', 144, NULL, NULL, NULL, 114.00, 'g', '2026-03-11 07:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (377, 4, 'lunch', '米饭', 317, NULL, NULL, NULL, 204.00, 'g', '2026-03-11 12:20:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (378, 4, 'lunch', '青椒肉丝', 235, NULL, NULL, NULL, 150.00, 'g', '2026-03-11 12:20:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (379, 4, 'lunch', '青菜', 40, NULL, NULL, NULL, 109.00, 'g', '2026-03-11 12:20:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (380, 4, 'lunch', '紫菜蛋汤', 97, NULL, NULL, NULL, 343.00, 'ml', '2026-03-11 12:20:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (381, 4, 'dinner', '荞麦面', 174, NULL, NULL, NULL, 242.00, 'g', '2026-03-11 18:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (382, 4, 'dinner', '鸡胸肉沙拉', 198, NULL, NULL, NULL, 160.00, 'g', '2026-03-11 18:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (383, 4, 'snack', '无糖酸奶', 75, NULL, NULL, NULL, 150.00, 'g', '2026-03-11 20:20:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (384, 4, 'breakfast', '燕麦粥', 194, NULL, NULL, NULL, 198.00, 'g', '2026-03-12 07:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (385, 4, 'breakfast', '鸡蛋', 156, NULL, NULL, NULL, 109.00, 'g', '2026-03-12 07:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (386, 4, 'breakfast', '牛奶', 91, NULL, NULL, NULL, 207.00, 'ml', '2026-03-12 07:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (387, 4, 'lunch', '米饭', 229, NULL, NULL, NULL, 177.00, 'g', '2026-03-12 12:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (388, 4, 'lunch', '蒜蓉西兰花', 114, NULL, NULL, NULL, 200.00, 'g', '2026-03-12 12:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (389, 4, 'lunch', '青菜', 55, NULL, NULL, NULL, 142.00, 'g', '2026-03-12 12:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (390, 4, 'dinner', '杂粮粥', 177, NULL, NULL, NULL, 248.00, 'g', '2026-03-12 18:16:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (391, 4, 'dinner', '鸡胸肉沙拉', 207, NULL, NULL, NULL, 164.00, 'g', '2026-03-12 18:16:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (392, 4, 'dinner', '豆腐汤', 81, NULL, NULL, NULL, 323.00, 'ml', '2026-03-12 18:16:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (393, 4, 'snack', '牛奶', 128, NULL, NULL, NULL, 200.00, 'ml', '2026-03-12 21:05:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (394, 4, 'snack', '无糖酸奶', 89, NULL, NULL, NULL, 150.00, 'g', '2026-03-12 20:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (395, 4, 'breakfast', '燕麦粥', 152, NULL, NULL, NULL, 182.00, 'g', '2026-03-13 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (396, 4, 'breakfast', '鸡蛋', 146, NULL, NULL, NULL, 110.00, 'g', '2026-03-13 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (397, 4, 'breakfast', '牛奶', 119, NULL, NULL, NULL, 200.00, 'ml', '2026-03-13 07:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (398, 4, 'lunch', '米饭', 241, NULL, NULL, NULL, 202.00, 'g', '2026-03-13 12:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (399, 4, 'lunch', '清蒸鲈鱼', 172, NULL, NULL, NULL, 200.00, 'g', '2026-03-13 12:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (400, 4, 'lunch', '青菜', 47, NULL, NULL, NULL, 120.00, 'g', '2026-03-13 12:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (401, 4, 'lunch', '紫菜蛋汤', 74, NULL, NULL, NULL, 261.00, 'ml', '2026-03-13 12:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (402, 4, 'dinner', '杂粮粥', 181, NULL, NULL, NULL, 231.00, 'g', '2026-03-13 18:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (403, 4, 'dinner', '鸡胸肉沙拉', 215, NULL, NULL, NULL, 197.00, 'g', '2026-03-13 18:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (404, 4, 'dinner', '豆腐汤', 119, NULL, NULL, NULL, 280.00, 'ml', '2026-03-13 18:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (405, 4, 'breakfast', '燕麦粥', 194, NULL, NULL, NULL, 184.00, 'g', '2026-03-14 07:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (406, 4, 'breakfast', '鸡蛋', 162, NULL, NULL, NULL, 105.00, 'g', '2026-03-14 07:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (407, 4, 'lunch', '米饭', 320, NULL, NULL, NULL, 202.00, 'g', '2026-03-14 12:35:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (408, 4, 'lunch', '清蒸鲈鱼', 165, NULL, NULL, NULL, 200.00, 'g', '2026-03-14 12:35:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (409, 4, 'lunch', '青菜', 52, NULL, NULL, NULL, 84.00, 'g', '2026-03-14 12:35:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (410, 4, 'dinner', '荞麦面', 194, NULL, NULL, NULL, 196.00, 'g', '2026-03-14 18:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (411, 4, 'dinner', '鸡胸肉沙拉', 153, NULL, NULL, NULL, 195.00, 'g', '2026-03-14 18:32:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (412, 4, 'breakfast', '燕麦粥', 145, NULL, NULL, NULL, 224.00, 'g', '2026-03-15 07:31:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (413, 4, 'breakfast', '鸡蛋', 162, NULL, NULL, NULL, 111.00, 'g', '2026-03-15 07:31:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (414, 4, 'breakfast', '牛奶', 97, NULL, NULL, NULL, 250.00, 'ml', '2026-03-15 07:31:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (415, 4, 'lunch', '米饭', 240, NULL, NULL, NULL, 207.00, 'g', '2026-03-15 12:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (416, 4, 'lunch', '青椒肉丝', 195, NULL, NULL, NULL, 150.00, 'g', '2026-03-15 12:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (417, 4, 'lunch', '青菜', 32, NULL, NULL, NULL, 107.00, 'g', '2026-03-15 12:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (418, 4, 'lunch', '紫菜蛋汤', 65, NULL, NULL, NULL, 263.00, 'ml', '2026-03-15 12:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (419, 4, 'dinner', '杂粮粥', 183, NULL, NULL, NULL, 214.00, 'g', '2026-03-15 18:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (420, 4, 'dinner', '鸡胸肉沙拉', 200, NULL, NULL, NULL, 142.00, 'g', '2026-03-15 18:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (421, 4, 'snack', '无糖酸奶', 85, NULL, NULL, NULL, 150.00, 'g', '2026-03-15 20:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (422, 4, 'breakfast', '燕麦粥', 152, NULL, NULL, NULL, 190.00, 'g', '2026-03-16 07:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (423, 4, 'breakfast', '鸡蛋', 178, NULL, NULL, NULL, 91.00, 'g', '2026-03-16 07:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (424, 4, 'breakfast', '牛奶', 91, NULL, NULL, NULL, 230.00, 'ml', '2026-03-16 07:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (425, 4, 'lunch', '米饭', 252, NULL, NULL, NULL, 235.00, 'g', '2026-03-16 12:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (426, 4, 'lunch', '宫保鸡丁', 226, NULL, NULL, NULL, 160.00, 'g', '2026-03-16 12:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (427, 4, 'lunch', '青菜', 30, NULL, NULL, NULL, 88.00, 'g', '2026-03-16 12:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (428, 4, 'lunch', '紫菜蛋汤', 71, NULL, NULL, NULL, 318.00, 'ml', '2026-03-16 12:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (429, 4, 'dinner', '荞麦面', 204, NULL, NULL, NULL, 221.00, 'g', '2026-03-16 18:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (430, 4, 'dinner', '鸡胸肉沙拉', 158, NULL, NULL, NULL, 192.00, 'g', '2026-03-16 18:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (431, 4, 'snack', '无糖酸奶', 99, NULL, NULL, NULL, 150.00, 'g', '2026-03-16 20:13:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (432, 4, 'breakfast', '燕麦粥', 217, NULL, NULL, NULL, 201.00, 'g', '2026-03-17 07:43:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (433, 4, 'breakfast', '鸡蛋', 170, NULL, NULL, NULL, 93.00, 'g', '2026-03-17 07:43:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (434, 4, 'breakfast', '牛奶', 116, NULL, NULL, NULL, 227.00, 'ml', '2026-03-17 07:43:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (435, 4, 'lunch', '米饭', 239, NULL, NULL, NULL, 205.00, 'g', '2026-03-17 12:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (436, 4, 'lunch', '蒜蓉西兰花', 88, NULL, NULL, NULL, 200.00, 'g', '2026-03-17 12:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (437, 4, 'lunch', '青菜', 36, NULL, NULL, NULL, 130.00, 'g', '2026-03-17 12:28:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (438, 4, 'dinner', '杂粮粥', 184, NULL, NULL, NULL, 202.00, 'g', '2026-03-17 18:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (439, 4, 'dinner', '鸡胸肉沙拉', 210, NULL, NULL, NULL, 165.00, 'g', '2026-03-17 18:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (440, 4, 'dinner', '豆腐汤', 103, NULL, NULL, NULL, 355.00, 'ml', '2026-03-17 18:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (441, 4, 'snack', '无糖酸奶', 100, NULL, NULL, NULL, 150.00, 'g', '2026-03-17 20:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (442, 4, 'breakfast', '燕麦粥', 202, NULL, NULL, NULL, 205.00, 'g', '2026-03-18 07:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (443, 4, 'breakfast', '鸡蛋', 163, NULL, NULL, NULL, 113.00, 'g', '2026-03-18 07:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (444, 4, 'breakfast', '牛奶', 92, NULL, NULL, NULL, 230.00, 'ml', '2026-03-18 07:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (445, 4, 'lunch', '米饭', 278, NULL, NULL, NULL, 181.00, 'g', '2026-03-18 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (446, 4, 'lunch', '清蒸鲈鱼', 159, NULL, NULL, NULL, 200.00, 'g', '2026-03-18 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (447, 4, 'lunch', '青菜', 32, NULL, NULL, NULL, 116.00, 'g', '2026-03-18 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (448, 4, 'lunch', '紫菜蛋汤', 68, NULL, NULL, NULL, 251.00, 'ml', '2026-03-18 12:03:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (449, 4, 'dinner', '杂粮粥', 151, NULL, NULL, NULL, 247.00, 'g', '2026-03-18 18:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (450, 4, 'dinner', '鸡胸肉沙拉', 179, NULL, NULL, NULL, 134.00, 'g', '2026-03-18 18:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (451, 4, 'dinner', '豆腐汤', 109, NULL, NULL, NULL, 376.00, 'ml', '2026-03-18 18:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (452, 4, 'snack', '香蕉', 76, NULL, NULL, NULL, 100.00, 'g', '2026-03-18 15:53:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (453, 4, 'breakfast', '燕麦粥', 166, NULL, NULL, NULL, 182.00, 'g', '2026-03-19 07:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (454, 4, 'breakfast', '鸡蛋', 168, NULL, NULL, NULL, 109.00, 'g', '2026-03-19 07:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (455, 4, 'breakfast', '牛奶', 110, NULL, NULL, NULL, 182.00, 'ml', '2026-03-19 07:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (456, 4, 'lunch', '米饭', 262, NULL, NULL, NULL, 174.00, 'g', '2026-03-19 12:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (457, 4, 'lunch', '麻婆豆腐', 193, NULL, NULL, NULL, 200.00, 'g', '2026-03-19 12:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (458, 4, 'lunch', '青菜', 54, NULL, NULL, NULL, 139.00, 'g', '2026-03-19 12:04:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (459, 4, 'dinner', '杂粮粥', 169, NULL, NULL, NULL, 231.00, 'g', '2026-03-19 18:24:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (460, 4, 'dinner', '鸡胸肉沙拉', 217, NULL, NULL, NULL, 159.00, 'g', '2026-03-19 18:24:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (461, 4, 'dinner', '豆腐汤', 117, NULL, NULL, NULL, 303.00, 'ml', '2026-03-19 18:24:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (462, 4, 'snack', '酸奶', 133, NULL, NULL, NULL, 100.00, 'g', '2026-03-19 10:46:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (463, 4, 'snack', '无糖酸奶', 76, NULL, NULL, NULL, 150.00, 'g', '2026-03-19 20:24:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (464, 4, 'breakfast', '燕麦粥', 197, NULL, NULL, NULL, 257.00, 'g', '2026-03-20 07:33:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (465, 4, 'breakfast', '鸡蛋', 143, NULL, NULL, NULL, 116.00, 'g', '2026-03-20 07:33:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (466, 4, 'breakfast', '牛奶', 127, NULL, NULL, NULL, 202.00, 'ml', '2026-03-20 07:33:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (467, 4, 'lunch', '米饭', 283, NULL, NULL, NULL, 168.00, 'g', '2026-03-20 12:00:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (468, 4, 'lunch', '宫保鸡丁', 263, NULL, NULL, NULL, 160.00, 'g', '2026-03-20 12:00:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (469, 4, 'lunch', '青菜', 37, NULL, NULL, NULL, 120.00, 'g', '2026-03-20 12:00:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (470, 4, 'lunch', '紫菜蛋汤', 97, NULL, NULL, NULL, 337.00, 'ml', '2026-03-20 12:00:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (471, 4, 'dinner', '荞麦面', 218, NULL, NULL, NULL, 214.00, 'g', '2026-03-20 18:07:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (472, 4, 'dinner', '鸡胸肉沙拉', 186, NULL, NULL, NULL, 135.00, 'g', '2026-03-20 18:07:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (473, 4, 'dinner', '豆腐汤', 114, NULL, NULL, NULL, 346.00, 'ml', '2026-03-20 18:07:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (474, 4, 'snack', '牛奶', 93, NULL, NULL, NULL, 200.00, 'ml', '2026-03-20 21:55:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (475, 4, 'breakfast', '燕麦粥', 197, NULL, NULL, NULL, 220.00, 'g', '2026-03-21 07:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (476, 4, 'breakfast', '鸡蛋', 142, NULL, NULL, NULL, 110.00, 'g', '2026-03-21 07:38:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (477, 4, 'lunch', '米饭', 302, NULL, NULL, NULL, 196.00, 'g', '2026-03-21 12:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (478, 4, 'lunch', '番茄炒蛋', 141, NULL, NULL, NULL, 180.00, 'g', '2026-03-21 12:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (479, 4, 'lunch', '青菜', 55, NULL, NULL, NULL, 102.00, 'g', '2026-03-21 12:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (480, 4, 'lunch', '紫菜蛋汤', 84, NULL, NULL, NULL, 299.00, 'ml', '2026-03-21 12:26:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (481, 4, 'dinner', '荞麦面', 239, NULL, NULL, NULL, 214.00, 'g', '2026-03-21 18:46:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (482, 4, 'dinner', '鸡胸肉沙拉', 152, NULL, NULL, NULL, 166.00, 'g', '2026-03-21 18:46:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (483, 4, 'dinner', '豆腐汤', 80, NULL, NULL, NULL, 292.00, 'ml', '2026-03-21 18:46:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (484, 4, 'breakfast', '燕麦粥', 156, NULL, NULL, NULL, 235.00, 'g', '2026-03-22 07:16:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (485, 4, 'breakfast', '鸡蛋', 145, NULL, NULL, NULL, 101.00, 'g', '2026-03-22 07:16:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (486, 4, 'breakfast', '牛奶', 129, NULL, NULL, NULL, 199.00, 'ml', '2026-03-22 07:16:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (487, 4, 'lunch', '米饭', 290, NULL, NULL, NULL, 168.00, 'g', '2026-03-22 12:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (488, 4, 'lunch', '青椒肉丝', 217, NULL, NULL, NULL, 150.00, 'g', '2026-03-22 12:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (489, 4, 'lunch', '青菜', 44, NULL, NULL, NULL, 107.00, 'g', '2026-03-22 12:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (490, 4, 'lunch', '紫菜蛋汤', 99, NULL, NULL, NULL, 312.00, 'ml', '2026-03-22 12:39:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (491, 4, 'dinner', '杂粮粥', 165, NULL, NULL, NULL, 300.00, 'g', '2026-03-22 18:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (492, 4, 'dinner', '鸡胸肉沙拉', 151, NULL, NULL, NULL, 174.00, 'g', '2026-03-22 18:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (493, 4, 'dinner', '豆腐汤', 115, NULL, NULL, NULL, 286.00, 'ml', '2026-03-22 18:12:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (494, 4, 'snack', '酸奶', 140, NULL, NULL, NULL, 100.00, 'g', '2026-03-22 21:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (495, 4, 'breakfast', '燕麦粥', 172, NULL, NULL, NULL, 209.00, 'g', '2026-03-23 07:35:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (496, 4, 'breakfast', '鸡蛋', 153, NULL, NULL, NULL, 114.00, 'g', '2026-03-23 07:35:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (497, 4, 'breakfast', '牛奶', 92, NULL, NULL, NULL, 224.00, 'ml', '2026-03-23 07:35:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (498, 4, 'lunch', '米饭', 317, NULL, NULL, NULL, 177.00, 'g', '2026-03-23 12:29:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (499, 4, 'lunch', '番茄炒蛋', 182, NULL, NULL, NULL, 180.00, 'g', '2026-03-23 12:29:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (500, 4, 'lunch', '青菜', 46, NULL, NULL, NULL, 104.00, 'g', '2026-03-23 12:29:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (501, 4, 'dinner', '荞麦面', 231, NULL, NULL, NULL, 204.00, 'g', '2026-03-23 18:35:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (502, 4, 'dinner', '鸡胸肉沙拉', 176, NULL, NULL, NULL, 142.00, 'g', '2026-03-23 18:35:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (503, 4, 'snack', '牛奶', 92, NULL, NULL, NULL, 200.00, 'ml', '2026-03-23 15:54:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (504, 4, 'breakfast', '燕麦粥', 212, NULL, NULL, NULL, 219.00, 'g', '2026-03-24 07:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (505, 4, 'breakfast', '鸡蛋', 174, NULL, NULL, NULL, 81.00, 'g', '2026-03-24 07:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (506, 4, 'breakfast', '牛奶', 91, NULL, NULL, NULL, 233.00, 'ml', '2026-03-24 07:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (507, 4, 'lunch', '米饭', 276, NULL, NULL, NULL, 230.00, 'g', '2026-03-24 12:31:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (508, 4, 'lunch', '番茄炒蛋', 154, NULL, NULL, NULL, 180.00, 'g', '2026-03-24 12:31:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (509, 4, 'lunch', '青菜', 26, NULL, NULL, NULL, 105.00, 'g', '2026-03-24 12:31:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (510, 4, 'lunch', '紫菜蛋汤', 83, NULL, NULL, NULL, 327.00, 'ml', '2026-03-24 12:31:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (511, 4, 'dinner', '荞麦面', 222, NULL, NULL, NULL, 249.00, 'g', '2026-03-24 18:27:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (512, 4, 'dinner', '鸡胸肉沙拉', 157, NULL, NULL, NULL, 128.00, 'g', '2026-03-24 18:27:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (513, 4, 'dinner', '豆腐汤', 93, NULL, NULL, NULL, 357.00, 'ml', '2026-03-24 18:27:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (514, 4, 'snack', '酸奶', 140, NULL, NULL, NULL, 100.00, 'g', '2026-03-24 16:18:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (515, 4, 'breakfast', '燕麦粥', 162, NULL, NULL, NULL, 210.00, 'g', '2026-03-25 07:33:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (516, 4, 'breakfast', '鸡蛋', 145, NULL, NULL, NULL, 86.00, 'g', '2026-03-25 07:33:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (517, 4, 'lunch', '米饭', 283, NULL, NULL, NULL, 189.00, 'g', '2026-03-25 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (518, 4, 'lunch', '番茄炒蛋', 138, NULL, NULL, NULL, 180.00, 'g', '2026-03-25 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (519, 4, 'lunch', '青菜', 47, NULL, NULL, NULL, 93.00, 'g', '2026-03-25 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (520, 4, 'lunch', '紫菜蛋汤', 60, NULL, NULL, NULL, 320.00, 'ml', '2026-03-25 12:01:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (521, 4, 'dinner', '杂粮粥', 134, NULL, NULL, NULL, 240.00, 'g', '2026-03-25 18:09:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (522, 4, 'dinner', '鸡胸肉沙拉', 156, NULL, NULL, NULL, 175.00, 'g', '2026-03-25 18:09:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (523, 4, 'dinner', '豆腐汤', 110, NULL, NULL, NULL, 358.00, 'ml', '2026-03-25 18:09:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (524, 4, 'snack', '无糖酸奶', 84, NULL, NULL, NULL, 150.00, 'g', '2026-03-25 20:11:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (525, 4, 'breakfast', '燕麦粥', 158, NULL, NULL, NULL, 229.00, 'g', '2026-03-26 07:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (526, 4, 'breakfast', '鸡蛋', 179, NULL, NULL, NULL, 88.00, 'g', '2026-03-26 07:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (527, 4, 'breakfast', '牛奶', 101, NULL, NULL, NULL, 249.00, 'ml', '2026-03-26 07:14:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (528, 4, 'lunch', '米饭', 319, NULL, NULL, NULL, 175.00, 'g', '2026-03-26 12:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (529, 4, 'lunch', '蒜蓉西兰花', 104, NULL, NULL, NULL, 200.00, 'g', '2026-03-26 12:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (530, 4, 'lunch', '青菜', 42, NULL, NULL, NULL, 134.00, 'g', '2026-03-26 12:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (531, 4, 'lunch', '紫菜蛋汤', 68, NULL, NULL, NULL, 291.00, 'ml', '2026-03-26 12:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (532, 4, 'dinner', '杂粮粥', 187, NULL, NULL, NULL, 268.00, 'g', '2026-03-26 18:44:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (533, 4, 'dinner', '鸡胸肉沙拉', 158, NULL, NULL, NULL, 180.00, 'g', '2026-03-26 18:44:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (534, 4, 'snack', '坚果', 155, NULL, NULL, NULL, 30.00, 'g', '2026-03-26 10:44:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (535, 4, 'snack', '无糖酸奶', 99, NULL, NULL, NULL, 150.00, 'g', '2026-03-26 20:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (536, 4, 'breakfast', '燕麦粥', 199, NULL, NULL, NULL, 236.00, 'g', '2026-03-27 07:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (537, 4, 'breakfast', '鸡蛋', 172, NULL, NULL, NULL, 103.00, 'g', '2026-03-27 07:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (538, 4, 'breakfast', '牛奶', 124, NULL, NULL, NULL, 184.00, 'ml', '2026-03-27 07:34:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (539, 4, 'lunch', '米饭', 287, NULL, NULL, NULL, 183.00, 'g', '2026-03-27 12:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (540, 4, 'lunch', '番茄炒蛋', 174, NULL, NULL, NULL, 180.00, 'g', '2026-03-27 12:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (541, 4, 'lunch', '青菜', 51, NULL, NULL, NULL, 90.00, 'g', '2026-03-27 12:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (542, 4, 'lunch', '紫菜蛋汤', 82, NULL, NULL, NULL, 287.00, 'ml', '2026-03-27 12:22:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (543, 4, 'dinner', '荞麦面', 195, NULL, NULL, NULL, 202.00, 'g', '2026-03-27 18:06:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (544, 4, 'dinner', '鸡胸肉沙拉', 178, NULL, NULL, NULL, 161.00, 'g', '2026-03-27 18:06:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (545, 4, 'dinner', '豆腐汤', 96, NULL, NULL, NULL, 378.00, 'ml', '2026-03-27 18:06:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (546, 4, 'breakfast', '燕麦粥', 217, NULL, NULL, NULL, 242.00, 'g', '2026-03-28 07:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (547, 4, 'breakfast', '鸡蛋', 165, NULL, NULL, NULL, 114.00, 'g', '2026-03-28 07:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (548, 4, 'breakfast', '牛奶', 128, NULL, NULL, NULL, 240.00, 'ml', '2026-03-28 07:21:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (549, 4, 'lunch', '米饭', 307, NULL, NULL, NULL, 162.00, 'g', '2026-03-28 12:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (550, 4, 'lunch', '宫保鸡丁', 242, NULL, NULL, NULL, 160.00, 'g', '2026-03-28 12:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (551, 4, 'lunch', '青菜', 30, NULL, NULL, NULL, 100.00, 'g', '2026-03-28 12:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (552, 4, 'lunch', '紫菜蛋汤', 60, NULL, NULL, NULL, 251.00, 'ml', '2026-03-28 12:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (553, 4, 'dinner', '杂粮粥', 151, NULL, NULL, NULL, 251.00, 'g', '2026-03-28 18:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (554, 4, 'dinner', '鸡胸肉沙拉', 201, NULL, NULL, NULL, 193.00, 'g', '2026-03-28 18:08:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (555, 4, 'breakfast', '燕麦粥', 167, NULL, NULL, NULL, 223.00, 'g', '2026-03-29 07:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (556, 4, 'breakfast', '鸡蛋', 168, NULL, NULL, NULL, 105.00, 'g', '2026-03-29 07:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (557, 4, 'breakfast', '牛奶', 104, NULL, NULL, NULL, 211.00, 'ml', '2026-03-29 07:17:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (558, 4, 'lunch', '米饭', 262, NULL, NULL, NULL, 204.00, 'g', '2026-03-29 12:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (559, 4, 'lunch', '番茄炒蛋', 163, NULL, NULL, NULL, 180.00, 'g', '2026-03-29 12:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (560, 4, 'lunch', '青菜', 48, NULL, NULL, NULL, 117.00, 'g', '2026-03-29 12:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (561, 4, 'dinner', '杂粮粥', 190, NULL, NULL, NULL, 216.00, 'g', '2026-03-29 18:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (562, 4, 'dinner', '鸡胸肉沙拉', 198, NULL, NULL, NULL, 188.00, 'g', '2026-03-29 18:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (563, 4, 'snack', '苹果', 78, NULL, NULL, NULL, 120.00, 'g', '2026-03-29 10:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (564, 4, 'breakfast', '燕麦粥', 194, NULL, NULL, NULL, 244.00, 'g', '2026-03-30 07:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (565, 4, 'breakfast', '鸡蛋', 174, NULL, NULL, NULL, 119.00, 'g', '2026-03-30 07:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (566, 4, 'breakfast', '牛奶', 95, NULL, NULL, NULL, 234.00, 'ml', '2026-03-30 07:15:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (567, 4, 'lunch', '米饭', 253, NULL, NULL, NULL, 235.00, 'g', '2026-03-30 12:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (568, 4, 'lunch', '清蒸鲈鱼', 199, NULL, NULL, NULL, 200.00, 'g', '2026-03-30 12:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (569, 4, 'lunch', '青菜', 51, NULL, NULL, NULL, 129.00, 'g', '2026-03-30 12:02:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (570, 4, 'dinner', '杂粮粥', 179, NULL, NULL, NULL, 207.00, 'g', '2026-03-30 18:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (571, 4, 'dinner', '鸡胸肉沙拉', 211, NULL, NULL, NULL, 186.00, 'g', '2026-03-30 18:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (572, 4, 'dinner', '豆腐汤', 79, NULL, NULL, NULL, 354.00, 'ml', '2026-03-30 18:10:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (573, 4, 'snack', '香蕉', 80, NULL, NULL, NULL, 100.00, 'g', '2026-03-30 10:37:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (574, 4, 'breakfast', '燕麦粥', 143, NULL, NULL, NULL, 243.00, 'g', '2026-03-31 07:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (575, 4, 'breakfast', '鸡蛋', 159, NULL, NULL, NULL, 111.00, 'g', '2026-03-31 07:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (576, 4, 'breakfast', '牛奶', 126, NULL, NULL, NULL, 193.00, 'ml', '2026-03-31 07:36:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (577, 4, 'lunch', '米饭', 279, NULL, NULL, NULL, 214.00, 'g', '2026-03-31 12:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (578, 4, 'lunch', '宫保鸡丁', 253, NULL, NULL, NULL, 160.00, 'g', '2026-03-31 12:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (579, 4, 'lunch', '青菜', 37, NULL, NULL, NULL, 87.00, 'g', '2026-03-31 12:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (580, 4, 'lunch', '紫菜蛋汤', 75, NULL, NULL, NULL, 270.00, 'ml', '2026-03-31 12:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (581, 4, 'dinner', '杂粮粥', 195, NULL, NULL, NULL, 252.00, 'g', '2026-03-31 18:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (582, 4, 'dinner', '鸡胸肉沙拉', 183, NULL, NULL, NULL, 134.00, 'g', '2026-03-31 18:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (583, 4, 'dinner', '豆腐汤', 80, NULL, NULL, NULL, 374.00, 'ml', '2026-03-31 18:19:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (584, 4, 'snack', '酸奶', 124, NULL, NULL, NULL, 100.00, 'g', '2026-03-31 21:33:00', NULL, '2026-04-02 04:33:38');
INSERT INTO `meal_record_legacy` VALUES (585, 4, 'snack', '无糖酸奶', 80, NULL, NULL, NULL, 150.00, 'g', '2026-03-31 20:17:00', NULL, '2026-04-02 04:33:38');

-- ----------------------------
-- Table structure for sport_item
-- ----------------------------
DROP TABLE IF EXISTS `sport_item`;
CREATE TABLE `sport_item`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `creator_user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `calories_per_60min` decimal(10, 2) NULL DEFAULT NULL,
  `category` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_custom` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1,
  `sort_no` int NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sport_item_creator`(`creator_user_id` ASC) USING BTREE,
  INDEX `idx_sport_item_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sport_item
-- ----------------------------
INSERT INTO `sport_item` VALUES (1, NULL, '跑步', '🏃', 390.00, '有氧', 0, 1, 0, '2026-04-02 04:33:38', '2026-04-04 15:08:34');
INSERT INTO `sport_item` VALUES (2, NULL, '跳绳', '🤸', 480.00, '有氧', 0, 1, 0, '2026-04-02 04:33:38', '2026-04-04 15:08:34');
INSERT INTO `sport_item` VALUES (3, NULL, '游泳', '🏊', 420.00, '有氧', 0, 1, 0, '2026-04-02 04:33:38', '2026-04-04 15:08:34');
INSERT INTO `sport_item` VALUES (4, NULL, '骑行', '🚴', 330.00, '有氧', 0, 1, 0, '2026-04-02 04:33:38', '2026-04-04 15:08:34');
INSERT INTO `sport_item` VALUES (5, NULL, '健步走', '🚶', 240.00, '有氧', 0, 1, 0, '2026-04-02 04:33:38', '2026-04-04 15:08:34');
INSERT INTO `sport_item` VALUES (6, NULL, '瑜伽', '🧘', 180.00, '柔韧', 0, 1, 0, '2026-04-02 04:33:38', '2026-04-04 15:08:34');
INSERT INTO `sport_item` VALUES (7, NULL, '俯卧撑', '💪', 300.00, '力量', 0, 1, 0, '2026-04-02 04:33:38', '2026-04-04 15:08:34');
INSERT INTO `sport_item` VALUES (8, NULL, '深蹲', '🏋️', 330.00, '力量', 0, 1, 0, '2026-04-02 04:33:38', '2026-04-04 15:08:34');
INSERT INTO `sport_item` VALUES (9, NULL, '椭圆机', '🏃', 360.00, '有氧', 0, 1, 0, '2026-04-02 04:33:38', '2026-04-04 15:08:34');
INSERT INTO `sport_item` VALUES (10, NULL, '爬楼梯', '🪜', 450.00, '有氧', 0, 1, 0, '2026-04-02 04:33:38', '2026-04-04 15:08:34');

-- ----------------------------
-- Table structure for sport_library_legacy
-- ----------------------------
DROP TABLE IF EXISTS `sport_library_legacy`;
CREATE TABLE `sport_library_legacy`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `calories_per_min` decimal(8, 2) NULL DEFAULT NULL,
  `icon` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `category` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sport_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sport_library_legacy
-- ----------------------------
INSERT INTO `sport_library_legacy` VALUES (1, '跑步', 6.50, '🏃', '有氧', '2026-04-02 04:33:38');
INSERT INTO `sport_library_legacy` VALUES (2, '跳绳', 8.00, '🤸', '有氧', '2026-04-02 04:33:38');
INSERT INTO `sport_library_legacy` VALUES (3, '游泳', 7.00, '🏊', '有氧', '2026-04-02 04:33:38');
INSERT INTO `sport_library_legacy` VALUES (4, '骑行', 5.50, '🚴', '有氧', '2026-04-02 04:33:38');
INSERT INTO `sport_library_legacy` VALUES (5, '健步走', 4.00, '🚶', '有氧', '2026-04-02 04:33:38');
INSERT INTO `sport_library_legacy` VALUES (6, '瑜伽', 3.00, '🧘', '柔韧', '2026-04-02 04:33:38');
INSERT INTO `sport_library_legacy` VALUES (7, '俯卧撑', 5.00, '💪', '力量', '2026-04-02 04:33:38');
INSERT INTO `sport_library_legacy` VALUES (8, '深蹲', 5.50, '🏋️', '力量', '2026-04-02 04:33:38');
INSERT INTO `sport_library_legacy` VALUES (9, '椭圆机', 6.00, '🏃', '有氧', '2026-04-02 04:33:38');
INSERT INTO `sport_library_legacy` VALUES (10, '爬楼梯', 7.50, '🪜', '有氧', '2026-04-02 04:33:38');

-- ----------------------------
-- Table structure for sport_record
-- ----------------------------
DROP TABLE IF EXISTS `sport_record`;
CREATE TABLE `sport_record`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `record_date` date NULL DEFAULT NULL,
  `sport_item_id` bigint UNSIGNED NULL DEFAULT NULL,
  `sport_name_snapshot` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `icon_snapshot` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sport_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration_min` int UNSIGNED NULL DEFAULT NULL,
  `calories_burned` decimal(12, 2) NULL DEFAULT NULL,
  `source` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual',
  `record_time` datetime NULL DEFAULT NULL,
  `calories` int UNSIGNED NOT NULL,
  `icon` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `recorded_at` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sport_user_time`(`user_id` ASC, `recorded_at` ASC) USING BTREE,
  CONSTRAINT `fk_sport_record_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sport_record
-- ----------------------------
INSERT INTO `sport_record` VALUES (1, 4, '2026-02-01', 4, '骑行', '🚴', '骑行', 41, 230.00, 'manual', '2026-02-01 12:33:00', 230, '🚴', '2026-02-01 12:33:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (2, 4, '2026-02-01', 9, '椭圆机', '🏃', '椭圆机', 21, 126.00, 'manual', '2026-02-01 17:19:00', 126, '🏃', '2026-02-01 17:19:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (3, 4, '2026-02-02', 1, '跑步', '🏃', '跑步', 22, 150.00, 'manual', '2026-02-02 17:38:00', 150, '🏃', '2026-02-02 17:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (4, 4, '2026-02-03', 9, '椭圆机', '🏃', '椭圆机', 45, 270.00, 'manual', '2026-02-03 07:26:00', 270, '🏃', '2026-02-03 07:26:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (5, 4, '2026-02-04', 4, '骑行', '🚴', '骑行', 31, 174.00, 'manual', '2026-02-04 07:16:00', 174, '🚴', '2026-02-04 07:16:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (6, 4, '2026-02-05', 5, '健步走', '🚶', '健步走', 43, 181.00, 'manual', '2026-02-05 12:41:00', 181, '🚶', '2026-02-05 12:41:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (7, 4, '2026-02-06', 5, '健步走', '🚶', '健步走', 30, 126.00, 'manual', '2026-02-06 19:14:00', 126, '🚶', '2026-02-06 19:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (8, 4, '2026-02-07', 3, '游泳', '🏊', '游泳', 37, 263.00, 'manual', '2026-02-07 17:12:00', 263, '🏊', '2026-02-07 17:12:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (9, 4, '2026-02-08', 10, '爬楼梯', '🪜', '爬楼梯', 31, 232.00, 'manual', '2026-02-08 07:28:00', 232, '🪜', '2026-02-08 07:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (10, 4, '2026-02-09', 1, '跑步', '🏃', '跑步', 19, 129.00, 'manual', '2026-02-09 19:46:00', 129, '🏃', '2026-02-09 19:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (11, 4, '2026-02-10', 10, '爬楼梯', '🪜', '爬楼梯', 18, 135.00, 'manual', '2026-02-10 06:47:00', 135, '🪜', '2026-02-10 06:47:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (12, 4, '2026-02-11', 5, '健步走', '🚶', '健步走', 42, 176.00, 'manual', '2026-02-11 06:33:00', 176, '🚶', '2026-02-11 06:33:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (13, 4, '2026-02-12', 6, '瑜伽', '🧘', '瑜伽', 25, 80.00, 'manual', '2026-02-12 07:29:00', 80, '🧘', '2026-02-12 07:29:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (14, 4, '2026-02-13', 5, '健步走', '🚶', '健步走', 30, 126.00, 'manual', '2026-02-13 12:36:00', 126, '🚶', '2026-02-13 12:36:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (15, 4, '2026-02-13', 2, '跳绳', '🤸', '跳绳', 41, 336.00, 'manual', '2026-02-13 17:46:00', 336, '🤸', '2026-02-13 17:46:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (16, 4, '2026-02-14', 1, '跑步', '🏃', '跑步', 49, 333.00, 'manual', '2026-02-14 07:16:00', 333, '🏃', '2026-02-14 07:16:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (17, 4, '2026-02-14', 5, '健步走', '🚶', '健步走', 41, 172.00, 'manual', '2026-02-14 07:43:00', 172, '🚶', '2026-02-14 07:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (18, 4, '2026-02-15', 10, '爬楼梯', '🪜', '爬楼梯', 25, 188.00, 'manual', '2026-02-15 17:35:00', 188, '🪜', '2026-02-15 17:35:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (19, 4, '2026-02-16', 4, '骑行', '🚴', '骑行', 32, 179.00, 'manual', '2026-02-16 12:17:00', 179, '🚴', '2026-02-16 12:17:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (20, 4, '2026-02-16', 5, '健步走', '🚶', '健步走', 23, 97.00, 'manual', '2026-02-16 19:37:00', 97, '🚶', '2026-02-16 19:37:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (21, 4, '2026-02-17', 2, '跳绳', '🤸', '跳绳', 38, 312.00, 'manual', '2026-02-17 12:21:00', 312, '🤸', '2026-02-17 12:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (22, 4, '2026-02-18', 3, '游泳', '🏊', '游泳', 26, 185.00, 'manual', '2026-02-18 06:05:00', 185, '🏊', '2026-02-18 06:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (23, 4, '2026-02-19', 5, '健步走', '🚶', '健步走', 42, 176.00, 'manual', '2026-02-19 06:23:00', 176, '🚶', '2026-02-19 06:23:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (24, 4, '2026-02-20', 4, '骑行', '🚴', '骑行', 48, 269.00, 'manual', '2026-02-20 06:53:00', 269, '🚴', '2026-02-20 06:53:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (25, 4, '2026-02-20', 2, '跳绳', '🤸', '跳绳', 29, 238.00, 'manual', '2026-02-20 19:03:00', 238, '🤸', '2026-02-20 19:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (26, 4, '2026-02-21', 4, '骑行', '🚴', '骑行', 21, 118.00, 'manual', '2026-02-21 17:00:00', 118, '🚴', '2026-02-21 17:00:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (27, 4, '2026-02-22', 3, '游泳', '🏊', '游泳', 35, 248.00, 'manual', '2026-02-22 17:16:00', 248, '🏊', '2026-02-22 17:16:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (28, 4, '2026-02-23', 9, '椭圆机', '🏃', '椭圆机', 43, 258.00, 'manual', '2026-02-23 06:10:00', 258, '🏃', '2026-02-23 06:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (29, 4, '2026-02-23', 10, '爬楼梯', '🪜', '爬楼梯', 46, 345.00, 'manual', '2026-02-23 19:10:00', 345, '🪜', '2026-02-23 19:10:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (30, 4, '2026-02-24', 1, '跑步', '🏃', '跑步', 39, 265.00, 'manual', '2026-02-24 17:03:00', 265, '🏃', '2026-02-24 17:03:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (31, 4, '2026-02-26', 1, '跑步', '🏃', '跑步', 20, 136.00, 'manual', '2026-02-26 12:04:00', 136, '🏃', '2026-02-26 12:04:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (32, 4, '2026-02-27', 3, '游泳', '🏊', '游泳', 30, 213.00, 'manual', '2026-02-27 12:14:00', 213, '🏊', '2026-02-27 12:14:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (33, 4, '2026-02-27', 3, '游泳', '🏊', '游泳', 23, 163.00, 'manual', '2026-02-27 12:42:00', 163, '🏊', '2026-02-27 12:42:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (34, 4, '2026-02-28', 5, '健步走', '🚶', '健步走', 45, 189.00, 'manual', '2026-02-28 12:07:00', 189, '🚶', '2026-02-28 12:07:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (35, 4, '2026-03-01', 4, '骑行', '🚴', '骑行', 35, 196.00, 'manual', '2026-03-01 07:50:00', 196, '🚴', '2026-03-01 07:50:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (36, 4, '2026-03-02', 1, '跑步', '🏃', '跑步', 20, 136.00, 'manual', '2026-03-02 07:29:00', 136, '🏃', '2026-03-02 07:29:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (37, 4, '2026-03-03', 1, '跑步', '🏃', '跑步', 41, 279.00, 'manual', '2026-03-03 07:39:00', 279, '🏃', '2026-03-03 07:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (38, 4, '2026-03-04', 1, '跑步', '🏃', '跑步', 46, 313.00, 'manual', '2026-03-04 19:43:00', 313, '🏃', '2026-03-04 19:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (39, 4, '2026-03-05', 10, '爬楼梯', '🪜', '爬楼梯', 21, 158.00, 'manual', '2026-03-05 06:51:00', 158, '🪜', '2026-03-05 06:51:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (40, 4, '2026-03-06', 6, '瑜伽', '🧘', '瑜伽', 21, 67.00, 'manual', '2026-03-06 12:55:00', 67, '🧘', '2026-03-06 12:55:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (41, 4, '2026-03-07', 1, '跑步', '🏃', '跑步', 20, 136.00, 'manual', '2026-03-07 19:28:00', 136, '🏃', '2026-03-07 19:28:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (42, 4, '2026-03-08', 10, '爬楼梯', '🪜', '爬楼梯', 38, 285.00, 'manual', '2026-03-08 06:06:00', 285, '🪜', '2026-03-08 06:06:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (43, 4, '2026-03-09', 5, '健步走', '🚶', '健步走', 44, 185.00, 'manual', '2026-03-09 07:21:00', 185, '🚶', '2026-03-09 07:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (44, 4, '2026-03-09', 10, '爬楼梯', '🪜', '爬楼梯', 32, 240.00, 'manual', '2026-03-09 07:51:00', 240, '🪜', '2026-03-09 07:51:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (45, 4, '2026-03-10', 4, '骑行', '🚴', '骑行', 18, 101.00, 'manual', '2026-03-10 19:20:00', 101, '🚴', '2026-03-10 19:20:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (46, 4, '2026-03-11', 9, '椭圆机', '🏃', '椭圆机', 26, 156.00, 'manual', '2026-03-11 07:20:00', 156, '🏃', '2026-03-11 07:20:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (47, 4, '2026-03-13', 3, '游泳', '🏊', '游泳', 33, 234.00, 'manual', '2026-03-13 12:18:00', 234, '🏊', '2026-03-13 12:18:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (48, 4, '2026-03-14', 10, '爬楼梯', '🪜', '爬楼梯', 19, 142.00, 'manual', '2026-03-14 07:44:00', 142, '🪜', '2026-03-14 07:44:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (49, 4, '2026-03-14', 9, '椭圆机', '🏃', '椭圆机', 25, 150.00, 'manual', '2026-03-14 19:34:00', 150, '🏃', '2026-03-14 19:34:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (50, 4, '2026-03-15', 4, '骑行', '🚴', '骑行', 48, 269.00, 'manual', '2026-03-15 19:32:00', 269, '🚴', '2026-03-15 19:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (51, 4, '2026-03-16', 1, '跑步', '🏃', '跑步', 30, 204.00, 'manual', '2026-03-16 07:38:00', 204, '🏃', '2026-03-16 07:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (52, 4, '2026-03-17', 6, '瑜伽', '🧘', '瑜伽', 27, 86.00, 'manual', '2026-03-17 17:29:00', 86, '🧘', '2026-03-17 17:29:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (53, 4, '2026-03-18', 9, '椭圆机', '🏃', '椭圆机', 50, 300.00, 'manual', '2026-03-18 12:38:00', 300, '🏃', '2026-03-18 12:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (54, 4, '2026-03-20', 5, '健步走', '🚶', '健步走', 22, 92.00, 'manual', '2026-03-20 17:11:00', 92, '🚶', '2026-03-20 17:11:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (55, 4, '2026-03-21', 4, '骑行', '🚴', '骑行', 38, 213.00, 'manual', '2026-03-21 19:40:00', 213, '🚴', '2026-03-21 19:40:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (56, 4, '2026-03-22', 2, '跳绳', '🤸', '跳绳', 43, 353.00, 'manual', '2026-03-22 06:21:00', 353, '🤸', '2026-03-22 06:21:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (57, 4, '2026-03-23', 1, '跑步', '🏃', '跑步', 43, 292.00, 'manual', '2026-03-23 17:43:00', 292, '🏃', '2026-03-23 17:43:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (58, 4, '2026-03-24', 3, '游泳', '🏊', '游泳', 48, 341.00, 'manual', '2026-03-24 19:27:00', 341, '🏊', '2026-03-24 19:27:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (59, 4, '2026-03-25', 10, '爬楼梯', '🪜', '爬楼梯', 26, 195.00, 'manual', '2026-03-25 12:27:00', 195, '🪜', '2026-03-25 12:27:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (60, 4, '2026-03-26', 10, '爬楼梯', '🪜', '爬楼梯', 20, 150.00, 'manual', '2026-03-26 17:32:00', 150, '🪜', '2026-03-26 17:32:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (61, 4, '2026-03-27', 9, '椭圆机', '🏃', '椭圆机', 29, 174.00, 'manual', '2026-03-27 12:27:00', 174, '🏃', '2026-03-27 12:27:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (62, 4, '2026-03-28', 6, '瑜伽', '🧘', '瑜伽', 44, 141.00, 'manual', '2026-03-28 17:38:00', 141, '🧘', '2026-03-28 17:38:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (63, 4, '2026-03-29', 9, '椭圆机', '🏃', '椭圆机', 40, 240.00, 'manual', '2026-03-29 19:05:00', 240, '🏃', '2026-03-29 19:05:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (64, 4, '2026-03-30', 9, '椭圆机', '🏃', '椭圆机', 18, 108.00, 'manual', '2026-03-30 07:20:00', 108, '🏃', '2026-03-30 07:20:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');
INSERT INTO `sport_record` VALUES (65, 4, '2026-03-31', 9, '椭圆机', '🏃', '椭圆机', 27, 162.00, 'manual', '2026-03-31 12:39:00', 162, '🏃', '2026-03-31 12:39:00', '2026-04-02 04:33:38', '2026-04-04 15:08:59');

-- ----------------------------
-- Table structure for user_budget_config
-- ----------------------------
DROP TABLE IF EXISTS `user_budget_config`;
CREATE TABLE `user_budget_config`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `use_custom_bmr` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `custom_bmr` decimal(10, 2) NULL DEFAULT NULL,
  `activity_level` decimal(6, 3) NULL DEFAULT NULL COMMENT '活动系数（PRD decimal）',
  `calculated_bmr` decimal(10, 2) NULL DEFAULT NULL,
  `calculated_tdee` decimal(10, 2) NULL DEFAULT NULL,
  `recommended_deficit` decimal(10, 2) NULL DEFAULT NULL,
  `daily_budget` decimal(10, 2) NULL DEFAULT NULL,
  `carb_target_g` decimal(10, 2) NULL DEFAULT NULL,
  `protein_target_g` decimal(10, 2) NULL DEFAULT NULL,
  `fat_target_g` decimal(10, 2) NULL DEFAULT NULL,
  `effective_date` date NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_budget_user_effective`(`user_id` ASC, `effective_date` ASC) USING BTREE,
  CONSTRAINT `fk_user_budget_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_budget_config
-- ----------------------------
INSERT INTO `user_budget_config` VALUES (1, 1, 0, NULL, 1.375, 1750.00, 2100.00, 500.00, 1600.00, NULL, NULL, NULL, '2026-04-02', '2026-04-02 04:33:38', '2026-04-03 10:32:50');
INSERT INTO `user_budget_config` VALUES (2, 4, 0, NULL, 1.375, 1784.00, 2453.00, 1000.00, 1453.00, NULL, NULL, NULL, '2026-04-03', '2026-04-03 01:14:57', '2026-04-03 01:14:57');

-- ----------------------------
-- Table structure for user_plan
-- ----------------------------
DROP TABLE IF EXISTS `user_plan`;
CREATE TABLE `user_plan`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `total_weeks` int NULL DEFAULT NULL,
  `target_weight_loss_kg` decimal(8, 2) NULL DEFAULT NULL,
  `daily_deficit_target` decimal(10, 2) NULL DEFAULT NULL,
  `exercise_plan_desc` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `diet_plan_desc` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `activated_at` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_plan_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_plan_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_plan
-- ----------------------------

-- ----------------------------
-- Table structure for user_profile
-- ----------------------------
DROP TABLE IF EXISTS `user_profile`;
CREATE TABLE `user_profile`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `gender` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `age` int NULL DEFAULT NULL,
  `height_cm` decimal(5, 2) NULL DEFAULT NULL,
  `initial_weight_kg` decimal(6, 2) NULL DEFAULT NULL,
  `current_weight_kg` decimal(6, 2) NULL DEFAULT NULL,
  `target_weight_kg` decimal(6, 2) NULL DEFAULT NULL,
  `target_date` date NULL DEFAULT NULL,
  `profile_completed` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_profile_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_profile_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_profile
-- ----------------------------
INSERT INTO `user_profile` VALUES (1, 1, 1, 25, 175.00, 80.00, 71.20, 65.00, '2026-12-31', 1, '2026-04-02 04:33:38', '2026-04-03 10:32:50');
INSERT INTO `user_profile` VALUES (2, 4, 1, 41, 175.00, 55.50, 89.00, 50.00, '2026-05-29', 1, '2026-04-03 01:14:57', '2026-04-03 01:14:57');

-- ----------------------------
-- Table structure for user_weight_record
-- ----------------------------
DROP TABLE IF EXISTS `user_weight_record`;
CREATE TABLE `user_weight_record`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `record_date` date NOT NULL,
  `weight_kg` decimal(6, 2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_weight_user_date`(`user_id` ASC, `record_date` ASC) USING BTREE,
  CONSTRAINT `fk_weight_record_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 305 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_weight_record
-- ----------------------------
INSERT INTO `user_weight_record` VALUES (246, 4, '2026-02-01', 72.85, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (247, 4, '2026-02-02', 73.03, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (248, 4, '2026-02-03', 72.49, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (249, 4, '2026-02-04', 72.85, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (250, 4, '2026-02-05', 72.43, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (251, 4, '2026-02-06', 72.89, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (252, 4, '2026-02-07', 72.76, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (253, 4, '2026-02-08', 72.79, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (254, 4, '2026-02-09', 72.41, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (255, 4, '2026-02-10', 72.21, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (256, 4, '2026-02-11', 72.30, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (257, 4, '2026-02-12', 72.52, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (258, 4, '2026-02-13', 72.58, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (259, 4, '2026-02-14', 72.22, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (260, 4, '2026-02-15', 72.37, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (261, 4, '2026-02-16', 72.54, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (262, 4, '2026-02-17', 72.20, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (263, 4, '2026-02-18', 72.11, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (264, 4, '2026-02-19', 72.32, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (265, 4, '2026-02-20', 72.59, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (266, 4, '2026-02-21', 72.34, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (267, 4, '2026-02-22', 72.76, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (268, 4, '2026-02-23', 72.35, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (269, 4, '2026-02-24', 72.10, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (270, 4, '2026-02-25', 72.46, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (271, 4, '2026-02-26', 71.93, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (272, 4, '2026-02-27', 72.38, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (273, 4, '2026-02-28', 72.51, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (274, 4, '2026-03-01', 72.20, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (275, 4, '2026-03-02', 72.01, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (276, 4, '2026-03-03', 72.24, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (277, 4, '2026-03-04', 71.69, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (278, 4, '2026-03-05', 72.01, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (279, 4, '2026-03-06', 71.96, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (280, 4, '2026-03-07', 71.81, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (281, 4, '2026-03-08', 71.72, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (282, 4, '2026-03-09', 72.04, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (283, 4, '2026-03-10', 71.63, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (284, 4, '2026-03-11', 71.59, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (285, 4, '2026-03-12', 71.38, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (286, 4, '2026-03-13', 71.58, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (287, 4, '2026-03-14', 71.87, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (288, 4, '2026-03-15', 71.46, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (289, 4, '2026-03-16', 71.38, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (290, 4, '2026-03-17', 71.65, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (291, 4, '2026-03-18', 71.60, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (292, 4, '2026-03-19', 71.60, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (293, 4, '2026-03-20', 71.30, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (294, 4, '2026-03-21', 71.50, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (295, 4, '2026-03-22', 71.28, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (296, 4, '2026-03-23', 71.53, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (297, 4, '2026-03-24', 71.34, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (298, 4, '2026-03-25', 71.25, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (299, 4, '2026-03-26', 71.39, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (300, 4, '2026-03-27', 71.43, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (301, 4, '2026-03-28', 71.05, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (302, 4, '2026-03-29', 71.78, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (303, 4, '2026-03-30', 71.32, '2026-04-02 04:33:38');
INSERT INTO `user_weight_record` VALUES (304, 4, '2026-03-31', 71.52, '2026-04-02 04:33:38');

-- ----------------------------
-- Table structure for vip_order
-- ----------------------------
DROP TABLE IF EXISTS `vip_order`;
CREATE TABLE `vip_order`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vip_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `pay_status` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `paid_at` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_vip_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_vip_order_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_vip_order_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of vip_order
-- ----------------------------

-- ----------------------------
-- Table structure for vip_user
-- ----------------------------
DROP TABLE IF EXISTS `vip_user`;
CREATE TABLE `vip_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `vip_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'quarter/year/lifetime',
  `start_time` datetime NULL DEFAULT NULL,
  `end_time` datetime NULL DEFAULT NULL,
  `status` tinyint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_vip_user_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_vip_user_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of vip_user
-- ----------------------------

-- ----------------------------
-- Table structure for wechat_login_log
-- ----------------------------
DROP TABLE IF EXISTS `wechat_login_log`;
CREATE TABLE `wechat_login_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '登录成功后关联 app_user.id；失败时可为空',
  `openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '成功换取后写入；code2session 失败时为空',
  `union_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `success` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '1 成功 0 失败',
  `error_message` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '失败原因或微信返回错误摘要',
  `login_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `client_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `client_ua` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_wx_login_user_time`(`user_id` ASC, `login_at` ASC) USING BTREE,
  INDEX `idx_wx_login_openid_time`(`openid` ASC, `login_at` ASC) USING BTREE,
  CONSTRAINT `fk_wx_login_user` FOREIGN KEY (`user_id`) REFERENCES `lw_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wechat_login_log
-- ----------------------------
INSERT INTO `wechat_login_log` VALUES (1, NULL, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-02 23:15:08', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (2, NULL, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 01:13:17', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (3, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 01:14:58', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (4, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 01:25:37', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (5, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 01:27:56', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (6, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 10:06:55', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (7, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 10:07:04', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (8, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 10:21:06', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (9, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 10:42:25', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (10, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 10:44:58', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (11, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 11:04:59', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (12, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 14:25:47', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (13, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 14:27:44', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (14, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 15:34:20', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (15, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 15:40:15', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (16, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 15:59:59', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (17, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 16:00:24', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (18, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 16:08:16', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (19, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 16:09:12', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (20, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 16:12:53', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (21, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 16:17:04', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (22, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 16:17:27', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (23, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 16:18:29', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (24, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-03 17:57:40', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (25, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-05 02:48:50', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (26, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-05 02:52:51', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');
INSERT INTO `wechat_login_log` VALUES (27, 4, 'oFjQq5GC83iMFq_IKOkSpPzi713M', 'oN5Rx5zVWGbKldNqd_Z1Ff5Y9iMY', 1, NULL, '2026-04-05 03:28:15', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1 wechatdevtools/1.06.2412050 MicroMessenger/8.0.5 Language/zh_CN webview/');

SET FOREIGN_KEY_CHECKS = 1;
