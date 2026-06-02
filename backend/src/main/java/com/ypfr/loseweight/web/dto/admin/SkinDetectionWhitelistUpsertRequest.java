package com.ypfr.loseweight.web.dto.admin;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public class SkinDetectionWhitelistUpsertRequest {

  @NotBlank(message = "手机号不能为空")
  @Pattern(regexp = "^1\\d{10}$", message = "请输入 11 位中国大陆手机号")
  private String phone;

  private String remark;
  private Integer status;

  @Min(value = 0, message = "检测次数不能小于 0")
  private Integer totalTimes;

  public String getPhone() { return phone; }
  public void setPhone(String phone) { this.phone = phone; }
  public String getRemark() { return remark; }
  public void setRemark(String remark) { this.remark = remark; }
  public Integer getStatus() { return status; }
  public void setStatus(Integer status) { this.status = status; }
  public Integer getTotalTimes() { return totalTimes; }
  public void setTotalTimes(Integer totalTimes) { this.totalTimes = totalTimes; }
}
