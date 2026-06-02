package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;

@TableName("skin_detection_quota_log")
public class SkinDetectionQuotaLog {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long whitelistId;
  private String phone;
  private Long userId;
  private Long recordId;
  private String changeType;
  private Integer changeCount;
  private Integer beforeTotalTimes;
  private Integer beforeUsedTimes;
  private Integer afterTotalTimes;
  private Integer afterUsedTimes;
  private String operatorType;
  private String operatorName;
  private String remark;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public Long getWhitelistId() { return whitelistId; }
  public void setWhitelistId(Long whitelistId) { this.whitelistId = whitelistId; }
  public String getPhone() { return phone; }
  public void setPhone(String phone) { this.phone = phone; }
  public Long getUserId() { return userId; }
  public void setUserId(Long userId) { this.userId = userId; }
  public Long getRecordId() { return recordId; }
  public void setRecordId(Long recordId) { this.recordId = recordId; }
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
  public String getOperatorType() { return operatorType; }
  public void setOperatorType(String operatorType) { this.operatorType = operatorType; }
  public String getOperatorName() { return operatorName; }
  public void setOperatorName(String operatorName) { this.operatorName = operatorName; }
  public String getRemark() { return remark; }
  public void setRemark(String remark) { this.remark = remark; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
  public LocalDateTime getUpdatedAt() { return updatedAt; }
  public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
