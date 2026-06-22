package com.ypfr.loseweight.web.dto.admin;

import java.math.BigDecimal;
import java.time.LocalDate;

/** 更新第三方接口单价配置；字段为 null 表示不修改该项。 */
public class ApiPriceConfigUpdateRequest {

  private BigDecimal unitPriceCny;
  private Integer unitsPerCall;
  private Integer freeQuota;
  private LocalDate freeUntil;
  private Integer enabled;
  private String remark;

  public BigDecimal getUnitPriceCny() {
    return unitPriceCny;
  }

  public void setUnitPriceCny(BigDecimal unitPriceCny) {
    this.unitPriceCny = unitPriceCny;
  }

  public Integer getUnitsPerCall() {
    return unitsPerCall;
  }

  public void setUnitsPerCall(Integer unitsPerCall) {
    this.unitsPerCall = unitsPerCall;
  }

  public Integer getFreeQuota() {
    return freeQuota;
  }

  public void setFreeQuota(Integer freeQuota) {
    this.freeQuota = freeQuota;
  }

  public LocalDate getFreeUntil() {
    return freeUntil;
  }

  public void setFreeUntil(LocalDate freeUntil) {
    this.freeUntil = freeUntil;
  }

  public Integer getEnabled() {
    return enabled;
  }

  public void setEnabled(Integer enabled) {
    this.enabled = enabled;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }
}
