package com.ypfr.loseweight.web.dto.skin;

public class SkinDetectionItemVo {

  private String itemCode;
  private String itemName;
  private Integer score;
  private String level;
  private String resultText;
  private String resultImage;
  private String metricsJson;
  private Integer sortOrder;
  private String scaleType;
  private String aiConclusion;
  private String aiReason;
  private String aiCareAdvice;
  private String aiRawJson;
  private String aiStatus;
  private String aiError;

  public String getItemCode() { return itemCode; }
  public void setItemCode(String itemCode) { this.itemCode = itemCode; }
  public String getItemName() { return itemName; }
  public void setItemName(String itemName) { this.itemName = itemName; }
  public Integer getScore() { return score; }
  public void setScore(Integer score) { this.score = score; }
  public String getLevel() { return level; }
  public void setLevel(String level) { this.level = level; }
  public String getResultText() { return resultText; }
  public void setResultText(String resultText) { this.resultText = resultText; }
  public String getResultImage() { return resultImage; }
  public void setResultImage(String resultImage) { this.resultImage = resultImage; }
  public String getMetricsJson() { return metricsJson; }
  public void setMetricsJson(String metricsJson) { this.metricsJson = metricsJson; }
  public Integer getSortOrder() { return sortOrder; }
  public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }
  public String getScaleType() { return scaleType; }
  public void setScaleType(String scaleType) { this.scaleType = scaleType; }
  public String getAiConclusion() { return aiConclusion; }
  public void setAiConclusion(String aiConclusion) { this.aiConclusion = aiConclusion; }
  public String getAiReason() { return aiReason; }
  public void setAiReason(String aiReason) { this.aiReason = aiReason; }
  public String getAiCareAdvice() { return aiCareAdvice; }
  public void setAiCareAdvice(String aiCareAdvice) { this.aiCareAdvice = aiCareAdvice; }
  public String getAiRawJson() { return aiRawJson; }
  public void setAiRawJson(String aiRawJson) { this.aiRawJson = aiRawJson; }
  public String getAiStatus() { return aiStatus; }
  public void setAiStatus(String aiStatus) { this.aiStatus = aiStatus; }
  public String getAiError() { return aiError; }
  public void setAiError(String aiError) { this.aiError = aiError; }
}
