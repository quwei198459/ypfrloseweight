package com.ypfr.loseweight.web.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

/** 返回给前端的用户信息（不含 openid 等敏感字段可按需裁剪） */
public class AppUserDto {

  private Long id;
  private String nickname;
  private String avatarUrl;
  private String phone;
  private Boolean profileCompleted;
  private Integer gender;
  private Integer age;
  private BigDecimal heightCm;
  private BigDecimal currentWeightKg;
  private BigDecimal targetWeightKg;
  private BigDecimal initialWeightKg;
  private LocalDate targetDate;
  private Integer bmr;
  private Integer tdee;
  private Integer dailyCalorieGoal;
  private Integer activityLevel;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getNickname() {
    return nickname;
  }

  public void setNickname(String nickname) {
    this.nickname = nickname;
  }

  public String getAvatarUrl() {
    return avatarUrl;
  }

  public void setAvatarUrl(String avatarUrl) {
    this.avatarUrl = avatarUrl;
  }

  public String getPhone() {
    return phone;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }

  public Boolean getProfileCompleted() {
    return profileCompleted;
  }

  public void setProfileCompleted(Boolean profileCompleted) {
    this.profileCompleted = profileCompleted;
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

  public LocalDate getTargetDate() {
    return targetDate;
  }

  public void setTargetDate(LocalDate targetDate) {
    this.targetDate = targetDate;
  }

  public Integer getBmr() {
    return bmr;
  }

  public void setBmr(Integer bmr) {
    this.bmr = bmr;
  }

  public Integer getTdee() {
    return tdee;
  }

  public void setTdee(Integer tdee) {
    this.tdee = tdee;
  }

  public Integer getDailyCalorieGoal() {
    return dailyCalorieGoal;
  }

  public void setDailyCalorieGoal(Integer dailyCalorieGoal) {
    this.dailyCalorieGoal = dailyCalorieGoal;
  }

  public Integer getActivityLevel() {
    return activityLevel;
  }

  public void setActivityLevel(Integer activityLevel) {
    this.activityLevel = activityLevel;
  }
}
