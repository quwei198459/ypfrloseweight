package com.ypfr.loseweight.web.dto;

import java.math.BigDecimal;

/** 批量写入单条饮食明细（与 diet_record 对应） */
public class BatchMealItemRequest {

  private Long foodId;
  private BigDecimal amountValue;
  private String amountUnit;
  /** 可选；缺省时使用批次级 recordedAt */
  private String recordedAt;

  public Long getFoodId() {
    return foodId;
  }

  public void setFoodId(Long foodId) {
    this.foodId = foodId;
  }

  public BigDecimal getAmountValue() {
    return amountValue;
  }

  public void setAmountValue(BigDecimal amountValue) {
    this.amountValue = amountValue;
  }

  public String getAmountUnit() {
    return amountUnit;
  }

  public void setAmountUnit(String amountUnit) {
    this.amountUnit = amountUnit;
  }

  public String getRecordedAt() {
    return recordedAt;
  }

  public void setRecordedAt(String recordedAt) {
    this.recordedAt = recordedAt;
  }
}
