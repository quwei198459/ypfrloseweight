-- =============================================================================
-- V023: 拍照识别会员手机号白名单
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS photo_recognition_member_phone (
  id BIGINT NOT NULL AUTO_INCREMENT,
  phone VARCHAR(20) NOT NULL COMMENT '允许使用拍照识别的手机号，建议保存纯数字',
  remark VARCHAR(255) NULL COMMENT '后台备注',
  status INT NOT NULL DEFAULT 1 COMMENT '1=启用 0=禁用',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_photo_member_phone (phone),
  KEY idx_photo_member_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='拍照识别会员手机号白名单';
