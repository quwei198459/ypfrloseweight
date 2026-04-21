-- =============================================================================
-- V022: 管理后台账号与登录日志
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS admin_user (
  id BIGINT NOT NULL AUTO_INCREMENT,
  username VARCHAR(64) NOT NULL COMMENT '登录账号',
  password VARCHAR(255) NOT NULL COMMENT 'BCrypt 密文',
  status INT NOT NULL DEFAULT 1 COMMENT '1=启用 0=禁用',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_admin_user_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='后台管理员';

CREATE TABLE IF NOT EXISTS admin_login_log (
  id BIGINT NOT NULL AUTO_INCREMENT,
  admin_id BIGINT NULL COMMENT '登录成功时管理员ID，失败可空',
  username VARCHAR(64) NOT NULL COMMENT '尝试登录的账号',
  success INT NOT NULL DEFAULT 0 COMMENT '1=成功 0=失败',
  ip VARCHAR(64) NULL,
  user_agent VARCHAR(512) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_admin_login_log_admin_id (admin_id),
  KEY idx_admin_login_log_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='后台登录日志';

INSERT INTO admin_user (username, password, status)
VALUES ('admin', '$2b$12$YWQICl15oqgA/.RPUef.Ledtwdgr00WTCbVT5QzmRGVzI13wLPJYa', 1)
ON DUPLICATE KEY UPDATE
  password = VALUES(password),
  status = VALUES(status),
  updated_at = CURRENT_TIMESTAMP;
