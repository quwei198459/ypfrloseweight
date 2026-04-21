package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.AdminManageService;
import com.ypfr.loseweight.web.dto.admin.AdminSportItemVo;
import com.ypfr.loseweight.web.dto.admin.AdminSportUpsertRequest;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin/sports")
public class AdminSportController {

  private final AdminAuthResolver adminAuthResolver;
  private final AdminManageService adminManageService;

  public AdminSportController(AdminAuthResolver adminAuthResolver, AdminManageService adminManageService) {
    this.adminAuthResolver = adminAuthResolver;
    this.adminManageService = adminManageService;
  }

  @GetMapping
  public ApiResponse<List<AdminSportItemVo>> list(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestParam(required = false) String keyword,
      @RequestParam(required = false) Integer status) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(adminManageService.listSports(keyword, status));
  }

  @PostMapping
  public ApiResponse<AdminSportItemVo> create(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody AdminSportUpsertRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(adminManageService.createSport(req));
  }

  @PutMapping("/{id}")
  public ApiResponse<AdminSportItemVo> update(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @Valid @RequestBody AdminSportUpsertRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(adminManageService.updateSport(id, req));
  }

  @DeleteMapping("/{id}")
  public ApiResponse<Boolean> delete(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    adminManageService.deleteSport(id);
    return ApiResponse.ok(Boolean.TRUE);
  }
}
