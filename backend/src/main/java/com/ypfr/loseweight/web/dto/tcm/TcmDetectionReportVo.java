package com.ypfr.loseweight.web.dto.tcm;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TcmDetectionReportVo {

  private Long recordId;
  private String status;
  private String failReason;
  private String phone;
  private String userName;
  private Integer gender;
  private LocalDate birthday;
  private Integer age;
  private String residence;
  private String tongueImageUrl;
  private String faceImageUrl;
  private String constitutionPrimary;
  private Integer overallScore;
  private String reportJson;
  private String aiSummary;
  private String deepseekStatus;
  private String deepseekError;
  private LocalDateTime createdAt;
  private List<TcmDetectionItemVo> items = new ArrayList<>();

  public Long getRecordId() { return recordId; }
  public void setRecordId(Long recordId) { this.recordId = recordId; }
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  public String getFailReason() { return failReason; }
  public void setFailReason(String failReason) { this.failReason = failReason; }
  public String getPhone() { return phone; }
  public void setPhone(String phone) { this.phone = phone; }
  public String getUserName() { return userName; }
  public void setUserName(String userName) { this.userName = userName; }
  public Integer getGender() { return gender; }
  public void setGender(Integer gender) { this.gender = gender; }
  public LocalDate getBirthday() { return birthday; }
  public void setBirthday(LocalDate birthday) { this.birthday = birthday; }
  public Integer getAge() { return age; }
  public void setAge(Integer age) { this.age = age; }
  public String getResidence() { return residence; }
  public void setResidence(String residence) { this.residence = residence; }
  public String getTongueImageUrl() { return tongueImageUrl; }
  public void setTongueImageUrl(String tongueImageUrl) { this.tongueImageUrl = tongueImageUrl; }
  public String getFaceImageUrl() { return faceImageUrl; }
  public void setFaceImageUrl(String faceImageUrl) { this.faceImageUrl = faceImageUrl; }
  public String getConstitutionPrimary() { return constitutionPrimary; }
  public void setConstitutionPrimary(String constitutionPrimary) { this.constitutionPrimary = constitutionPrimary; }
  public Integer getOverallScore() { return overallScore; }
  public void setOverallScore(Integer overallScore) { this.overallScore = overallScore; }
  public String getReportJson() { return reportJson; }
  public void setReportJson(String reportJson) { this.reportJson = reportJson; }
  public String getAiSummary() { return aiSummary; }
  public void setAiSummary(String aiSummary) { this.aiSummary = aiSummary; }
  public String getDeepseekStatus() { return deepseekStatus; }
  public void setDeepseekStatus(String deepseekStatus) { this.deepseekStatus = deepseekStatus; }
  public String getDeepseekError() { return deepseekError; }
  public void setDeepseekError(String deepseekError) { this.deepseekError = deepseekError; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
  public List<TcmDetectionItemVo> getItems() { return items; }
  public void setItems(List<TcmDetectionItemVo> items) { this.items = items; }
}
