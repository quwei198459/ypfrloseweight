package com.ypfr.loseweight.service.photograph;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoFoodItemVo;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
public class MealPhotoAliyunJsonParser {

  private static final Pattern KCAL_PATTERN = Pattern.compile("(\\d+)(\\.\\d+)?\\s*千?卡");
  private static final BigDecimal DEFAULT_QUANTITY = BigDecimal.valueOf(100);
  private static final String DEFAULT_QUANTITY_UNIT = "g/ml";

  private final ObjectMapper objectMapper;

  public MealPhotoAliyunJsonParser(ObjectMapper objectMapper) {
    this.objectMapper = objectMapper;
  }

  /**
   * 阿里云市场常见包体：{@code success=false} / {@code code!=200} 时 {@code data} 可能为空，不能再走占位「识别食物」逻辑。
   *
   * @return 有值表示供应商明确拒绝或业务失败，应将该段文案展示给用户（可截断）
   */
  public Optional<String> readVendorFailureReason(String rawBody) {
    if (!StringUtils.hasText(rawBody)) {
      return Optional.empty();
    }
    try {
      JsonNode root = objectMapper.readTree(rawBody);
      boolean vendorFail = false;
      if (root.has("success") && root.get("success").isBoolean() && !root.get("success").asBoolean()) {
        vendorFail = true;
      }
      if (root.has("code")) {
        JsonNode c = root.get("code");
        if (c.isIntegralNumber()) {
          int code = c.asInt();
          if (code != 200 && code != 0) {
            vendorFail = true;
          }
        }
      }
      if (!vendorFail) {
        return Optional.empty();
      }
      if (root.has("msg") && root.get("msg").isTextual()) {
        String m = root.get("msg").asText().trim();
        if (StringUtils.hasText(m)) {
          return Optional.of(m);
        }
      }
      return Optional.of("识图服务未返回有效食物数据");
    } catch (Exception ignored) {
      return Optional.empty();
    }
  }

  public List<MealPhotoFoodItemVo> parseFoods(String rawBody) {
    if (!StringUtils.hasText(rawBody)) {
      return defaultList(0);
    }
    try {
      JsonNode root = objectMapper.readTree(rawBody);
      List<MealPhotoFoodItemVo> list = tryParseArray(root);
      if (!list.isEmpty()) {
        return list;
      }
      list = tryParseDataItems(root);
      if (!list.isEmpty()) {
        return list;
      }
      for (String key : new String[] {"data", "result", "items", "foods", "list"}) {
        if (root.has(key) && root.get(key).isArray()) {
          list = parseArray(root.get(key));
          if (!list.isEmpty()) {
            return list;
          }
        }
      }
      list = deepCollectFoodNodes(root);
      if (!list.isEmpty()) {
        return list;
      }
    } catch (Exception ignored) {
    }
    return defaultList(guessCaloriesFromText(rawBody));
  }

  private List<MealPhotoFoodItemVo> tryParseArray(JsonNode node) {
    if (node != null && node.isArray()) {
      return parseArray(node);
    }
    return List.of();
  }

  /**
   * 阿里云食物识别常见形态：{@code {"data":{"count":n,"items":[{name,calory},...]},...}}。
   */
  private List<MealPhotoFoodItemVo> tryParseDataItems(JsonNode root) {
    if (root == null || !root.isObject() || !root.has("data")) {
      return List.of();
    }
    JsonNode data = root.get("data");
    if (data == null || !data.isObject() || !data.has("items")) {
      return List.of();
    }
    JsonNode items = data.get("items");
    if (items == null || !items.isArray()) {
      return List.of();
    }
    return parseArray(items);
  }

  private List<MealPhotoFoodItemVo> parseArray(JsonNode arr) {
    List<MealPhotoFoodItemVo> out = new ArrayList<>();
    int i = 0;
    for (JsonNode el : arr) {
      MealPhotoFoodItemVo one = extractFood(el, i++);
      if (one != null) {
        out.add(one);
      }
    }
    return out;
  }

  private List<MealPhotoFoodItemVo> deepCollectFoodNodes(JsonNode node) {
    List<MealPhotoFoodItemVo> out = new ArrayList<>();
    walk(node, out, 0);
    return out;
  }

