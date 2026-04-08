package com.ypfr.loseweight.service.photograph;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoFoodItemVo;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
public class MealPhotoAliyunJsonParser {

  private static final Pattern KCAL_PATTERN = Pattern.compile("(\\d+)(\\.\\d+)?\\s*千?卡");

  private final ObjectMapper objectMapper;

  public MealPhotoAliyunJsonParser(ObjectMapper objectMapper) {
    this.objectMapper = objectMapper;
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
    String name = firstText(n, "name", "foodName", "food_name", "food", "dishName", "title");
    int cal = firstInt(n, "calorie", "calories", "heat", "energy", "kcal", "cal");
    if (!StringUtils.hasText(name) && cal <= 0) {
      return null;
    }
    if (!StringUtils.hasText(name)) {
      name = "识别食物";
    }
    MealPhotoFoodItemVo vo = new MealPhotoFoodItemVo();
    vo.setLineId(String.valueOf(index + 1));
    vo.setFoodName(name.length() > 128 ? name.substring(0, 128) : name);
    vo.setCalories(Math.max(0, cal));
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

  private static int firstInt(JsonNode n, String... keys) {
    for (String k : keys) {
      if (!n.has(k)) {
        continue;
      }
      JsonNode v = n.get(k);
      if (v.isInt()) {
        return v.intValue();
      }
      if (v.isDouble()) {
        return (int) Math.round(v.doubleValue());
      }
      if (v.isTextual()) {
        try {
          return (int) Math.round(Double.parseDouble(v.asText().trim()));
        } catch (NumberFormatException ignored) {
        }
      }
    }
    return 0;
  }

  private static List<MealPhotoFoodItemVo> defaultList(int calories) {
    MealPhotoFoodItemVo vo = new MealPhotoFoodItemVo();
    vo.setLineId("1");
    vo.setFoodName("识别食物");
    vo.setCalories(Math.max(0, calories));
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
