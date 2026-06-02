-- =============================================================================
-- V028: 皮肤检测配置化、AI 提示词模板与分项结构化 AI 结果
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

ALTER TABLE skin_detection_record
  MODIFY COLUMN detect_types BIGINT NOT NULL DEFAULT 40990 COMMENT '本次检测项组合，支持高位 detect_type';

ALTER TABLE skin_detection_item
  ADD COLUMN scale_type VARCHAR(32) NULL COMMENT '分档类型：severity/skin_type 等' AFTER sort_order,
  ADD COLUMN ai_conclusion TEXT NULL COMMENT '分项 AI 结论' AFTER scale_type,
  ADD COLUMN ai_reason TEXT NULL COMMENT '分项 AI 产生原因' AFTER ai_conclusion,
  ADD COLUMN ai_care_advice TEXT NULL COMMENT '分项 AI 护理建议' AFTER ai_reason,
  ADD COLUMN ai_raw_json JSON NULL COMMENT '分项 DeepSeek 原始结构化返回' AFTER ai_care_advice,
  ADD COLUMN ai_status VARCHAR(24) NULL COMMENT '分项 AI 状态：success/failed/skipped' AFTER ai_raw_json,
  ADD COLUMN ai_error VARCHAR(512) NULL COMMENT '分项 AI 失败原因' AFTER ai_status;

