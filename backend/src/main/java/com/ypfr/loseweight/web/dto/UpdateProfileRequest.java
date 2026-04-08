package com.ypfr.loseweight.web.dto;

import java.math.BigDecimal;

/** 个人信息保存（字段均可选，未传的保持库中原值；保存时会重算 profile_completed） */
public class UpdateProfileRequest {

  private String nickname;
  private String avatarBase64;
  private Integer gender;
  private Integer age;
  private BigDecimal heightCm;
  private BigDecimal currentWeightKg;
  private BigDecimal targetWeightKg;
  private BigDecimal initialWeightKg;
  /** yyyy-MM-dd */
  private String targetDate;
  /** 活动系数档位 1-5，可选 */
  private Integer activityLevel;

  public String getNickname() {
    return nickname;
  }

  public void setNickname(String nickname) {
    this.nickname = nickname;
  }

  public String getAvatarBase64() {
    return avatarBase64;
  }

  public void setAvatarBase64(String avatarBase64) {
    this.avatarBase64 = avatarBase64;
  }

  public Integer getGender() {
    return gender;
  }

  public void setGender(Integer gender) {
    this.gender = gender;
  }

  public Integer getAge() {
    return age;
  }

  public void setAge(Integer age) {
    this.age = age;
  }

  public BigDecimal getHeightCm() {
    return heightCm;
  }

  public void setHeightCm(BigDecimal heightCm) {
    this.heightCm = heightCm;
  }

  public BigDecimal getCurrentWeightKg() {
    return currentWeightKg;
  }

  public void setCurrentWeightKg(BigDecimal currentWeightKg) {
    this.currentWeightKg = currentWeightKg;
  }

  public BigDecimal getTargetWeightKg() {
    return targetWeightKg;
  }

  public void setTargetWeightKg(BigDecimal targetWeightKg) {
    this.targetWeightKg = targetWeightKg;
  }

  public BigDecimal getInitialWeightKg() {
    return initialWeightKg;
  }

  public void setInitialWeightKg(BigDecimal initialWeightKg) {
    this.initialWeightKg = initialWeightKg;
  }

  public String getTargetDate() {
    return targetDate;
  }

  public void setTargetDate(String targetDate) {
    this.targetDate = targetDate;
  }

  public Integer getActivityLevel() {
    return activityLevel;
  }

  public void setActivityLevel(Integer activityLevel) {
    this.activityLevel = activityLevel;
  }
}
