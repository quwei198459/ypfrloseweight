package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.Food;
import com.ypfr.loseweight.service.CustomFoodService;
import com.ypfr.loseweight.web.dto.CreateCustomFoodRequest;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/users/{userId}/custom-foods")
public class CustomFoodController {

  private final CustomFoodService customFoodService;
  private final AuthUserResolver authUserResolver;

  public CustomFoodController(
      CustomFoodService customFoodService, AuthUserResolver authUserResolver) {
    this.customFoodService = customFoodService;
    this.authUserResolver = authUserResolver;
  }

  @PostMapping
  public ApiResponse<Food> create(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long userId,
      @RequestBody CreateCustomFoodRequest body) {
    authUserResolver.requirePathUser(authorization, userId);
    return ApiResponse.ok(customFoodService.create(userId, body));
  }
}
