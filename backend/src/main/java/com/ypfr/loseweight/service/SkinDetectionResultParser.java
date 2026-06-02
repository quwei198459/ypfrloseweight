package com.ypfr.loseweight.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.SkinDetectionItemConfig;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
public class SkinDetectionResultParser {

  private static final List<ItemSpec> ITEM_SPECS = List.of(
      new ItemSpec("spot", "斑点", 1),
      new ItemSpec("pore", "毛孔", 2),
      new ItemSpec("skin_type", "肤质", 3),
      new ItemSpec("pockmark", "痘痘", 4),
      new ItemSpec("wrinkle", "皱纹", 5),
      new ItemSpec("blackhead", "黑头", 6));

  private final ObjectMapper objectMapper;
  private final SkinDetectionItemConfigService itemConfigService;

  public SkinDetectionResultParser(ObjectMapper objectMapper, SkinDetectionItemConfigService itemConfigService) {
    this.objectMapper = objectMapper;
    this.itemConfigService = itemConfigService;
  }

  public ParsedSkinDetectionResult parse(String rawJson) {
    try {
      JsonNode root = objectMapper.readTree(rawJson);
      String errorMessage = findErrorMessage(root);
      if (StringUtils.hasText(errorMessage)) {
        throw new ApiException(4701, errorMessage);
      }
      List<ParsedSkinDetectionItem> items = new ArrayList<>();
      for (SkinDetectionItemConfig config : resolveItemConfigs()) {
        JsonNode node = findNodeByFieldName(root, config.getYimeiField());
        ParsedSkinDetectionItem item = toItem(config, node);
        items.add(item);
      }
      ParsedSkinDetectionResult result = new ParsedSkinDetectionResult();
      result.setThirdPartyId(textOfFirst(root, "request_id", "requestId", "task_id", "taskId", "id"));
      result.setItems(items);
      result.setOverallScore(calculateOverallScore(items));
      return result;
    } catch (ApiException e) {
      throw e;
    } catch (Exception e) {
      throw new ApiException(4701, "解析宜远测肤结果失败");
    }
  }

  private ParsedSkinDetectionItem toItem(SkinDetectionItemConfig config, JsonNode node) {
    ParsedSkinDetectionItem item = new ParsedSkinDetectionItem();
    item.setItemCode(config.getItemCode());
    item.setItemName(config.getItemName());
    item.setSortOrder(config.getSortOrder());
    item.setScaleType(config.getScaleType());
    if (node == null || node.isMissingNode() || node.isNull()) {
      item.setScore(null);
      item.setLevel(null);
      item.setResultText(config.getItemName() + "检测结果暂未返回");
      item.setMetricsJson("{}");
      return item;
    }
    Integer score = intOfFirst(node, "score", "skin_score", "skinScore", "value", "grade_score", "gradeScore");
    String level = textOfFirst(node, "level", "severity", "grade", "type", "result");
    item.setScore(score);
    item.setLevel(level);
    item.setResultText(textOfFirst(node, "desc", "description", "conclusion", "text", "result_text", "resultText"));
    item.setResultImage(textOfFirst(node, "image", "image_url", "imageUrl", "result_image", "resultImage", "url"));
    item.setMetricsJson(toJson(node));
    return item;
  }

  private String findErrorMessage(JsonNode root) {
    Integer code = intOfFirst(root, "code", "errcode", "error_code", "errorCode");
    if (code != null && code != 0 && code != 200) {
      String message = textOfFirst(root, "message", "msg", "error", "error_message", "errorMessage");
      return StringUtils.hasText(message) ? message : "宜远测肤接口返回错误：" + code;
    }
    Boolean success = booleanOfFirst(root, "success");
    if (Boolean.FALSE.equals(success)) {
      String message = textOfFirst(root, "message", "msg", "error", "error_message", "errorMessage");
      return StringUtils.hasText(message) ? message : "宜远测肤接口返回失败";
    }
    return null;
  }

  private Integer calculateOverallScore(List<ParsedSkinDetectionItem> items) {
    int total = 0;
    int count = 0;
    for (ParsedSkinDetectionItem item : items) {
      if (item.getScore() != null) {
        total += item.getScore();
        count++;
      }
    }
    return count == 0 ? null : Math.round((float) total / count);
  }

  private List<SkinDetectionItemConfig> resolveItemConfigs() {
    List<SkinDetectionItemConfig> configs = itemConfigService.listEnabled();
    if (!configs.isEmpty()) {
      return configs;
    }
    List<SkinDetectionItemConfig> fallback = new ArrayList<>();
    for (ItemSpec spec : ITEM_SPECS) {
      SkinDetectionItemConfig config = new SkinDetectionItemConfig();
      config.setItemCode(spec.code());
      config.setYimeiField(spec.code());
      config.setItemName(spec.name());
      config.setDisplayName(spec.name());
      config.setSortOrder(spec.sortOrder());
      config.setScaleType("skin_type".equals(spec.code()) ? "skin_type" : "severity");
      fallback.add(config);
    }
    return fallback;
  }

  private JsonNode findNodeByFieldName(JsonNode root, String fieldName) {
    if (root == null) {
      return null;
    }
    JsonNode direct = root.get(fieldName);
    if (direct != null) {
      return direct;
    }
    if (root.isObject()) {
      Iterator<Map.Entry<String, JsonNode>> fields = root.fields();
      while (fields.hasNext()) {
        Map.Entry<String, JsonNode> entry = fields.next();
        JsonNode found = findNodeByFieldName(entry.getValue(), fieldName);
        if (found != null) {
          return found;
        }
      }
    } else if (root.isArray()) {
      for (JsonNode child : root) {
        JsonNode found = findNodeByFieldName(child, fieldName);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }

  private String textOfFirst(JsonNode node, String... names) {
    for (String name : names) {
      JsonNode value = findNodeByFieldName(node, name);
      if (value != null && value.isValueNode() && StringUtils.hasText(value.asText())) {
        return value.asText();
      }
    }
    return null;
  }

  private Integer intOfFirst(JsonNode node, String... names) {
    for (String name : names) {
      JsonNode value = findNodeByFieldName(node, name);
      if (value != null && value.isNumber()) {
        return value.asInt();
      }
      if (value != null && value.isTextual()) {
        try {
          return Integer.parseInt(value.asText());
        } catch (NumberFormatException ignored) {
          return null;
        }
      }
    }
    return null;
  }

  private Boolean booleanOfFirst(JsonNode node, String... names) {
    for (String name : names) {
      JsonNode value = findNodeByFieldName(node, name);
      if (value != null && value.isBoolean()) {
        return value.asBoolean();
      }
    }
    return null;
  }

  private String toJson(JsonNode node) {
    try {
      if (node instanceof ObjectNode) {
        return objectMapper.writeValueAsString(node);
      }
      return node == null ? "{}" : node.toString();
    } catch (Exception e) {
      return "{}";
    }
  }

  private record ItemSpec(String code, String name, int sortOrder) {}
}
