package com.ypfr.loseweight.web.dto.admin;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class PhotoRecognitionQuotaAdjustRequest {

  @NotNull(message = "调整次数不能为空")
  @Min(value = -100000, message = "调整次数不能小于 -100000")
  @Max(value = 100000, message = "调整次数不能大于 100000")
  private Integer delta;

  @Size(max = 255, message = "备注最多 255 字")
  private String remark;

  public Integer getDelta() {
    return delta;
  }

  public void setDelta(Integer delta) {
    this.delta = delta;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }
}
