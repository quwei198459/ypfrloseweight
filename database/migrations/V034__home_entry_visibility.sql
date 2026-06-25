-- =============================================================================
-- V034: 首页功能入口显示开关（皮肤检测 / 舌诊）
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

-- 默认显示（1=显示 0=隐藏）
INSERT INTO system_config (config_key, config_value, remark)
VALUES
  ('skin_detection_entry_visible', '1', '首页皮肤检测入口显示开关：1=显示 0=隐藏'),
  ('tcm_detection_entry_visible', '1', '首页舌诊(中医体检)入口显示开关：1=显示 0=隐藏')
ON DUPLICATE KEY UPDATE
  remark = VALUES(remark),
  updated_at = CURRENT_TIMESTAMP;
