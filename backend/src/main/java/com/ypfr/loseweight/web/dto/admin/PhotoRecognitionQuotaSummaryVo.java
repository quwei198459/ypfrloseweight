package com.ypfr.loseweight.web.dto.admin;

public class PhotoRecognitionQuotaSummaryVo {

  private Integer grantCount;
  private Integer reduceCount;
  private Integer usedCount;
  private Integer currentBalance;

  public Integer getGrantCount() {
    return grantCount;
  }

  public void setGrantCount(Integer grantCount) {
    this.grantCount = grantCount;
  }

  public Integer getReduceCount() {
    return reduceCount;
  }

  public void setReduceCount(Integer reduceCount) {
    this.reduceCount = reduceCount;
  }

  public Integer getUsedCount() {
    return usedCount;
  }

  public void setUsedCount(Integer usedCount) {
    this.usedCount = usedCount;
  }

  public Integer getCurrentBalance() {
    return currentBalance;
  }

  public void setCurrentBalance(Integer currentBalance) {
    this.currentBalance = currentBalance;
  }
}
