package com.ypfr.loseweight.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.ypfr.loseweight.common.ApiException;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

/**
 * 解析脉景 macrocura（cmapi00066970）返回。
 * api1 create → {@link ParsedTcmCreate}（session_id + inquiry_questions）；
 * api2 report → {@link ParsedTcmDetectionResult}（score/physique_name/features + 打包报告）。
 */
@Component
public class TcmDetectionResultParser {

  private final ObjectMapper objectMapper;

  public TcmDetectionResultParser(ObjectMapper objectMapper) {
    this.objectMapper = objectMapper;
  }

  public ParsedTcmCreate parseCreate(String rawJson) {
    JsonNode root = readTree(rawJson);
    requireVendorSuccess(root);
    JsonNode data = root.path("data");
    ParsedTcmCreate result = new ParsedTcmCreate();
    result.setSessionId(text(data, "session_id", "sessionId"));
    if (!StringUtils.hasText(result.getSessionId())) {
      throw new ApiException(4801, "舌面诊创建未返回 session_id");
    }
    JsonNode questions = data.path("inquiry_questions");
    if (questions.isArray()) {
      for (JsonNode q : questions) {
        String name = text(q, "name");
        String value = text(q, "value");
        if (StringUtils.hasText(name)) {
          result.getQuestions().add(new ParsedTcmCreate.Question(name, value));
        }
      }
    }
    return result;
  }

  public ParsedTcmDetectionResult parseReport(String rawJson, Integer gender) {
    JsonNode root = readTree(rawJson);
    requireVendorSuccess(root);
    JsonNode data = root.path("data");

    List<ParsedTcmDetectionItem> items = new ArrayList<>();
    JsonNode features = data.path("features");
    int index = 0;
    if (features.isArray()) {
      for (JsonNode f : features) {
        index++;
        String category = text(f, "feature_category");
        String group = text(f, "feature_group");
        String name = text(f, "feature_name");
        String situation = text(f, "feature_situation");
        String interpret = text(f, "feature_interpret");
        ParsedTcmDetectionItem item = new ParsedTcmDetectionItem();
        item.setItemCode(codePrefix(category) + "_" + index);
        item.setItemName(StringUtils.hasText(name) ? name : group);
        item.setLevel(situation);
        item.setResultText(interpret);
        item.setScaleType(category);
        item.setSortOrder(index);
        item.setMetricsJson(metricsJson(group, name, situation, category));
        items.add(item);
      }
    }

    ParsedTcmDetectionResult result = new ParsedTcmDetectionResult();
    result.setItems(items);
    result.setConstitutionPrimary(text(data, "physique_name"));
    result.setOverallScore(roundScore(data.path("score")));
    result.setConstitutionJson(buildReportJson(data, gender));
    result.setThirdPartyId(text(root, "log_id"));
    return result;
  }

  private String buildReportJson(JsonNode data, Integer gender) {
    ObjectNode report = objectMapper.createObjectNode();
    report.put("physiqueName", text(data, "physique_name"));
    report.put("physiqueAnalysis", text(data, "physique_analysis"));
    report.put("typicalSymptom", stripOppositeGender(text(data, "typical_symptom"), gender, "；"));
    report.put("riskWarning", stripOppositeGender(text(data, "risk_warning"), gender, "\n"));
    report.put("syndromeName", text(data, "syndrome_name"));
    report.put("syndromeIntroduction", text(data, "syndrome_introduction"));
    if (data.has("advices") && !data.path("advices").isNull()) {
      report.set("advices", data.path("advices"));
    }
    if (data.has("goods") && !data.path("goods").isNull()) {
      report.set("goods", data.path("goods"));
    }
    JsonNode tf = data.path("tf_detect_matches");
    if (tf.isObject()) {
      report.put("annotatedTongueUrl", text(tf, "url"));
    }
    try {
      return objectMapper.writeValueAsString(report);
    } catch (Exception e) {
      return "{}";
    }
  }

