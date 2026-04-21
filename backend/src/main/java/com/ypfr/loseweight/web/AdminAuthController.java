package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.AdminAuthService;
import com.ypfr.loseweight.service.AdminManageService;
import com.ypfr.loseweight.web.dto.admin.AdminChangePasswordRequest;
import com.ypfr.loseweight.web.dto.admin.AdminDashboardStatsVo;
import com.ypfr.loseweight.web.dto.admin.AdminLoginRequest;
import com.ypfr.loseweight.web.dto.admin.AdminLoginResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin")
public class AdminAuthController {

  private final AdminAuthResolver adminAuthResolver;
  private final AdminAuthService adminAuthService;
  private final AdminManageService adminManageService;

  public AdminAuthController(
      AdminAuthResolver adminAuthResolver,
      AdminAuthService adminAuthService,
      AdminManageService adminManageService) {
    this.adminAuthResolver = adminAuthResolver;
    this.adminAuthService = adminAuthService;
    this.adminManageService = adminManageService;
  }

  @PostMapping("/login")
  public ApiResponse<AdminLoginResponse> login(
      @Valid @RequestBody AdminLoginRequest req, HttpServletRequest httpRequest) {
    String ip = httpRequest.getRemoteAddr();
    String userAgent = httpRequest.getHeader("User-Agent");
    return ApiResponse.ok(adminAuthService.login(req.getUsername(), req.getPassword(), ip, userAgent));
  }

  /** 已登录管理员修改自己的密码 */
  @PostMapping("/change-password")
  public ApiResponse<Boolean> changePassword(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody AdminChangePasswordRequest body) {
    Long adminId = adminAuthResolver.requireAdminId(authorization);
    adminAuthService.changePassword(adminId, body.getOldPassword(), body.getNewPassword());
    return ApiResponse.ok(Boolean.TRUE);
  }

  /** 首页统计看板（与 {@code AdminManageService#dashboardStats} 一致） */
  @GetMapping("/dashboard/stats")
  public ApiResponse<AdminDashboardStatsVo> dashboardStats(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(adminManageService.dashboardStats());
  }
}
