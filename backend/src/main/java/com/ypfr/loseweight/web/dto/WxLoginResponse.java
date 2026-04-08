package com.ypfr.loseweight.web.dto;

/**
 * 微信登录返回：仅 code 换 openid 绑定；资料在个人信息页维护。
 * 契约对齐产品文档时，实际路径为 POST /api/v1/auth/wx-login（非 /api/user/wx-login）。
 */
public class WxLoginResponse {

  private Long userId;
  private String token;
  private String openid;
  private boolean profileCompleted;
  private AppUserDto userInfo;

  public WxLoginResponse() {}

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public String getToken() {
    return token;
  }

  public void setToken(String token) {
    this.token = token;
  }

  public String getOpenid() {
    return openid;
  }

  public void setOpenid(String openid) {
    this.openid = openid;
  }

  public boolean isProfileCompleted() {
    return profileCompleted;
  }

  public void setProfileCompleted(boolean profileCompleted) {
    this.profileCompleted = profileCompleted;
  }

  public AppUserDto getUserInfo() {
    return userInfo;
  }

  public void setUserInfo(AppUserDto userInfo) {
    this.userInfo = userInfo;
  }
}
