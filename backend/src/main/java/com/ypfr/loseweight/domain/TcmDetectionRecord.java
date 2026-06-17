package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("tcm_detection_record")
public class TcmDetectionRecord {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long userId;
  private String phone;
  private String userName;
  private Integer gender;
  private LocalDate birthday;
  private Integer age;
  private String residence;
  private String tongueImageUrl;
  private String faceImageUrl;
  private String thirdPartyId;
  private String constitutionPrimary;
  private String constitutionJson;
  private Integer overallScore;
  private String aiSummary;
  private String aiSummaryJson;
  private String thirdPartyRaw;
  private String status;
  private String failReason;
  private String deepseekStatus;
  private String deepseekError;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public Long getUserId() { return userId; }
  public void setUserId(Long userId) { this.userId = userId; }
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
  public String getThirdPartyId() { return thirdPartyId; }
  public void setThirdPartyId(String thirdPartyId) { this.thirdPartyId = thirdPartyId; }
  public String getConstitutionPrimary() { return constitutionPrimary; }
  public void setConstitutionPrimary(String constitutionPrimary) { this.constitutionPrimary = constitutionPrimary; }
  public String getConstitutionJson() { return constitutionJson; }
  public void setConstitutionJson(String constitutionJson) { this.constitutionJson = constitutionJson; }
  public Integer getOverallScore() { return overallScore; }
  public void setOverallScore(Integer overallScore) { this.overallScore = overallScore; }
  public String getAiSummary() { return aiSummary; }
  public void setAiSummary(String aiSummary) { this.aiSummary = aiSummary; }
  public String getAiSummaryJson() { return aiSummaryJson; }
  public void setAiSummaryJson(String aiSummaryJson) { this.aiSummaryJson = aiSummaryJson; }
  public String getThirdPartyRaw() { return thirdPartyRaw; }
  public void setThirdPartyRaw(String thirdPartyRaw) { this.thirdPartyRaw = thirdPartyRaw; }
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  public String getFailReason() { return failReason; }
  public void setFailReason(String failReason) { this.failReason = failReason; }
  public String getDeepseekStatus() { return deepseekStatus; }
  public void setDeepseekStatus(String deepseekStatus) { this.deepseekStatus = deepseekStatus; }
  public String getDeepseekError() { return deepseekError; }
  public void setDeepseekError(String deepseekError) { this.deepseekError = deepseekError; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
  public LocalDateTime getUpdatedAt() { return updatedAt; }
  public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
