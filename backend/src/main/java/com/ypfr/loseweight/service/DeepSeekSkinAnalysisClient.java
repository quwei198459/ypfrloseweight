package com.ypfr.loseweight.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ypfr.loseweight.config.SkinDetectionProperties;
import com.ypfr.loseweight.domain.SkinDetectionAiPromptTemplate;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Component
public class DeepSeekSkinAnalysisClient {

  private final RestTemplate restTemplate;
  private final SkinDetectionProperties properties;
  private final ObjectMapper objectMapper;
  private final SkinDetectionAiPromptTemplateService promptTemplateService;
  private final SkinDetectionAiFactBuilder factBuilder;

  public DeepSeekSkinAnalysisClient(
      RestTemplate restTemplate,
      SkinDetectionProperties properties,
      ObjectMapper objectMapper,
      SkinDetectionAiPromptTemplateService promptTemplateService,
      SkinDetectionAiFactBuilder factBuilder) {
    this.restTemplate = restTemplate;
    this.properties = properties;
    this.objectMapper = objectMapper;
    this.promptTemplateService = promptTemplateService;
    this.factBuilder = factBuilder;
  }

  public DeepSeekSkinAnalysisResult analyze(ParsedSkinDetectionResult result) {
    DeepSeekSkinAnalysisResult output = new DeepSeekSkinAnalysisResult();
    SkinDetectionAiPromptTemplate overallTemplate = promptTemplateService.findOverallTemplate();
    output.setOverall(analyzeOverall(result, overallTemplate));

    Map<String, SkinDetectionAiPromptTemplate> itemTemplates = promptTemplateService.listEnabledItemTemplatesByItemCode();
    List<DeepSeekItemAnalysisResult> itemResults = new ArrayList<>();
    for (ParsedSkinDetectionItem item : result.getItems()) {
      SkinDetectionAiPromptTemplate template = itemTemplates.get(item.getItemCode());
      itemResults.add(analyzeItem(item, template));
    }
    output.setItems(itemResults);
    return output;
  }

  public DeepSeekAnalysisResult analyzeOverall(
      ParsedSkinDetectionResult result,
      SkinDetectionAiPromptTemplate template) {
    String fallback = fallbackSummary(result);
    if (!StringUtils.hasText(properties.getDeepseekApiKey()) || "change-me".equals(properties.getDeepseekApiKey())) {
      return DeepSeekAnalysisResult.failed(fallback, "未配置 DeepSeek API Key");
    }
    if (template == null || !StringUtils.hasText(template.getTemplateContent())) {
      return DeepSeekAnalysisResult.failed(fallback, "未配置综合报告提示词模板");
    }
    String prompt = factBuilder.buildOverallPrompt(template, result);
    ChatCallResult call = callDeepSeek(template, prompt);
    if (!call.success()) {
      return DeepSeekAnalysisResult.failed(fallback, call.error());
    }
    String json = extractJson(call.content());
    if (!StringUtils.hasText(json)) {
      return DeepSeekAnalysisResult.failed(fallback, "DeepSeek 综合报告未返回 JSON");
    }
    String summary = extractOverallSummary(json, fallback);
    return DeepSeekAnalysisResult.success(summary, json);
  }

  public DeepSeekItemAnalysisResult analyzeItem(
      ParsedSkinDetectionItem item,
      SkinDetectionAiPromptTemplate template) {
    String fallbackConclusion = item.getItemName() + "评分为" + (item.getScore() == null ? "--" : item.getScore()) + "分。";
    String fallbackReason = "根据当前检测数据，" + item.getItemName() + "情况需要结合日常清洁、保湿、防晒和作息习惯综合判断。";
    String fallbackAdvice = "建议保持温和清洁，做好基础保湿和防晒，如需更细致的产品搭配与用量建议，可联系客服定制方案。";
    if (!StringUtils.hasText(properties.getDeepseekApiKey()) || "change-me".equals(properties.getDeepseekApiKey())) {
      return DeepSeekItemAnalysisResult.failed(item.getItemCode(), fallbackConclusion, fallbackReason, fallbackAdvice, "未配置 DeepSeek API Key");
    }
    if (template == null || !StringUtils.hasText(template.getTemplateContent())) {
      return DeepSeekItemAnalysisResult.failed(item.getItemCode(), fallbackConclusion, fallbackReason, fallbackAdvice, "未配置分项提示词模板");
    }
    String prompt = factBuilder.buildItemPrompt(template, item);
    ChatCallResult call = callDeepSeek(template, prompt);
    if (!call.success()) {
      return DeepSeekItemAnalysisResult.failed(item.getItemCode(), fallbackConclusion, fallbackReason, fallbackAdvice, call.error());
    }
    String json = extractJson(call.content());
    if (!StringUtils.hasText(json)) {
      return DeepSeekItemAnalysisResult.failed(item.getItemCode(), fallbackConclusion, fallbackReason, fallbackAdvice, "DeepSeek 分项未返回 JSON");
    }
    try {
      JsonNode root = objectMapper.readTree(json);
      String conclusion = firstText(root, "conclusion", "summary");
      String reason = firstText(root, "reason", "cause");
      String careAdvice = firstText(root, "careAdvice", "advice");
      return DeepSeekItemAnalysisResult.success(
          item.getItemCode(),
          firstNonBlank(conclusion, fallbackConclusion),
          firstNonBlank(reason, fallbackReason),
          firstNonBlank(careAdvice, fallbackAdvice),
          json);
    } catch (Exception e) {
      return DeepSeekItemAnalysisResult.failed(item.getItemCode(), fallbackConclusion, fallbackReason, fallbackAdvice, "DeepSeek 分项 JSON 解析失败");
    }
  }

