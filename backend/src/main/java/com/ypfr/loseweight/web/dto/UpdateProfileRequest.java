package com.ypfr.loseweight.web.dto;

import java.math.BigDecimal;

/** 个人信息保存（字段均可选，未传的保持库中原值；保存时会重算 profile_completed） */
public class UpdateProfileRequest {

  private String nickname;
  private String avatarBase64;
  private Integer gender;
  private Integer age;
  /** yyyy-MM-dd */
  private String birthday;
  private BigDecimal heightCm;
  private BigDecimal currentWeightKg;
  private BigDecimal targetWeightKg;
  private BigDecimal initialWeightKg;
  /** yyyy-MM-dd */
  private String targetDate;
  private String residenceProvince;
  private String residenceCity;
  private String residenceDistrict;
  /** 活动系数档位 1-5，可选 */
  private Integer activityLevel;
  /** 1=使用 customBmr，0=恢复系统按资料计算 */
  private Integer useCustomBmr;
  /** 自定义基础代谢（kcal），仅 useCustomBmr=1 时生效 */
  private BigDecimal customBmr;

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

  public String getBirthday() {
    return birthday;
  }

  public void setBirthday(String birthday) {
    this.birthday = birthday;
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

  public String getResidenceProvince() {
    return residenceProvince;
  }

  public void setResidenceProvince(String residenceProvince) {
    this.residenceProvince = residenceProvince;
  }

  public String getResidenceCity() {
    return residenceCity;
  }

  public void setResidenceCity(String residenceCity) {
    this.residenceCity = residenceCity;
  }

  public String getResidenceDistrict() {
    return residenceDistrict;
  }

  public void setResidenceDistrict(String residenceDistrict) {
    this.residenceDistrict = residenceDistrict;
  }

  public Integer getActivityLevel() {
    return activityLevel;
  }

  public void setActivityLevel(Integer activityLevel) {
    this.activityLevel = activityLevel;
  }

  public Integer getUseCustomBmr() {
    return useCustomBmr;
  }

  public void setUseCustomBmr(Integer useCustomBmr) {
    this.useCustomBmr = useCustomBmr;
  }

  public BigDecimal getCustomBmr() {
    return customBmr;
  }

  public void setCustomBmr(BigDecimal customBmr) {
    this.customBmr = customBmr;
  }
}
