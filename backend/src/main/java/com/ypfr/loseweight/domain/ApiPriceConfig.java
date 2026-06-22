package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/** 第三方接口单价配置（管理员可改）。 */
@TableName("api_price_config")
public class ApiPriceConfig {

  @TableId(type = IdType.AUTO)
  private Long id;

  private String provider;
  private String feature;
  private String displayName;
  private BigDecimal unitPriceCny;
  private Integer unitsPerCall;
  private Integer freeQuota;
  private LocalDate freeUntil;
  private Integer enabled;
  private String remark;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getProvider() {
    return provider;
  }

  public void setProvider(String provider) {
    this.provider = provider;
  }

  public String getFeature() {
    return feature;
  }

  public void setFeature(String feature) {
    this.feature = feature;
  }

  public String getDisplayName() {
    return displayName;
  }

  public void setDisplayName(String displayName) {
    this.displayName = displayName;
  }

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

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }
}