  // 按性别过滤异性专属内容（脉景 risk_warning/typical_symptom/问诊题 不分性别返回）
  private static final java.util.List<String> FEMALE_KEYWORDS =
      java.util.List.of(
          "女性", "月经", "痛经", "经量", "经色", "经期", "经血", "行经", "闭经", "崩漏", "带下", "白带", "经带",
          "妊娠", "怀孕", "孕", "胎", "产后", "外阴", "阴道", "子宫", "宫颈", "卵巢", "乳腺", "乳房", "妇科");
  private static final java.util.List<String> MALE_KEYWORDS =
      java.util.List.of(
          "男性", "阴囊", "睾丸", "前列腺", "遗精", "阳痿", "早泄", "龟头", "包皮", "精液", "精子", "勃起");

  /** 文本是否含与该性别相反的专属词：gender=1(男)→女性词，gender=2(女)→男性词。 */
  public boolean isOppositeGenderText(String text, Integer gender) {
    if (!StringUtils.hasText(text) || gender == null) {
      return false;
    }
    if (gender == 1) {
      return FEMALE_KEYWORDS.stream().anyMatch(text::contains);
    }
    if (gender == 2) {
      return MALE_KEYWORDS.stream().anyMatch(text::contains);
    }
    return false;
  }

  /** 按分隔符拆分，剔除含异性专属词的片段；gender 非 1/2 时原样返回。 */
  private String stripOppositeGender(String text, Integer gender, String delimiter) {
    if (!StringUtils.hasText(text) || gender == null || (gender != 1 && gender != 2)) {
      return text;
    }
    String[] parts = text.split(java.util.regex.Pattern.quote(delimiter));
    StringBuilder sb = new StringBuilder();
    for (String part : parts) {
      if (isOppositeGenderText(part, gender)) {
        continue;
      }
      if (sb.length() > 0) {
        sb.append(delimiter);
      }
      sb.append(part);
    }
    return sb.toString();
  }

  private void requireVendorSuccess(JsonNode root) {
    JsonNode codeNode = root.path("code");
    boolean success = root.path("success").asBoolean(true);
    int code = codeNode.isNumber() ? codeNode.asInt() : 20000;
    if (!success || (code != 20000 && code != 0 && code != 200)) {
      String msg = text(root, "msg", "message", "reason");
      throw new ApiException(4801, StringUtils.hasText(msg) ? msg : ("中医体检接口返回错误：" + code));
    }
  }

  private String metricsJson(String group, String name, String situation, String category) {
    ObjectNode node = objectMapper.createObjectNode();
    node.put("group", group);
    node.put("featureName", name);
    node.put("situation", situation);
    node.put("category", category);
    try {
      return objectMapper.writeValueAsString(node);
    } catch (Exception e) {
      return "{}";
    }
  }

  private Integer roundScore(JsonNode scoreNode) {
    if (scoreNode == null || scoreNode.isMissingNode() || scoreNode.isNull()) {
      return null;
    }
    if (scoreNode.isNumber()) {
      return (int) Math.round(scoreNode.asDouble());
    }
    if (scoreNode.isTextual()) {
      try {
        return (int) Math.round(Double.parseDouble(scoreNode.asText().trim()));
      } catch (NumberFormatException ignored) {
        return null;
      }
    }
    return null;
  }

  private static String codePrefix(String category) {
    if ("面部".equals(category)) {
      return "face";
    }
    if ("舌部".equals(category)) {
      return "tongue";
    }
    return "feat";
  }

  private JsonNode readTree(String rawJson) {
    try {
      return objectMapper.readTree(rawJson);
    } catch (Exception e) {
      throw new ApiException(4801, "解析中医体检结果失败");
    }
  }

  private static String text(JsonNode node, String... names) {
    if (node == null) {
      return null;
    }
    for (String name : names) {
      JsonNode value = node.get(name);
      if (value != null && value.isValueNode() && StringUtils.hasText(value.asText())) {
        return value.asText();
      }
    }
    return null;
  }
}
