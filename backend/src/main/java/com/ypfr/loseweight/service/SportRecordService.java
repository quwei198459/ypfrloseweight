package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.SportItem;
import com.ypfr.loseweight.domain.SportRecord;
import com.ypfr.loseweight.mapper.SportItemMapper;
import com.ypfr.loseweight.mapper.SportRecordMapper;
import com.ypfr.loseweight.util.RecordedAtParser;
import com.ypfr.loseweight.web.dto.CreateSportRecordRequest;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class SportRecordService {

  private final SportRecordMapper sportRecordMapper;
  private final SportItemMapper sportItemMapper;
  private final DailySummaryService dailySummaryService;

  public SportRecordService(
      SportRecordMapper sportRecordMapper,
      SportItemMapper sportItemMapper,
      DailySummaryService dailySummaryService) {
    this.sportRecordMapper = sportRecordMapper;
    this.sportItemMapper = sportItemMapper;
    this.dailySummaryService = dailySummaryService;
  }

  public SportRecord create(Long userId, CreateSportRecordRequest req) {
    if (req == null) {
      throw new ApiException(400, "请求体不能为空");
    }
    if (!StringUtils.hasText(req.getSportName())) {
      throw new ApiException(400, "sportName 不能为空");
    }
    if (req.getDurationMin() == null || req.getDurationMin() <= 0) {
      throw new ApiException(400, "durationMin 无效");
    }
    String nameTrim = req.getSportName().trim();
    String n = nameTrim.length() > 64 ? nameTrim.substring(0, 64) : nameTrim;

    SportItem item =
        sportItemMapper.selectOne(
            new LambdaQueryWrapper<SportItem>().eq(SportItem::getName, n).last("LIMIT 1"));

    var rt = RecordedAtParser.parse(req.getRecordedAt());
    SportRecord s = new SportRecord();
    s.setUserId(userId);
    s.setRecordDate(rt.toLocalDate());
    s.setSportItemId(item != null ? item.getId() : null);
    s.setSportNameSnapshot(n);
    s.setIconSnapshot(
        StringUtils.hasText(req.getIcon())
            ? req.getIcon()
            : (item != null ? item.getIcon() : null));
    s.setDurationMin(req.getDurationMin());
    BigDecimal burned;
    if (item != null
        && item.getCaloriesPer60min() != null
        && item.getCaloriesPer60min().compareTo(BigDecimal.ZERO) > 0) {
      // 真值口径：calories_burned = calories_per_60min × duration_min ÷ 60
      burned =
          item.getCaloriesPer60min()
              .multiply(BigDecimal.valueOf(req.getDurationMin()))
              .divide(BigDecimal.valueOf(60), 2, java.math.RoundingMode.HALF_UP);
    } else if (req.getCalories() != null && req.getCalories() >= 0) {
      burned = BigDecimal.valueOf(req.getCalories());
    } else {
      throw new ApiException(400, "calories 无效");
    }
    s.setCaloriesBurned(burned);
    s.setSource("manual");
    s.setRecordTime(rt);
    sportRecordMapper.insert(s);
    try {
      dailySummaryService.updateForDay(userId, rt.toLocalDate());
    } catch (Exception ignored) {
    }
    return sportRecordMapper.selectById(s.getId());
  }

  public void delete(Long userId, Long id) {
    SportRecord s = sportRecordMapper.selectById(id);
    if (s == null) {
      throw new ApiException(404, "记录不存在");
    }
    if (!s.getUserId().equals(userId)) {
      throw new ApiException(403, "无权删除该记录");
    }
    sportRecordMapper.deleteById(id);
    try {
      if (s.getRecordDate() != null) {
        dailySummaryService.updateForDay(userId, s.getRecordDate());
      }
    } catch (Exception ignored) {
    }
  }

  public List<SportRecord> listDay(Long userId, LocalDate day) {
    return sportRecordMapper.selectList(
        new LambdaQueryWrapper<SportRecord>()
            .eq(SportRecord::getUserId, userId)
            .eq(SportRecord::getRecordDate, day)
            .orderByAsc(SportRecord::getRecordTime));
  }
}
