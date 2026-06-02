package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.SkinDetectionWhitelist;
import com.ypfr.loseweight.service.AdminSkinDetectionService;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionQuotaAdjustRequest;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionQuotaLogItemVo;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionQuotaSummaryVo;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionWhitelistUpsertRequest;
import jakarta.validation.Valid;
import java.util.List;
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
@RequestMapping("/api/v1/admin/skin-detection-whitelist")
public class AdminSkinDetectionWhitelistController {

  private final AdminAuthResolver adminAuthResolver;
  private final AdminSkinDetectionService skinDetectionService;

  public AdminSkinDetectionWhitelistController(
      AdminAuthResolver adminAuthResolver, AdminSkinDetectionService skinDetectionService) {
    this.adminAuthResolver = adminAuthResolver;
    this.skinDetectionService = skinDetectionService;
  }

  @GetMapping
  public ApiResponse<List<SkinDetectionWhitelist>> list(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestParam(required = false) String keyword,
      @RequestParam(required = false) Integer status) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(skinDetectionService.listWhitelist(keyword, status));
  }

  @PostMapping
  public ApiResponse<SkinDetectionWhitelist> create(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody SkinDetectionWhitelistUpsertRequest req) {
    Long adminId = adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(skinDetectionService.createWhitelist(req, adminId));
  }

  @PutMapping("/{id}")
  public ApiResponse<SkinDetectionWhitelist> update(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @Valid @RequestBody SkinDetectionWhitelistUpsertRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(skinDetectionService.updateWhitelist(id, req));
  }

  @PostMapping("/{id}/quota-adjustments")
  public ApiResponse<SkinDetectionWhitelist> adjustQuota(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @Valid @RequestBody SkinDetectionQuotaAdjustRequest req) {
    Long adminId = adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(skinDetectionService.adjustQuota(id, req, adminId));
  }

  @GetMapping("/{id}/quota-summary")
  public ApiResponse<SkinDetectionQuotaSummaryVo> quotaSummary(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(skinDetectionService.quotaSummary(id));
  }

  @GetMapping("/{id}/quota-logs/manual")
  public ApiResponse<List<SkinDetectionQuotaLogItemVo>> manualLogs(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(skinDetectionService.listManualLogs(id));
  }

  @GetMapping("/{id}/quota-logs/consume")
  public ApiResponse<List<SkinDetectionQuotaLogItemVo>> consumeLogs(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(skinDetectionService.listConsumeLogs(id));
  }
}
