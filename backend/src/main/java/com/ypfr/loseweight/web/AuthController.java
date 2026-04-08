package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.JwtService;
import com.ypfr.loseweight.service.WechatAuthService;
import com.ypfr.loseweight.web.dto.BindPhoneRequest;
import com.ypfr.loseweight.web.dto.WxLoginRequest;
import com.ypfr.loseweight.web.dto.WxLoginResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import java.util.Map;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

  private final WechatAuthService wechatAuthService;
  private final JwtService jwtService;

  public AuthController(WechatAuthService wechatAuthService, JwtService jwtService) {
    this.wechatAuthService = wechatAuthService;
    this.jwtService = jwtService;
  }

  /** wx.login 仅 code：openid 绑定与 JWT；资料见 POST /api/v1/user/profile/update */
  @PostMapping("/wx-login")
  public ApiResponse<WxLoginResponse> wxLogin(
      @Valid @RequestBody WxLoginRequest body, HttpServletRequest request) {
    String ip = request.getRemoteAddr();
    String ua = request.getHeader("User-Agent");
    return ApiResponse.ok(wechatAuthService.loginWithWx(body, ip, ua));
  }

  /** Authorization: Bearer &lt;JWT&gt;，body 为 getPhoneNumber 返回的 code */
  @PostMapping("/bind-phone")
  public ApiResponse<Map<String, String>> bindPhone(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody BindPhoneRequest body) {
    if (!StringUtils.hasText(authorization) || !authorization.startsWith("Bearer ")) {
      throw new ApiException(401, "请先登录");
    }
    String token = authorization.substring(7).trim();
    Long userId = jwtService.parseUserId(token);
    wechatAuthService.bindPhoneForUser(userId, body.getCode());
    return ApiResponse.ok(Map.of("ok", "1"));
  }
}
