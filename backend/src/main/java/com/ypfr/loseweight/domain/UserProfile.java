package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("user_profile")
public class UserProfile {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long userId;
  private Integer gender;
  private Integer age;
  private LocalDate birthday;
  private BigDecimal heightCm;
  private BigDecimal initialWeightKg;
  private BigDecimal currentWeightKg;
  private BigDecimal targetWeightKg;
  private LocalDate targetDate;
  private String residenceProvince;
  private String residenceCity;
  private String residenceDistrict;
  private Integer profileCompleted;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public Long getUserId() { return userId; }
  public void setUserId(Long userId) { this.userId = userId; }
  public Integer getGender() { return gender; }
  public void setGender(Integer gender) { this.gender = gender; }
  public Integer getAge() { return age; }
  public void setAge(Integer age) { this.age = age; }
  public LocalDate getBirthday() { return birthday; }
  public void setBirthday(LocalDate birthday) { this.birthday = birthday; }
  public BigDecimal getHeightCm() { return heightCm; }
  public void setHeightCm(BigDecimal heightCm) { this.heightCm = heightCm; }
  public BigDecimal getInitialWeightKg() { return initialWeightKg; }
  public void setInitialWeightKg(BigDecimal initialWeightKg) { this.initialWeightKg = initialWeightKg; }
  public BigDecimal getCurrentWeightKg() { return currentWeightKg; }
  public void setCurrentWeightKg(BigDecimal currentWeightKg) { this.currentWeightKg = currentWeightKg; }
  public BigDecimal getTargetWeightKg() { return targetWeightKg; }
  public void setTargetWeightKg(BigDecimal targetWeightKg) { this.targetWeightKg = targetWeightKg; }
  public LocalDate getTargetDate() { return targetDate; }
  public void setTargetDate(LocalDate targetDate) { this.targetDate = targetDate; }
  public String getResidenceProvince() { return residenceProvince; }
  public void setResidenceProvince(String residenceProvince) { this.residenceProvince = residenceProvince; }
  public String getResidenceCity() { return residenceCity; }
  public void setResidenceCity(String residenceCity) { this.residenceCity = residenceCity; }
  public String getResidenceDistrict() { return residenceDistrict; }
  public void setResidenceDistrict(String residenceDistrict) { this.residenceDistrict = residenceDistrict; }
  public Integer getProfileCompleted() { return profileCompleted; }
  public void setProfileCompleted(Integer profileCompleted) { this.profileCompleted = profileCompleted; }
  public LocalDateTime getCreatedAt() { return createdAt; }
  public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
  public LocalDateTime getUpdatedAt() { return updatedAt; }
  public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
