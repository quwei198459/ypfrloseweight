package com.ypfr.loseweight.web.dto;

import jakarta.validation.constraints.NotBlank;

public class BindPhoneRequest {

  /** 按钮 getPhoneNumber 返回的 code（基础库 2.21.2+） */
  @NotBlank(message = "phoneCode 不能为空")
  private String code;

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }
}
