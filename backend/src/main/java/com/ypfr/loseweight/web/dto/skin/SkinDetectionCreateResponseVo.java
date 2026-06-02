package com.ypfr.loseweight.web.dto.skin;

public class SkinDetectionCreateResponseVo {

  private Long recordId;
  private String status;
  private Integer overallScore;
  private String message;

  public Long getRecordId() { return recordId; }
  public void setRecordId(Long recordId) { this.recordId = recordId; }
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  public Integer getOverallScore() { return overallScore; }
  public void setOverallScore(Integer overallScore) { this.overallScore = overallScore; }
  public String getMessage() { return message; }
  public void setMessage(String message) { this.message = message; }
}
