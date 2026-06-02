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
    MealPhotoFoodItemVo vo = new MealPhotoFoodItemVo();
    vo.setLineId(String.valueOf(index + 1));
    vo.setFoodName(name.length() > 128 ? name.substring(0, 128) : name);
    vo.setType(type);
    vo.setCaloriesPer100(caloriesPer100.setScale(2, RoundingMode.HALF_UP));
    vo.setQuantity(DEFAULT_QUANTITY);
    vo.setQuantityUnit(DEFAULT_QUANTITY_UNIT);
    vo.setCalories(
        caloriesPer100
            .multiply(DEFAULT_QUANTITY)
            .divide(BigDecimal.valueOf(100), 0, RoundingMode.HALF_UP)
            .max(BigDecimal.ZERO)
            .setScale(0, RoundingMode.HALF_UP)
            .intValue());
    vo.setGiLabel("低 GI");
    return vo;
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
    vo.setCalories(caloriesPer100.intValue());
    vo.setGiLabel("低 GI");
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
