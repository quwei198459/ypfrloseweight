package com.ypfr.loseweight.service;

import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.DailySummary;
import com.ypfr.loseweight.domain.LoseWeightUser;
import com.ypfr.loseweight.domain.UserBudgetConfig;
import com.ypfr.loseweight.domain.UserProfile;
import com.ypfr.loseweight.mapper.DailySummaryMapper;
import com.ypfr.loseweight.mapper.LoseWeightUserMapper;
import com.ypfr.loseweight.web.dto.WeekStatsCardDto;
import com.ypfr.loseweight.web.dto.WeekStatsDto;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;

@Service
public class WeekStatsService {

  private static final int MAX_RANGE_DAYS = 31;

  private final LoseWeightUserMapper loseWeightUserMapper;
  private final UserService userService;
  private final DailySummaryMapper dailySummaryMapper;

  public WeekStatsService(
      LoseWeightUserMapper loseWeightUserMapper,
      UserService userService,
      DailySummaryMapper dailySummaryMapper) {
    this.loseWeightUserMapper = loseWeightUserMapper;
    this.userService = userService;
    this.dailySummaryMapper = dailySummaryMapper;
  }

  public WeekStatsDto build(Long userId, LocalDate startDate, LocalDate endDate) {
    if (startDate == null || endDate == null) {
      throw new ApiException(400, "startDate 与 endDate 必填");
    }
    if (endDate.isBefore(startDate)) {
      throw new ApiException(400, "endDate 不能早于 startDate");
    }
    long span = endDate.toEpochDay() - startDate.toEpochDay() + 1;
    if (span > MAX_RANGE_DAYS) {
      throw new ApiException(400, "统计区间最长 " + MAX_RANGE_DAYS + " 天");
    }

    LoseWeightUser lw = loseWeightUserMapper.selectById(userId);
    if (lw == null) {
      throw new ApiException(404, "用户不存在");
    }
    UserProfile profile = userService.ensureProfile(userId);
    UserBudgetConfig budget = userService.loadLatestBudget(userId);

    int tdee = resolveTdee(profile, budget);
    int goal = resolveDailyGoal(budget, tdee);
    double guideDeficit = Math.max(0, tdee - goal);

    List<DailySummary> summaryRows =
        dailySummaryMapper.selectList(
            new LambdaQueryWrapper<DailySummary>()
                .eq(DailySummary::getUserId, userId)
                .between(DailySummary::getSummaryDate, startDate, endDate));
    Map<LocalDate, DailySummary> summaryMap = new HashMap<>();
    for (DailySummary s : summaryRows) {
      summaryMap.put(s.getSummaryDate(), s);
    }

    List<LocalDate> days = enumerateDays(startDate, endDate);
    List<Double> deficitVals = new ArrayList<>();
    List<Double> intakeVals = new ArrayList<>();
    List<Double> sportVals = new ArrayList<>();
    List<Double> eatingVals = new ArrayList<>();

    double sumDeficit = 0d;
    double sumIntake = 0d;
    double sumSport = 0d;
    double sumEating = 0d;
    int validDays = 0;
    int eatingCount = 0;

    for (LocalDate d : days) {
      DailySummary summary = summaryMap.get(d);
      int in = summary == null ? 0 : toInt(summary.getIntakeCalories());
      int sp = summary == null ? 0 : toInt(summary.getExerciseCalories());
      double deficit =
          summary != null && summary.getActualDeficitCalories() != null
              ? summary.getActualDeficitCalories().doubleValue()
              : (tdee - in + sp);
      deficitVals.add(deficit);
      intakeVals.add((double) in);
      sportVals.add((double) sp);
      double eh =
          summary != null && summary.getEatingWindowHours() != null
              ? summary.getEatingWindowHours().doubleValue()
              : 0d;
      eatingVals.add(round2(eh));

      if (summary != null) {
        validDays++;
      }
      sumDeficit += deficit;
      sumIntake += in;
      sumSport += sp;
      if (eh > 0.001) {
        sumEating += eh;
        eatingCount++;
      }
    }

    int denominator = Math.max(1, validDays);
    double avgDeficit = sumDeficit / denominator;
    double avgIntake = sumIntake / denominator;
    double avgSport = sumSport / denominator;
    double avgEating = eatingCount > 0 ? sumEating / eatingCount : 0;

    WeekStatsDto dto = new WeekStatsDto();
    List<WeekStatsCardDto> cards = new ArrayList<>();

    cards.add(deficitCard(deficitVals, guideDeficit, round1(avgDeficit)));
    cards.add(intakeCard(intakeVals, goal, round1(avgIntake)));
    cards.add(sportCard(sportVals, round1(avgSport)));
    cards.add(
        eatingWindowCard(eatingVals, 8.0, round2(avgEating)));

    dto.setCards(cards);
    return dto;
  }

  private static WeekStatsCardDto deficitCard(
      List<Double> values, double guideDeficit, double totalSum) {
    WeekStatsCardDto c = new WeekStatsCardDto();
    c.setTitle("日均热量缺口");
    c.setUnitLabel("单位/千卡");
    c.setTotalValue(totalSum);
    c.setTotalSuffix("千卡");
    c.setValues(values);
    c.setShowGuideLine(true);
    c.setGuideValue(round1(guideDeficit));
    c.setGuideLabel("推荐 " + (int) Math.round(guideDeficit));
    c.setBarColor("#E85D5D");
    c.setGuideColor("#7CB342");
    c.setMode("deficit");
    c.setYAxisLabels(buildDeficitAxis(values, guideDeficit));
    return c;
  }

