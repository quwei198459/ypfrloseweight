package com.ypfr.loseweight.web.dto.admin;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;

public class TcmDetectionAiPromptTemplateRequest {

  @NotBlank(message = "模板名称不能为空")
  @Size(max = 128, message = "模板名称最多 128 字")
  private String promptName;

  @NotBlank(message = "提示词内容不能为空")
  private String templateContent;

  private String outputSchema;

  @NotBlank(message = "模型名不能为空")
  @Size(max = 64, message = "模型名最多 64 字")
  private String model;

  @NotNull(message = "temperature 不能为空")
  @DecimalMin(value = "0.00", message = "temperature 不能小于 0")
  @DecimalMax(value = "2.00", message = "temperature 不能大于 2")
  private BigDecimal temperature;

  @NotNull(message = "状态不能为空")
  @Min(value = 0, message = "状态无效")
  @Max(value = 1, message = "状态无效")
  private Integer status;

  @Size(max = 255, message = "备注最多 255 字")
  private String remark;

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
  public String getRemark() { return remark; }
  public void setRemark(String remark) { this.remark = remark; }
}
