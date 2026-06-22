package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/** 第三方接口调用流水（食物/皮肤/舌诊）。 */
@TableName("api_usage_log")
public class ApiUsageLog {

  @TableId(type = IdType.AUTO)
  private Long id;

  private String provider;
  private String feature;
  private Long userId;
  private Long recordId;
  private Integer success;
  private Integer billable;
  private Integer free;
  private Integer units;
  private BigDecimal unitPriceCny;
  private BigDecimal costCny;
  private String error;
  private LocalDateTime createdAt;

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

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public Long getRecordId() {
    return recordId;
  }

  public void setRecordId(Long recordId) {
    this.recordId = recordId;
  }

  public Integer getSuccess() {
    return success;
  }

  public void setSuccess(Integer success) {
    this.success = success;
  }

  public Integer getBillable() {
    return billable;
  }

  public void setBillable(Integer billable) {
    this.billable = billable;
  }

  public Integer getFree() {
    return free;
  }

  public void setFree(Integer free) {
    this.free = free;
  }

  public Integer getUnits() {
    return units;
  }

  public void setUnits(Integer units) {
    this.units = units;
  }

  public BigDecimal getUnitPriceCny() {
    return unitPriceCny;
  }

  public void setUnitPriceCny(BigDecimal unitPriceCny) {
    this.unitPriceCny = unitPriceCny;
  }

  public BigDecimal getCostCny() {
    return costCny;
  }

  public void setCostCny(BigDecimal costCny) {
    this.costCny = costCny;
  }

  public String getError() {
    return error;
  }

  public void setError(String error) {
    this.error = error;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }
}
