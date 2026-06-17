-- =============================================================================
-- V030: 中医体检（AI舌诊/AI面诊/体质检测/健康报告）独立白名单、次数、检测记录与明细
-- 第三方：阿里云云市场「AI舌诊-AI面诊-体质检测-健康报告（专业版）cmapi00066970」
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS tcm_detection_whitelist (
  id BIGINT NOT NULL AUTO_INCREMENT,
  phone VARCHAR(20) NOT NULL COMMENT '允许使用中医体检的手机号，建议保存纯数字',
  remark VARCHAR(255) NULL COMMENT '后台备注',
  status INT NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  total_times INT NOT NULL DEFAULT 3 COMMENT '中医体检总赠送/调整次数',
  used_times INT NOT NULL DEFAULT 0 COMMENT '中医体检已使用次数',
  quota_updated_at DATETIME NULL COMMENT '最近一次次数调整时间',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_tcm_detection_whitelist_phone (phone),
  KEY idx_tcm_detection_whitelist_status (status),
  KEY idx_tcm_detection_whitelist_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='中医体检手机号白名单与次数';

CREATE TABLE IF NOT EXISTS tcm_detection_record (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL COMMENT '检测用户ID，关联 lw_user.id',
  phone VARCHAR(20) NULL COMMENT '检测时用户手机号快照',
  user_name VARCHAR(128) NULL COMMENT '检测时填写的姓名/昵称快照',
  gender INT NULL COMMENT '性别快照：1=男 2=女',
  birthday DATE NULL COMMENT '出生日期快照',
  age INT NULL COMMENT '检测时年龄快照，可由 birthday 计算',
  residence VARCHAR(128) NULL COMMENT '居住地快照',
  tongue_image_url VARCHAR(1024) NULL COMMENT '舌象原始图片地址',
  face_image_url VARCHAR(1024) NULL COMMENT '面象原始图片地址',
  third_party_id VARCHAR(128) NULL COMMENT '脉景/云市场返回的记录标识，如有',
  constitution_primary VARCHAR(64) NULL COMMENT '主体质，如 平和质/气虚质/阳虚质',
  constitution_json JSON NULL COMMENT '九种体质概率/得分分布',
  overall_score INT NULL COMMENT '综合健康分 0-100',
  ai_summary MEDIUMTEXT NULL COMMENT 'DeepSeek 综合分析文本',
  ai_summary_json JSON NULL COMMENT 'DeepSeek 结构化结果',
  third_party_raw JSON NULL COMMENT '厂商原始返回 JSON',
  status VARCHAR(24) NOT NULL DEFAULT 'pending' COMMENT 'pending/success/failed',
  fail_reason VARCHAR(512) NULL COMMENT '失败原因',
  deepseek_status VARCHAR(24) NULL COMMENT 'DeepSeek 状态：success/failed/skipped',
  deepseek_error VARCHAR(512) NULL COMMENT 'DeepSeek 失败原因',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_tcm_detection_record_user_id (user_id),
  KEY idx_tcm_detection_record_phone (phone),
  KEY idx_tcm_detection_record_status (status),
  KEY idx_tcm_detection_record_created_at (created_at),
  KEY idx_tcm_detection_record_overall_score (overall_score),
  CONSTRAINT fk_tcm_detection_record_user FOREIGN KEY (user_id) REFERENCES lw_user (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='中医体检记录主表';

CREATE TABLE IF NOT EXISTS tcm_detection_item (
  id BIGINT NOT NULL AUTO_INCREMENT,
  record_id BIGINT NOT NULL COMMENT '中医体检记录ID',
  item_code VARCHAR(32) NOT NULL COMMENT '体质/特征编码，如 pinghe/qixu/yangxu',
  item_name VARCHAR(64) NOT NULL COMMENT '体质/特征中文名',
  score INT NULL COMMENT '该项得分或倾向概率 0-100',
  level VARCHAR(64) NULL COMMENT '倾向程度/等级',
  result_text TEXT NULL COMMENT '结果说明',
  result_image VARCHAR(1024) NULL COMMENT '结果图地址（如切割后舌图）',
  metrics_json JSON NULL COMMENT '扩展指标（舌色/苔质等结构化数据）',
  sort_order INT NOT NULL DEFAULT 0 COMMENT '展示顺序',
  scale_type VARCHAR(32) NULL COMMENT '分档类型：constitution/tongue 等',
  ai_conclusion TEXT NULL COMMENT '分项 AI 结论',
  ai_reason TEXT NULL COMMENT '分项 AI 成因/表现',
  ai_care_advice TEXT NULL COMMENT '分项 AI 调理建议',
  ai_raw_json JSON NULL COMMENT '分项 DeepSeek 原始结构化返回',
  ai_status VARCHAR(24) NULL COMMENT '分项 AI 状态：success/failed/skipped',
  ai_error VARCHAR(512) NULL COMMENT '分项 AI 失败原因',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_tcm_detection_item_record_code (record_id, item_code),
  KEY idx_tcm_detection_item_record_id (record_id),
  KEY idx_tcm_detection_item_code (item_code),
  CONSTRAINT fk_tcm_detection_item_record FOREIGN KEY (record_id) REFERENCES tcm_detection_record (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='中医体检单项明细（体质/特征）';

CREATE TABLE IF NOT EXISTS tcm_detection_quota_log (
  id BIGINT NOT NULL AUTO_INCREMENT,
  whitelist_id BIGINT NOT NULL COMMENT '中医体检白名单ID',
  phone VARCHAR(20) NOT NULL COMMENT '手机号快照',
  user_id BIGINT UNSIGNED NULL COMMENT '使用人用户ID或操作人用户ID',
  record_id BIGINT NULL COMMENT '中医体检记录ID，使用扣减时填写',
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
  KEY idx_tcm_detection_quota_log_whitelist_id (whitelist_id),
  KEY idx_tcm_detection_quota_log_phone (phone),
  KEY idx_tcm_detection_quota_log_user_id (user_id),
  KEY idx_tcm_detection_quota_log_record_id (record_id),
  KEY idx_tcm_detection_quota_log_change_type (change_type),
  KEY idx_tcm_detection_quota_log_created_at (created_at),
  CONSTRAINT fk_tcm_detection_quota_log_whitelist FOREIGN KEY (whitelist_id) REFERENCES tcm_detection_whitelist (id) ON DELETE RESTRICT,
  CONSTRAINT fk_tcm_detection_quota_log_record FOREIGN KEY (record_id) REFERENCES tcm_detection_record (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='中医体检次数调整与使用明细';