  private ChatCallResult callDeepSeek(SkinDetectionAiPromptTemplate template, String prompt) {
    String url = properties.getDeepseekBaseUrl().replaceAll("/$", "") + "/chat/completions";
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(new MediaType("application", "json", StandardCharsets.UTF_8));
    headers.setBearerAuth(properties.getDeepseekApiKey().trim());
    Map<String, Object> payload = new LinkedHashMap<>();
    payload.put("model", firstNonBlank(template.getModel(), "deepseek-chat"));
    payload.put("messages", List.of(
        Map.of("role", "system", "content", "你是一名皮肤检测报告分析助手，请严格按用户要求返回合法 JSON。"),
        Map.of("role", "user", "content", prompt)));
    payload.put("temperature", temperature(template.getTemperature()));
    try {
      ResponseEntity<String> response = restTemplate.postForEntity(url, new HttpEntity<>(payload, headers), String.class);
      String body = response.getBody();
      if (!response.getStatusCode().is2xxSuccessful() || !StringUtils.hasText(body)) {
        return ChatCallResult.failed("DeepSeek 返回异常");
      }
      String content = extractContent(body);
      if (!StringUtils.hasText(content)) {
        return ChatCallResult.failed("DeepSeek 内容为空");
      }
      return ChatCallResult.success(content);
    } catch (RestClientException e) {
      return ChatCallResult.failed("DeepSeek 调用失败");
    }
  }

  private String extractContent(String body) {
    try {
      JsonNode root = objectMapper.readTree(body);
      JsonNode choices = root.path("choices");
      if (choices.isArray() && choices.size() > 0) {
        return choices.get(0).path("message").path("content").asText(null);
      }
    } catch (Exception ignored) {
      return null;
    }
    return null;
  }

  private String extractJson(String content) {
    if (!StringUtils.hasText(content)) {
      return null;
    }
    String trimmed = content.trim();
    if (trimmed.startsWith("```") ) {
      trimmed = trimmed.replaceFirst("^```(?:json)?", "").replaceFirst("```$", "").trim();
    }
    int start = trimmed.indexOf('{');
    int end = trimmed.lastIndexOf('}');
    if (start >= 0 && end > start) {
      return trimmed.substring(start, end + 1);
    }
    return null;
  }

  private String extractOverallSummary(String json, String fallback) {
    try {
      JsonNode root = objectMapper.readTree(json);
      return firstNonBlank(firstText(root, "overallConclusion", "skinSummary"), fallback);
    } catch (Exception e) {
      return fallback;
    }
  }

  private String firstText(JsonNode node, String... names) {
    for (String name : names) {
      JsonNode value = node.get(name);
      if (value != null && value.isValueNode() && StringUtils.hasText(value.asText())) {
        return value.asText();
      }
    }
    return null;
  }

  private double temperature(BigDecimal value) {
    return value == null ? 0.2 : value.doubleValue();
  }

  private String fallbackSummary(ParsedSkinDetectionResult result) {
    List<String> weakItems = new ArrayList<>();
    for (ParsedSkinDetectionItem item : result.getItems()) {
      if (item.getScore() != null && item.getScore() < 70) {
        weakItems.add(item.getItemName());
      }
    }
    String focus = weakItems.isEmpty() ? "整体状态相对稳定，建议继续保持规律清洁、保湿和防晒。" : "需要重点关注" + String.join("、", weakItems) + "，建议结合生活习惯进行针对性护理。";
    return "本次皮肤检测综合分为" + (result.getOverallScore() == null ? "--" : result.getOverallScore()) + "。" + focus + "如需更细致的护肤方案，可联系客服进行一对一咨询。";
  }

  private static String firstNonBlank(String value, String fallback) {
    return StringUtils.hasText(value) ? value : fallback;
  }

  private record ChatCallResult(boolean success, String content, String error) {
    static ChatCallResult success(String content) {
      return new ChatCallResult(true, content, null);
    }

    static ChatCallResult failed(String error) {
      return new ChatCallResult(false, null, error);
    }
  }
}
