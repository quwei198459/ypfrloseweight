package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.FoodCategoryListService;
import com.ypfr.loseweight.web.dto.FoodCategoryItemVo;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/food-categories")
public class FoodCategoryController {

  private final FoodCategoryListService foodCategoryListService;

  public FoodCategoryController(FoodCategoryListService foodCategoryListService) {
    this.foodCategoryListService = foodCategoryListService;
  }

  @GetMapping
  public ApiResponse<List<FoodCategoryItemVo>> list() {
    return ApiResponse.ok(foodCategoryListService.listSidebarCategories());
  }
}
