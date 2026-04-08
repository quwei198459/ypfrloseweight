package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.Food;
import com.ypfr.loseweight.service.FoodLibraryService;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/food-library")
public class FoodLibraryController {

  private final FoodLibraryService foodLibraryService;

  public FoodLibraryController(FoodLibraryService foodLibraryService) {
    this.foodLibraryService = foodLibraryService;
  }

  @GetMapping("/search")
  public ApiResponse<List<Food>> search(
      @RequestParam(required = false) String q,
      @RequestParam(defaultValue = "30") int limit,
      @RequestParam(required = false) Long forUserId,
      @RequestParam(required = false) String categoryCode) {
    return ApiResponse.ok(foodLibraryService.search(q, limit, forUserId, categoryCode));
  }
}
