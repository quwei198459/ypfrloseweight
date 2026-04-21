package com.ypfr.loseweight.web.dto.admin;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class AdminChangePasswordRequest {

  @NotBlank(message = "原密码不能为空")
  private String oldPassword;

  @NotBlank(message = "新密码不能为空")
  @Size(min = 6, max = 64, message = "新密码长度须为 6～64 位")
  private String newPassword;

  public String getOldPassword() {
    return oldPassword;
  }

  public void setOldPassword(String oldPassword) {
    this.oldPassword = oldPassword;
  }

  public String getNewPassword() {
    return newPassword;
  }

  public void setNewPassword(String newPassword) {
    this.newPassword = newPassword;
  }
}
