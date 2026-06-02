package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;

@TableName("photo_recognition_quota_log")
public class PhotoRecognitionQuotaLog {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long memberPhoneId;
  private String phone;
  private Long userId;
  private Long photoJobId;
  private String changeType;
  private Integer changeCount;
  private Integer beforeTotalQuota;
  private Integer beforeUsedCount;
  private Integer afterTotalQuota;
  private Integer afterUsedCount;
  private String operatorType;
  private String operatorName;
  private String remark;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Long getMemberPhoneId() {
    return memberPhoneId;
  }

  public void setMemberPhoneId(Long memberPhoneId) {
    this.memberPhoneId = memberPhoneId;
  }

  public String getPhone() {
    return phone;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public Long getPhotoJobId() {
    return photoJobId;
  }

  public void setPhotoJobId(Long photoJobId) {
    this.photoJobId = photoJobId;
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
