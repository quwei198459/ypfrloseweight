package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.DietRecordRow;
import com.ypfr.loseweight.domain.Food;
import com.ypfr.loseweight.domain.MealRecord;
import com.ypfr.loseweight.mapper.DietRecordMapper;
import com.ypfr.loseweight.mapper.FoodMapper;
import com.ypfr.loseweight.mapper.MealRecordMapper;
import com.ypfr.loseweight.util.RecordedAtParser;
import com.ypfr.loseweight.web.dto.CreateMealRecordRequest;
import com.ypfr.loseweight.web.dto.MealEntryVo;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class MealRecordService {

  private static final java.util.Set<String> MEAL_TYPES =
      java.util.Set.of("breakfast", "lunch", "dinner", "snack");

  private final MealRecordMapper mealRecordMapper;
  private final DietRecordMapper dietRecordMapper;
  private final FoodMapper foodMapper;
  private final DailySummaryService dailySummaryService;

  public MealRecordService(
      MealRecordMapper mealRecordMapper,
      DietRecordMapper dietRecordMapper,
      FoodMapper foodMapper,
      DailySummaryService dailySummaryService) {
    this.mealRecordMapper = mealRecordMapper;
    this.dietRecordMapper = dietRecordMapper;
    this.foodMapper = foodMapper;
    this.dailySummaryService = dailySummaryService;
  }

  public MealEntryVo create(Long userId, CreateMealRecordRequest req) {
    if (req == null) {
      throw new ApiException(400, "请求体不能为空");
    }
    if (!StringUtils.hasText(req.getMealType()) || !MEAL_TYPES.contains(req.getMealType().trim())) {
      throw new ApiException(400, "mealType 须为 breakfast/lunch/dinner/snack");
    }
    if (!StringUtils.hasText(req.getFoodName())) {
      throw new ApiException(400, "foodName 不能为空");
    }
    LocalDateTime recordedAt = RecordedAtParser.parse(req.getRecordedAt());
    LocalDate recordDate = recordedAt.toLocalDate();
    String mealType = req.getMealType().trim();
    String fn = req.getFoodName().trim();
    if (fn.length() > 128) {
      fn = fn.substring(0, 128);
    }

    Food food = null;
    if (req.getFoodLibraryId() != null) {
      food = foodMapper.selectById(req.getFoodLibraryId());
    }

    NutritionCalc nutrition = calculateNutrition(req, food);
    if (nutrition.caloriesTotal.compareTo(BigDecimal.ZERO) <= 0) {
      throw new ApiException(400, "calories 无效");
    }
    MealRecord meal = new MealRecord();
    meal.setUserId(userId);
    meal.setRecordDate(recordDate);
    meal.setMealType(mealType);
    meal.setTotalCalories(nutrition.caloriesTotal);
    meal.setTotalProteinG(nutrition.proteinTotal);
    meal.setTotalFatG(nutrition.fatTotal);
    meal.setTotalCarbG(nutrition.carbTotal);
    meal.setFoodCount(1);
    meal.setStatus("submitted");
    mealRecordMapper.insert(meal);

    DietRecordRow d = new DietRecordRow();
    d.setMealId(meal.getId());
    d.setUserId(userId);
    d.setRecordDate(recordDate);
    d.setMealType(mealType);
    d.setFoodId(req.getFoodLibraryId());
    d.setFoodNameSnapshot(fn);
    d.setImageSnapshot(food != null ? food.getImage() : null);
    d.setGiLevelSnapshot(food != null ? food.getGiLevel() : null);
    d.setCaloriesTotal(nutrition.caloriesTotal);
    d.setProteinTotalG(nutrition.proteinTotal);
    d.setFatTotalG(nutrition.fatTotal);
    d.setCarbTotalG(nutrition.carbTotal);
    d.setAmount(nutrition.amount);
    d.setAmountUnit(nutrition.amountUnit);
    d.setWeightG(nutrition.weightG);
    d.setSource(food != null ? "search" : "manual");
    d.setRecordTime(recordedAt);
    dietRecordMapper.insert(d);

    try {
      dailySummaryService.updateForDay(userId, recordDate);
    } catch (Exception ignored) {
    }
    return toEntryDto(userId, dietRecordMapper.selectById(d.getId()), mealType, fn);
  }

  private NutritionCalc calculateNutrition(CreateMealRecordRequest req, Food food) {
    BigDecimal amount = req.getAmountValue();
    if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
      amount = BigDecimal.ONE;
    }
    String amountUnit = StringUtils.hasText(req.getAmountUnit()) ? req.getAmountUnit().trim() : "份";
    BigDecimal weightG = null;
    BigDecimal caloriesTotal = null;
    BigDecimal proteinTotal = req.getProteinG();
    BigDecimal fatTotal = req.getFatG();
    BigDecimal carbTotal = req.getCarbsG();

    if (food != null) {
      boolean gramMode = "g".equalsIgnoreCase(amountUnit) || "克".equals(amountUnit);
      if (gramMode) {
        weightG = amount;
      } else if (food.getStandardWeightG() != null && food.getStandardWeightG().compareTo(BigDecimal.ZERO) > 0) {
        weightG = food.getStandardWeightG().multiply(amount);
      }

      if (weightG != null
          && food.getCaloriesPer100g() != null
          && food.getCaloriesPer100g().compareTo(BigDecimal.ZERO) > 0) {
        caloriesTotal = food.getCaloriesPer100g().multiply(weightG).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        if (food.getProteinPer100g() != null) {
          proteinTotal = food.getProteinPer100g().multiply(weightG).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        }
        if (food.getFatPer100g() != null) {
          fatTotal = food.getFatPer100g().multiply(weightG).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        }
        if (food.getCarbPer100g() != null) {
          carbTotal = food.getCarbPer100g().multiply(weightG).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        }
      } else if (food.getCaloriesPerUnit() != null && food.getCaloriesPerUnit().compareTo(BigDecimal.ZERO) > 0) {
        caloriesTotal = food.getCaloriesPerUnit().multiply(amount).setScale(2, RoundingMode.HALF_UP);
        if (weightG != null && food.getProteinPer100g() != null) {
          proteinTotal = food.getProteinPer100g().multiply(weightG).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        }
        if (weightG != null && food.getFatPer100g() != null) {
          fatTotal = food.getFatPer100g().multiply(weightG).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        }
        if (weightG != null && food.getCarbPer100g() != null) {
          carbTotal = food.getCarbPer100g().multiply(weightG).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        }
      }
      if (!StringUtils.hasText(req.getAmountUnit()) && StringUtils.hasText(food.getUnitName())) {
        amountUnit = food.getUnitName();
      }
    }

    if (caloriesTotal == null && req.getCalories() != null) {
      caloriesTotal = BigDecimal.valueOf(req.getCalories());
    }
    if (caloriesTotal == null) {
      caloriesTotal = BigDecimal.ZERO;
    }
    if (proteinTotal == null) {
      proteinTotal = BigDecimal.ZERO;
    }
    if (fatTotal == null) {
      fatTotal = BigDecimal.ZERO;
    }
    if (carbTotal == null) {
      carbTotal = BigDecimal.ZERO;
    }
    return new NutritionCalc(
        amount.setScale(2, RoundingMode.HALF_UP),
        amountUnit,
        weightG == null ? null : weightG.setScale(2, RoundingMode.HALF_UP),
        caloriesTotal.setScale(2, RoundingMode.HALF_UP),
        proteinTotal.setScale(2, RoundingMode.HALF_UP),
        fatTotal.setScale(2, RoundingMode.HALF_UP),
        carbTotal.setScale(2, RoundingMode.HALF_UP));
  }

  private record NutritionCalc(
      BigDecimal amount,
      String amountUnit,
      BigDecimal weightG,
      BigDecimal caloriesTotal,
      BigDecimal proteinTotal,
      BigDecimal fatTotal,
      BigDecimal carbTotal) {}

  public void delete(Long userId, Long dietId) {
    DietRecordRow d = dietRecordMapper.selectById(dietId);
    if (d == null) {
      throw new ApiException(404, "记录不存在");
    }
    if (!d.getUserId().equals(userId)) {
      throw new ApiException(403, "无权删除该记录");
    }
    LocalDate day = d.getRecordDate();
    Long mealId = d.getMealId();
    dietRecordMapper.deleteById(dietId);

    List<DietRecordRow> rest =
        dietRecordMapper.selectList(
            new LambdaQueryWrapper<DietRecordRow>().eq(DietRecordRow::getMealId, mealId));
    if (rest.isEmpty()) {
      mealRecordMapper.deleteById(mealId);
    } else {
      recalcMealTotals(mealId);
    }
    try {
      dailySummaryService.updateForDay(userId, day);
    } catch (Exception ignored) {
    }
  }

  private void recalcMealTotals(Long mealId) {
    List<DietRecordRow> list =
        dietRecordMapper.selectList(
            new LambdaQueryWrapper<DietRecordRow>().eq(DietRecordRow::getMealId, mealId));
    MealRecord m = mealRecordMapper.selectById(mealId);
    if (m == null) {
      return;
    }
    BigDecimal cals = BigDecimal.ZERO;
    BigDecimal p = BigDecimal.ZERO;
    BigDecimal f = BigDecimal.ZERO;
    BigDecimal carb = BigDecimal.ZERO;
    for (DietRecordRow r : list) {
      if (r.getCaloriesTotal() != null) {
        cals = cals.add(r.getCaloriesTotal());
      }
      if (r.getProteinTotalG() != null) {
        p = p.add(r.getProteinTotalG());
      }
      if (r.getFatTotalG() != null) {
        f = f.add(r.getFatTotalG());
      }
      if (r.getCarbTotalG() != null) {
        carb = carb.add(r.getCarbTotalG());
      }
    }
    m.setTotalCalories(cals);
    m.setTotalProteinG(p);
    m.setTotalFatG(f);
    m.setTotalCarbG(carb);
    m.setFoodCount(list.size());
    mealRecordMapper.updateById(m);
  }

  public List<DietRecordRow> listDietDay(Long userId, LocalDate day) {
    return dietRecordMapper.selectList(
        new LambdaQueryWrapper<DietRecordRow>()
            .eq(DietRecordRow::getUserId, userId)
            .eq(DietRecordRow::getRecordDate, day)
            .orderByAsc(DietRecordRow::getRecordTime));
  }

  private static MealEntryVo toEntryDto(
      Long userId, DietRecordRow d, String mealType, String foodName) {
    MealEntryVo out = new MealEntryVo();
    out.setId(d.getId());
    out.setUserId(userId);
    out.setMealType(mealType);
    out.setFoodName(foodName);
    if (d.getCaloriesTotal() != null) {
      out.setCalories(d.getCaloriesTotal().setScale(0, RoundingMode.HALF_UP).intValue());
    }
    out.setProteinG(d.getProteinTotalG());
    out.setFatG(d.getFatTotalG());
    out.setCarbsG(d.getCarbTotalG());
    out.setAmountValue(d.getAmount());
    out.setAmountUnit(d.getAmountUnit());
    out.setRecordedAt(d.getRecordTime());
    out.setFoodLibraryId(d.getFoodId());
    out.setCreatedAt(d.getCreatedAt());
    return out;
  }
}
