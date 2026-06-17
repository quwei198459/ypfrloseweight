-- =============================================================================
-- V029: 系统配置（键值对），含拍照识图 / 皮肤检测白名单限制总开关
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS system_config (
  id BIGINT NOT NULL AUTO_INCREMENT,
  config_key VARCHAR(64) NOT NULL COMMENT '配置键',
  config_value VARCHAR(255) NOT NULL COMMENT '配置值，开关用 1=开启 0=关闭',
  remark VARCHAR(255) NULL COMMENT '备注/用途说明',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_system_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置键值对';

-- 默认开启白名单限制（1=限制开启，需在白名单内才可使用；0=关闭限制，所有用户可用）
INSERT INTO system_config (config_key, config_value, remark)
VALUES
  ('photo_recognition_whitelist_enabled', '1', '拍照识图白名单限制开关：1=开启限制 0=关闭限制'),
  ('skin_detection_whitelist_enabled', '1', '皮肤检测白名单限制开关：1=开启限制 0=关闭限制')
ON DUPLICATE KEY UPDATE
  remark = VALUES(remark),
  updated_at = CURRENT_TIMESTAMP;
