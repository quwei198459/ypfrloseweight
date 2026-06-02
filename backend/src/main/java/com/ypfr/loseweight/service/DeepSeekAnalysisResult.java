package com.ypfr.loseweight.service;

public class DeepSeekAnalysisResult {

  private String status;
  private String summary;
  private String rawJson;
  private String error;

  public static DeepSeekAnalysisResult success(String summary, String rawJson) {
    DeepSeekAnalysisResult result = new DeepSeekAnalysisResult();
    result.setStatus("success");
    result.setSummary(summary);
    result.setRawJson(rawJson);
    return result;
  }

  public static DeepSeekAnalysisResult failed(String summary, String error) {
    DeepSeekAnalysisResult result = new DeepSeekAnalysisResult();
    result.setStatus("failed");
    result.setSummary(summary);
    result.setError(error);
    return result;
  }

  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  public String getSummary() { return summary; }
  public void setSummary(String summary) { this.summary = summary; }
  public String getRawJson() { return rawJson; }
  public void setRawJson(String rawJson) { this.rawJson = rawJson; }
  public String getError() { return error; }
  public void setError(String error) { this.error = error; }
}
