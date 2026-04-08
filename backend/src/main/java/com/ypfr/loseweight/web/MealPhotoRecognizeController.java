package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.photograph.MealPhotoRecognizeService;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoConfirmRequest;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoConfirmResponseVo;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoRecognizeResultVo;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoResultQuery;
import com.ypfr.loseweight.web.dto.photograph.MealPhotoSubmitRequest;
import jakarta.validation.Valid;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/recognize")
@Validated
public class MealPhotoRecognizeController {

  private final MealPhotoRecognizeService mealPhotoRecognizeService;
  private final AuthUserResolver authUserResolver;

  public MealPhotoRecognizeController(
      MealPhotoRecognizeService mealPhotoRecognizeService, AuthUserResolver authUserResolver) {
    this.mealPhotoRecognizeService = mealPhotoRecognizeService;
    this.authUserResolver = authUserResolver;
  }

  @PostMapping("/meal-photo")
  public ApiResponse<MealPhotoRecognizeResultVo> submit(
      @org.springframework.web.bind.annotation.RequestHeader(
              value = "Authorization", required = false)
          String authorization,
      @Valid @RequestBody MealPhotoSubmitRequest request) {
    Long userId = authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(mealPhotoRecognizeService.submit(userId, request));
  }

  @GetMapping("/meal-photo/result")
  public ApiResponse<MealPhotoRecognizeResultVo> result(
      @org.springframework.web.bind.annotation.RequestHeader(
              value = "Authorization", required = false)
          String authorization,
      @Valid @ModelAttribute MealPhotoResultQuery query) {
    Long userId = authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(mealPhotoRecognizeService.getResult(userId, query.getPhotoJobId()));
  }

  @PostMapping("/meal-photo/confirm")
  public ApiResponse<MealPhotoConfirmResponseVo> confirm(
      @org.springframework.web.bind.annotation.RequestHeader(
              value = "Authorization", required = false)
          String authorization,
      @Valid @RequestBody MealPhotoConfirmRequest request) {
    Long userId = authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(mealPhotoRecognizeService.confirm(userId, request));
  }
}
