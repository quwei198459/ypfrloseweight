package com.ypfr.loseweight.web.dto.admin;

import java.time.LocalDateTime;

public class TcmDetectionQuotaLogItemVo {

  private Long id;
  private String changeType;
  private Integer changeCount;
  private Integer beforeTotalTimes;
  private Integer beforeUsedTimes;
  private Integer afterTotalTimes;
  private Integer afterUsedTimes;
  private Long userId;
  private Long recordId;
  private String operatorType;
  private String operatorName;
  private String remark;
  private LocalDateTime createdAt;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getChangeType() { return changeType; }
  public void setChangeType(String changeType) { this.changeType = changeType; }
  public Integer getChangeCount() { return changeCount; }
  public void setChangeCount(Integer changeCount) { this.changeCount = changeCount; }
  public Integer getBeforeTotalTimes() { return beforeTotalTimes; }
  public void setBeforeTotalTimes(Integer beforeTotalTimes) { this.beforeTotalTimes = beforeTotalTimes; }
  public Integer getBeforeUsedTimes() { return beforeUsedTimes; }
  public void setBeforeUsedTimes(Integer beforeUsedTimes) { this.beforeUsedTimes = beforeUsedTimes; }
  public Integer getAfterTotalTimes() { return afterTotalTimes; }
  public void setAfterTotalTimes(Integer afterTotalTimes) { this.afterTotalTimes = afterTotalTimes; }
  public Integer getAfterUsedTimes() { return afterUsedTimes; }
  public void setAfterUsedTimes(Integer afterUsedTimes) { this.afterUsedTimes = afterUsedTimes; }
  public Long getUserId() { return userId; }
  public void setUserId(Long userId) { this.userId = userId; }
  public Long getRecordId() { return recordId; }
  public void setRecordId(Long recordId) { this.recordId = recordId; }
  public String getOperatorType() { return operatorType; }
  public void setOperatorType(String operatorType) { this.operatorType = operatorType; }
  public String getOperatorName() { return operatorName; }
  public void setOperatorName(String operatorName) { this.operatorName = operatorName; }
  public String getRemark() { return remark; }
  public void setRemark(String remark) { this.remark = remark; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
