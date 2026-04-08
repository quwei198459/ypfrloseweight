package com.ypfr.loseweight.service;

import com.ypfr.loseweight.domain.UserBudgetConfig;
import com.ypfr.loseweight.domain.UserProfile;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/** Mifflin-St Jeor BMR、活动系数 TDEE、按目标日期估算每日预算，写入 {@link UserBudgetConfig}。 */
public final class CalorieBudgetCalculator {

  private CalorieBudgetCalculator() {}

  public static int mifflinBmr(double weightKg, double heightCm, int age, int gender) {
    double s = gender == 1 ? 5 : -161;
    return (int) Math.round(10 * weightKg + 6.25 * heightCm - 5 * age + s);
  }

  public static double activityFactor(int level) {
    return switch (level) {
      case 1 -> 1.2;
      case 2 -> 1.375;
      case 3 -> 1.55;
      case 4 -> 1.725;
      case 5 -> 1.9;
      default -> 1.375;
    };
  }

  public static int normalizedActivityLevel(Integer level) {
    if (level == null || level < 1 || level > 5) {
      return 2;
    }
    return level;
  }

  /** 前端档位 1-5 → 存库活动系数 decimal */
  public static BigDecimal activityDecimalFromTier(Integer tier) {
    return BigDecimal.valueOf(activityFactor(normalizedActivityLevel(tier)));
  }

  /** 展示用：将系数粗略映射回 1-5 档 */
  public static int tierFromActivityDecimal(BigDecimal activity) {
    if (activity == null) {
      return 2;
    }
    double v = activity.doubleValue();
    if (v <= 1.25) {
      return 1;
    }
    if (v <= 1.45) {
      return 2;
    }
    if (v <= 1.6) {
      return 3;
    }
    if (v <= 1.8) {
      return 4;
    }
    return 5;
  }

  /**
   * 具备必要体测字段时重算并写入 budget；否则不修改 calculated_* / daily_budget。
   */
  public static void applyToProfileAndBudget(UserProfile p, UserBudgetConfig b, LocalDate today) {
    if (p == null || b == null || today == null) {
      return;
    }
    if (p.getGender() == null || (p.getGender() != 1 && p.getGender() != 2)) {
      return;
    }
    if (p.getAge() == null || p.getAge() <= 0) {
      return;
    }
    if (p.getHeightCm() == null || p.getHeightCm().doubleValue() <= 0) {
      return;
    }
    if (p.getCurrentWeightKg() == null || p.getCurrentWeightKg().doubleValue() <= 0) {
      return;
    }

    int gender = p.getGender();
    int age = p.getAge();
    double h = p.getHeightCm().doubleValue();
    double w = p.getCurrentWeightKg().doubleValue();

    double act =
        b.getActivityLevel() != null && b.getActivityLevel().doubleValue() > 0
            ? b.getActivityLevel().doubleValue()
            : 1.375;

    int bmrInt;
    if (b.getUseCustomBmr() != null
        && b.getUseCustomBmr() == 1
        && b.getCustomBmr() != null
        && b.getCustomBmr().doubleValue() > 0) {
      bmrInt = b.getCustomBmr().setScale(0, RoundingMode.HALF_UP).intValue();
    } else {
      bmrInt = mifflinBmr(w, h, age, gender);
    }

    int tdee = (int) Math.round(bmrInt * act);
    b.setCalculatedBmr(BigDecimal.valueOf(bmrInt));
    b.setCalculatedTdee(BigDecimal.valueOf(tdee));

    BigDecimal targetW = p.getTargetWeightKg();
    LocalDate targetDate = p.getTargetDate();
    if (targetW == null || targetDate == null) {
      b.setRecommendedDeficit(BigDecimal.ZERO);
      b.setDailyBudget(BigDecimal.valueOf(tdee));
      return;
    }
    double tw = targetW.doubleValue();
    if (tw <= 0) {
      b.setRecommendedDeficit(BigDecimal.ZERO);
      b.setDailyBudget(BigDecimal.valueOf(tdee));
      return;
    }
    double deltaKg = w - tw;
    if (deltaKg <= 0.05) {
      b.setRecommendedDeficit(BigDecimal.ZERO);
      b.setDailyBudget(BigDecimal.valueOf(tdee));
      return;
    }
    long days = ChronoUnit.DAYS.between(today, targetDate);
    if (days < 1) {
      days = 1;
    }
    double rawDeficit = deltaKg * 7700.0 / days;
    double deficit = Math.min(1000, Math.max(300, rawDeficit));
    int goal = (int) Math.round(tdee - deficit);
    goal = Math.max(goal, 1200);
    if (goal > tdee) {
      goal = tdee;
    }
    b.setRecommendedDeficit(BigDecimal.valueOf(deficit).setScale(2, RoundingMode.HALF_UP));
    b.setDailyBudget(BigDecimal.valueOf(goal));
  }
}
