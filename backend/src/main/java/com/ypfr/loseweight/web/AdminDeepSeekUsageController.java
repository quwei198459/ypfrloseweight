package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.DeepSeekUsageLog;
import com.ypfr.loseweight.service.AdminDeepSeekUsageService;
import com.ypfr.loseweight.web.dto.admin.DeepSeekUsageSummaryVo;
import java.time.LocalDate;
import java.util.List;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin/deepseek-usage")
public class AdminDeepSeekUsageController {

  private final AdminAuthResolver adminAuthResolver;
  private final AdminDeepSeekUsageService usageService;

  public AdminDeepSeekUsageController(
      AdminAuthResolver adminAuthResolver, AdminDeepSeekUsageService usageService) {
    this.adminAuthResolver = adminAuthResolver;
    this.usageService = usageService;
  }

  @GetMapping("/summary")
  public ApiResponse<DeepSeekUsageSummaryVo> summary(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(usageService.summary(from, to));
  }

  @GetMapping("/logs")
  public ApiResponse<List<DeepSeekUsageLog>> logs(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
      @RequestParam(required = false) String feature,
      @RequestParam(required = false) Integer limit) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(usageService.recentLogs(from, to, feature, limit));
  }
}
