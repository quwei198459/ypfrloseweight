package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("daily_summary")
public class DailySummary {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long userId;
  private LocalDate summaryDate;

  private BigDecimal dailyBudget;
  private BigDecimal intakeCalories;
  private BigDecimal exerciseCalories;
  private BigDecimal remainCalories;
  private BigDecimal actualDeficitCalories;
  private BigDecimal budgetDeficitCalories;

  private BigDecimal carbTotalG;
  private BigDecimal proteinTotalG;
  private BigDecimal fatTotalG;
  private BigDecimal carbTargetG;
  private BigDecimal proteinTargetG;
  private BigDecimal fatTargetG;

  private LocalDateTime firstMealTime;
  private LocalDateTime lastMealTime;
  private BigDecimal eatingWindowHours;
  private Integer healthyDietFlag;
  private String dayStatus;

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

  public LocalDate getSummaryDate() {
    return summaryDate;
  }

  public void setSummaryDate(LocalDate summaryDate) {
    this.summaryDate = summaryDate;
  }

  public BigDecimal getDailyBudget() {
    return dailyBudget;
  }

  public void setDailyBudget(BigDecimal dailyBudget) {
    this.dailyBudget = dailyBudget;
  }

  public BigDecimal getIntakeCalories() {
    return intakeCalories;
  }

  public void setIntakeCalories(BigDecimal intakeCalories) {
    this.intakeCalories = intakeCalories;
  }

  public BigDecimal getExerciseCalories() {
    return exerciseCalories;
  }

  public void setExerciseCalories(BigDecimal exerciseCalories) {
    this.exerciseCalories = exerciseCalories;
  }

  public BigDecimal getRemainCalories() {
    return remainCalories;
  }

  public void setRemainCalories(BigDecimal remainCalories) {
    this.remainCalories = remainCalories;
  }

  public BigDecimal getActualDeficitCalories() {
    return actualDeficitCalories;
  }

  public void setActualDeficitCalories(BigDecimal actualDeficitCalories) {
    this.actualDeficitCalories = actualDeficitCalories;
  }

  public BigDecimal getBudgetDeficitCalories() {
    return budgetDeficitCalories;
  }

  public void setBudgetDeficitCalories(BigDecimal budgetDeficitCalories) {
    this.budgetDeficitCalories = budgetDeficitCalories;
  }

  public BigDecimal getCarbTotalG() {
    return carbTotalG;
  }

  public void setCarbTotalG(BigDecimal carbTotalG) {
    this.carbTotalG = carbTotalG;
  }

  public BigDecimal getProteinTotalG() {
    return proteinTotalG;
  }

  public void setProteinTotalG(BigDecimal proteinTotalG) {
    this.proteinTotalG = proteinTotalG;
  }

  public BigDecimal getFatTotalG() {
    return fatTotalG;
  }

  public void setFatTotalG(BigDecimal fatTotalG) {
    this.fatTotalG = fatTotalG;
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

  public LocalDateTime getFirstMealTime() {
    return firstMealTime;
  }

  public void setFirstMealTime(LocalDateTime firstMealTime) {
    this.firstMealTime = firstMealTime;
  }

  public LocalDateTime getLastMealTime() {
    return lastMealTime;
  }

  public void setLastMealTime(LocalDateTime lastMealTime) {
    this.lastMealTime = lastMealTime;
  }

  public BigDecimal getEatingWindowHours() {
    return eatingWindowHours;
  }

  public void setEatingWindowHours(BigDecimal eatingWindowHours) {
    this.eatingWindowHours = eatingWindowHours;
  }

  public Integer getHealthyDietFlag() {
    return healthyDietFlag;
  }

  public void setHealthyDietFlag(Integer healthyDietFlag) {
    this.healthyDietFlag = healthyDietFlag;
  }

  public String getDayStatus() {
    return dayStatus;
  }

  public void setDayStatus(String dayStatus) {
    this.dayStatus = dayStatus;
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