  private static WeekStatsCardDto intakeCard(
      List<Double> values, double guideIntake, double totalSum) {
    WeekStatsCardDto c = new WeekStatsCardDto();
    c.setTitle("日均饮食摄入");
    c.setUnitLabel("单位/千卡");
    c.setTotalValue(totalSum);
    c.setTotalSuffix("千卡");
    c.setValues(values);
    c.setShowGuideLine(true);
    c.setGuideValue(round1(guideIntake));
    c.setGuideLabel("推荐 " + (int) Math.round(guideIntake));
    c.setBarColor("#FFB74D");
    c.setGuideColor("#F57C00");
    c.setMode("positive");
    c.setYAxisLabels(buildPositiveAxis(values, guideIntake));
    return c;
  }

  private static WeekStatsCardDto sportCard(List<Double> values, double totalSum) {
    boolean allZero = values.stream().allMatch(v -> Math.abs(v) < 1e-6);
    WeekStatsCardDto c = new WeekStatsCardDto();
    c.setTitle("日运动消耗");
    c.setUnitLabel("单位/千卡");
    c.setTotalValue(totalSum);
    c.setTotalSuffix("千卡");
    c.setValues(values);
    c.setShowGuideLine(false);
    c.setGuideValue(0);
    c.setGuideLabel("");
    c.setBarColor("#64B5F6");
    c.setGuideColor("#1976D2");
    c.setMode(allZero ? "empty" : "positive");
    double maxV = values.stream().mapToDouble(Double::doubleValue).max().orElse(0);
    if (allZero) {
      c.setYAxisLabels(List.of(1.0, 0.8, 0.6, 0.4, 0.2, 0.0));
    } else {
      c.setYAxisLabels(buildPositiveAxis(values, maxV));
    }
    return c;
  }

  private static WeekStatsCardDto eatingWindowCard(
      List<Double> values, double guideHours, double avgHours) {
    WeekStatsCardDto c = new WeekStatsCardDto();
    c.setTitle("日均轻断食用餐时长");
    c.setUnitLabel("单位/小时");
    c.setTotalValue(avgHours);
    c.setTotalSuffix("小时");
    c.setValues(values);
    c.setShowGuideLine(true);
    c.setGuideValue(round2(guideHours));
    c.setGuideLabel("推荐 " + (int) Math.round(guideHours));
    c.setBarColor("#81C784");
    c.setGuideColor("#388E3C");
    c.setMode("positive");
    c.setYAxisLabels(buildPositiveAxis(values, guideHours));
    return c;
  }

  private static List<Double> buildDeficitAxis(List<Double> values, double guide) {
    double minV = 0;
    double maxV = 0;
    for (Double v : values) {
      minV = Math.min(minV, v);
      maxV = Math.max(maxV, v);
    }
    minV = Math.min(minV, -Math.abs(guide));
    maxV = Math.max(maxV, Math.abs(guide));
    minV = Math.min(minV, 0);
    maxV = Math.max(maxV, 0);
    double pad = (maxV - minV) * 0.08 + 50;
    return axisDescending(minV - pad, maxV + pad, 8);
  }

  private static List<Double> buildPositiveAxis(List<Double> values, double guide) {
    double maxV = 0;
    for (Double v : values) {
      maxV = Math.max(maxV, v);
    }
    maxV = Math.max(maxV, guide);
    maxV = Math.max(maxV, 1);
    maxV *= 1.12;
    return axisDescending(0, maxV, 7);
  }

  private static List<Double> axisDescending(double min, double max, int tickCount) {
    if (max < min) {
      double t = min;
      min = max;
      max = t;
    }
    if (max - min < 1e-6) {
      max = min + 1;
    }
    List<Double> out = new ArrayList<>();
    for (int i = tickCount - 1; i >= 0; i--) {
      double v = min + (max - min) * i / (tickCount - 1);
      out.add(Math.round(v * 10.0) / 10.0);
    }
    return out;
  }

  private static List<LocalDate> enumerateDays(LocalDate start, LocalDate end) {
    List<LocalDate> out = new ArrayList<>();
    for (LocalDate d = start; !d.isAfter(end); d = d.plusDays(1)) {
      out.add(d);
    }
    return out;
  }

  private static double round1(double v) {
    return Math.round(v * 10.0) / 10.0;
  }

  private static double round2(double v) {
    return Math.round(v * 100.0) / 100.0;
  }

  private int resolveTdee(UserProfile p, UserBudgetConfig b) {
    if (b != null && b.getCalculatedTdee() != null && b.getCalculatedTdee().doubleValue() > 0) {
      return b.getCalculatedTdee().intValue();
    }
    if (p.getGender() == null
        || (p.getGender() != 1 && p.getGender() != 2)
        || p.getAge() == null
        || p.getAge() <= 0
        || p.getHeightCm() == null
        || p.getHeightCm().doubleValue() <= 0
        || p.getCurrentWeightKg() == null
        || p.getCurrentWeightKg().doubleValue() <= 0) {
      return 2000;
    }
    int bmr =
        CalorieBudgetCalculator.mifflinBmr(
            p.getCurrentWeightKg().doubleValue(),
            p.getHeightCm().doubleValue(),
            p.getAge(),
            p.getGender());
    double factor =
        b != null && b.getActivityLevel() != null && b.getActivityLevel().doubleValue() > 0
            ? b.getActivityLevel().doubleValue()
            : 1.375;
    return (int) Math.round(bmr * factor);
  }

  private int resolveDailyGoal(UserBudgetConfig b, int tdee) {
    if (b != null && b.getDailyBudget() != null && b.getDailyBudget().doubleValue() > 0) {
      return b.getDailyBudget().intValue();
    }
    return tdee > 0 ? tdee : 1600;
  }

  private static int toInt(java.math.BigDecimal val) {
    return val == null ? 0 : val.setScale(0, RoundingMode.HALF_UP).intValue();
  }
}
