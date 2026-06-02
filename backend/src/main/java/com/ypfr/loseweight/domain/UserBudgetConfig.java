package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("user_budget_config")
public class UserBudgetConfig {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long userId;
  private Integer useCustomBmr;
  private BigDecimal customBmr;
  private BigDecimal activityLevel;
  private BigDecimal calculatedBmr;
  private BigDecimal calculatedTdee;
  private BigDecimal recommendedDeficit;
  private BigDecimal dailyBudget;
  private BigDecimal carbTargetG;
  private BigDecimal proteinTargetG;
  private BigDecimal fatTargetG;
  private LocalDate effectiveDate;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
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

  public BigDecimal getActivityLevel() {
    return activityLevel;
  }

  public void setActivityLevel(BigDecimal activityLevel) {
    this.activityLevel = activityLevel;
  }

  public BigDecimal getCalculatedBmr() {
    return calculatedBmr;
  }

  public void setCalculatedBmr(BigDecimal calculatedBmr) {
    this.calculatedBmr = calculatedBmr;
  }

  public BigDecimal getCalculatedTdee() {
    return calculatedTdee;
  }

  public void setCalculatedTdee(BigDecimal calculatedTdee) {
    this.calculatedTdee = calculatedTdee;
  }

  public BigDecimal getRecommendedDeficit() {
    return recommendedDeficit;
  }

  public void setRecommendedDeficit(BigDecimal recommendedDeficit) {
    this.recommendedDeficit = recommendedDeficit;
  }

  public BigDecimal getDailyBudget() {
    return dailyBudget;
  }

  public void setDailyBudget(BigDecimal dailyBudget) {
    this.dailyBudget = dailyBudget;
  }

  public BigDecimal getCarbTargetG() {
    return carbTargetG;
  }

  public void setCarbTargetG(BigDecimal carbTargetG) {
    this.carbTargetG = carbTargetG;
  }

  public BigDecimal getProteinTargetG() {
    return proteinTargetG;
  }

  public void setProteinTargetG(BigDecimal proteinTargetG) {
    this.proteinTargetG = proteinTargetG;
  }

  public BigDecimal getFatTargetG() {
    return fatTargetG;
  }

  public void setFatTargetG(BigDecimal fatTargetG) {
    this.fatTargetG = fatTargetG;
  }

  public LocalDate getEffectiveDate() {
    return effectiveDate;
  }

  public void setEffectiveDate(LocalDate effectiveDate) {
    this.effectiveDate = effectiveDate;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }
}
