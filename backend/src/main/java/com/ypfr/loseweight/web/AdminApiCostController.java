package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.ApiPriceConfig;
import com.ypfr.loseweight.domain.ApiUsageLog;
import com.ypfr.loseweight.service.AdminApiCostService;
import com.ypfr.loseweight.web.dto.admin.AiCostSummaryVo;
import com.ypfr.loseweight.web.dto.admin.ApiPriceConfigUpdateRequest;
import java.time.LocalDate;
import java.util.List;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin/api-cost")
public class AdminApiCostController {

  private final AdminAuthResolver adminAuthResolver;
  private final AdminApiCostService apiCostService;

  public AdminApiCostController(
      AdminAuthResolver adminAuthResolver, AdminApiCostService apiCostService) {
    this.adminAuthResolver = adminAuthResolver;
    this.apiCostService = apiCostService;
  }

  @GetMapping("/summary")
  public ApiResponse<AiCostSummaryVo> summary(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(apiCostService.summary(from, to));
  }

  @GetMapping("/prices")
  public ApiResponse<List<ApiPriceConfig>> prices(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(apiCostService.listPrices());
  }

  @PutMapping("/prices/{id}")
  public ApiResponse<ApiPriceConfig> updatePrice(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @RequestBody ApiPriceConfigUpdateRequest request) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(apiCostService.updatePrice(id, request));
  }

  @GetMapping("/logs")
  public ApiResponse<List<ApiUsageLog>> logs(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
      @RequestParam(required = false) String feature,
      @RequestParam(required = false) String provider,
      @RequestParam(required = false) Integer limit) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(apiCostService.recentLogs(from, to, feature, provider, limit));
  }
}
