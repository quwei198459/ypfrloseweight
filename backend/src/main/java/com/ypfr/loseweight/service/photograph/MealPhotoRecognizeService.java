package com.ypfr.loseweight.service.photograph;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.DietRecordRow;
import com.ypfr.loseweight.domain.MealPhotoRecognition;
import com.ypfr.loseweight.domain.MealRecord;
import com.ypfr.loseweight.mapper.DietRecordMapper;
import com.ypfr.loseweight.mapper.MealPhotoRecognitionMapper;
import com.ypfr.loseweight.mapper.MealRecordMapper;
import com.ypfr.loseweight.service.AliyunFoodCalorieClient;
import com.ypfr.loseweight.service.ApiUsageLogger;
import com.ypfr.loseweight.service.DeepSeekUsageContext;
import com.ypfr.loseweight.service.PhotoRecognitionAccessService;
import com.ypfr.loseweight.service.DailySummaryService;
import com.ypfr.loseweight.service.DashboardService;
import com.ypfr.loseweight.web.dto.DashboardDto;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoConfirmItemDto;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoConfirmRequest;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoConfirmResponseVo;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoFoodItemVo;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoRecognizeResultVo;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoSubmitRequest;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.Set;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class MealPhotoRecognizeService {

  private static final Set<String> MEAL_TYPES =
      Set.of("breakfast", "lunch", "dinner", "snack");

  private static final Set<String> NON_FOOD_RECOGNITION_NAMES =
      Set.of("碳水化合物", "蛋白质", "脂肪", "膳食纤维", "钠");

  private final MealPhotoRecognitionMapper mealPhotoRecognitionMapper;
  private final MealRecordMapper mealRecordMapper;
  private final DietRecordMapper dietRecordMapper;
  private final AliyunFoodCalorieClient aliyunFoodCalorieClient;
  private final MealPhotoAliyunJsonParser aliyunJsonParser;
  private final DashboardService dashboardService;
  private final DailySummaryService dailySummaryService;
  private final PhotoRecognitionAccessService photoRecognitionAccessService;
  private final MealPhotoRecommendService recommendService;
  private final ApiUsageLogger apiUsageLogger;

  public MealPhotoRecognizeService(
      MealPhotoRecognitionMapper mealPhotoRecognitionMapper,
      MealRecordMapper mealRecordMapper,
      DietRecordMapper dietRecordMapper,
      AliyunFoodCalorieClient aliyunFoodCalorieClient,
      MealPhotoAliyunJsonParser aliyunJsonParser,
      DashboardService dashboardService,
      DailySummaryService dailySummaryService,
      PhotoRecognitionAccessService photoRecognitionAccessService,
      MealPhotoRecommendService recommendService,
      ApiUsageLogger apiUsageLogger) {
    this.mealPhotoRecognitionMapper = mealPhotoRecognitionMapper;
    this.mealRecordMapper = mealRecordMapper;
    this.dietRecordMapper = dietRecordMapper;
    this.aliyunFoodCalorieClient = aliyunFoodCalorieClient;
    this.aliyunJsonParser = aliyunJsonParser;
    this.dashboardService = dashboardService;
    this.dailySummaryService = dailySummaryService;
    this.photoRecognitionAccessService = photoRecognitionAccessService;
    this.recommendService = recommendService;
    this.apiUsageLogger = apiUsageLogger;
  }

  public MealPhotoRecognizeResultVo submit(Long userId, MealPhotoSubmitRequest req) {
    LocalDate recordDate = parseRecordDate(req.getRecordDate());
    String source = normalizeSource(req.getSource());
    String chosenMeal = normalizeMealType(req.getMealType());
    String recommended = MealRecommendedMealTypeUtil.recommend(LocalTime.now());
    if (!StringUtils.hasText(chosenMeal)) {
      chosenMeal = recommended;
    }

    MealPhotoRecognition row = new MealPhotoRecognition();
    row.setUserId(userId);
    row.setMealType(chosenMeal);
    row.setRecommendedMealType(recommended);
    row.setRecordDate(recordDate);
    row.setSource(source);
    row.setVendor("aliyun");
    row.setRecognizeStatus("uploading");
    row.setConfirmStatus("none");
    row.setRecommendedEatRatio(BigDecimal.ONE);
    if (StringUtils.hasText(req.getImageUrl())) {
      String u = req.getImageUrl().trim();
      row.setImageUrl(u.length() > 1024 ? u.substring(0, 1024) : u);
    }
    mealPhotoRecognitionMapper.insert(row);
    photoRecognitionAccessService.consumeQuota(userId, row.getId());

    row.setRecognizeStatus("recognizing");
    mealPhotoRecognitionMapper.updateById(row);

    try {
      ResponseEntity<String> resp =
          aliyunFoodCalorieClient.query(
              StringUtils.hasText(req.getImageBase64()) ? req.getImageBase64() : null,
              StringUtils.hasText(req.getImageUrl()) ? req.getImageUrl() : null);
      String body = resp.getBody() != null ? resp.getBody() : "";
      row.setRawResult(body);
      if (resp.getStatusCode().is2xxSuccessful()) {
        Optional<String> vendorFail = aliyunJsonParser.readVendorFailureReason(body);
        if (vendorFail.isPresent()) {
          row.setRecognizeStatus("fail");
          row.setErrorCode("ALIYUN_VENDOR");
          row.setErrorMessage(truncate(vendorFail.get(), 512));
          row.setConfirmStatus("none");
          row.setParsedResultJson("[]");
          mealPhotoRecognitionMapper.updateById(row);
          apiUsageLogger.record(
              ApiUsageLogger.PROVIDER_FOOD, "food", userId, row.getId(), false, vendorFail.get());
          return buildResultVo(row, List.of(), row.getErrorCode(), row.getErrorMessage());
        }
        List<MealPhotoFoodItemVo> foods =
            filterRecognizedFoods(aliyunJsonParser.parseFoods(body));
        row.setParsedResultJson(aliyunJsonParser.toJson(foods));
        row.setResultType("candidate_foods");
        row.setRecognizeStatus("success");
        row.setConfirmStatus("pending_confirm");
        fillRecognizedSnapshots(row, foods);
        apiUsageLogger.record(ApiUsageLogger.PROVIDER_FOOD, "food", userId, row.getId(), true, null);
        // DeepSeek 个性化推荐（比例 + 用语）；失败/未配置则保持默认 100%
        DeepSeekUsageContext.set(userId, row.getId());
        MealPhotoRecommendService.Result rec;
        try {
          rec = recommendService.recommend(foods, chosenMeal);
        } finally {
          DeepSeekUsageContext.clear();
        }
        if (rec != null) {
          row.setRecommendedEatRatio(BigDecimal.valueOf(rec.ratio()));
        }
        mealPhotoRecognitionMapper.updateById(row);
        MealPhotoRecognizeResultVo vo = buildResultVo(row, foods, null, null);
        if (rec != null) {
          vo.setRecommendText(rec.text());
        }
        return vo;
      }
      row.setRecognizeStatus("fail");
      row.setErrorCode("VENDOR_HTTP_" + resp.getStatusCode().value());
      row.setErrorMessage(truncate("识图服务返回非成功状态", 512));
      row.setConfirmStatus("none");
      mealPhotoRecognitionMapper.updateById(row);
      apiUsageLogger.record(
          ApiUsageLogger.PROVIDER_FOOD, "food", userId, row.getId(), false, row.getErrorCode());
      return buildResultVo(row, List.of(), row.getErrorCode(), row.getErrorMessage());
    } catch (Exception e) {
      row.setRecognizeStatus("fail");
      String msg = e.getMessage() != null ? e.getMessage() : "识图失败";
      row.setErrorMessage(truncate(msg, 512));
      row.setErrorCode("RECOGNIZE_EXCEPTION");
      row.setConfirmStatus("none");
      mealPhotoRecognitionMapper.updateById(row);
      apiUsageLogger.record(ApiUsageLogger.PROVIDER_FOOD, "food", userId, row.getId(), false, msg);
      return buildResultVo(row, List.of(), row.getErrorCode(), row.getErrorMessage());
    }
  }

  public MealPhotoRecognizeResultVo getResult(Long userId, Long photoJobId) {
    MealPhotoRecognition row = loadOwned(userId, photoJobId);
    List<MealPhotoFoodItemVo> foods =
        "success".equals(row.getRecognizeStatus())
            ? aliyunJsonParser.fromJson(row.getParsedResultJson())
            : List.of();
    return buildResultVo(row, foods, row.getErrorCode(), row.getErrorMessage());
  }

  @Transactional
  public MealPhotoConfirmResponseVo confirm(Long userId, MealPhotoConfirmRequest req) {
    MealPhotoRecognition photo = loadOwned(userId, req.getPhotoJobId());
    if (!"success".equals(photo.getRecognizeStatus())) {
      throw new ApiException(400, "当前识图任务未成功，无法确认");
    }
    String mealType = req.getConfirmedMealType().trim().toLowerCase(Locale.ROOT);
    if (!MEAL_TYPES.contains(mealType)) {
      throw new ApiException(400, "confirmedMealType 须为 breakfast/lunch/dinner/snack");
    }
    LocalDate recordDate =
        StringUtils.hasText(req.getRecordDate())
            ? parseRecordDate(req.getRecordDate())
            : photo.getRecordDate();

    if ("confirmed".equals(photo.getConfirmStatus())) {
      return buildConfirmResponseFromExisting(photo, userId, recordDate);
    }

    List<MealPhotoConfirmItemDto> items = req.getItems();

    BigDecimal totalCal = BigDecimal.ZERO;
    for (MealPhotoConfirmItemDto it : items) {
      if (it.getConfirmedCalories() == null || it.getConfirmedCalories().signum() <= 0) {
        throw new ApiException(400, "confirmedCalories 须为正数");
      }
      totalCal = totalCal.add(it.getConfirmedCalories());
    }

    MealRecord meal = new MealRecord();
    meal.setUserId(userId);
    meal.setRecordDate(recordDate);
    meal.setMealType(mealType);
    meal.setTotalCalories(totalCal);
    meal.setFoodCount(items.size());
    meal.setStatus("submitted");
    mealRecordMapper.insert(meal);

    LocalDateTime now = LocalDateTime.now();
    List<Long> dietIds = new ArrayList<>();
    MealPhotoFoodItemVo[] parsed =
        aliyunJsonParser.fromJson(photo.getParsedResultJson()).toArray(new MealPhotoFoodItemVo[0]);

    for (int i = 0; i < items.size(); i++) {
      MealPhotoConfirmItemDto it = items.get(i);
      String foodName = StringUtils.hasText(it.getConfirmedFoodName()) ? it.getConfirmedFoodName().trim() : null;
      if (!StringUtils.hasText(foodName)) {
        foodName = findFoodName(parsed, it.getLineId(), i);
      }
      if (foodName.length() > 128) {
        foodName = foodName.substring(0, 128);
      }
      String giLabel = findGiLabel(parsed, it.getLineId(), i);

      DietRecordRow d = new DietRecordRow();
      d.setMealId(meal.getId());
      d.setUserId(userId);
      d.setRecordDate(recordDate);
      d.setMealType(mealType);
      d.setFoodId(it.getFoodId());
      d.setFoodNameSnapshot(foodName);
      d.setImageSnapshot(photo.getImageUrl());
      d.setGiLevelSnapshot(MealPhotoAliyunJsonParser.giSnapshotFromLabel(giLabel));
      d.setCaloriesTotal(it.getConfirmedCalories());
      d.setAmount(it.getConfirmedQuantity() != null ? it.getConfirmedQuantity() : BigDecimal.valueOf(100));
      d.setAmountUnit(
          StringUtils.hasText(it.getConfirmedQuantityUnit())
              ? it.getConfirmedQuantityUnit().trim()
              : "g/ml");
      d.setWeightG(d.getAmount());
      d.setSource("photo");
      d.setRecordTime(now);
      dietRecordMapper.insert(d);
      dietIds.add(d.getId());
    }

    try {
      dailySummaryService.updateForDay(userId, recordDate);
    } catch (Exception ignored) {
    }

    DashboardDto dash = dashboardService.getDashboard(userId, recordDate);
    BigDecimal badge =
        BigDecimal.valueOf(computeBadgePercent(dash.getIntakeCalories(), dash.getDailyBudget()));

    photo.setConfirmedMealType(mealType);
    photo.setConfirmedFoodName(items.get(0).getConfirmedFoodName());
    if (!StringUtils.hasText(photo.getConfirmedFoodName()) && !dietIds.isEmpty()) {
      DietRecordRow first = dietRecordMapper.selectById(dietIds.get(0));
      if (first != null && StringUtils.hasText(first.getFoodNameSnapshot())) {
        photo.setConfirmedFoodName(first.getFoodNameSnapshot());
      }
    }
    photo.setConfirmedCalories(totalCal);
    photo.setConfirmedEatRatio(items.get(0).getConfirmedEatRatio() != null ? items.get(0).getConfirmedEatRatio() : BigDecimal.ONE);
    photo.setBadgeProgressPercent(badge);
    photo.setConfirmStatus("confirmed");
    photo.setConfirmedAt(now);
    photo.setMealRecordId(meal.getId());
    if (!dietIds.isEmpty()) {
      photo.setDietRecordId(dietIds.get(0));
    }
    mealPhotoRecognitionMapper.updateById(photo);

    MealPhotoConfirmResponseVo vo = new MealPhotoConfirmResponseVo();
    vo.setMealRecordId(meal.getId());
    vo.setDietRecordIds(dietIds);
    vo.setConfirmStatus("confirmed");
    vo.setConfirmedAt(now);
    vo.setIntakeCaloriesToday(dash.getIntakeCalories());
    vo.setDailyBudgetCalories(dash.getDailyBudget());
    return vo;
  }

  private MealPhotoConfirmResponseVo buildConfirmResponseFromExisting(
      MealPhotoRecognition photo, Long userId, LocalDate recordDate) {
    DashboardDto dash = dashboardService.getDashboard(userId, recordDate);
    MealPhotoConfirmResponseVo vo = new MealPhotoConfirmResponseVo();
    vo.setMealRecordId(photo.getMealRecordId());
    if (photo.getMealRecordId() != null) {
      List<DietRecordRow> rows =
          dietRecordMapper.selectList(
              new LambdaQueryWrapper<DietRecordRow>()
                  .eq(DietRecordRow::getMealId, photo.getMealRecordId())
                  .orderByAsc(DietRecordRow::getId));
      List<Long> ids = new ArrayList<>();
      for (DietRecordRow r : rows) {
        ids.add(r.getId());
      }
      vo.setDietRecordIds(ids);
    }
    vo.setConfirmStatus("confirmed");
    vo.setConfirmedAt(photo.getConfirmedAt());
    vo.setIntakeCaloriesToday(dash.getIntakeCalories());
    vo.setDailyBudgetCalories(dash.getDailyBudget());
    return vo;
  }

  private MealPhotoRecognition loadOwned(Long userId, Long photoJobId) {
    MealPhotoRecognition row = mealPhotoRecognitionMapper.selectById(photoJobId);
    if (row == null) {
      throw new ApiException(404, "识图任务不存在");
    }
    if (!row.getUserId().equals(userId)) {
      throw new ApiException(403, "无权访问该识图任务");
    }
    return row;
  }

  private static List<MealPhotoFoodItemVo> filterRecognizedFoods(List<MealPhotoFoodItemVo> foods) {
    if (foods == null || foods.isEmpty()) {
      return List.of();
    }
    List<MealPhotoFoodItemVo> filtered = new ArrayList<>();
    int lineNo = 1;
    for (MealPhotoFoodItemVo food : foods) {
      if (food == null || !StringUtils.hasText(food.getFoodName())) {
        continue;
      }
      if (food.getType() != null && food.getType() != 1) {
        continue;
      }
      String name = food.getFoodName().trim();
      if (food.getType() == null && NON_FOOD_RECOGNITION_NAMES.contains(name)) {
        continue;
      }
      food.setFoodName(name);
      food.setLineId(String.valueOf(lineNo++));
      filtered.add(food);
    }
    return filtered;
  }

  private void fillRecognizedSnapshots(MealPhotoRecognition row, List<MealPhotoFoodItemVo> foods) {
    if (foods.isEmpty()) {
      return;
    }
    MealPhotoFoodItemVo f = foods.get(0);
    row.setRecognizedFoodName(f.getFoodName());
    if (f.getCalories() != null) {
      row.setRecognizedCalories(BigDecimal.valueOf(f.getCalories()));
    }
  }

  private MealPhotoRecognizeResultVo buildResultVo(
      MealPhotoRecognition row,
      List<MealPhotoFoodItemVo> foods,
      String errorCode,
      String errorMessage) {
    MealPhotoRecognizeResultVo vo = new MealPhotoRecognizeResultVo();
    vo.setPhotoJobId(row.getId());
    vo.setRecognizeStatus(row.getRecognizeStatus());
    vo.setRecognizePhase(null);
    vo.setImageUrl(row.getImageUrl());
    vo.setPreviewUrl(row.getImageUrl());
    vo.setRecommendedMealType(row.getRecommendedMealType());
    vo.setConfirmStatus(row.getConfirmStatus());
    vo.setErrorCode(errorCode);
    vo.setErrorMessage(errorMessage);

    if ("success".equals(row.getRecognizeStatus())) {
      vo.setFoods(foods);
      if (row.getRecommendedEatRatio() != null) {
        vo.setRecommendedEatRatio(row.getRecommendedEatRatio().doubleValue());
      } else {
        vo.setRecommendedEatRatio(1.0);
      }
      int total = 0;
      for (MealPhotoFoodItemVo f : foods) {
        if (f.getCalories() != null) {
          total += f.getCalories();
        }
      }
      vo.setTotalRecognizedCalories(total);
      DashboardDto dash = dashboardService.getDashboard(row.getUserId(), row.getRecordDate());
      vo.setIntakeCaloriesToday(dash.getIntakeCalories());
      vo.setDailyBudgetCalories(dash.getDailyBudget());
      vo.setBadgeProgressPercent(
          computeBadgePercent(
              dash.getIntakeCalories() + total, dash.getDailyBudget()));
    }
    return vo;
  }

  private static double computeBadgePercent(int intakeAfter, int budget) {
    if (budget <= 0) {
      return 0d;
    }
    double p = intakeAfter * 100.0 / budget;
    return Math.min(100, BigDecimal.valueOf(p).setScale(1, RoundingMode.HALF_UP).doubleValue());
  }

  private static String normalizeSource(String source) {
    if (!StringUtils.hasText(source)) {
      return "camera";
    }
    String s = source.trim().toLowerCase(Locale.ROOT);
    if (!s.equals("camera") && !s.equals("album")) {
      return "camera";
    }
    return s;
  }

  private static String normalizeMealType(String mealType) {
    if (!StringUtils.hasText(mealType)) {
      return null;
    }
    String s = mealType.trim().toLowerCase(Locale.ROOT);
    return MEAL_TYPES.contains(s) ? s : null;
  }

  private static LocalDate parseRecordDate(String raw) {
    if (!StringUtils.hasText(raw)) {
      return LocalDate.now();
    }
    try {
      return LocalDate.parse(raw.trim());
    } catch (DateTimeParseException e) {
      throw new ApiException(400, "recordDate 格式须为 yyyy-MM-dd");
    }
  }

  private static String truncate(String s, int max) {
    if (s == null) {
      return null;
    }
    return s.length() > max ? s.substring(0, max) : s;
  }

  private static String findFoodName(MealPhotoFoodItemVo[] parsed, String lineId, int index) {
    if (parsed != null) {
      for (MealPhotoFoodItemVo p : parsed) {
        if (p.getLineId() != null && p.getLineId().equals(lineId) && StringUtils.hasText(p.getFoodName())) {
          return p.getFoodName();
        }
      }
      if (index < parsed.length && StringUtils.hasText(parsed[index].getFoodName())) {
        return parsed[index].getFoodName();
      }
    }
    return "食物";
  }

  private static String findGiLabel(MealPhotoFoodItemVo[] parsed, String lineId, int index) {
    if (parsed != null) {
      for (MealPhotoFoodItemVo p : parsed) {
        if (p.getLineId() != null && p.getLineId().equals(lineId) && StringUtils.hasText(p.getGiLabel())) {
          return p.getGiLabel();
        }
      }
      if (index < parsed.length && StringUtils.hasText(parsed[index].getGiLabel())) {
        return parsed[index].getGiLabel();
      }
    }
    return "低 GI";
  }
}
