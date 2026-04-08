package com.ypfr.loseweight.service;

import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.DailySummary;
import com.ypfr.loseweight.domain.LoseWeightUser;
import com.ypfr.loseweight.domain.UserBudgetConfig;
import com.ypfr.loseweight.mapper.DailySummaryMapper;
import com.ypfr.loseweight.mapper.DietRecordMapper;
import com.ypfr.loseweight.mapper.LoseWeightUserMapper;
import com.ypfr.loseweight.mapper.SportRecordMapper;
import com.ypfr.loseweight.web.dto.DashboardDto;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;

@Service
public class DashboardService {

  private final LoseWeightUserMapper loseWeightUserMapper;
  private final DailySummaryMapper dailySummaryMapper;
  private final DietRecordMapper dietRecordMapper;
  private final SportRecordMapper sportRecordMapper;
  private final UserService userService;

  public DashboardService(
      LoseWeightUserMapper loseWeightUserMapper,
      DailySummaryMapper dailySummaryMapper,
      DietRecordMapper dietRecordMapper,
      SportRecordMapper sportRecordMapper,
      UserService userService) {
    this.loseWeightUserMapper = loseWeightUserMapper;
    this.dailySummaryMapper = dailySummaryMapper;
    this.dietRecordMapper = dietRecordMapper;
    this.sportRecordMapper = sportRecordMapper;
    this.userService = userService;
  }

  /** 剩余热量 = 每日目标 - 摄入 + 运动消耗 */
  public DashboardDto getDashboard(Long userId, LocalDate day) {
    LoseWeightUser user = loseWeightUserMapper.selectById(userId);
    if (user == null) {
      throw new ApiException(404, "用户不存在");
    }
    DailySummary summary =
        dailySummaryMapper.selectOne(
            new LambdaQueryWrapper<DailySummary>()
                .eq(DailySummary::getUserId, userId)
                .eq(DailySummary::getSummaryDate, day)
                .last("LIMIT 1"));
    int intake = 0;
    int sport = 0;
    int goal = 1600;
    int remaining = 1600;
    if (summary != null) {
      intake = toInt(summary.getIntakeCalories());
      sport = toInt(summary.getExerciseCalories());
      if (summary.getDailyBudget() != null) {
        goal = toInt(summary.getDailyBudget());
      }
      if (summary.getRemainCalories() != null) {
        remaining = toInt(summary.getRemainCalories());
      } else {
        remaining = goal - intake + sport;
      }
    } else {
      UserBudgetConfig b = userService.loadLatestBudget(userId);
      if (b != null && b.getDailyBudget() != null && b.getDailyBudget().doubleValue() > 0) {
        goal = b.getDailyBudget().intValue();
      }
      BigDecimal intakeBd = dietRecordMapper.sumCaloriesByUserAndDate(userId, day);
      BigDecimal sportBd = sportRecordMapper.sumCaloriesByUserAndDate(userId, day);
      intake = intakeBd != null ? intakeBd.setScale(0, RoundingMode.HALF_UP).intValue() : 0;
      sport = sportBd != null ? sportBd.setScale(0, RoundingMode.HALF_UP).intValue() : 0;
      remaining = goal - intake + sport;
    }

    DashboardDto dto = new DashboardDto();
    dto.setIntakeCalories(intake);
    dto.setSportCalories(sport);
    dto.setDailyBudget(goal);
    dto.setRemainingCalories(remaining);
    return dto;
  }

  private static int toInt(BigDecimal val) {
    return val == null ? 0 : val.setScale(0, RoundingMode.HALF_UP).intValue();
  }
}
