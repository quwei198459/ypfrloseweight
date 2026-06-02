package com.ypfr.loseweight.web.dto.admin;

import jakarta.validation.constraints.NotNull;

public class SkinDetectionQuotaAdjustRequest {

  @NotNull(message = "请输入调整次数")
  private Integer delta;

  private String remark;

  public Integer getDelta() { return delta; }
  public void setDelta(Integer delta) { this.delta = delta; }
  public String getRemark() { return remark; }
  public void setRemark(String remark) { this.remark = remark; }
}
