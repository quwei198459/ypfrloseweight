package com.ypfr.loseweight.web.dto.tcm;

public class TcmDetectionQuotaVo {

  private Boolean allowed;
  private Boolean phoneBound;
  private String reason;
  private String message;
  private Integer totalTimes;
  private Integer usedTimes;
  private Integer remainingTimes;

  public Boolean getAllowed() { return allowed; }
  public void setAllowed(Boolean allowed) { this.allowed = allowed; }
  public Boolean getPhoneBound() { return phoneBound; }
  public void setPhoneBound(Boolean phoneBound) { this.phoneBound = phoneBound; }
  public String getReason() { return reason; }
  public void setReason(String reason) { this.reason = reason; }
  public String getMessage() { return message; }
  public void setMessage(String message) { this.message = message; }
  public Integer getTotalTimes() { return totalTimes; }
  public void setTotalTimes(Integer totalTimes) { this.totalTimes = totalTimes; }
  public Integer getUsedTimes() { return usedTimes; }
  public void setUsedTimes(Integer usedTimes) { this.usedTimes = usedTimes; }
  public Integer getRemainingTimes() { return remainingTimes; }
  public void setRemainingTimes(Integer remainingTimes) { this.remainingTimes = remainingTimes; }
}