  private void walk(JsonNode n, List<MealPhotoFoodItemVo> out, int depth) {
    if (n == null || depth > 8) {
      return;
    }
    if (n.isObject()) {
      MealPhotoFoodItemVo one = extractFood(n, out.size());
      if (one != null && StringUtils.hasText(one.getFoodName())) {
        out.add(one);
        return;
      }
      Iterator<String> it = n.fieldNames();
      while (it.hasNext()) {
        walk(n.get(it.next()), out, depth + 1);
      }
    } else if (n.isArray()) {
      for (JsonNode c : n) {
        walk(c, out, depth + 1);
      }
    }
  }

  private MealPhotoFoodItemVo extractFood(JsonNode n, int index) {
    if (n == null || !n.isObject()) {
      return null;
    }
    Integer type = firstInteger(n, "type");
    if (type != null && type == 2) {
      return null;
    }
    String name = firstText(n, "name", "foodName", "food_name", "food", "dishName", "title");
    BigDecimal caloriesPer100 =
        firstDecimal(
            n,
            "calory",
            "calorie",
            "calories",
            "heat",
            "energy",
            "kcal",
            "cal");
    if (!StringUtils.hasText(name) && caloriesPer100.compareTo(BigDecimal.ZERO) <= 0) {
      return null;
    }
    if (!StringUtils.hasText(name)) {
      name = "识别食物";
    }
    // 预估重量：第三方返回如 "300g"，缺省按 100 计
    ParsedWeight weight = parseWeight(n);
    MealPhotoFoodItemVo vo = new MealPhotoFoodItemVo();
    vo.setLineId(String.valueOf(index + 1));
    vo.setFoodName(name.length() > 128 ? name.substring(0, 128) : name);
    vo.setType(type);
    vo.setCaloriesPer100(caloriesPer100.setScale(2, RoundingMode.HALF_UP));
    vo.setQuantity(weight.grams);
    vo.setQuantityUnit(weight.unit);
    vo.setWeightG(weight.grams.doubleValue());
    // 实际热量 = 标准热量(每100g/ml) × 实际重量 ÷ 100
    vo.setCalories(
        caloriesPer100
            .multiply(weight.grams)
            .divide(BigDecimal.valueOf(100), 0, RoundingMode.HALF_UP)
            .max(BigDecimal.ZERO)
            .setScale(0, RoundingMode.HALF_UP)
            .intValue());
    Integer gi = firstInteger(n, "GI", "gi", "giValue", "gi_value");
    vo.setGi(gi);
    vo.setGiLabel(giLabelFromValue(gi));
    return vo;
  }

  /** 预估重量解析结果：统一换算到数值 + 展示单位（g/ml）。 */
  private static final class ParsedWeight {
    final BigDecimal grams;
    final String unit;

    ParsedWeight(BigDecimal grams, String unit) {
      this.grams = grams;
      this.unit = unit;
    }
  }

  private static final Pattern WEIGHT_PATTERN =
      Pattern.compile("([\\d]+(?:\\.\\d+)?)\\s*(kg|千克|公斤|g|克|ml|毫升|l|升)?", Pattern.CASE_INSENSITIVE);

  /**
   * 解析第三方预估重量字符串（如 {@code "300g"}、{@code "1.5kg"}、{@code "250ml"}）。
   * 单位归一：kg/千克/公斤→g(×1000)，l/升→ml(×1000)；无单位或无法解析时按 100 g/ml 兜底。
   */
  private ParsedWeight parseWeight(JsonNode n) {
    String raw = null;
    for (String k : new String[] {"weight", "amount", "estimateWeight", "weight_g", "weightG"}) {
      if (n == null || !n.has(k)) {
        continue;
      }
      JsonNode v = n.get(k);
      if (v.isTextual() && StringUtils.hasText(v.asText())) {
        raw = v.asText().trim();
        break;
      }
      if (v.isNumber()) {
        // 纯数字按克/毫升处理（无单位）
        raw = v.asText();
        break;
      }
    }
    if (StringUtils.hasText(raw)) {
      Matcher m = WEIGHT_PATTERN.matcher(raw.trim());
      if (m.find()) {
        try {
          BigDecimal value = new BigDecimal(m.group(1));
          String unitRaw = m.group(2) == null ? "" : m.group(2).toLowerCase(Locale.ROOT);
          BigDecimal grams = value;
          String unit;
          switch (unitRaw) {
            case "kg":
            case "千克":
            case "公斤":
              grams = value.multiply(BigDecimal.valueOf(1000));
              unit = "g";
              break;
            case "g":
            case "克":
              unit = "g";
              break;
            case "l":
            case "升":
              grams = value.multiply(BigDecimal.valueOf(1000));
              unit = "ml";
              break;
            case "ml":
            case "毫升":
              unit = "ml";
              break;
            default:
              unit = DEFAULT_QUANTITY_UNIT;
          }
          if (grams.compareTo(BigDecimal.ZERO) > 0) {
            return new ParsedWeight(grams.setScale(1, RoundingMode.HALF_UP), unit);
          }
        } catch (NumberFormatException ignored) {
        }
      }
    }
    return new ParsedWeight(DEFAULT_QUANTITY, DEFAULT_QUANTITY_UNIT);
  }

