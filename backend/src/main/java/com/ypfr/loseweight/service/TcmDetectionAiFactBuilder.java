package com.ypfr.loseweight.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ypfr.loseweight.domain.TcmDetectionAiPromptTemplate;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
public class TcmDetectionAiFactBuilder {

  private final ObjectMapper objectMapper;
  private final TcmDetectionAiPromptTemplateService promptTemplateService;

  public TcmDetectionAiFactBuilder(
      ObjectMapper objectMapper, TcmDetectionAiPromptTemplateService promptTemplateService) {
    this.objectMapper = objectMapper;
    this.promptTemplateService = promptTemplateService;
  }

  public String buildOverallPrompt(TcmDetectionAiPromptTemplate template, ParsedTcmDetectionResult result) {
    String content = template == null ? "" : template.getTemplateContent();
    Map<String, String> variables = new LinkedHashMap<>();
    variables.put("userProfileText", "本次检测暂未传入完整用户画像，仅基于体质检测数据生成养生调理参考。");
    variables.put("itemsFactsText", buildItemsFactsText(result));
    return promptTemplateService.render(content, variables);
  }

  public String buildItemPrompt(TcmDetectionAiPromptTemplate template, ParsedTcmDetectionItem item) {
    String content = template == null ? "" : template.getTemplateContent();
    Map<String, String> variables = new LinkedHashMap<>();
    variables.put("itemFactsText", buildItemFactsText(item));
    return promptTemplateService.render(content, variables);
  }

  public String buildItemsFactsText(ParsedTcmDetectionResult result) {
    StringBuilder sb = new StringBuilder();
    sb.append("综合健康分：").append(value(result.getOverallScore())).append("\n");
    sb.append("主体质：").append(value(result.getConstitutionPrimary())).append("\n");
    appendReportFacts(sb, result.getConstitutionJson());
    sb.append("望诊特征：\n");
    for (ParsedTcmDetectionItem item : result.getItems()) {
      sb.append("- ").append(value(item.getScaleType()))
          .append("/").append(value(item.getItemName()))
          .append("（").append(value(item.getLevel())).append("）：")
          .append(value(item.getResultText()))
          .append("\n");
    }
    return sb.toString();
  }

  private void appendReportFacts(StringBuilder sb, String reportJson) {
    if (!StringUtils.hasText(reportJson)) {
      return;
    }
    try {
      JsonNode root = objectMapper.readTree(reportJson);
      appendMetric(sb, root, "physiqueAnalysis", "体质分析");
      appendMetric(sb, root, "typicalSymptom", "典型症状");
      appendMetric(sb, root, "syndromeName", "证型");
    } catch (Exception ignored) {
      // 解析失败则仅基于望诊特征生成
    }
  }

  public String buildItemFactsText(ParsedTcmDetectionItem item) {
    StringBuilder sb = new StringBuilder();
    sb.append("体质项：").append(item.getItemName()).append("\n");
    sb.append("体质编码：").append(item.getItemCode()).append("\n");
    sb.append("分数/倾向：").append(value(item.getScore())).append("\n");
    sb.append("接口程度：").append(value(item.getLevel())).append("\n");
    sb.append("程度中文：").append(levelText(item.getLevel())).append("\n");
    sb.append("分档类型：").append(value(item.getScaleType())).append("\n");
    if (StringUtils.hasText(item.getResultText())) {
      sb.append("接口说明：").append(item.getResultText()).append("\n");
    }
    appendMetricsFacts(sb, item.getMetricsJson());
    return sb.toString();
  }

  private void appendMetricsFacts(StringBuilder sb, String metricsJson) {
    if (!StringUtils.hasText(metricsJson)) {
      return;
    }
    try {
      JsonNode root = objectMapper.readTree(metricsJson);
      appendMetric(sb, root, "score", "接口分数");
      appendMetric(sb, root, "level", "倾向程度");
      appendMetric(sb, root, "tongueColor", "舌色");
      appendMetric(sb, root, "tongueCoating", "苔质");
      appendMetric(sb, root, "faceColor", "面色");
      appendMetric(sb, root, "desc", "接口描述");
    } catch (Exception ignored) {
      sb.append("原始扩展指标：").append(metricsJson).append("\n");
    }
  }

  private void appendMetric(StringBuilder sb, JsonNode root, String key, String label) {
    JsonNode node = root.get(key);
    if (node != null && !node.isNull() && StringUtils.hasText(node.asText())) {
      sb.append(label).append("：").append(node.asText()).append("\n");
    }
  }

  public static String levelText(String level) {
    if (!StringUtils.hasText(level)) {
      return "未知";
    }
    return switch (level.trim()) {
      case "none" -> "无明显倾向";
      case "mild" -> "轻度倾向";
      case "tendency" -> "倾向较明显";
      case "obvious" -> "明显倾向";
      case "basic" -> "体质基础尚可";
      default -> level;
    };
  }

  private static String value(Object value) {
    if (value == null) {
      return "未知";
    }
    String s = String.valueOf(value).trim();
    return s.isEmpty() ? "未知" : s;
  }
}
