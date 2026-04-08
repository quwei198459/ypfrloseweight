package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.FoodRecognizeService;
import com.ypfr.loseweight.web.dto.FoodRecognizeRequest;
import com.ypfr.loseweight.web.dto.FoodRecognizeResponse;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/food")
public class FoodRecognizeController {

  private final FoodRecognizeService foodRecognizeService;

  public FoodRecognizeController(FoodRecognizeService foodRecognizeService) {
    this.foodRecognizeService = foodRecognizeService;
  }

  @PostMapping("/recognize")
  public ApiResponse<FoodRecognizeResponse> recognize(@Valid @RequestBody FoodRecognizeRequest request) {
    return ApiResponse.ok(foodRecognizeService.recognize(request));
  }
}
