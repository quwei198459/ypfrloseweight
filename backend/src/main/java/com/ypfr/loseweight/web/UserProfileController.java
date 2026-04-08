package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.JwtService;
import com.ypfr.loseweight.service.UserService;
import com.ypfr.loseweight.service.WechatAuthService;
import com.ypfr.loseweight.web.dto.AppUserDto;
import com.ypfr.loseweight.web.dto.BindPhoneRequest;
import com.ypfr.loseweight.web.dto.UpdateProfileRequest;
import jakarta.validation.Valid;
import java.util.Map;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 当前用户资料（需 JWT）。产品文档中的 /api/user/* 对应本组 /api/v1/user/*。
 */
@RestController
@RequestMapping("/api/v1/user")
public class UserProfileController {

  private final JwtService jwtService;
  private final UserService userService;
  private final WechatAuthService wechatAuthService;

  public UserProfileController(
      JwtService jwtService, UserService userService, WechatAuthService wechatAuthService) {
    this.jwtService = jwtService;
    this.userService = userService;
    this.wechatAuthService = wechatAuthService;
  }

  private Long requireUserId(String authorization) {
    if (!StringUtils.hasText(authorization) || !authorization.startsWith("Bearer ")) {
      throw new ApiException(401, "请先登录");
    }
    return jwtService.parseUserId(authorization.substring(7).trim());
  }

  @GetMapping("/profile")
  public ApiResponse<AppUserDto> getProfile(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    Long uid = requireUserId(authorization);
    return ApiResponse.ok(userService.getUser(uid));
  }

  /** 与文档 POST /api/user/profile/update 对齐，此处为 /api/v1/user/profile/update */
  @PostMapping("/profile/update")
  public ApiResponse<AppUserDto> updateProfile(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody UpdateProfileRequest body) {
    Long uid = requireUserId(authorization);
    return ApiResponse.ok(userService.updateProfile(uid, body));
  }

  /** 与文档 POST /api/user/bind-phone 对齐；与 /api/v1/auth/bind-phone 行为一致 */
  @PostMapping("/bind-phone")
  public ApiResponse<Map<String, String>> bindPhone(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody BindPhoneRequest body) {
    Long uid = requireUserId(authorization);
    wechatAuthService.bindPhoneForUser(uid, body.getCode());
    return ApiResponse.ok(Map.of("ok", "1"));
  }
}
