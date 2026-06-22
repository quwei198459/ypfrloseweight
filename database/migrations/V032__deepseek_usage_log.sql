-- =============================================================================
-- V032: DeepSeek 调用用量与费用日志（按功能/用户/月份对账）
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS deepseek_usage_log (
  id BIGINT NOT NULL AUTO_INCREMENT,
  feature VARCHAR(16) NOT NULL COMMENT '业务功能：food/skin/tcm',
  scene VARCHAR(64) NULL COMMENT '细分场景：提示词 promptKey 或餐次',
  model VARCHAR(64) NOT NULL COMMENT '请求时传的模型名（如 deepseek-chat）',
  billed_model VARCHAR(32) NOT NULL COMMENT '实际计费模型：deepseek-v4-flash / deepseek-v4-pro',
  user_id BIGINT NULL COMMENT '触发用户ID',
  record_id BIGINT NULL COMMENT '关联业务记录ID（皮肤/中医 record 或识图 job）',
  prompt_tokens INT NOT NULL DEFAULT 0 COMMENT '输入 token 总数',
  cache_hit_tokens INT NOT NULL DEFAULT 0 COMMENT '命中缓存的输入 token',
  cache_miss_tokens INT NOT NULL DEFAULT 0 COMMENT '未命中缓存的输入 token',
  completion_tokens INT NOT NULL DEFAULT 0 COMMENT '输出 token',
  total_tokens INT NOT NULL DEFAULT 0 COMMENT '合计 token',
  cost_cny DECIMAL(12,6) NOT NULL DEFAULT 0 COMMENT '本次费用（人民币元）',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '调用时间',
  PRIMARY KEY (id),
  KEY idx_dsu_feature_created (feature, created_at),
  KEY idx_dsu_created (created_at),
  KEY idx_dsu_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='DeepSeek 调用用量与费用日志';
