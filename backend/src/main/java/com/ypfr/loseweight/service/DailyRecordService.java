package com.ypfr.loseweight.service;

import com.ypfr.loseweight.domain.DietRecordRow;
import com.ypfr.loseweight.domain.SportRecord;
import com.ypfr.loseweight.domain.UserBudgetConfig;
import com.ypfr.loseweight.mapper.DietRecordMapper;
import com.ypfr.loseweight.mapper.SportRecordMapper;
import com.ypfr.loseweight.web.dto.DailyMacroDto;
import com.ypfr.loseweight.web.dto.DailyRecordDto;
import com.ypfr.loseweight.web.dto.DailyRecordItemDto;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class DailyRecordService {

  private static final DateTimeFormatter ISO_TS = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

  private final DietRecordMapper dietRecordMapper;
  private final SportRecordMapper sportRecordMapper;
  private final MealRecordService mealRecordService;
  private final SportRecordService sportRecordService;
  private final UserService userService;

  public DailyRecordService(
      DietRecordMapper dietRecordMapper,
      SportRecordMapper sportRecordMapper,
      MealRecordService mealRecordService,
      SportRecordService sportRecordService,
      UserService userService) {
    this.dietRecordMapper = dietRecordMapper;
    this.sportRecordMapper = sportRecordMapper;
    this.mealRecordService = mealRecordService;
    this.sportRecordService = sportRecordService;
    this.userService = userService;
  }

  public DailyRecordDto getDay(Long userId, LocalDate day) {
    BigDecimal intake = dietRecordMapper.sumCaloriesByUserAndDate(userId, day);
    BigDecimal sport = sportRecordMapper.sumCaloriesByUserAndDate(userId, day);

    List<DietRecordRow> diets = mealRecordService.listDietDay(userId, day);
    List<SportRecord> sports = sportRecordService.listDay(userId, day);

    DailyMacroDto macros = new DailyMacroDto();
    double p = 0;
    double f = 0;
    double c = 0;
    for (DietRecordRow m : diets) {
      p += bd(m.getProteinTotalG());
      f += bd(m.getFatTotalG());
      c += bd(m.getCarbTotalG());
    }
    macros.setProteinG(round1(p));
    macros.setFatG(round1(f));
    macros.setCarbsG(round1(c));
    fillMacroTargets(userId, macros);

    List<DailyRecordItemDto> timeline = new ArrayList<>();
    for (DietRecordRow m : diets) {
      timeline.add(toMealItem(m));
    }
    for (SportRecord s : sports) {
      timeline.add(toSportItem(s));
    }
    timeline.sort(
        Comparator.comparing(
                DailyRecordItemDto::getRecordedAt, Comparator.nullsLast(String::compareTo))
            .reversed());

    DailyRecordDto dto = new DailyRecordDto();
    dto.setDate(day.toString());
    dto.setIntakeCalories(intake != null ? intake.setScale(0, RoundingMode.HALF_UP).intValue() : 0);
    dto.setSportCalories(sport != null ? sport.setScale(0, RoundingMode.HALF_UP).intValue() : 0);
    dto.setMacros(macros);
    dto.setTimeline(timeline);
    return dto;
  }

  private static DailyRecordItemDto toMealItem(DietRecordRow m) {
    DailyRecordItemDto d = new DailyRecordItemDto();
    d.setKind("meal");
    d.setId(m.getId());
    d.setRecordedAt(m.getRecordTime() != null ? ISO_TS.format(m.getRecordTime()) : null);
    d.setTitle(mealTitleCn(m.getMealType()) + " · " + m.getFoodNameSnapshot());

    String sub = "";
    if (m.getAmount() != null && m.getAmountUnit() != null) {
      sub = m.getAmount().stripTrailingZeros().toPlainString() + " " + m.getAmountUnit();
    }
    if (m.getCaloriesTotal() != null) {
      if (!sub.isEmpty()) {
        sub += " · ";
      }
      sub += m.getCaloriesTotal().setScale(0, RoundingMode.HALF_UP).intValue() + " 千卡";
    }
    d.setSubtitle(sub);
    d.setCalories(
        m.getCaloriesTotal() != null
            ? m.getCaloriesTotal().setScale(0, RoundingMode.HALF_UP).intValue()
            : 0);
    return d;
  }

  private static DailyRecordItemDto toSportItem(SportRecord s) {
    DailyRecordItemDto d = new DailyRecordItemDto();
    d.setKind("sport");
    d.setId(s.getId());
    d.setRecordedAt(s.getRecordTime() != null ? ISO_TS.format(s.getRecordTime()) : null);
    d.setTitle("运动 · " + s.getSportNameSnapshot());

    String sub = "";
    if (s.getDurationMin() != null) {
      sub = s.getDurationMin() + " 分钟";
    }
    if (s.getCaloriesBurned() != null) {
      if (!sub.isEmpty()) {
        sub += " · ";
      }
      sub += "消耗 " + s.getCaloriesBurned().setScale(0, RoundingMode.HALF_UP).intValue() + " 千卡";
    }
    d.setSubtitle(sub);
    d.setCalories(
        s.getCaloriesBurned() != null
            ? s.getCaloriesBurned().setScale(0, RoundingMode.HALF_UP).intValue()
            : 0);
    return d;
  }

  private static String mealTitleCn(String type) {
    if (type == null) {
      return "饮食";
    }
    return switch (type) {
      case "breakfast" -> "早餐";
      case "lunch" -> "午餐";
      case "dinner" -> "晚餐";
      case "snack" -> "加餐";
      default -> "饮食";
    };
  }

  private static double bd(java.math.BigDecimal x) {
    return x == null ? 0 : x.doubleValue();
  }

  private static double round1(double v) {
    return Math.round(v * 10.0) / 10.0;
  }

  private void fillMacroTargets(Long userId, DailyMacroDto macros) {
    double ct = 250;
    double ft = 60;
    double pt = 90;
    UserBudgetConfig b = userService.loadLatestBudget(userId);
    if (b != null) {
      if (b.getCarbTargetG() != null && b.getCarbTargetG().doubleValue() > 0) {
        ct = b.getCarbTargetG().doubleValue();
      }
      if (b.getFatTargetG() != null && b.getFatTargetG().doubleValue() > 0) {
        ft = b.getFatTargetG().doubleValue();
      }
      if (b.getProteinTargetG() != null && b.getProteinTargetG().doubleValue() > 0) {
        pt = b.getProteinTargetG().doubleValue();
      }
    }
    macros.setCarbTargetG(round1(ct));
    macros.setFatTargetG(round1(ft));
    macros.setProteinTargetG(round1(pt));
  }
}
