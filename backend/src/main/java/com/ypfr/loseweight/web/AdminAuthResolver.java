package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.service.AdminTokenService;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
public class AdminAuthResolver {

  private final AdminTokenService adminTokenService;

  public AdminAuthResolver(AdminTokenService adminTokenService) {
    this.adminTokenService = adminTokenService;
  }

  public Long requireAdminId(String authorization) {
    if (!StringUtils.hasText(authorization)) {
      throw new ApiException(401, "缺少 Authorization");
    }
    String token = authorization.trim();
    if (token.regionMatches(true, 0, "Bearer ", 0, 7)) {
      token = token.substring(7).trim();
    }
    return adminTokenService.parseAdminId(token);
  }
}
