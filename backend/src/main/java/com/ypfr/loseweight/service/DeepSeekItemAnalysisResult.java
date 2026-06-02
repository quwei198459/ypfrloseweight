package com.ypfr.loseweight.service;

public class DeepSeekItemAnalysisResult {

  private String itemCode;
  private String status;
  private String conclusion;
  private String reason;
  private String careAdvice;
  private String rawJson;
  private String error;

  public static DeepSeekItemAnalysisResult success(
      String itemCode,
      String conclusion,
      String reason,
      String careAdvice,
      String rawJson) {
    DeepSeekItemAnalysisResult result = new DeepSeekItemAnalysisResult();
    result.setItemCode(itemCode);
    result.setStatus("success");
    result.setConclusion(conclusion);
    result.setReason(reason);
    result.setCareAdvice(careAdvice);
    result.setRawJson(rawJson);
    return result;
  }

  public static DeepSeekItemAnalysisResult failed(
      String itemCode,
      String conclusion,
      String reason,
      String careAdvice,
      String error) {
    DeepSeekItemAnalysisResult result = new DeepSeekItemAnalysisResult();
    result.setItemCode(itemCode);
    result.setStatus("failed");
    result.setConclusion(conclusion);
    result.setReason(reason);
    result.setCareAdvice(careAdvice);
    result.setError(error);
    return result;
  }

  public String getItemCode() { return itemCode; }
  public void setItemCode(String itemCode) { this.itemCode = itemCode; }
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  public String getConclusion() { return conclusion; }
  public void setConclusion(String conclusion) { this.conclusion = conclusion; }
  public String getReason() { return reason; }
  public void setReason(String reason) { this.reason = reason; }
  public String getCareAdvice() { return careAdvice; }
  public void setCareAdvice(String careAdvice) { this.careAdvice = careAdvice; }
  public String getRawJson() { return rawJson; }
  public void setRawJson(String rawJson) { this.rawJson = rawJson; }
  public String getError() { return error; }
  public void setError(String error) { this.error = error; }
}
