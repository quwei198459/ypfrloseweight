package com.ypfr.loseweight.service.photograph;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoFoodItemVo;
import java.util.List;
import org.junit.jupiter.api.Test;

/** 校验新版阿里云食物识别返回（calory + weight + GI + type）解析口径。 */
class MealPhotoAliyunJsonParserTest {

  private final MealPhotoAliyunJsonParser parser =
      new MealPhotoAliyunJsonParser(new ObjectMapper());

  private static final String NEW_FORMAT_BODY =
      "{\"code\":200,\"data\":{\"count\":1,\"items\":["
          + "{\"calory\":280,\"GI\":\"65\",\"name\":\"糖醋里脊\",\"weight\":\"300g\",\"type\":1},"
          + "{\"calory\":18,\"name\":\"蛋白质\",\"type\":2}"
          + "]},\"msg\":\"成功\",\"taskNo\":\"123117418248089423391937\"}";

  @Test
  void parsesActualCaloriesFromStandardCalorieAndWeight() {
    List<MealPhotoFoodItemVo> foods = parser.parseFoods(NEW_FORMAT_BODY);

    // 营养成分（type=2）应被过滤，仅保留 type=1 食物
    assertEquals(1, foods.size());
    MealPhotoFoodItemVo food = foods.get(0);
    assertEquals("糖醋里脊", food.getFoodName());
    assertEquals(1, food.getType());
    // 标准热量（每 100g）
    assertEquals(0, food.getCaloriesPer100().compareTo(new java.math.BigDecimal("280.00")));
    // 预估重量 300g
    assertEquals(0, food.getQuantity().compareTo(new java.math.BigDecimal("300.0")));
    assertEquals("g", food.getQuantityUnit());
    // 实际热量 = 280 × 300 / 100 = 840
    assertEquals(840, food.getCalories());
  }

  @Test
  void parsesRealGiValueAndLevel() {
    MealPhotoFoodItemVo food = parser.parseFoods(NEW_FORMAT_BODY).get(0);
    assertEquals(65, food.getGi());
    // 56-69 区间为「中 GI」
    assertEquals("中 GI", food.getGiLabel());
  }

  @Test
  void defaultsWeightToHundredWhenMissing() {
    String body =
        "{\"code\":200,\"data\":{\"items\":[{\"calory\":120,\"name\":\"米饭\",\"type\":1}]}}";
    MealPhotoFoodItemVo food = parser.parseFoods(body).get(0);
    assertEquals(0, food.getQuantity().compareTo(new java.math.BigDecimal("100")));
    assertEquals(120, food.getCalories());
    // 无 GI 真值时不再伪造「低 GI」
    assertNull(food.getGi());
    assertEquals("", food.getGiLabel());
  }

  @Test
  void convertsKilogramWeightToGrams() {
    String body =
        "{\"data\":{\"items\":[{\"calory\":50,\"name\":\"西瓜\",\"weight\":\"1.5kg\",\"type\":1}]}}";
    MealPhotoFoodItemVo food = parser.parseFoods(body).get(0);
    assertNotNull(food.getQuantity());
    // 1.5kg → 1500g，实际热量 = 50 × 1500 / 100 = 750
    assertEquals(0, food.getQuantity().compareTo(new java.math.BigDecimal("1500.0")));
    assertEquals("g", food.getQuantityUnit());
    assertEquals(750, food.getCalories());
  }
}
