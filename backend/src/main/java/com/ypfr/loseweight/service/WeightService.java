package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.UserBudgetConfig;
import com.ypfr.loseweight.domain.UserProfile;
import com.ypfr.loseweight.domain.WeightRecord;
import com.ypfr.loseweight.mapper.UserBudgetConfigMapper;
import com.ypfr.loseweight.mapper.UserProfileMapper;
import com.ypfr.loseweight.mapper.WeightRecordMapper;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class WeightService {

  private final WeightRecordMapper weightRecordMapper;
  private final UserProfileMapper userProfileMapper;
  private final UserBudgetConfigMapper userBudgetConfigMapper;
  private final UserService userService;
  private final DailySummaryService dailySummaryService;

  public WeightService(
      WeightRecordMapper weightRecordMapper,
      UserProfileMapper userProfileMapper,
      UserBudgetConfigMapper userBudgetConfigMapper,
      UserService userService,
      DailySummaryService dailySummaryService) {
    this.weightRecordMapper = weightRecordMapper;
    this.userProfileMapper = userProfileMapper;
    this.userBudgetConfigMapper = userBudgetConfigMapper;
    this.userService = userService;
    this.dailySummaryService = dailySummaryService;
  }

  public List<WeightRecord> listRecent(Long userId, int limit) {
    return weightRecordMapper.selectList(
        new LambdaQueryWrapper<WeightRecord>()
            .eq(WeightRecord::getUserId, userId)
            .orderByDesc(WeightRecord::getRecordDate)
            .last("LIMIT " + limit));
  }

  public WeightRecord upsert(Long userId, String recordDateIso, BigDecimal weightKg) {
    if (!StringUtils.hasText(recordDateIso)) {
      throw new ApiException(400, "recordDate 必填，格式 yyyy-MM-dd");
    }
    if (weightKg == null || weightKg.doubleValue() <= 0) {
      throw new ApiException(400, "weightKg 无效");
    }
    LocalDate recordDate;
    try {
      recordDate = LocalDate.parse(recordDateIso.trim());
    } catch (Exception e) {
      throw new ApiException(400, "recordDate 格式无效");
    }
    WeightRecord existing =
        weightRecordMapper.selectOne(
            new LambdaQueryWrapper<WeightRecord>()
                .eq(WeightRecord::getUserId, userId)
                .eq(WeightRecord::getRecordDate, recordDate));
    if (existing != null) {
      existing.setWeightKg(weightKg);
      weightRecordMapper.updateById(existing);
      syncProfileCurrentWeight(userId, recordDate, weightKg);
      return weightRecordMapper.selectById(existing.getId());
    }
    WeightRecord n = new WeightRecord();
    n.setUserId(userId);
    n.setRecordDate(recordDate);
    n.setWeightKg(weightKg);
    n.setSource("manual");
    weightRecordMapper.insert(n);
    syncProfileCurrentWeight(userId, recordDate, weightKg);
    return weightRecordMapper.selectById(n.getId());
  }

  private void syncProfileCurrentWeight(Long userId, LocalDate recordDate, BigDecimal weightKg) {
    if (!recordDate.equals(LocalDate.now())) {
      return;
    }
    UserProfile p =
        userProfileMapper.selectOne(
            new LambdaQueryWrapper<UserProfile>().eq(UserProfile::getUserId, userId));
    if (p == null) {
      return;
    }
    UserBudgetConfig b = userService.loadLatestBudget(userId);
    if (b == null) {
      userService.ensureBudget(userId);
      b = userService.loadLatestBudget(userId);
    }
    if (b == null) {
      return;
    }
    p.setCurrentWeightKg(weightKg);
    CalorieBudgetCalculator.applyToProfileAndBudget(p, b, LocalDate.now());
    userProfileMapper.updateById(p);
    userBudgetConfigMapper.updateById(b);
    try {
      dailySummaryService.updateForDay(userId, LocalDate.now());
    } catch (Exception ignored) {
    }
  }
}
