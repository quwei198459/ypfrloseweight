package com.ypfr.loseweight.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ypfr.loseweight.domain.SkinDetectionAiPromptTemplate;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
public class SkinDetectionAiFactBuilder {

  private final ObjectMapper objectMapper;
  private final SkinDetectionAiPromptTemplateService promptTemplateService;

  public SkinDetectionAiFactBuilder(
      ObjectMapper objectMapper, SkinDetectionAiPromptTemplateService promptTemplateService) {
    this.objectMapper = objectMapper;
    this.promptTemplateService = promptTemplateService;
  }

  public String buildOverallPrompt(SkinDetectionAiPromptTemplate template, ParsedSkinDetectionResult result) {
    String content = template == null ? "" : template.getTemplateContent();
    Map<String, String> variables = new LinkedHashMap<>();
    variables.put("userProfileText", "本次检测暂未传入完整用户画像，仅基于检测数据生成护肤参考。");
    variables.put("itemsFactsText", buildItemsFactsText(result));
    return promptTemplateService.render(content, variables);
  }

  public String buildItemPrompt(SkinDetectionAiPromptTemplate template, ParsedSkinDetectionItem item) {
    String content = template == null ? "" : template.getTemplateContent();
    Map<String, String> variables = new LinkedHashMap<>();
    variables.put("itemFactsText", buildItemFactsText(item));
    return promptTemplateService.render(content, variables);
  }

  public String buildItemsFactsText(ParsedSkinDetectionResult result) {
    StringBuilder sb = new StringBuilder();
    sb.append("综合分：").append(value(result.getOverallScore())).append("\n");
    for (ParsedSkinDetectionItem item : result.getItems()) {
      sb.append("- ").append(item.getItemName())
          .append("（").append(item.getItemCode()).append("）：")
          .append("分数=").append(value(item.getScore()))
          .append("，程度=").append(levelText(item.getLevel()))
          .append("，分档类型=").append(value(item.getScaleType()))
          .append("\n");
    }
    return sb.toString();
  }

  public String buildItemFactsText(ParsedSkinDetectionItem item) {
    StringBuilder sb = new StringBuilder();
    sb.append("检测项：").append(item.getItemName()).append("\n");
    sb.append("检测项编码：").append(item.getItemCode()).append("\n");
    sb.append("分数：").append(value(item.getScore())).append("\n");
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
      appendMetric(sb, root, "count", "数量");
      appendMetric(sb, root, "area", "面积占比");
      appendMetric(sb, root, "score", "接口分数");
      appendMetric(sb, root, "type", "类型");
      JsonNode category = root.path("category");
      if (category.isArray() && category.size() > 0) {
        sb.append("分类指标：");
        for (JsonNode node : category) {
          String cls = firstText(node, "cls", "class", "type", "name");
          String count = firstText(node, "count");
          String score = firstText(node, "score");
          String level = firstText(node, "level");
          sb.append("[类别=").append(value(cls))
              .append("，数量=").append(value(count))
              .append("，分数=").append(value(score))
              .append("，程度=").append(levelText(level))
              .append("]");
        }
        sb.append("\n");
      }
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

  private String firstText(JsonNode node, String... names) {
    for (String name : names) {
      JsonNode value = node.get(name);
      if (value != null && !value.isNull() && StringUtils.hasText(value.asText())) {
        return value.asText();
      }
    }
    return null;
  }

  public static String levelText(String level) {
    if (!StringUtils.hasText(level)) {
      return "未知";
    }
    return switch (level.trim()) {
      case "severe" -> "严重";
      case "moderately" -> "中度";
      case "lightly" -> "轻度";
      case "none" -> "无明显问题";
      case "oil" -> "油性";
      case "dry" -> "干性";
      case "mid" -> "中性";
      case "mix" -> "混合性";
      case "mid_oil" -> "中性偏油";
      case "mid_dry" -> "中性偏干";
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
