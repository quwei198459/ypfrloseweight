-- =============================================================================
-- V019: BMI 四档解读文案表（供计划页等展示；可由大模型生成后 UPDATE 维护）
-- 幂等：INSERT IGNORE，已存在 bucket 则跳过
-- 执行：mysql -h ... -u ... -p loseweight < database/migrations/V019__bmi_interpretation.sql
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS bmi_interpretation (
  bucket_code VARCHAR(32) NOT NULL COMMENT 'UNDERWEIGHT|NORMAL|OVERWEIGHT|OBESE',
  body_text TEXT NOT NULL COMMENT '展示用长文案',
  revision INT NOT NULL DEFAULT 1 COMMENT '文案版本号',
  source VARCHAR(32) NOT NULL DEFAULT 'seed' COMMENT 'seed/llm/manual 等',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (bucket_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BMI 分桶解读（与 WHO 常用分界对齐）';

INSERT IGNORE INTO bmi_interpretation (bucket_code, body_text, revision, source) VALUES
(
  'UNDERWEIGHT',
  'BMI 偏低通常提示体重偏轻或营养储备不足。建议优先保证充足热量与优质蛋白，避免极端节食；如近期体重下降明显或伴有乏力、头晕等，建议咨询医生或营养师评估原因。本说明仅供健康教育参考，不能替代诊疗。',
  1,
  'seed'
),
(
  'NORMAL',
  'BMI 处于成人常用参考范围内的「标准」区间，整体代谢风险相对较低。建议继续保持均衡饮食（足量蔬菜、适量全谷与优质蛋白）、规律作息与可持续的运动习惯，把当前状态当作长期健康资产来维护。本说明仅供健康教育参考，不能替代诊疗。',
  1,
  'seed'
),
(
  'OVERWEIGHT',
  'BMI 处于「超重」区间，常与能量摄入偏高、久坐、睡眠不足等因素相关，也可能伴随代谢风险上升。建议以「可持续」为优先：适度控制精制糖与高脂零食、增加日常活动量，并逐步建立固定进食节律；如有血压、血糖或血脂异常史，建议在医生指导下综合管理。本说明仅供健康教育参考，不能替代诊疗。',
  1,
  'seed'
),
(
  'OBESE',
  'BMI 处于「肥胖」区间，提示体重对健康的影响更需要系统性管理。建议把目标设定为循序渐进的生活方式改变（饮食结构调整、活动量提升、睡眠与压力管理），并在医生或营养师指导下制定个体化方案，必要时评估相关代谢指标。本说明仅供健康教育参考，不能替代诊疗。',
  1,
  'seed'
);
