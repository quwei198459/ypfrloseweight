package com.ypfr.loseweight.web.dto;

import java.math.BigDecimal;

public class WeightUpsertRequest {

  /** yyyy-MM-dd */
  private String recordDate;
  private BigDecimal weightKg;

  public String getRecordDate() {
    return recordDate;
  }

  public void setRecordDate(String recordDate) {
    this.recordDate = recordDate;
  }

  public BigDecimal getWeightKg() {
    return weightKg;
  }

  public void setWeightKg(BigDecimal weightKg) {
    this.weightKg = weightKg;
  }
}
