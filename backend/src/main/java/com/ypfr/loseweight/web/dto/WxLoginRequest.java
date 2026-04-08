package com.ypfr.loseweight.web.dto;

import jakarta.validation.constraints.NotBlank;

public class WxLoginRequest {

  @NotBlank(message = "code 不能为空")
  private String code;

  /** 用户授权后 getUserProfile 的昵称（可选） */
  private String nickName;

  private String avatarUrl;

  /** 微信 userInfo.gender：0 未知 1 男 2 女 */
  private Integer gender;

  /**
   * 小程序 chooseAvatar 后 readFile 的 Base64（可带 data:image/jpeg;base64, 前缀），服务端落盘为
   * /api/v1/public/avatars/{userId}.jpg
   */
  private String avatarBase64;

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getNickName() {
    return nickName;
  }

  public void setNickName(String nickName) {
    this.nickName = nickName;
  }

  public String getAvatarUrl() {
    return avatarUrl;
  }

  public void setAvatarUrl(String avatarUrl) {
    this.avatarUrl = avatarUrl;
  }

  public Integer getGender() {
    return gender;
  }

  public void setGender(Integer gender) {
    this.gender = gender;
  }

  public String getAvatarBase64() {
    return avatarBase64;
  }

  public void setAvatarBase64(String avatarBase64) {
    this.avatarBase64 = avatarBase64;
  }
}
