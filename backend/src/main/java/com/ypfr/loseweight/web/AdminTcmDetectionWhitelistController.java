package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.TcmDetectionWhitelist;
import com.ypfr.loseweight.service.AdminTcmDetectionService;
import com.ypfr.loseweight.web.dto.admin.TcmDetectionQuotaAdjustRequest;
import com.ypfr.loseweight.web.dto.admin.TcmDetectionQuotaLogItemVo;
import com.ypfr.loseweight.web.dto.admin.TcmDetectionQuotaSummaryVo;
import com.ypfr.loseweight.web.dto.admin.TcmDetectionWhitelistUpsertRequest;
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
@RequestMapping("/api/v1/admin/tcm-detection-whitelist")
public class AdminTcmDetectionWhitelistController {

  private final AdminAuthResolver adminAuthResolver;
  private final AdminTcmDetectionService tcmDetectionService;

  public AdminTcmDetectionWhitelistController(
      AdminAuthResolver adminAuthResolver, AdminTcmDetectionService tcmDetectionService) {
    this.adminAuthResolver = adminAuthResolver;
    this.tcmDetectionService = tcmDetectionService;
  }

  @GetMapping
  public ApiResponse<List<TcmDetectionWhitelist>> list(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestParam(required = false) String keyword,
      @RequestParam(required = false) Integer status) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(tcmDetectionService.listWhitelist(keyword, status));
  }

  @PostMapping
  public ApiResponse<TcmDetectionWhitelist> create(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody TcmDetectionWhitelistUpsertRequest req) {
    Long adminId = adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(tcmDetectionService.createWhitelist(req, adminId));
  }

  @PutMapping("/{id}")
  public ApiResponse<TcmDetectionWhitelist> update(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @Valid @RequestBody TcmDetectionWhitelistUpsertRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(tcmDetectionService.updateWhitelist(id, req));
  }

  @PostMapping("/{id}/quota-adjustments")
  public ApiResponse<TcmDetectionWhitelist> adjustQuota(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @Valid @RequestBody TcmDetectionQuotaAdjustRequest req) {
    Long adminId = adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(tcmDetectionService.adjustQuota(id, req, adminId));
  }

  @GetMapping("/{id}/quota-summary")
  public ApiResponse<TcmDetectionQuotaSummaryVo> quotaSummary(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(tcmDetectionService.quotaSummary(id));
  }

  @GetMapping("/{id}/quota-logs/manual")
  public ApiResponse<List<TcmDetectionQuotaLogItemVo>> manualLogs(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(tcmDetectionService.listManualLogs(id));
  }

  @GetMapping("/{id}/quota-logs/consume")
  public ApiResponse<List<TcmDetectionQuotaLogItemVo>> consumeLogs(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(tcmDetectionService.listConsumeLogs(id));
  }
}
