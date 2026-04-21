package com.ypfr.loseweight.web.dto.admin;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class AdminUserListItemVo {

  private Long id;
  private String nickname;
  private String phone;
  private Integer status;
  private Integer gender;
  private Integer age;
  private BigDecimal heightCm;
  private BigDecimal currentWeightKg;
  private BigDecimal targetWeightKg;
  private LocalDateTime createdAt;

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

  public String getPhone() {
    return phone;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
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

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }
}
