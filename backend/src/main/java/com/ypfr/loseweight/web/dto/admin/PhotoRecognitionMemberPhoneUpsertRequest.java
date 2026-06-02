package com.ypfr.loseweight.web.dto.admin;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class PhotoRecognitionMemberPhoneUpsertRequest {

  @NotBlank(message = "手机号不能为空")
  @Pattern(regexp = "^1\\d{10}$", message = "请输入 11 位中国大陆手机号")
  private String phone;

  @Size(max = 255, message = "备注最多 255 字")
  private String remark;

  private Integer status = 1;

  @Min(value = 0, message = "默认赠送次数不能小于 0")
  private Integer totalQuota = 100;

  public String getPhone() {
    return phone;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
  }

  public Integer getTotalQuota() {
    return totalQuota;
  }

  public void setTotalQuota(Integer totalQuota) {
    this.totalQuota = totalQuota;
  }
}
