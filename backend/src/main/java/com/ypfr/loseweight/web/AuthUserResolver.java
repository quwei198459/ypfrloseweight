package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.service.JwtService;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
public class AuthUserResolver {

  private final JwtService jwtService;

  public AuthUserResolver(JwtService jwtService) {
    this.jwtService = jwtService;
  }

  public Long requireUserId(String authorization) {
    if (!StringUtils.hasText(authorization) || !authorization.startsWith("Bearer ")) {
      throw new ApiException(401, "请先登录");
    }
    return jwtService.parseUserId(authorization.substring(7).trim());
  }

  public Long requirePathUser(String authorization, Long pathUserId) {
    Long tokenUserId = requireUserId(authorization);
    if (pathUserId == null || !pathUserId.equals(tokenUserId)) {
      throw new ApiException(403, "无权操作该用户数据");
    }
    return tokenUserId;
  }
}

