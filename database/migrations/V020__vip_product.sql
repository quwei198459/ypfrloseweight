-- =============================================================================
-- V020: 会员档位商品表（名称/价格/原价/时长可运营修改）
-- 幂等：CREATE IF NOT EXISTS + INSERT IGNORE
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS vip_product (
  id BIGINT NOT NULL AUTO_INCREMENT,
  code VARCHAR(32) NOT NULL COMMENT 'lifetime|quarter|year，与前端分栏一致',
  title VARCHAR(64) NOT NULL,
  subtitle VARCHAR(255) NULL COMMENT '卡片副文案',
  price_yuan DECIMAL(10, 2) NOT NULL,
  origin_price_yuan DECIMAL(10, 2) NOT NULL,
  duration_days INT NOT NULL COMMENT '-1 表示永久有效',
  corner_tag VARCHAR(32) NULL COMMENT '大卡片挂角文案，如 92%人选择',
  sort_order INT NOT NULL DEFAULT 0,
  enabled INT NOT NULL DEFAULT 1 COMMENT '1 上架（勿用 TINYINT(1)，部分 JDBC 会当 Boolean 导致映射异常）',
  PRIMARY KEY (id),
  UNIQUE KEY uk_vip_product_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='VIP 档位配置';

INSERT IGNORE INTO vip_product (code, title, subtitle, price_yuan, origin_price_yuan, duration_days, corner_tag, sort_order, enabled) VALUES
('lifetime', '永久会员', '一次买断，终生有效', 168.00, 360.00, -1, '92%人选择', 1, 1),
('quarter', '季度会员', '', 48.00, 75.00, 90, NULL, 2, 1),
('year', '年费会员', '', 148.00, 198.00, 365, NULL, 3, 1);
