package com.ypfr.loseweight.service.photograph;

import java.time.LocalTime;

/** 补充 PRD：默认餐别推荐（简化时间规则，与前端可后续统一配置） */
public final class MealRecommendedMealTypeUtil {

  private MealRecommendedMealTypeUtil() {}

  public static String recommend(LocalTime now) {
    int h = now.getHour();
    if (h >= 5 && h < 10) {
      return "breakfast";
    }
    if (h >= 10 && h < 14) {
      return "lunch";
    }
    if (h >= 14 && h < 17) {
      return "snack";
    }
    if (h >= 17 && h < 21) {
      return "dinner";
    }
    return "snack";
  }
}
