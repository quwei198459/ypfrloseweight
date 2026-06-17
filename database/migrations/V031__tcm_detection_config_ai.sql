-- =============================================================================
-- V031: 中医体检项配置（九种体质）、AI 提示词模板，及系统白名单开关种子
-- =============================================================================

USE loseweight;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS tcm_detection_item_config (
  id BIGINT NOT NULL AUTO_INCREMENT,
  item_code VARCHAR(32) NOT NULL COMMENT '系统内部编码，如 pinghe/qixu',
  vendor_field VARCHAR(64) NOT NULL COMMENT '厂商返回字段名',
  item_name VARCHAR(64) NOT NULL COMMENT '体质/特征名称',
  display_name VARCHAR(64) NOT NULL COMMENT '前端展示短名称',
  sort_order INT NOT NULL DEFAULT 0 COMMENT '展示顺序',
  enabled INT NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  scale_type VARCHAR(32) NOT NULL DEFAULT 'constitution' COMMENT 'constitution/tongue 等',
  score_direction VARCHAR(16) NOT NULL DEFAULT 'lower_better' COMMENT 'higher_better/lower_better',
  prompt_key VARCHAR(64) NOT NULL COMMENT '分项 DeepSeek prompt key',
  remark VARCHAR(255) NULL COMMENT '备注',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_tcm_detection_item_config_code (item_code),
  KEY idx_tcm_detection_item_config_enabled_sort (enabled, sort_order),
  KEY idx_tcm_detection_item_config_prompt_key (prompt_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='中医体检项配置（九种体质）';

CREATE TABLE IF NOT EXISTS tcm_detection_ai_prompt_template (
  id BIGINT NOT NULL AUTO_INCREMENT,
  prompt_key VARCHAR(64) NOT NULL COMMENT '提示词唯一键',
  prompt_type VARCHAR(32) NOT NULL COMMENT 'overall/item',
  item_code VARCHAR(32) NULL COMMENT '分项体质编码，综合模板为空',
  prompt_name VARCHAR(128) NOT NULL COMMENT '模板名称',
  template_content MEDIUMTEXT NOT NULL COMMENT '提示词模板内容',
  output_schema JSON NULL COMMENT '期望输出 JSON 结构',
  model VARCHAR(64) NOT NULL DEFAULT 'deepseek-chat' COMMENT '模型名',
  temperature DECIMAL(3,2) NOT NULL DEFAULT 0.30 COMMENT '采样温度',
  status INT NOT NULL DEFAULT 1 COMMENT '1=启用 0=停用',
  version INT NOT NULL DEFAULT 1 COMMENT '版本号',
  remark VARCHAR(255) NULL COMMENT '备注',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_tcm_detection_ai_prompt_key (prompt_key),
  KEY idx_tcm_detection_ai_prompt_type_status (prompt_type, status),
  KEY idx_tcm_detection_ai_prompt_item_code (item_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='中医体检 AI 提示词模板';

-- 九种体质项配置：score_direction 平和质越高越好，其余偏颇体质越低越好
INSERT INTO tcm_detection_item_config
  (item_code, vendor_field, item_name, display_name, sort_order, enabled, scale_type, score_direction, prompt_key, remark)
VALUES
  ('pinghe', 'pinghe', '平和质', '平和', 1, 1, 'constitution', 'higher_better', 'tcm_item_pinghe', '平和体质'),
  ('qixu',   'qixu',   '气虚质', '气虚', 2, 1, 'constitution', 'lower_better',  'tcm_item_qixu',   '气虚体质'),
  ('yangxu', 'yangxu', '阳虚质', '阳虚', 3, 1, 'constitution', 'lower_better',  'tcm_item_yangxu', '阳虚体质'),
  ('yinxu',  'yinxu',  '阴虚质', '阴虚', 4, 1, 'constitution', 'lower_better',  'tcm_item_yinxu',  '阴虚体质'),
  ('tanshi', 'tanshi', '痰湿质', '痰湿', 5, 1, 'constitution', 'lower_better',  'tcm_item_tanshi', '痰湿体质'),
  ('shire',  'shire',  '湿热质', '湿热', 6, 1, 'constitution', 'lower_better',  'tcm_item_shire',  '湿热体质'),
  ('xueyu',  'xueyu',  '血瘀质', '血瘀', 7, 1, 'constitution', 'lower_better',  'tcm_item_xueyu',  '血瘀体质'),
  ('qiyu',   'qiyu',   '气郁质', '气郁', 8, 1, 'constitution', 'lower_better',  'tcm_item_qiyu',   '气郁体质'),
  ('tebing', 'tebing', '特禀质', '特禀', 9, 1, 'constitution', 'lower_better',  'tcm_item_tebing', '特禀（过敏）体质')
ON DUPLICATE KEY UPDATE
  vendor_field = VALUES(vendor_field),
  item_name = VALUES(item_name),
  display_name = VALUES(display_name),
  sort_order = VALUES(sort_order),
  scale_type = VALUES(scale_type),
  score_direction = VALUES(score_direction),
  prompt_key = VALUES(prompt_key),
  remark = VALUES(remark);

-- 综合健康报告提示词
INSERT INTO tcm_detection_ai_prompt_template
  (prompt_key, prompt_type, item_code, prompt_name, template_content, output_schema, model, temperature, status, remark)
VALUES
  ('tcm_overall_report', 'overall', NULL, '中医综合健康报告提示词',
'你是一名严谨克制的中医体质调理分析助手。请基于用户的舌面诊体质检测结构化数据，生成一份面向普通用户的中医健康报告。

要求：
1. 只根据输入数据分析，不要编造不存在的检测项、数值或疾病诊断。
2. 不做西医疾病诊断，不开具处方药物。
3. 不使用 Markdown，不输出任何解释性前后缀，只返回合法 JSON。
4. 语言通俗、温和，强调日常养生与生活方式调理。
5. 数据不足时使用“根据当前检测数据”这类保守表达。

用户信息：
{{userProfileText}}

体质检测概览：
{{itemsFactsText}}

请严格按以下 JSON 返回：
{
  "overallConclusion": "整体体质总结，80字以内",
  "constitutionPrimary": "主体质名称，如 平和质",
  "healthSummary": "综合分析，150字以内",
  "keyConstitutions": [
    {"itemCode": "体质编码", "itemName": "体质名称", "score": 0, "levelText": "倾向程度", "summary": "该体质概括，60字以内"}
  ],
  "carePrinciples": ["调理原则1", "调理原则2", "调理原则3"],
  "dietAdvice": "饮食建议，100字以内",
  "lifestyleAdvice": "起居/运动/情志建议，100字以内",
  "serviceGuide": "引导联系客服定制调理方案，80字以内"
}',
  JSON_OBJECT('overallConclusion','string','constitutionPrimary','string','healthSummary','string','keyConstitutions','array','carePrinciples','array','dietAdvice','string','lifestyleAdvice','string','serviceGuide','string'),
  'deepseek-chat', 0.30, 1, '综合报告默认模板'),

  ('tcm_item_pinghe', 'item', 'pinghe', '平和质分析提示词',
'你是一名严谨克制的中医体质调理分析助手。请基于“平和质”的体质检测数据生成分项分析。
要求：只依据输入数据，不编造数值；不做疾病诊断；不开具处方药物；不使用 Markdown；只返回合法 JSON；语言面向普通用户，强调养生而非治疗。
检测数据：
{{itemFactsText}}
请严格返回：
{"itemCode":"pinghe","itemName":"平和质","conclusion":"一句话总结，60字以内","reason":"成因/常见表现，120字以内","careAdvice":"调理建议（饮食/起居/运动/情志），160字以内","riskTips":["注意点1","注意点2","注意点3"]}',
  JSON_OBJECT('itemCode','pinghe','itemName','平和质','conclusion','string','reason','string','careAdvice','string','riskTips','array'),
  'deepseek-chat', 0.30, 1, '平和质分项默认模板'),

  ('tcm_item_qixu', 'item', 'qixu', '气虚质分析提示词',
'你是一名严谨克制的中医体质调理分析助手。请基于“气虚质”的体质检测数据生成分项分析。
要求：只依据输入数据，不编造数值；不做疾病诊断；不开具处方药物；不使用 Markdown；只返回合法 JSON；语言面向普通用户，强调养生而非治疗。
检测数据：
{{itemFactsText}}
请严格返回：
{"itemCode":"qixu","itemName":"气虚质","conclusion":"一句话总结，60字以内","reason":"成因/常见表现，120字以内","careAdvice":"调理建议（饮食/起居/运动/情志），160字以内","riskTips":["注意点1","注意点2","注意点3"]}',
  JSON_OBJECT('itemCode','qixu','itemName','气虚质','conclusion','string','reason','string','careAdvice','string','riskTips','array'),
  'deepseek-chat', 0.30, 1, '气虚质分项默认模板'),

  ('tcm_item_yangxu', 'item', 'yangxu', '阳虚质分析提示词',
'你是一名严谨克制的中医体质调理分析助手。请基于“阳虚质”的体质检测数据生成分项分析。
要求：只依据输入数据，不编造数值；不做疾病诊断；不开具处方药物；不使用 Markdown；只返回合法 JSON；语言面向普通用户，强调养生而非治疗。
检测数据：
{{itemFactsText}}
请严格返回：
{"itemCode":"yangxu","itemName":"阳虚质","conclusion":"一句话总结，60字以内","reason":"成因/常见表现，120字以内","careAdvice":"调理建议（饮食/起居/运动/情志），160字以内","riskTips":["注意点1","注意点2","注意点3"]}',
  JSON_OBJECT('itemCode','yangxu','itemName','阳虚质','conclusion','string','reason','string','careAdvice','string','riskTips','array'),
  'deepseek-chat', 0.30, 1, '阳虚质分项默认模板'),

  ('tcm_item_yinxu', 'item', 'yinxu', '阴虚质分析提示词',
'你是一名严谨克制的中医体质调理分析助手。请基于“阴虚质”的体质检测数据生成分项分析。
要求：只依据输入数据，不编造数值；不做疾病诊断；不开具处方药物；不使用 Markdown；只返回合法 JSON；语言面向普通用户，强调养生而非治疗。
检测数据：
{{itemFactsText}}
请严格返回：
{"itemCode":"yinxu","itemName":"阴虚质","conclusion":"一句话总结，60字以内","reason":"成因/常见表现，120字以内","careAdvice":"调理建议（饮食/起居/运动/情志），160字以内","riskTips":["注意点1","注意点2","注意点3"]}',
  JSON_OBJECT('itemCode','yinxu','itemName','阴虚质','conclusion','string','reason','string','careAdvice','string','riskTips','array'),
  'deepseek-chat', 0.30, 1, '阴虚质分项默认模板'),

  ('tcm_item_tanshi', 'item', 'tanshi', '痰湿质分析提示词',
'你是一名严谨克制的中医体质调理分析助手。请基于“痰湿质”的体质检测数据生成分项分析。
要求：只依据输入数据，不编造数值；不做疾病诊断；不开具处方药物；不使用 Markdown；只返回合法 JSON；语言面向普通用户，强调养生而非治疗。
检测数据：
{{itemFactsText}}
请严格返回：
{"itemCode":"tanshi","itemName":"痰湿质","conclusion":"一句话总结，60字以内","reason":"成因/常见表现，120字以内","careAdvice":"调理建议（饮食/起居/运动/情志），160字以内","riskTips":["注意点1","注意点2","注意点3"]}',
  JSON_OBJECT('itemCode','tanshi','itemName','痰湿质','conclusion','string','reason','string','careAdvice','string','riskTips','array'),
  'deepseek-chat', 0.30, 1, '痰湿质分项默认模板'),

  ('tcm_item_shire', 'item', 'shire', '湿热质分析提示词',
'你是一名严谨克制的中医体质调理分析助手。请基于“湿热质”的体质检测数据生成分项分析。
要求：只依据输入数据，不编造数值；不做疾病诊断；不开具处方药物；不使用 Markdown；只返回合法 JSON；语言面向普通用户，强调养生而非治疗。
检测数据：
{{itemFactsText}}
请严格返回：
{"itemCode":"shire","itemName":"湿热质","conclusion":"一句话总结，60字以内","reason":"成因/常见表现，120字以内","careAdvice":"调理建议（饮食/起居/运动/情志），160字以内","riskTips":["注意点1","注意点2","注意点3"]}',
  JSON_OBJECT('itemCode','shire','itemName','湿热质','conclusion','string','reason','string','careAdvice','string','riskTips','array'),
  'deepseek-chat', 0.30, 1, '湿热质分项默认模板'),

  ('tcm_item_xueyu', 'item', 'xueyu', '血瘀质分析提示词',
'你是一名严谨克制的中医体质调理分析助手。请基于“血瘀质”的体质检测数据生成分项分析。
要求：只依据输入数据，不编造数值；不做疾病诊断；不开具处方药物；不使用 Markdown；只返回合法 JSON；语言面向普通用户，强调养生而非治疗。
检测数据：
{{itemFactsText}}
请严格返回：
{"itemCode":"xueyu","itemName":"血瘀质","conclusion":"一句话总结，60字以内","reason":"成因/常见表现，120字以内","careAdvice":"调理建议（饮食/起居/运动/情志），160字以内","riskTips":["注意点1","注意点2","注意点3"]}',
  JSON_OBJECT('itemCode','xueyu','itemName','血瘀质','conclusion','string','reason','string','careAdvice','string','riskTips','array'),
  'deepseek-chat', 0.30, 1, '血瘀质分项默认模板'),

  ('tcm_item_qiyu', 'item', 'qiyu', '气郁质分析提示词',
'你是一名严谨克制的中医体质调理分析助手。请基于“气郁质”的体质检测数据生成分项分析。
要求：只依据输入数据，不编造数值；不做疾病诊断；不开具处方药物；不使用 Markdown；只返回合法 JSON；语言面向普通用户，强调养生而非治疗。
检测数据：
{{itemFactsText}}
请严格返回：
{"itemCode":"qiyu","itemName":"气郁质","conclusion":"一句话总结，60字以内","reason":"成因/常见表现，120字以内","careAdvice":"调理建议（饮食/起居/运动/情志），160字以内","riskTips":["注意点1","注意点2","注意点3"]}',
  JSON_OBJECT('itemCode','qiyu','itemName','气郁质','conclusion','string','reason','string','careAdvice','string','riskTips','array'),
  'deepseek-chat', 0.30, 1, '气郁质分项默认模板'),

  ('tcm_item_tebing', 'item', 'tebing', '特禀质分析提示词',
'你是一名严谨克制的中医体质调理分析助手。请基于“特禀质（过敏体质）”的体质检测数据生成分项分析。
要求：只依据输入数据，不编造数值；不做疾病诊断；不开具处方药物；不使用 Markdown；只返回合法 JSON；语言面向普通用户，强调养生而非治疗。
检测数据：
{{itemFactsText}}
请严格返回：
{"itemCode":"tebing","itemName":"特禀质","conclusion":"一句话总结，60字以内","reason":"成因/常见表现，120字以内","careAdvice":"调理建议（饮食/起居/运动/情志），160字以内","riskTips":["注意点1","注意点2","注意点3"]}',
  JSON_OBJECT('itemCode','tebing','itemName','特禀质','conclusion','string','reason','string','careAdvice','string','riskTips','array'),
  'deepseek-chat', 0.30, 1, '特禀质分项默认模板')
ON DUPLICATE KEY UPDATE
  prompt_type = VALUES(prompt_type),
  item_code = VALUES(item_code),
  prompt_name = VALUES(prompt_name),
  output_schema = VALUES(output_schema),
  model = VALUES(model),
  temperature = VALUES(temperature),
  status = VALUES(status),
  remark = VALUES(remark);

-- 系统配置：中医体检白名单限制开关（默认 1=开启限制）
INSERT INTO system_config (config_key, config_value, remark)
VALUES ('tcm_detection_whitelist_enabled', '1', '中医体检白名单限制开关：1=开启限制 0=关闭限制')
ON DUPLICATE KEY UPDATE
  remark = VALUES(remark),
  updated_at = CURRENT_TIMESTAMP;
