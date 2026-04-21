-- =============================================================================
-- V021: 将 vip_product.enabled 改为 INT（修复已按旧 V020 建表为 TINYINT 时的 MyBatis 映射 500）
-- 可重复执行。若表不存在会报错，请先执行 V020。
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

ALTER TABLE vip_product MODIFY COLUMN enabled INT NOT NULL DEFAULT 1 COMMENT '1 上架';
