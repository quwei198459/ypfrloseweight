package com.ypfr.loseweight.web.dto.admin;

public class AdminLoginResponse {

  private String token;
  private String username;
  private Long expireSeconds;

  public String getToken() {
    return token;
  }

  public void setToken(String token) {
    this.token = token;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public Long getExpireSeconds() {
    return expireSeconds;
  }

  public void setExpireSeconds(Long expireSeconds) {
    this.expireSeconds = expireSeconds;
  }
}
