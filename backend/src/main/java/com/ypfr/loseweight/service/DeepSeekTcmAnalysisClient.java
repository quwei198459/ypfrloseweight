package com.ypfr.loseweight.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ypfr.loseweight.config.TcmDetectionProperties;
import com.ypfr.loseweight.domain.TcmDetectionAiPromptTemplate;
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
public class DeepSeekTcmAnalysisClient {

  private final RestTemplate restTemplate;
  private final TcmDetectionProperties properties;
  private final ObjectMapper objectMapper;
  private final TcmDetectionAiPromptTemplateService promptTemplateService;
  private final TcmDetectionAiFactBuilder factBuilder;

  public DeepSeekTcmAnalysisClient(
      RestTemplate restTemplate,
      TcmDetectionProperties properties,
      ObjectMapper objectMapper,
      TcmDetectionAiPromptTemplateService promptTemplateService,
      TcmDetectionAiFactBuilder factBuilder) {
    this.restTemplate = restTemplate;
    this.properties = properties;
    this.objectMapper = objectMapper;
    this.promptTemplateService = promptTemplateService;
    this.factBuilder = factBuilder;
  }

  public DeepSeekTcmAnalysisResult analyze(ParsedTcmDetectionResult result) {
    DeepSeekTcmAnalysisResult output = new DeepSeekTcmAnalysisResult();
    TcmDetectionAiPromptTemplate overallTemplate = promptTemplateService.findOverallTemplate();
    output.setOverall(analyzeOverall(result, overallTemplate));

    Map<String, TcmDetectionAiPromptTemplate> itemTemplates = promptTemplateService.listEnabledItemTemplatesByItemCode();
    List<DeepSeekItemAnalysisResult> itemResults = new ArrayList<>();
    for (ParsedTcmDetectionItem item : result.getItems()) {
      TcmDetectionAiPromptTemplate template = itemTemplates.get(item.getItemCode());
      itemResults.add(analyzeItem(item, template));
    }
    output.setItems(itemResults);
    return output;
  }

  /** 仅在厂商报告之上生成一段综合总结（不做逐特征 AI，避免过多调用）。 */
  public DeepSeekAnalysisResult summarize(ParsedTcmDetectionResult result) {
    return analyzeOverall(result, promptTemplateService.findOverallTemplate());
  }

  public DeepSeekAnalysisResult analyzeOverall(
      ParsedTcmDetectionResult result,
      TcmDetectionAiPromptTemplate template) {
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
      ParsedTcmDetectionItem item,
      TcmDetectionAiPromptTemplate template) {
    String fallbackConclusion = item.getItemName() + "倾向分值为" + (item.getScore() == null ? "--" : item.getScore()) + "。";
    String fallbackReason = "根据当前检测数据，" + item.getItemName() + "情况需要结合饮食、起居、运动和情志等日常习惯综合判断。";
    String fallbackAdvice = "建议顺应该体质特点调整饮食起居，规律作息、适度运动，如需更细致的调理方案，可联系客服定制。";
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

  private ChatCallResult callDeepSeek(TcmDetectionAiPromptTemplate template, String prompt) {
    String url = properties.getDeepseekBaseUrl().replaceAll("/$", "") + "/chat/completions";
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(new MediaType("application", "json", StandardCharsets.UTF_8));
    headers.setBearerAuth(properties.getDeepseekApiKey().trim());
    Map<String, Object> payload = new LinkedHashMap<>();
    payload.put("model", firstNonBlank(template.getModel(), "deepseek-chat"));
    payload.put("messages", List.of(
        Map.of("role", "system", "content", "你是一名中医体质健康报告分析助手，请严格按用户要求返回合法 JSON。"),
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
      return firstNonBlank(firstText(root, "overallConclusion", "healthSummary"), fallback);
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
    return value == null ? 0.3 : value.doubleValue();
  }

  private String fallbackSummary(ParsedTcmDetectionResult result) {
    String primary = StringUtils.hasText(result.getConstitutionPrimary()) ? result.getConstitutionPrimary() : "暂未明确主体质";
    return "本次中医体检综合健康分为" + (result.getOverallScore() == null ? "--" : result.getOverallScore())
        + "，主体质倾向为" + primary + "。建议结合日常饮食、起居、运动与情志进行针对性调理。"
        + "如需更细致的调理方案，可联系客服进行一对一咨询。";
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
