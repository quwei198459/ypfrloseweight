package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("skin_detection_ai_prompt_template")
public class SkinDetectionAiPromptTemplate {

  @TableId(type = IdType.AUTO)
  private Long id;

  private String promptKey;
  private String promptType;
  private String itemCode;
  private String promptName;
  private String templateContent;
  private String outputSchema;
  private String model;
  private BigDecimal temperature;
  private Integer status;
  private Integer version;
  private String remark;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getPromptKey() { return promptKey; }
  public void setPromptKey(String promptKey) { this.promptKey = promptKey; }
  public String getPromptType() { return promptType; }
  public void setPromptType(String promptType) { this.promptType = promptType; }
  public String getItemCode() { return itemCode; }
  public void setItemCode(String itemCode) { this.itemCode = itemCode; }
  public String getPromptName() { return promptName; }
  public void setPromptName(String promptName) { this.promptName = promptName; }
  public String getTemplateContent() { return templateContent; }
  public void setTemplateContent(String templateContent) { this.templateContent = templateContent; }
  public String getOutputSchema() { return outputSchema; }
  public void setOutputSchema(String outputSchema) { this.outputSchema = outputSchema; }
  public String getModel() { return model; }
  public void setModel(String model) { this.model = model; }
  public BigDecimal getTemperature() { return temperature; }
  public void setTemperature(BigDecimal temperature) { this.temperature = temperature; }
  public Integer getStatus() { return status; }
  public void setStatus(Integer status) { this.status = status; }
  public Integer getVersion() { return version; }
  public void setVersion(Integer version) { this.version = version; }
  public String getRemark() { return remark; }
  public void setRemark(String remark) { this.remark = remark; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
  public LocalDateTime getUpdatedAt() { return updatedAt; }
  public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
