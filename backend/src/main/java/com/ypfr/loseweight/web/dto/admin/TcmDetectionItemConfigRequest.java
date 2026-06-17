package com.ypfr.loseweight.web.dto.admin;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class TcmDetectionItemConfigRequest {

  @NotBlank(message = "展示名称不能为空")
  @Size(max = 64, message = "展示名称最多 64 字")
  private String itemName;

  @NotBlank(message = "短名称不能为空")
  @Size(max = 64, message = "短名称最多 64 字")
  private String displayName;

  @NotNull(message = "排序不能为空")
  private Integer sortOrder;

  @NotNull(message = "启用状态不能为空")
  @Min(value = 0, message = "启用状态无效")
  @Max(value = 1, message = "启用状态无效")
  private Integer enabled;

  @NotBlank(message = "分档类型不能为空")
  @Size(max = 32, message = "分档类型最多 32 字")
  private String scaleType;

  @NotBlank(message = "分数方向不能为空")
  @Size(max = 16, message = "分数方向最多 16 字")
  private String scoreDirection;

  @NotBlank(message = "提示词 key 不能为空")
  @Size(max = 64, message = "提示词 key 最多 64 字")
  private String promptKey;

  @Size(max = 255, message = "备注最多 255 字")
  private String remark;

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
}
