package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.domain.DailySummary;
import com.ypfr.loseweight.domain.UserBudgetConfig;
import com.ypfr.loseweight.mapper.DailySummaryMapper;
import com.ypfr.loseweight.mapper.DietRecordMapper;
import com.ypfr.loseweight.mapper.SportRecordMapper;
import com.ypfr.loseweight.mapper.row.StatDateMacros;
import com.ypfr.loseweight.mapper.row.StatDateMealWindow;
import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDate;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class DailySummaryService {

  private final DailySummaryMapper dailySummaryMapper;
  private final DietRecordMapper dietRecordMapper;
  private final SportRecordMapper sportRecordMapper;
  private final UserService userService;

  public DailySummaryService(
      DailySummaryMapper dailySummaryMapper,
      DietRecordMapper dietRecordMapper,
      SportRecordMapper sportRecordMapper,
      UserService userService) {
    this.dailySummaryMapper = dailySummaryMapper;
    this.dietRecordMapper = dietRecordMapper;
    this.sportRecordMapper = sportRecordMapper;
    this.userService = userService;
  }

  /**
   * 对某日进行 daily_summary 汇总写入。
   *
   * 调用方在 try/catch 中吞异常时，可实现「汇总失败不影响主业务」。
   */
  public void updateForDay(Long userId, LocalDate day) {
    if (userId == null || day == null) return;

    BigDecimal intake = nullSafeBd(dietRecordMapper.sumCaloriesByUserAndDate(userId, day));
    BigDecimal sport = nullSafeBd(sportRecordMapper.sumCaloriesByUserAndDate(userId, day));

    List<StatDateMacros> macrosRows = dietRecordMapper.sumMacrosByDateRange(userId, day, day);
    StatDateMacros mr = (macrosRows == null || macrosRows.isEmpty()) ? null : macrosRows.get(0);

    List<StatDateMealWindow> winRows =
        dietRecordMapper.selectMealWindowsByDateRange(userId, day, day);
    StatDateMealWindow w = (winRows == null || winRows.isEmpty()) ? null : winRows.get(0);

    // eating window：首餐到末餐（小时）
    BigDecimal eatingHours = null;
    if (w != null && w.getFirstAt() != null && w.getLastAt() != null) {
      long minutes = Duration.between(w.getFirstAt(), w.getLastAt()).toMinutes();
      double hours = Math.max(0, minutes) / 60.0;
      if (hours < 1e-6 && minutes >= 0) {
        // 若只有一条记录，尽量给一个“非 0 的视觉合理值”
        hours = 0.25;
      }
      eatingHours = BigDecimal.valueOf(round2(hours));
    }

    BigDecimal proteinG = mr != null ? mr.getProteinG() : null;
    BigDecimal fatG = mr != null ? mr.getFatG() : null;
    BigDecimal carbsG = mr != null ? mr.getCarbsG() : null;

    UserBudgetConfig budget = userService.loadLatestBudget(userId);
    BigDecimal dailyBudget = budget != null ? budget.getDailyBudget() : null;
    BigDecimal tdee = budget != null ? budget.getCalculatedTdee() : null;
    BigDecimal carbTarget = budget != null ? budget.getCarbTargetG() : null;
    BigDecimal proteinTarget = budget != null ? budget.getProteinTargetG() : null;
    BigDecimal fatTarget = budget != null ? budget.getFatTargetG() : null;
    BigDecimal remain = null;
    BigDecimal budgetDeficit = null;
    BigDecimal actualDeficit = null;
    if (dailyBudget != null) {
      remain = dailyBudget.subtract(intake).add(sport).setScale(2, java.math.RoundingMode.HALF_UP);
      budgetDeficit = remain;
    }
    if (tdee != null) {
      actualDeficit = tdee.add(sport).subtract(intake).setScale(2, java.math.RoundingMode.HALF_UP);
    }

    boolean hasAny =
        intake.compareTo(BigDecimal.ZERO) != 0
            || sport.compareTo(BigDecimal.ZERO) != 0
            || (proteinG != null && proteinG.compareTo(BigDecimal.ZERO) != 0)
            || (fatG != null && fatG.compareTo(BigDecimal.ZERO) != 0)
            || (carbsG != null && carbsG.compareTo(BigDecimal.ZERO) != 0)
            || (eatingHours != null && eatingHours.compareTo(BigDecimal.ZERO) != 0)
            || dailyBudget != null;

    DailySummary existing =
        dailySummaryMapper.selectOne(
            new LambdaQueryWrapper<DailySummary>()
                .eq(DailySummary::getUserId, userId)
                .eq(DailySummary::getSummaryDate, day));

    if (!hasAny) {
      if (existing != null) {
        dailySummaryMapper.deleteById(existing.getId());
      }
      return;
    }

    if (existing == null) {
      DailySummary n = new DailySummary();
      n.setUserId(userId);
      n.setSummaryDate(day);
      n.setIntakeCalories(intake);
      n.setExerciseCalories(sport);
      n.setDailyBudget(dailyBudget);
      n.setRemainCalories(remain);
      n.setBudgetDeficitCalories(budgetDeficit);
      n.setActualDeficitCalories(actualDeficit);
      n.setProteinTotalG(proteinG);
      n.setFatTotalG(fatG);
      n.setCarbTotalG(carbsG);
      n.setProteinTargetG(proteinTarget);
      n.setFatTargetG(fatTarget);
      n.setCarbTargetG(carbTarget);
      n.setEatingWindowHours(eatingHours);
      n.setHealthyDietFlag(0);
      n.setDayStatus("normal");
      if (w != null) {
        n.setFirstMealTime(w.getFirstAt());
        n.setLastMealTime(w.getLastAt());
      }
      dailySummaryMapper.insert(n);
      return;
    }

    existing.setIntakeCalories(intake);
    existing.setExerciseCalories(sport);
    existing.setDailyBudget(dailyBudget);
    existing.setRemainCalories(remain);
    existing.setBudgetDeficitCalories(budgetDeficit);
    existing.setActualDeficitCalories(actualDeficit);
    existing.setProteinTotalG(proteinG);
    existing.setFatTotalG(fatG);
    existing.setCarbTotalG(carbsG);
    existing.setProteinTargetG(proteinTarget);
    existing.setFatTargetG(fatTarget);
    existing.setCarbTargetG(carbTarget);
    existing.setEatingWindowHours(eatingHours);
    if (w != null) {
      existing.setFirstMealTime(w.getFirstAt());
      existing.setLastMealTime(w.getLastAt());
    }
    dailySummaryMapper.updateById(existing);
  }

  private static BigDecimal nullSafeBd(BigDecimal v) {
    return v == null ? BigDecimal.ZERO : v;
  }

  private static double round2(double v) {
    return Math.round(v * 100.0) / 100.0;
  }
}

