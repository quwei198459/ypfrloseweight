package com.ypfr.loseweight.service.photograph;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ypfr.loseweight.service.DeepSeekUsageLogger;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoFoodItemVo;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestTemplate;

/**
 * 用 DeepSeek 根据本餐识别到的食物，生成「个性化建议食用比例 ratio + 一句推荐用语 text」。
 * 复用 DEEPSEEK_API_KEY / DEEPSEEK_BASE_URL；未配置或调用失败时返回 null，调用方回退默认（推荐吃 100%）。
 */
@Service
public class MealPhotoRecommendService {

  private static final Logger log = LoggerFactory.getLogger(MealPhotoRecommendService.class);

  private final RestTemplate restTemplate;
  private final ObjectMapper objectMapper;
  private final DeepSeekUsageLogger usageLogger;
  private final String apiKey;
  private final String baseUrl;

  public MealPhotoRecommendService(
      RestTemplate restTemplate,
      ObjectMapper objectMapper,
      DeepSeekUsageLogger usageLogger,
      @Value("${DEEPSEEK_API_KEY:change-me}") String apiKey,
      @Value("${DEEPSEEK_BASE_URL:https://api.deepseek.com}") String baseUrl) {
    this.restTemplate = restTemplate;
    this.objectMapper = objectMapper;
    this.usageLogger = usageLogger;
    this.apiKey = apiKey;
    this.baseUrl = baseUrl;
  }

  public record Result(double ratio, String text) {}

  public Result recommend(List<MealPhotoFoodItemVo> foods, String mealType) {
    if (foods == null || foods.isEmpty()) {
      return null;
    }
    if (!StringUtils.hasText(apiKey) || "change-me".equals(apiKey)) {
      return null;
    }
    try {
      String url = baseUrl.replaceAll("/$", "") + "/chat/completions";
      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(new MediaType("application", "json", StandardCharsets.UTF_8));
      headers.setBearerAuth(apiKey.trim());
      Map<String, Object> payload = new LinkedHashMap<>();
      payload.put("model", "deepseek-chat");
      payload.put(
          "messages",
          List.of(
              Map.of("role", "system", "content", "你是健康饮食助手，只返回合法 JSON，不要多余文字。"),
              Map.of("role", "user", "content", buildPrompt(foods, mealType))));
      payload.put("temperature", 0.4);
      ResponseEntity<String> resp =
          restTemplate.postForEntity(url, new HttpEntity<>(payload, headers), String.class);
      if (!resp.getStatusCode().is2xxSuccessful() || !StringUtils.hasText(resp.getBody())) {
        return null;
      }
      usageLogger.record("food", mealType == null ? "meal" : mealType, "deepseek-chat", resp.getBody());
      String json = extractJson(extractContent(resp.getBody()));
      if (!StringUtils.hasText(json)) {
        return null;
      }
      JsonNode node = objectMapper.readTree(json);
      double ratio = node.path("ratio").asDouble(1.0);
      if (ratio < 0.1) {
        ratio = 0.1;
      }
      if (ratio > 1.0) {
        ratio = 1.0;
      }
      String text = node.path("text").asText(null);
      if (!StringUtils.hasText(text)) {
        return null;
      }
      return new Result(ratio, text.trim());
    } catch (Exception e) {
      log.warn("DeepSeek 食物推荐失败，回退默认。reason={}", e.getMessage());
      return null;
    }
  }

  private String buildPrompt(List<MealPhotoFoodItemVo> foods, String mealType) {
    StringBuilder sb = new StringBuilder();
    sb.append("本餐次：").append(mealTypeText(mealType)).append("\n识别到的食物：\n");
    int total = 0;
    for (MealPhotoFoodItemVo f : foods) {
      sb.append("- ").append(value(f.getFoodName()));
      if (f.getCalories() != null) {
        sb.append("，约").append(f.getCalories()).append("千卡");
        total += f.getCalories();
      }
      if (f.getGi() != null) {
        sb.append("，GI ").append(f.getGi());
      }
      sb.append("\n");
    }
    sb.append("本餐合计约").append(total).append("千卡。\n");
    sb.append(
        "请据此判断这餐相对一份健康正餐的【建议食用比例 ratio】(0.1~1.0) 和【一句个性化建议 text】(中文，不超过 24 字)。"
            + "高糖/高油/高盐/油炸/甜点/膨化零食应给较低比例并温和提醒适量；正常正餐、蔬菜、水果、优质蛋白可接近 1.0 并正向鼓励。"
            + "语气友好、不要医疗诊断口吻。只返回 JSON：{\"ratio\":0.x,\"text\":\"...\"}");
    return sb.toString();
  }

  private static String mealTypeText(String t) {
    if (t == null) {
      return "正餐";
    }
    return switch (t) {
      case "breakfast" -> "早餐";
      case "lunch" -> "午餐";
      case "dinner" -> "晚餐";
      case "snack" -> "加餐";
      default -> "正餐";
    };
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
    String t = content.trim();
    if (t.startsWith("```")) {
      t = t.replaceFirst("^```(?:json)?", "").replaceFirst("```$", "").trim();
    }
    int s = t.indexOf('{');
    int e = t.lastIndexOf('}');
    return (s >= 0 && e > s) ? t.substring(s, e + 1) : null;
  }

  private static String value(String s) {
    return s == null ? "" : s.trim();
  }
}
