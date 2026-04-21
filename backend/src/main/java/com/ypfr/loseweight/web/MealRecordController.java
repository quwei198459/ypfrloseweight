package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.MealRecordService;
import com.ypfr.loseweight.web.dto.CreateMealRecordRequest;
import com.ypfr.loseweight.web.dto.CreateMealRecordsBatchRequest;
import com.ypfr.loseweight.web.dto.CreateMealRecordsBatchResponse;
import com.ypfr.loseweight.web.dto.MealEntryVo;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/users/{userId}/meal-records")
public class MealRecordController {

  private final MealRecordService mealRecordService;
  private final AuthUserResolver authUserResolver;

  public MealRecordController(
      MealRecordService mealRecordService, AuthUserResolver authUserResolver) {
    this.mealRecordService = mealRecordService;
    this.authUserResolver = authUserResolver;
  }

  @PostMapping
  public ApiResponse<MealEntryVo> create(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long userId,
      @RequestBody CreateMealRecordRequest body) {
    authUserResolver.requirePathUser(authorization, userId);
    return ApiResponse.ok(mealRecordService.create(userId, body));
  }

  /**
   * 批量追加同一餐次下的多条饮食明细（食物搜索页「完成」）；同一 recordDate+mealType 复用已有 meal_record。
   */
  @PostMapping("/batch")
  public ApiResponse<CreateMealRecordsBatchResponse> createBatch(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long userId,
      @RequestBody CreateMealRecordsBatchRequest body) {
    authUserResolver.requirePathUser(authorization, userId);
    return ApiResponse.ok(mealRecordService.createBatchAppend(userId, body));
  }

  @DeleteMapping("/{id}")
  public ApiResponse<Void> delete(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long userId,
      @PathVariable Long id) {
    authUserResolver.requirePathUser(authorization, userId);
    mealRecordService.delete(userId, id);
    return ApiResponse.ok(null);
  }
}
