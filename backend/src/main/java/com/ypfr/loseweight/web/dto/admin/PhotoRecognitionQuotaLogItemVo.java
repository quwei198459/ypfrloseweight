package com.ypfr.loseweight.web.dto.admin;

import java.time.LocalDateTime;

public class PhotoRecognitionQuotaLogItemVo {

  private Long id;
  private String changeType;
  private Integer changeCount;
  private Integer beforeTotalQuota;
  private Integer beforeUsedCount;
  private Integer afterTotalQuota;
  private Integer afterUsedCount;
  private Long photoJobId;
  private String remark;
  private String operatorType;
  private String operatorName;
  private LocalDateTime createdAt;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getChangeType() {
    return changeType;
  }

  public void setChangeType(String changeType) {
    this.changeType = changeType;
  }

  public Integer getChangeCount() {
    return changeCount;
  }

  public void setChangeCount(Integer changeCount) {
    this.changeCount = changeCount;
  }

  public Integer getBeforeTotalQuota() {
    return beforeTotalQuota;
  }

  public void setBeforeTotalQuota(Integer beforeTotalQuota) {
    this.beforeTotalQuota = beforeTotalQuota;
  }

  public Integer getBeforeUsedCount() {
    return beforeUsedCount;
  }

  public void setBeforeUsedCount(Integer beforeUsedCount) {
    this.beforeUsedCount = beforeUsedCount;
  }

  public Integer getAfterTotalQuota() {
    return afterTotalQuota;
  }

  public void setAfterTotalQuota(Integer afterTotalQuota) {
    this.afterTotalQuota = afterTotalQuota;
  }

  public Integer getAfterUsedCount() {
    return afterUsedCount;
  }

  public void setAfterUsedCount(Integer afterUsedCount) {
    this.afterUsedCount = afterUsedCount;
  }

  public Long getPhotoJobId() {
    return photoJobId;
  }

  public void setPhotoJobId(Long photoJobId) {
    this.photoJobId = photoJobId;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

  public String getOperatorType() {
    return operatorType;
  }

  public void setOperatorType(String operatorType) {
    this.operatorType = operatorType;
  }

  public String getOperatorName() {
    return operatorName;
  }

  public void setOperatorName(String operatorName) {
    this.operatorName = operatorName;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }
}
