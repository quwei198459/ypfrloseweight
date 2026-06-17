package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;

@TableName("tcm_detection_item_config")
public class TcmDetectionItemConfig {

  @TableId(type = IdType.AUTO)
  private Long id;

  private String itemCode;
  private String vendorField;
  private String itemName;
  private String displayName;
  private Integer sortOrder;
  private Integer enabled;
  private String scaleType;
  private String scoreDirection;
  private String promptKey;
  private String remark;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getItemCode() { return itemCode; }
  public void setItemCode(String itemCode) { this.itemCode = itemCode; }
  public String getVendorField() { return vendorField; }
  public void setVendorField(String vendorField) { this.vendorField = vendorField; }
  public String getItemName() { return itemName; }
  public void setItemName(String itemName) { this.itemName = itemName; }
  public String getDisplayName() { return displayName; }
  public void setDisplayName(String displayName) { this.displayName = displayName; }
  public Integer getSortOrder() { return sortOrder; }
  public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }
  public Integer getEnabled() { return enabled; }
  public void setEnabled(Integer enabled) { this.enabled = enabled; }
  public String getScaleType() { return scaleType; }
  public void setScaleType(String scaleType) { this.scaleType = scaleType; }
  public String getScoreDirection() { return scoreDirection; }
  public void setScoreDirection(String scoreDirection) { this.scoreDirection = scoreDirection; }
  public String getPromptKey() { return promptKey; }
  public void setPromptKey(String promptKey) { this.promptKey = promptKey; }
  public String getRemark() { return remark; }
  public void setRemark(String remark) { this.remark = remark; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
  public LocalDateTime getUpdatedAt() { return updatedAt; }
  public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
