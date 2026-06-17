package com.ypfr.loseweight.service;

public class ParsedTcmDetectionItem {

  private String itemCode;
  private String itemName;
  private Integer score;
  private String level;
  private String resultText;
  private String resultImage;
  private String metricsJson;
  private Integer sortOrder;
  private String scaleType;

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
}
