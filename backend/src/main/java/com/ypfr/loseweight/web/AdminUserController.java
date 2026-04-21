package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.AdminManageService;
import com.ypfr.loseweight.web.dto.admin.AdminPagedResult;
import com.ypfr.loseweight.web.dto.admin.AdminUserListItemVo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin/users")
public class AdminUserController {

  private final AdminAuthResolver adminAuthResolver;
  private final AdminManageService adminManageService;

  public AdminUserController(AdminAuthResolver adminAuthResolver, AdminManageService adminManageService) {
    this.adminAuthResolver = adminAuthResolver;
    this.adminManageService = adminManageService;
  }

  @GetMapping
  public ApiResponse<AdminPagedResult<AdminUserListItemVo>> list(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestParam(required = false) String keyword,
      @RequestParam(defaultValue = "1") int page,
      @RequestParam(defaultValue = "20") int pageSize) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(adminManageService.listUsers(keyword, page, pageSize));
  }
}