CREATE TABLE IF NOT EXISTS skin_detection_item_config (
  id BIGINT NOT NULL AUTO_INCREMENT,
  item_code VARCHAR(32) NOT NULL COMMENT '系统内部检测项编码',
  yimei_field VARCHAR(32) NOT NULL COMMENT '宜远返回字段名',
  detect_type BIGINT NOT NULL COMMENT '宜远 detect_type 位值',
  item_name VARCHAR(64) NOT NULL COMMENT '检测项名称',
  display_name VARCHAR(64) NOT NULL COMMENT '前端展示短名称',
  sort_order INT NOT NULL DEFAULT 0 COMMENT '展示顺序',
  enabled INT NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  scale_type VARCHAR(32) NOT NULL DEFAULT 'severity' COMMENT '分档类型：severity/skin_type 等',
  score_direction VARCHAR(16) NOT NULL DEFAULT 'higher_better' COMMENT 'higher_better/lower_better',
  prompt_key VARCHAR(64) NOT NULL COMMENT '分项 DeepSeek prompt key',
  remark VARCHAR(255) NULL COMMENT '备注',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_skin_detection_item_config_code (item_code),
  KEY idx_skin_detection_item_config_enabled_sort (enabled, sort_order),
  KEY idx_skin_detection_item_config_prompt_key (prompt_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='皮肤检测项配置';

CREATE TABLE IF NOT EXISTS skin_detection_ai_prompt_template (
  id BIGINT NOT NULL AUTO_INCREMENT,
  prompt_key VARCHAR(64) NOT NULL COMMENT '提示词唯一键',
  prompt_type VARCHAR(32) NOT NULL COMMENT 'overall/item',
  item_code VARCHAR(32) NULL COMMENT '分项检测项编码，综合模板为空',
  prompt_name VARCHAR(128) NOT NULL COMMENT '模板名称',
  template_content MEDIUMTEXT NOT NULL COMMENT '提示词模板内容',
  output_schema JSON NULL COMMENT '期望输出 JSON 结构',
  model VARCHAR(64) NOT NULL DEFAULT 'deepseek-chat' COMMENT '模型名',
  temperature DECIMAL(3,2) NOT NULL DEFAULT 0.20 COMMENT '采样温度',
  status INT NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  version INT NOT NULL DEFAULT 1 COMMENT '版本号',
  remark VARCHAR(255) NULL COMMENT '备注',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_skin_detection_ai_prompt_key (prompt_key),
  KEY idx_skin_detection_ai_prompt_type_status (prompt_type, status),
  KEY idx_skin_detection_ai_prompt_item_code (item_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='皮肤检测 AI 提示词模板';

INSERT INTO skin_detection_item_config
  (item_code, yimei_field, detect_type, item_name, display_name, sort_order, enabled, scale_type, score_direction, prompt_key, remark)
VALUES
  ('pockmark', 'pockmark', 65536, '痘痘', '痘痘', 1, 1, 'severity', 'higher_better', 'skin_item_pockmark', '痘痘/痘印检测'),
  ('pore', 'pore', 4, '毛孔', '毛孔', 2, 1, 'severity', 'higher_better', 'skin_item_pore', '毛孔检测'),
  ('spot', 'spot', 2, '色斑', '色斑', 3, 1, 'severity', 'higher_better', 'skin_item_spot', '色斑检测'),
  ('blackhead', 'blackhead', 32768, '黑头', '黑头', 4, 1, 'severity', 'higher_better', 'skin_item_blackhead', '黑头检测'),
  ('skin_type', 'skin_type', 8, '肤质', '肤质', 5, 1, 'skin_type', 'higher_better', 'skin_item_skin_type', '肤质油干性检测'),
  ('wrinkle', 'wrinkle', 8192, '皱纹', '皱纹', 6, 1, 'severity', 'higher_better', 'skin_item_wrinkle', '皱纹检测')
ON DUPLICATE KEY UPDATE
  yimei_field = VALUES(yimei_field),
  detect_type = VALUES(detect_type),
  item_name = VALUES(item_name),
  display_name = VALUES(display_name),
  sort_order = VALUES(sort_order),
  scale_type = VALUES(scale_type),
  score_direction = VALUES(score_direction),
  prompt_key = VALUES(prompt_key),
  remark = VALUES(remark);

INSERT INTO skin_detection_ai_prompt_template
  (prompt_key, prompt_type, item_code, prompt_name, template_content, output_schema, model, temperature, status, remark)
VALUES
  ('skin_overall_report', 'overall', NULL, '综合报告提示词',
'你是一名专业但表达克制的皮肤护理分析助手。请基于用户的皮肤检测结构化数据，生成综合报告。

要求：
1. 只根据输入数据分析，不要编造不存在的检测项、数值或疾病诊断。
2. 不要使用 Markdown。
3. 不要输出任何解释性前后缀。
4. 只返回合法 JSON。
5. 语言面向普通用户，避免医疗诊断口吻。
6. 如果数据不足，请用“根据当前检测数据”这种保守表达。
7. 护理建议应偏日常护肤、生活习惯、温和安全，不推荐具体药物。

用户信息：
{{userProfileText}}

检测项概览：
{{itemsFactsText}}

请严格按以下 JSON 格式返回：
{
  "overallConclusion": "整体肤况总结，80字以内",
  "skinSummary": "综合分析，150字以内",
  "keyProblems": [
    {
      "itemCode": "检测项编码",
      "itemName": "检测项名称",
      "score": 0,
      "levelText": "程度中文",
      "summary": "该项问题概括，60字以内"
    }
  ],
  "carePrinciples": ["护理原则1", "护理原则2", "护理原则3"],
  "serviceGuide": "引导用户联系客服定制护肤方案，80字以内"
}',
  JSON_OBJECT('overallConclusion', 'string', 'skinSummary', 'string', 'keyProblems', 'array', 'carePrinciples', 'array', 'serviceGuide', 'string'), 'deepseek-chat', 0.20, 1, '综合报告默认模板'),

  ('skin_item_spot', 'item', 'spot', '色斑分析提示词',
'你是一名专业但表达克制的皮肤护理分析助手。请基于“色斑”检测数据生成分项分析。

要求：只根据输入数据分析，不编造检测数值；不做疾病诊断；不推荐药物；不使用 Markdown；只返回合法 JSON。

检测数据：
{{itemFactsText}}

请严格返回：
{
  "itemCode": "spot",
  "itemName": "色斑",
  "conclusion": "一句话总结，60字以内",
  "reason": "产生原因，120字以内",
  "careAdvice": "护理建议，160字以内",
  "riskTips": ["注意点1", "注意点2", "注意点3"]
}',
  JSON_OBJECT('itemCode', 'spot', 'itemName', '色斑', 'conclusion', 'string', 'reason', 'string', 'careAdvice', 'string', 'riskTips', 'array'), 'deepseek-chat', 0.20, 1, '色斑分项默认模板'),

  ('skin_item_pore', 'item', 'pore', '毛孔分析提示词',
'你是一名专业但表达克制的皮肤护理分析助手。请基于“毛孔”检测数据生成分项分析。

要求：只根据输入数据分析，不编造检测数值；不做疾病诊断；不推荐药物；不使用 Markdown；只返回合法 JSON。重点解释油脂分泌、清洁、角质、保湿和生活习惯对毛孔的影响。

检测数据：
{{itemFactsText}}

请严格返回：
{
  "itemCode": "pore",
  "itemName": "毛孔",
  "conclusion": "一句话总结，60字以内",
  "reason": "产生原因，120字以内",
  "careAdvice": "护理建议，160字以内",
  "riskTips": ["注意点1", "注意点2", "注意点3"]
}',
  JSON_OBJECT('itemCode', 'pore', 'itemName', '毛孔', 'conclusion', 'string', 'reason', 'string', 'careAdvice', 'string', 'riskTips', 'array'), 'deepseek-chat', 0.20, 1, '毛孔分项默认模板'),

  ('skin_item_skin_type', 'item', 'skin_type', '肤质分析提示词',
'你是一名专业但表达克制的皮肤护理分析助手。请基于“肤质（油干性）”检测数据生成分项分析。

要求：只根据输入数据分析，不编造检测数值；不做疾病诊断；不推荐药物；不使用 Markdown；只返回合法 JSON。重点解释油脂、水分、区域差异和护理平衡。

检测数据：
{{itemFactsText}}

请严格返回：
{
  "itemCode": "skin_type",
  "itemName": "肤质",
  "conclusion": "一句话总结，60字以内",
  "reason": "产生原因，120字以内",
  "careAdvice": "护理建议，160字以内",
  "riskTips": ["注意点1", "注意点2", "注意点3"]
}',
  JSON_OBJECT('itemCode', 'skin_type', 'itemName', '肤质', 'conclusion', 'string', 'reason', 'string', 'careAdvice', 'string', 'riskTips', 'array'), 'deepseek-chat', 0.20, 1, '肤质分项默认模板'),

  ('skin_item_wrinkle', 'item', 'wrinkle', '皱纹分析提示词',
'你是一名专业但表达克制的皮肤护理分析助手。请基于“皱纹”检测数据生成分项分析。

要求：只根据输入数据分析，不编造检测数值；不做疾病诊断；不推荐药物；不使用 Markdown；只返回合法 JSON。重点解释干燥、表情纹、紫外线、作息和皮肤弹性变化。

检测数据：
{{itemFactsText}}

请严格返回：
{
  "itemCode": "wrinkle",
  "itemName": "皱纹",
  "conclusion": "一句话总结，60字以内",
  "reason": "产生原因，120字以内",
  "careAdvice": "护理建议，160字以内",
  "riskTips": ["注意点1", "注意点2", "注意点3"]
}',
  JSON_OBJECT('itemCode', 'wrinkle', 'itemName', '皱纹', 'conclusion', 'string', 'reason', 'string', 'careAdvice', 'string', 'riskTips', 'array'), 'deepseek-chat', 0.20, 1, '皱纹分项默认模板'),

  ('skin_item_blackhead', 'item', 'blackhead', '黑头分析提示词',
'你是一名专业但表达克制的皮肤护理分析助手。请基于“黑头”检测数据生成分项分析。

要求：只根据输入数据分析，不编造检测数值；不做疾病诊断；不推荐药物；不使用 Markdown；只返回合法 JSON。重点解释油脂氧化、毛孔堵塞、清洁方式和屏障保护。

检测数据：
{{itemFactsText}}

请严格返回：
{
  "itemCode": "blackhead",
  "itemName": "黑头",
  "conclusion": "一句话总结，60字以内",
  "reason": "产生原因，120字以内",
  "careAdvice": "护理建议，160字以内",
  "riskTips": ["注意点1", "注意点2", "注意点3"]
}',
  JSON_OBJECT('itemCode', 'blackhead', 'itemName', '黑头', 'conclusion', 'string', 'reason', 'string', 'careAdvice', 'string', 'riskTips', 'array'), 'deepseek-chat', 0.20, 1, '黑头分项默认模板'),

  ('skin_item_pockmark', 'item', 'pockmark', '痘痘分析提示词',
'你是一名专业但表达克制的皮肤护理分析助手。请基于“痘痘/痘印”检测数据生成分项分析。

要求：只根据输入数据分析，不编造检测数值；不做疾病诊断；不推荐药物；不使用 Markdown；只返回合法 JSON。如果检测数据包含痘痘和痘印分类，请分别提及。

检测数据：
{{itemFactsText}}

请严格返回：
{
  "itemCode": "pockmark",
  "itemName": "痘痘",
  "conclusion": "一句话总结，60字以内",
  "reason": "产生原因，120字以内",
  "careAdvice": "护理建议，160字以内",
  "riskTips": ["注意点1", "注意点2", "注意点3"]
}',
  JSON_OBJECT('itemCode', 'pockmark', 'itemName', '痘痘', 'conclusion', 'string', 'reason', 'string', 'careAdvice', 'string', 'riskTips', 'array'), 'deepseek-chat', 0.20, 1, '痘痘分项默认模板')
ON DUPLICATE KEY UPDATE
  prompt_type = VALUES(prompt_type),
  item_code = VALUES(item_code),
  prompt_name = VALUES(prompt_name),
  output_schema = VALUES(output_schema),
  model = VALUES(model),
  temperature = VALUES(temperature),
  status = VALUES(status),
  remark = VALUES(remark);
