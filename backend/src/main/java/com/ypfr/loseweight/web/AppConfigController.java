package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.SystemConfigService;
import com.ypfr.loseweight.service.SystemConfigService.HomeEntryConfig;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** 小程序可读的应用配置（无需登录），目前提供首页入口可见性开关。 */
@RestController
@RequestMapping("/api/v1/app-config")
public class AppConfigController {

  private final SystemConfigService systemConfigService;

  public AppConfigController(SystemConfigService systemConfigService) {
    this.systemConfigService = systemConfigService;
  }

  @GetMapping("/home-entries")
  public ApiResponse<HomeEntryConfig> homeEntries() {
    return ApiResponse.ok(systemConfigService.getHomeEntryConfig());
  }
}
