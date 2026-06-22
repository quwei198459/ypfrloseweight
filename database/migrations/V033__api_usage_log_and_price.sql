-- =============================================================================
-- V033: 第三方检测接口（食物识别/皮肤检测/舌诊）调用费用 —— 流水 + 可配置单价
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

-- 单价配置（管理员可在后台改）。cost = unit_price_cny * units_per_call（免费额度内为 0）
CREATE TABLE IF NOT EXISTS api_price_config (
  id BIGINT NOT NULL AUTO_INCREMENT,
  provider VARCHAR(32) NOT NULL COMMENT '供应商：aliyun_food/yimei_skin/maijing_tcm',
  feature VARCHAR(16) NOT NULL COMMENT '功能：food/skin/tcm',
  display_name VARCHAR(64) NOT NULL COMMENT '展示名',
  unit_price_cny DECIMAL(10,6) NOT NULL DEFAULT 0 COMMENT '单价（元/计费单元）',
  units_per_call INT NOT NULL DEFAULT 1 COMMENT '每次调用计费单元数（皮肤=6项）',
  free_quota INT NOT NULL DEFAULT 0 COMMENT '免费额度次数（0=无）',
  free_until DATE NULL COMMENT '免费额度截止日期',
  enabled INT NOT NULL DEFAULT 1 COMMENT '1=计费启用 0=停用',
  remark VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_api_price_provider (provider)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='第三方接口单价配置';

-- 预填实测报价：食物 220元/1万次=0.022；皮肤 240元/6项各1000次=0.04/项×6；舌诊 150元/1000次=0.15，50次免费至 2026-07-17
INSERT INTO api_price_config (provider, feature, display_name, unit_price_cny, units_per_call, free_quota, free_until, remark)
VALUES
  ('aliyun_food', 'food', '食物识别(阿里云)', 0.022000, 1, 0, NULL, '220元/1万次'),
  ('yimei_skin',  'skin', '皮肤检测(易美)',   0.040000, 6, 0, NULL, '240元/6项各1000次=0.04元/项×6项'),
  ('maijing_tcm', 'tcm',  '舌诊(脉景)',       0.150000, 1, 50, '2026-07-17', '150元/1000次；前50次免费')
ON DUPLICATE KEY UPDATE
  display_name = VALUES(display_name),
  updated_at = CURRENT_TIMESTAMP;

-- 第三方调用流水（成功失败都记，失败/免费额度内 cost=0）
CREATE TABLE IF NOT EXISTS api_usage_log (
  id BIGINT NOT NULL AUTO_INCREMENT,
  provider VARCHAR(32) NOT NULL COMMENT 'aliyun_food/yimei_skin/maijing_tcm',
  feature VARCHAR(16) NOT NULL COMMENT 'food/skin/tcm',
  user_id BIGINT NULL COMMENT '触发用户ID',
  record_id BIGINT NULL COMMENT '业务记录ID（识图job/皮肤record/中医record）',
  success INT NOT NULL DEFAULT 1 COMMENT '1=成功 0=失败',
  billable INT NOT NULL DEFAULT 1 COMMENT '是否计费口径（成功=1，失败=0）',
  free INT NOT NULL DEFAULT 0 COMMENT '是否命中免费额度（命中则 cost=0）',
  units INT NOT NULL DEFAULT 1 COMMENT '本次计费单元数快照',
  unit_price_cny DECIMAL(10,6) NOT NULL DEFAULT 0 COMMENT '单价快照',
  cost_cny DECIMAL(12,6) NOT NULL DEFAULT 0 COMMENT '本次费用（元）',
  error VARCHAR(255) NULL COMMENT '失败原因',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_aul_feature_created (feature, created_at),
  KEY idx_aul_provider_created (provider, created_at),
  KEY idx_aul_created (created_at),
  KEY idx_aul_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='第三方接口调用用量与费用日志';
