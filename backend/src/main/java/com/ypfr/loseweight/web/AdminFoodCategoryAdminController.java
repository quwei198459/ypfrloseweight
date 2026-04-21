package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.FoodCategory;
import com.ypfr.loseweight.service.AdminManageService;
import com.ypfr.loseweight.web.dto.admin.AdminFoodCategoryUpsertRequest;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin/food-categories")
public class AdminFoodCategoryAdminController {

  private final AdminAuthResolver adminAuthResolver;
  private final AdminManageService adminManageService;

  public AdminFoodCategoryAdminController(
      AdminAuthResolver adminAuthResolver, AdminManageService adminManageService) {
    this.adminAuthResolver = adminAuthResolver;
    this.adminManageService = adminManageService;
  }

  @GetMapping
  public ApiResponse<List<FoodCategory>> list(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(adminManageService.listFoodCategories());
  }

  @PostMapping
  public ApiResponse<FoodCategory> create(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody AdminFoodCategoryUpsertRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(adminManageService.createFoodCategory(req));
  }

  @PutMapping("/{id}")
  public ApiResponse<FoodCategory> update(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @Valid @RequestBody AdminFoodCategoryUpsertRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(adminManageService.updateFoodCategory(id, req));
  }

  @DeleteMapping("/{id}")
  public ApiResponse<Boolean> delete(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    adminManageService.deleteFoodCategory(id);
    return ApiResponse.ok(Boolean.TRUE);
  }
}
