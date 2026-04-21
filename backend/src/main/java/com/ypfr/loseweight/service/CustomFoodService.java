package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.Food;
import com.ypfr.loseweight.domain.FoodCategory;
import com.ypfr.loseweight.mapper.FoodCategoryMapper;
import com.ypfr.loseweight.mapper.FoodMapper;
import com.ypfr.loseweight.web.dto.CreateCustomFoodRequest;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class CustomFoodService {

  private static final String CUSTOM_FOOD_CATEGORY_CODE = "other";

  private final FoodMapper foodMapper;
  private final FoodCategoryMapper foodCategoryMapper;

  public CustomFoodService(FoodMapper foodMapper, FoodCategoryMapper foodCategoryMapper) {
    this.foodMapper = foodMapper;
    this.foodCategoryMapper = foodCategoryMapper;
  }

  public Food create(Long userId, CreateCustomFoodRequest req) {
    if (req == null) {
      throw new ApiException(400, "请求体不能为空");
    }
    if (!StringUtils.hasText(req.getName())) {
      throw new ApiException(400, "名称不能为空");
    }
    if (req.getWeightG() == null || req.getWeightG().compareTo(BigDecimal.ZERO) <= 0) {
      throw new ApiException(400, "重量须大于 0");
    }
    if (req.getCalories() == null || req.getCalories().compareTo(BigDecimal.ZERO) <= 0) {
      throw new ApiException(400, "热量须大于 0");
    }

    String name = req.getName().trim();
    if (name.length() > 128) {
      name = name.substring(0, 128);
    }

    BigDecimal weightG = req.getWeightG().setScale(2, RoundingMode.HALF_UP);
    BigDecimal caloriesTotal = req.getCalories().setScale(2, RoundingMode.HALF_UP);
    BigDecimal per100 =
        caloriesTotal
            .multiply(BigDecimal.valueOf(100))
            .divide(weightG, 4, RoundingMode.HALF_UP);

    LambdaQueryWrapper<FoodCategory> cw = new LambdaQueryWrapper<>();
    cw.eq(FoodCategory::getCode, CUSTOM_FOOD_CATEGORY_CODE)
        .eq(FoodCategory::getStatus, 1);
    FoodCategory otherCat = foodCategoryMapper.selectOne(cw);
    if (otherCat == null) {
      throw new ApiException(
          500, "缺少食物分类 other，请先执行数据库迁移 V017__food_category_code_sidebar_seed.sql");
    }

    LocalDateTime now = LocalDateTime.now();
    Food food = new Food();
    food.setCreatorUserId(userId);
    food.setCategoryId(otherCat.getId());
    food.setName(name);
    food.setImage("/api/v1/public/food-images/default.png");
    food.setGiLevel(null);
    food.setStandardWeightG(weightG);
    food.setCaloriesPer100g(per100);
    food.setCaloriesPerUnit(caloriesTotal);
    food.setUnitName("份");
    food.setKeywords(name);
    food.setProteinPer100g(BigDecimal.ZERO);
    food.setFatPer100g(BigDecimal.ZERO);
    food.setCarbPer100g(BigDecimal.ZERO);
    food.setIsCustom(1);
    food.setStatus(1);
    food.setCreatedAt(now);
    food.setUpdatedAt(now);

    foodMapper.insert(food);
    return food;
  }
}
