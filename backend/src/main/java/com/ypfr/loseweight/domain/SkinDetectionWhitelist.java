package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;

@TableName("skin_detection_whitelist")
public class SkinDetectionWhitelist {

  @TableId(type = IdType.AUTO)
  private Long id;

  private String phone;
  private String remark;
  private Integer status;
  private Integer totalTimes;
  private Integer usedTimes;
  private LocalDateTime quotaUpdatedAt;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getPhone() { return phone; }
  public void setPhone(String phone) { this.phone = phone; }
  public String getRemark() { return remark; }
  public void setRemark(String remark) { this.remark = remark; }
  public Integer getStatus() { return status; }
  public void setStatus(Integer status) { this.status = status; }
  public Integer getTotalTimes() { return totalTimes; }
  public void setTotalTimes(Integer totalTimes) { this.totalTimes = totalTimes; }
  public Integer getUsedTimes() { return usedTimes; }
  public void setUsedTimes(Integer usedTimes) { this.usedTimes = usedTimes; }
  public LocalDateTime getQuotaUpdatedAt() { return quotaUpdatedAt; }
  public void setQuotaUpdatedAt(LocalDateTime quotaUpdatedAt) { this.quotaUpdatedAt = quotaUpdatedAt; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
  public LocalDateTime getUpdatedAt() { return updatedAt; }
  public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
