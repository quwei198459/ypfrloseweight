package com.ypfr.loseweight.web.dto.skin;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class SkinDetectionReportVo {

  private Long recordId;
  private String status;
  private String failReason;
  private String phone;
  private String userName;
  private Integer gender;
  private LocalDate birthday;
  private Integer age;
  private String residence;
  private String imageUrl;
  private Long detectTypes;
  private Integer overallScore;
  private String aiSummary;
  private String deepseekStatus;
  private String deepseekError;
  private LocalDateTime createdAt;
  private List<SkinDetectionItemVo> items = new ArrayList<>();

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
  public String getImageUrl() { return imageUrl; }
  public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
  public Long getDetectTypes() { return detectTypes; }
  public void setDetectTypes(Long detectTypes) { this.detectTypes = detectTypes; }
  public Integer getOverallScore() { return overallScore; }
  public void setOverallScore(Integer overallScore) { this.overallScore = overallScore; }
  public String getAiSummary() { return aiSummary; }
  public void setAiSummary(String aiSummary) { this.aiSummary = aiSummary; }
  public String getDeepseekStatus() { return deepseekStatus; }
  public void setDeepseekStatus(String deepseekStatus) { this.deepseekStatus = deepseekStatus; }
  public String getDeepseekError() { return deepseekError; }
  public void setDeepseekError(String deepseekError) { this.deepseekError = deepseekError; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
  public List<SkinDetectionItemVo> getItems() { return items; }
  public void setItems(List<SkinDetectionItemVo> items) { this.items = items; }
}
