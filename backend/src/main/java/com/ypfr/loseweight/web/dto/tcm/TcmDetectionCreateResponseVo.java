package com.ypfr.loseweight.web.dto.tcm;

import java.util.ArrayList;
import java.util.List;

public class TcmDetectionCreateResponseVo {

  private Long recordId;
  private String status;
  private Integer overallScore;
  private String constitutionPrimary;
  private String message;
  private List<TcmInquiryQuestionVo> inquiryQuestions = new ArrayList<>();

  public Long getRecordId() { return recordId; }
  public void setRecordId(Long recordId) { this.recordId = recordId; }
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  public Integer getOverallScore() { return overallScore; }
  public void setOverallScore(Integer overallScore) { this.overallScore = overallScore; }
  public String getConstitutionPrimary() { return constitutionPrimary; }
  public void setConstitutionPrimary(String constitutionPrimary) { this.constitutionPrimary = constitutionPrimary; }
  public String getMessage() { return message; }
  public void setMessage(String message) { this.message = message; }
  public List<TcmInquiryQuestionVo> getInquiryQuestions() { return inquiryQuestions; }
  public void setInquiryQuestions(List<TcmInquiryQuestionVo> inquiryQuestions) { this.inquiryQuestions = inquiryQuestions; }
}
