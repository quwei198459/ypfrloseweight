-- =============================================================================
-- V025: 拍照识别会员次数与使用明细
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

ALTER TABLE photo_recognition_member_phone
  ADD COLUMN total_quota INT NOT NULL DEFAULT 100 COMMENT '累计赠送/调整后的总次数' AFTER status,
  ADD COLUMN used_count INT NOT NULL DEFAULT 0 COMMENT '累计已使用次数' AFTER total_quota,
  ADD COLUMN quota_updated_at DATETIME NULL COMMENT '最近一次次数调整时间' AFTER used_count;

CREATE TABLE IF NOT EXISTS photo_recognition_quota_log (
  id BIGINT NOT NULL AUTO_INCREMENT,
  member_phone_id BIGINT NOT NULL COMMENT '手机号白名单ID',
  phone VARCHAR(20) NOT NULL COMMENT '手机号快照',
  user_id BIGINT NULL COMMENT '使用人用户ID或操作人用户ID',
  photo_job_id BIGINT NULL COMMENT '识图任务ID，使用扣减时填写',
  change_type VARCHAR(32) NOT NULL COMMENT 'grant/reduce/consume',
  change_count INT NOT NULL COMMENT '变化次数，正数表示增加，负数表示减少',
  before_total_quota INT NOT NULL COMMENT '变化前总次数',
  before_used_count INT NOT NULL COMMENT '变化前已使用次数',
  after_total_quota INT NOT NULL COMMENT '变化后总次数',
  after_used_count INT NOT NULL COMMENT '变化后已使用次数',
  operator_type VARCHAR(32) NOT NULL COMMENT 'system/admin/user',
  operator_name VARCHAR(64) NULL COMMENT '操作人名称或标识',
  remark VARCHAR(255) NULL COMMENT '备注',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_quota_log_member_phone_id (member_phone_id),
  KEY idx_quota_log_phone (phone),
  KEY idx_quota_log_photo_job_id (photo_job_id),
  KEY idx_quota_log_change_type (change_type),
  KEY idx_quota_log_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='拍照识别次数调整与使用明细';

INSERT INTO photo_recognition_quota_log (
  member_phone_id,
  phone,
  change_type,
  change_count,
  before_total_quota,
  before_used_count,
  after_total_quota,
  after_used_count,
  operator_type,
  operator_name,
  remark
)
SELECT
  id,
  phone,
  'grant',
  100,
  0,
  0,
  total_quota,
  used_count,
  'system',
  'migration',
  '历史手机号默认赠送'
FROM photo_recognition_member_phone
WHERE total_quota = 100 AND used_count = 0;
