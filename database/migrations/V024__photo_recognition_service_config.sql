-- =============================================================================
-- V024: 拍照识别客服配置
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS photo_recognition_service_config (
  id BIGINT NOT NULL AUTO_INCREMENT,
  config_key VARCHAR(64) NOT NULL COMMENT '固定值 default',
  service_phone VARCHAR(32) NOT NULL DEFAULT '400-000-0000' COMMENT '客服电话',
  service_wechat VARCHAR(64) NOT NULL DEFAULT 'baohu-service' COMMENT '客服微信号',
  qr_image_url VARCHAR(512) NULL COMMENT '客服二维码图片地址',
  qr_image_path VARCHAR(512) NULL COMMENT '客服二维码本地路径',
  qr_image_name VARCHAR(128) NULL COMMENT '客服二维码文件名',
  status INT NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  remark VARCHAR(255) NULL COMMENT '备注',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_photo_service_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='拍照识别客服配置';

INSERT INTO photo_recognition_service_config (config_key, service_phone, service_wechat, status)
VALUES ('default', '400-000-0000', 'baohu-service', 1)
ON DUPLICATE KEY UPDATE
  service_phone = VALUES(service_phone),
  service_wechat = VALUES(service_wechat),
  updated_at = CURRENT_TIMESTAMP;
