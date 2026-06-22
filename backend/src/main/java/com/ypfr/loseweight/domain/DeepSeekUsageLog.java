package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("deepseek_usage_log")
public class DeepSeekUsageLog {

  @TableId(type = IdType.AUTO)
  private Long id;

  private String feature;
  private String scene;
  private String model;
  private String billedModel;
  private Long userId;
  private Long recordId;
  private Integer promptTokens;
  private Integer cacheHitTokens;
  private Integer cacheMissTokens;
  private Integer completionTokens;
  private Integer totalTokens;
  private BigDecimal costCny;
  private LocalDateTime createdAt;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getFeature() { return feature; }
  public void setFeature(String feature) { this.feature = feature; }
  public String getScene() { return scene; }
  public void setScene(String scene) { this.scene = scene; }
  public String getModel() { return model; }
  public void setModel(String model) { this.model = model; }
  public String getBilledModel() { return billedModel; }
  public void setBilledModel(String billedModel) { this.billedModel = billedModel; }
  public Long getUserId() { return userId; }
  public void setUserId(Long userId) { this.userId = userId; }
  public Long getRecordId() { return recordId; }
  public void setRecordId(Long recordId) { this.recordId = recordId; }
  public Integer getPromptTokens() { return promptTokens; }
  public void setPromptTokens(Integer promptTokens) { this.promptTokens = promptTokens; }
  public Integer getCacheHitTokens() { return cacheHitTokens; }
  public void setCacheHitTokens(Integer cacheHitTokens) { this.cacheHitTokens = cacheHitTokens; }
  public Integer getCacheMissTokens() { return cacheMissTokens; }
  public void setCacheMissTokens(Integer cacheMissTokens) { this.cacheMissTokens = cacheMissTokens; }
  public Integer getCompletionTokens() { return completionTokens; }
  public void setCompletionTokens(Integer completionTokens) { this.completionTokens = completionTokens; }
  public Integer getTotalTokens() { return totalTokens; }
  public void setTotalTokens(Integer totalTokens) { this.totalTokens = totalTokens; }
  public BigDecimal getCostCny() { return costCny; }
  public void setCostCny(BigDecimal costCny) { this.costCny = costCny; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
