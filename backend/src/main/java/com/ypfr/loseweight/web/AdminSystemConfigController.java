package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.SystemConfigService;
import com.ypfr.loseweight.web.dto.admin.SystemConfigUpdateRequest;
import com.ypfr.loseweight.web.dto.admin.SystemConfigVo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin/system-config")
public class AdminSystemConfigController {

  private final AdminAuthResolver adminAuthResolver;
  private final SystemConfigService systemConfigService;

  public AdminSystemConfigController(
      AdminAuthResolver adminAuthResolver, SystemConfigService systemConfigService) {
    this.adminAuthResolver = adminAuthResolver;
    this.systemConfigService = systemConfigService;
  }

  @GetMapping
  public ApiResponse<SystemConfigVo> get(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(systemConfigService.getConfig());
  }

  @PutMapping
  public ApiResponse<SystemConfigVo> update(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestBody SystemConfigUpdateRequest request) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(systemConfigService.updateConfig(request));
  }
}