  /**
   * 按通用 GI 分级阈值给出展示文案：≤55 低 GI，56-69 中 GI，≥70 高 GI；无真值时返回空串（不再伪造）。
   */
  private static String giLabelFromValue(Integer gi) {
    if (gi == null) {
      return "";
    }
    if (gi <= 55) {
      return "低 GI";
    }
    if (gi <= 69) {
      return "中 GI";
    }
    return "高 GI";
  }

  private static String firstText(JsonNode n, String... keys) {
    for (String k : keys) {
      if (n.has(k) && n.get(k).isTextual()) {
        String t = n.get(k).asText();
        if (StringUtils.hasText(t)) {
          return t.trim();
        }
      }
    }
    return null;
  }

  private static Integer firstInteger(JsonNode n, String... keys) {
    for (String k : keys) {
      if (!n.has(k)) {
        continue;
      }
      JsonNode v = n.get(k);
      if (v.isIntegralNumber()) {
        return v.intValue();
      }
      if (v.isFloatingPointNumber()) {
        return (int) Math.round(v.doubleValue());
      }
      if (v.isTextual()) {
        try {
          return (int) Math.round(Double.parseDouble(v.asText().trim()));
        } catch (NumberFormatException ignored) {
        }
      }
    }
    return null;
  }

  private static BigDecimal firstDecimal(JsonNode n, String... keys) {
    for (String k : keys) {
      if (!n.has(k)) {
        continue;
      }
      JsonNode v = n.get(k);
      if (v.isNumber()) {
        return BigDecimal.valueOf(v.asDouble()).max(BigDecimal.ZERO);
      }
      if (v.isTextual()) {
        try {
          return new BigDecimal(v.asText().trim()).max(BigDecimal.ZERO);
        } catch (NumberFormatException ignored) {
        }
      }
    }
    return BigDecimal.ZERO;
  }

  private static List<MealPhotoFoodItemVo> defaultList(int calories) {
    MealPhotoFoodItemVo vo = new MealPhotoFoodItemVo();
    BigDecimal caloriesPer100 = BigDecimal.valueOf(Math.max(0, calories));
    vo.setLineId("1");
    vo.setFoodName("识别食物");
    vo.setType(1);
    vo.setCaloriesPer100(caloriesPer100.setScale(2, RoundingMode.HALF_UP));
    vo.setQuantity(DEFAULT_QUANTITY);
    vo.setQuantityUnit(DEFAULT_QUANTITY_UNIT);
    vo.setWeightG(DEFAULT_QUANTITY.doubleValue());
    vo.setCalories(caloriesPer100.intValue());
    vo.setGiLabel("");
    return List.of(vo);
  }

  private static int guessCaloriesFromText(String body) {
    Matcher m = KCAL_PATTERN.matcher(body);
    if (m.find()) {
      try {
        return Integer.parseInt(m.group(1));
      } catch (NumberFormatException ignored) {
      }
    }
    return 0;
  }

  public String toJson(List<MealPhotoFoodItemVo> foods) {
    try {
      return objectMapper.writeValueAsString(foods);
    } catch (Exception e) {
      return "[]";
    }
  }

  public List<MealPhotoFoodItemVo> fromJson(String json) {
    if (!StringUtils.hasText(json)) {
      return List.of();
    }
    try {
      JsonNode arr = objectMapper.readTree(json);
      if (arr.isArray()) {
        return parseArray(arr);
      }
    } catch (Exception ignored) {
    }
    return List.of();
  }

  public static String giSnapshotFromLabel(String giLabel) {
    if (giLabel == null) {
      return "low";
    }
    String s = giLabel.toLowerCase(Locale.ROOT);
    if (s.contains("高")) {
      return "high";
    }
    if (s.contains("中")) {
      return "mid";
    }
    return "low";
  }
}
