-- =============================================================================
-- V026: 皮肤检测独立白名单、次数、检测记录与明细
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS skin_detection_whitelist (
  id BIGINT NOT NULL AUTO_INCREMENT,
  phone VARCHAR(20) NOT NULL COMMENT '允许使用皮肤检测的手机号，建议保存纯数字',
  remark VARCHAR(255) NULL COMMENT '后台备注',
  status INT NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  total_times INT NOT NULL DEFAULT 3 COMMENT '皮肤检测总赠送/调整次数',
  used_times INT NOT NULL DEFAULT 0 COMMENT '皮肤检测已使用次数',
  quota_updated_at DATETIME NULL COMMENT '最近一次次数调整时间',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_skin_detection_whitelist_phone (phone),
  KEY idx_skin_detection_whitelist_status (status),
  KEY idx_skin_detection_whitelist_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='皮肤检测手机号白名单与次数';

CREATE TABLE IF NOT EXISTS skin_detection_record (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL COMMENT '检测用户ID，关联 lw_user.id',
  phone VARCHAR(20) NULL COMMENT '检测时用户手机号快照',
  user_name VARCHAR(128) NULL COMMENT '检测时填写的姓名/昵称快照',
  gender INT NULL COMMENT '性别快照：1=男 2=女 其它按现有用户枚举',
  birthday DATE NULL COMMENT '出生日期快照',
  age INT NULL COMMENT '检测时年龄快照，可由 birthday 计算',
  residence VARCHAR(128) NULL COMMENT '居住地快照',
  image_url VARCHAR(1024) NULL COMMENT '用户原始检测图片地址',
  third_party_id VARCHAR(128) NULL COMMENT '宜远返回的记录/任务标识，如有',
  detect_types INT NOT NULL DEFAULT 40990 COMMENT '本次固定检测项组合，默认 40990',
  overall_score INT NULL COMMENT '综合分，6 项平均分四舍五入',
  ai_summary MEDIUMTEXT NULL COMMENT 'DeepSeek 综合分析文本',
  ai_summary_json JSON NULL COMMENT 'DeepSeek 结构化结果',
  third_party_raw JSON NULL COMMENT '宜远原始返回 JSON',
  status VARCHAR(24) NOT NULL DEFAULT 'pending' COMMENT 'pending/success/failed',
  fail_reason VARCHAR(512) NULL COMMENT '失败原因',
  deepseek_status VARCHAR(24) NULL COMMENT 'DeepSeek 状态：success/failed/skipped',
  deepseek_error VARCHAR(512) NULL COMMENT 'DeepSeek 失败原因',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_skin_detection_record_user_id (user_id),
  KEY idx_skin_detection_record_phone (phone),
  KEY idx_skin_detection_record_status (status),
  KEY idx_skin_detection_record_created_at (created_at),
  KEY idx_skin_detection_record_overall_score (overall_score),
  CONSTRAINT fk_skin_detection_record_user FOREIGN KEY (user_id) REFERENCES lw_user (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='皮肤检测记录主表';

CREATE TABLE IF NOT EXISTS skin_detection_item (
  id BIGINT NOT NULL AUTO_INCREMENT,
  record_id BIGINT NOT NULL COMMENT '皮肤检测记录ID',
  item_code VARCHAR(32) NOT NULL COMMENT 'spot/pore/skin_type/wrinkle/blackhead/acne',
  item_name VARCHAR(64) NOT NULL COMMENT '检测项中文名',
  score INT NULL COMMENT '单项分，0-100；如第三方无 score，由后端按规则换算',
  level VARCHAR(64) NULL COMMENT '程度/等级',
  result_text TEXT NULL COMMENT '结果说明',
  result_image VARCHAR(1024) NULL COMMENT '检测结果图地址',
  metrics_json JSON NULL COMMENT '数量、面积占比、分类等扩展指标',
  sort_order INT NOT NULL DEFAULT 0 COMMENT '展示顺序',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_skin_detection_item_record_code (record_id, item_code),
  KEY idx_skin_detection_item_record_id (record_id),
  KEY idx_skin_detection_item_code (item_code),
  CONSTRAINT fk_skin_detection_item_record FOREIGN KEY (record_id) REFERENCES skin_detection_record (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='皮肤检测单项明细';

CREATE TABLE IF NOT EXISTS skin_detection_quota_log (
  id BIGINT NOT NULL AUTO_INCREMENT,
  whitelist_id BIGINT NOT NULL COMMENT '皮肤检测白名单ID',
  phone VARCHAR(20) NOT NULL COMMENT '手机号快照',
  user_id BIGINT UNSIGNED NULL COMMENT '使用人用户ID或操作人用户ID',
  record_id BIGINT NULL COMMENT '皮肤检测记录ID，使用扣减时填写',
  change_type VARCHAR(32) NOT NULL COMMENT 'grant/reduce/consume',
  change_count INT NOT NULL COMMENT '变化次数，正数表示增加，负数表示减少',
  before_total_times INT NOT NULL COMMENT '变化前总次数',
  before_used_times INT NOT NULL COMMENT '变化前已使用次数',
  after_total_times INT NOT NULL COMMENT '变化后总次数',
  after_used_times INT NOT NULL COMMENT '变化后已使用次数',
  operator_type VARCHAR(32) NOT NULL COMMENT 'system/admin/user',
  operator_name VARCHAR(64) NULL COMMENT '操作人名称或标识',
  remark VARCHAR(255) NULL COMMENT '备注',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_skin_detection_quota_log_whitelist_id (whitelist_id),
  KEY idx_skin_detection_quota_log_phone (phone),
  KEY idx_skin_detection_quota_log_user_id (user_id),
  KEY idx_skin_detection_quota_log_record_id (record_id),
  KEY idx_skin_detection_quota_log_change_type (change_type),
  KEY idx_skin_detection_quota_log_created_at (created_at),
  CONSTRAINT fk_skin_detection_quota_log_whitelist FOREIGN KEY (whitelist_id) REFERENCES skin_detection_whitelist (id) ON DELETE RESTRICT,
  CONSTRAINT fk_skin_detection_quota_log_record FOREIGN KEY (record_id) REFERENCES skin_detection_record (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='皮肤检测次数调整与使用明细';
