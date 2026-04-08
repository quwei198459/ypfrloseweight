-- 增量脚本：若你已执行过旧版 01_schema.sql（尚无登录日志表），在 MySQL 中执行本文件即可。
USE loseweight;

CREATE TABLE IF NOT EXISTS wechat_login_log (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED       DEFAULT NULL COMMENT '登录成功后关联 app_user.id；失败时可为空',
  openid          VARCHAR(64)           DEFAULT NULL COMMENT '成功换取后写入；code2session 失败时为空',
  union_id        VARCHAR(64)           DEFAULT NULL,
  success         TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1 成功 0 失败',
  error_message   VARCHAR(256)          DEFAULT NULL COMMENT '失败原因或微信返回错误摘要',
  login_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  client_ip       VARCHAR(45)           DEFAULT NULL,
  client_ua       VARCHAR(512)          DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_wx_login_user_time (user_id, login_at),
  KEY idx_wx_login_openid_time (openid, login_at),
  CONSTRAINT fk_wx_login_user FOREIGN KEY (user_id) REFERENCES app_user (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
