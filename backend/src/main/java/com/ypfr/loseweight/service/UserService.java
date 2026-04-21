package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.DailySummary;
import com.ypfr.loseweight.domain.LoseWeightUser;
import com.ypfr.loseweight.domain.MealRecord;
import com.ypfr.loseweight.domain.UserBudgetConfig;
import com.ypfr.loseweight.domain.UserProfile;
import com.ypfr.loseweight.domain.WeightRecord;
import com.ypfr.loseweight.mapper.DailySummaryMapper;
import com.ypfr.loseweight.mapper.LoseWeightUserMapper;
import com.ypfr.loseweight.mapper.MealRecordMapper;
import com.ypfr.loseweight.mapper.UserBudgetConfigMapper;
import com.ypfr.loseweight.mapper.UserProfileMapper;
import com.ypfr.loseweight.mapper.WeightRecordMapper;
import com.ypfr.loseweight.web.dto.AppUserDto;
import com.ypfr.loseweight.web.dto.UpdateProfileRequest;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class UserService {

  private final LoseWeightUserMapper loseWeightUserMapper;
  private final UserProfileMapper userProfileMapper;
  private final UserBudgetConfigMapper userBudgetConfigMapper;
  private final AvatarStorageService avatarStorageService;
  private final BmiInterpretationService bmiInterpretationService;
  private final MealRecordMapper mealRecordMapper;
  private final DailySummaryMapper dailySummaryMapper;
  private final WeightRecordMapper weightRecordMapper;

  public UserService(
      LoseWeightUserMapper loseWeightUserMapper,
      UserProfileMapper userProfileMapper,
      UserBudgetConfigMapper userBudgetConfigMapper,
      AvatarStorageService avatarStorageService,
      BmiInterpretationService bmiInterpretationService,
      MealRecordMapper mealRecordMapper,
      DailySummaryMapper dailySummaryMapper,
      WeightRecordMapper weightRecordMapper) {
    this.loseWeightUserMapper = loseWeightUserMapper;
    this.userProfileMapper = userProfileMapper;
    this.userBudgetConfigMapper = userBudgetConfigMapper;
    this.avatarStorageService = avatarStorageService;
    this.bmiInterpretationService = bmiInterpretationService;
    this.mealRecordMapper = mealRecordMapper;
    this.dailySummaryMapper = dailySummaryMapper;
    this.weightRecordMapper = weightRecordMapper;
  }

  public AppUserDto getUser(Long id) {
    LoseWeightUser u = loseWeightUserMapper.selectById(id);
    if (u == null) {
      throw new ApiException(404, "用户不存在");
    }
    UserProfile p = userProfileMapper.selectOne(new LambdaQueryWrapper<UserProfile>().eq(UserProfile::getUserId, id));
    UserBudgetConfig b = loadLatestBudget(id);
    return toDto(u, p, b);
  }

  public UserBudgetConfig loadLatestBudget(Long userId) {
    return userBudgetConfigMapper.selectOne(
        new LambdaQueryWrapper<UserBudgetConfig>()
            .eq(UserBudgetConfig::getUserId, userId)
            .orderByDesc(UserBudgetConfig::getEffectiveDate)
            .orderByDesc(UserBudgetConfig::getId)
            .last("LIMIT 1"));
  }

  public AppUserDto updateProfile(Long userId, UpdateProfileRequest req) {
    if (req == null) {
      throw new ApiException(400, "请求体不能为空");
    }
    LoseWeightUser u = loseWeightUserMapper.selectById(userId);
    if (u == null) {
      throw new ApiException(404, "用户不存在");
    }
    UserProfile p = ensureProfile(userId);
    UserBudgetConfig b = ensureBudget(userId);

    final boolean hadInitialWeight = p.getInitialWeightKg() != null;

    if (StringUtils.hasText(req.getNickname())) {
      String n = req.getNickname().trim();
      u.setNickname(n.length() > 64 ? n.substring(0, 64) : n);
    }
    if (req.getGender() != null && req.getGender() >= 0 && req.getGender() <= 2) {
      p.setGender(req.getGender());
    }
    if (req.getAge() != null && req.getAge() > 0) {
      p.setAge(req.getAge());
    }
    if (req.getHeightCm() != null && req.getHeightCm().doubleValue() > 0) {
      p.setHeightCm(req.getHeightCm());
    }
    if (req.getCurrentWeightKg() != null && req.getCurrentWeightKg().doubleValue() > 0) {
      p.setCurrentWeightKg(req.getCurrentWeightKg());
    }
    if (req.getTargetWeightKg() != null && req.getTargetWeightKg().doubleValue() > 0) {
      p.setTargetWeightKg(req.getTargetWeightKg());
    }
    if (req.getInitialWeightKg() != null && req.getInitialWeightKg().doubleValue() > 0) {
      p.setInitialWeightKg(req.getInitialWeightKg());
    }
    if (StringUtils.hasText(req.getTargetDate())) {
      try {
        p.setTargetDate(LocalDate.parse(req.getTargetDate().trim()));
      } catch (Exception e) {
        throw new ApiException(400, "目标日期格式无效，需 yyyy-MM-dd");
      }
    }
    if (req.getActivityLevel() != null) {
      int al = req.getActivityLevel();
      if (al >= 1 && al <= 5) {
        b.setActivityLevel(CalorieBudgetCalculator.activityDecimalFromTier(al));
      }
    }
    if (req.getUseCustomBmr() != null) {
      int use = req.getUseCustomBmr();
      if (use == 0) {
        b.setUseCustomBmr(0);
        b.setCustomBmr(null);
      } else if (use == 1) {
        if (req.getCustomBmr() == null || req.getCustomBmr().doubleValue() <= 0) {
          throw new ApiException(400, "自定义基础代谢须大于 0");
        }
        b.setUseCustomBmr(1);
        b.setCustomBmr(req.getCustomBmr().setScale(2, java.math.RoundingMode.HALF_UP));
      } else {
        throw new ApiException(400, "useCustomBmr 仅支持 0/1");
      }
    } else if (req.getCustomBmr() != null) {
      if (req.getCustomBmr().doubleValue() <= 0) {
        throw new ApiException(400, "自定义基础代谢须大于 0");
      }
      b.setUseCustomBmr(1);
      b.setCustomBmr(req.getCustomBmr().setScale(2, java.math.RoundingMode.HALF_UP));
    }
    if (StringUtils.hasText(req.getAvatarBase64())) {
      avatarStorageService.saveUserAvatar(userId, req.getAvatarBase64());
      u.setAvatar("/api/v1/public/avatars/" + userId);
    }

    if (!hadInitialWeight
        && p.getInitialWeightKg() == null
        && p.getCurrentWeightKg() != null
        && p.getCurrentWeightKg().doubleValue() > 0
        && computeProfileComplete(u, p)) {
      p.setInitialWeightKg(p.getCurrentWeightKg());
    }

    CalorieBudgetCalculator.applyToProfileAndBudget(p, b, LocalDate.now());

    p.setProfileCompleted(computeProfileComplete(u, p) ? 1 : 0);
    loseWeightUserMapper.updateById(u);
    userProfileMapper.updateById(p);
    userBudgetConfigMapper.updateById(b);
    return getUser(userId);
  }

  /** 保证存在 user_profile 行（登录后应已存在） */
  public UserProfile ensureProfile(Long userId) {
    UserProfile p =
        userProfileMapper.selectOne(new LambdaQueryWrapper<UserProfile>().eq(UserProfile::getUserId, userId));
    if (p != null) {
      return p;
    }
    p = new UserProfile();
    p.setUserId(userId);
    p.setGender(0);
    p.setProfileCompleted(0);
    userProfileMapper.insert(p);
    return userProfileMapper.selectOne(new LambdaQueryWrapper<UserProfile>().eq(UserProfile::getUserId, userId));
  }

  public UserBudgetConfig ensureBudget(Long userId) {
    UserBudgetConfig b = loadLatestBudget(userId);
    if (b != null) {
      return b;
    }
    b = new UserBudgetConfig();
    b.setUserId(userId);
    b.setUseCustomBmr(0);
    b.setActivityLevel(CalorieBudgetCalculator.activityDecimalFromTier(2));
    b.setEffectiveDate(LocalDate.now());
    userBudgetConfigMapper.insert(b);
    return loadLatestBudget(userId);
  }

  public static boolean computeProfileComplete(LoseWeightUser u, UserProfile p) {
    if (u == null || p == null) {
      return false;
    }
    if (!StringUtils.hasText(u.getNickname()) || u.getNickname().trim().isEmpty()) {
      return false;
    }
    if (p.getGender() == null || (p.getGender() != 1 && p.getGender() != 2)) {
      return false;
    }
    if (p.getAge() == null || p.getAge() <= 0) {
      return false;
    }
    if (p.getHeightCm() == null || p.getHeightCm().doubleValue() <= 0) {
      return false;
    }
    if (p.getCurrentWeightKg() == null || p.getCurrentWeightKg().doubleValue() <= 0) {
      return false;
    }
    if (p.getTargetWeightKg() == null || p.getTargetWeightKg().doubleValue() <= 0) {
      return false;
    }
    return p.getTargetDate() != null;
  }

  private AppUserDto toDto(LoseWeightUser u, UserProfile p, UserBudgetConfig b) {
    AppUserDto d = new AppUserDto();
    d.setId(u.getId());
    d.setNickname(u.getNickname());
    d.setAvatarUrl(u.getAvatar());
    d.setPhone(u.getPhone());
    if (p != null) {
      d.setProfileCompleted(
          p.getProfileCompleted() != null && p.getProfileCompleted() == 1
              ? Boolean.TRUE
              : Boolean.FALSE);
      if (p.getProfileCompleted() == null && computeProfileComplete(u, p)) {
        d.setProfileCompleted(Boolean.TRUE);
      }
      d.setGender(p.getGender());
      d.setAge(p.getAge());
      d.setHeightCm(p.getHeightCm());
      d.setCurrentWeightKg(p.getCurrentWeightKg());
      d.setTargetWeightKg(p.getTargetWeightKg());
      d.setInitialWeightKg(p.getInitialWeightKg());
      d.setTargetDate(p.getTargetDate());
      d.setBmiInterpretation(
          bmiInterpretationService.resolveInterpretationText(
              p.getHeightCm(), p.getCurrentWeightKg()));
    } else {
      d.setProfileCompleted(Boolean.FALSE);
      d.setBmiInterpretation(null);
    }
    if (b != null) {
      if (b.getCalculatedBmr() != null) {
        d.setBmr(b.getCalculatedBmr().intValue());
      }
      if (b.getCalculatedTdee() != null) {
        d.setTdee(b.getCalculatedTdee().intValue());
      }
      if (b.getDailyBudget() != null) {
        d.setDailyCalorieGoal(b.getDailyBudget().intValue());
      }
      d.setActivityLevel(CalorieBudgetCalculator.tierFromActivityDecimal(b.getActivityLevel()));
    } else {
      d.setActivityLevel(CalorieBudgetCalculator.normalizedActivityLevel(null));
    }
    attachMineStats(d, u.getId(), u);
    return d;
  }

  private static int capInt(long v) {
    if (v > Integer.MAX_VALUE) {
      return Integer.MAX_VALUE;
    }
    if (v < Integer.MIN_VALUE) {
      return Integer.MIN_VALUE;
    }
    return (int) v;
  }

  /**
   * 「我的」页统计：餐次条数、未超预算且有摄入的天数、加入天数、最近称重距今天数。
   */
  private void attachMineStats(AppUserDto d, Long userId, LoseWeightUser u) {
    long mealCnt =
        mealRecordMapper.selectCount(
            new LambdaQueryWrapper<MealRecord>().eq(MealRecord::getUserId, userId));
    d.setMealRecordCount(capInt(mealCnt));

    long healthyCnt =
        dailySummaryMapper.selectCount(
            new LambdaQueryWrapper<DailySummary>()
                .eq(DailySummary::getUserId, userId)
                .and(
                    w ->
                        w.eq(DailySummary::getHealthyDietFlag, 1)
                            .or(
                                w2 ->
                                    w2.gt(DailySummary::getIntakeCalories, BigDecimal.ZERO)
                                        .isNotNull(DailySummary::getRemainCalories)
                                        .ge(DailySummary::getRemainCalories, BigDecimal.ZERO))));
    d.setHealthyDietDays(capInt(healthyCnt));

    if (u.getCreatedAt() != null) {
      long jd = ChronoUnit.DAYS.between(u.getCreatedAt().toLocalDate(), LocalDate.now()) + 1;
      d.setJoinedDays((int) Math.min(Math.max(jd, 1L), Integer.MAX_VALUE));
    }

    WeightRecord wr =
        weightRecordMapper.selectOne(
            new LambdaQueryWrapper<WeightRecord>()
                .eq(WeightRecord::getUserId, userId)
                .orderByDesc(WeightRecord::getRecordDate)
                .orderByDesc(WeightRecord::getId)
                .last("LIMIT 1"));
    if (wr != null && wr.getRecordDate() != null) {
      int ago = (int) ChronoUnit.DAYS.between(wr.getRecordDate(), LocalDate.now());
      d.setWeightRecordedDaysAgo(Math.max(0, ago));
    } else {
      d.setWeightRecordedDaysAgo(null);
    }
  }
}
