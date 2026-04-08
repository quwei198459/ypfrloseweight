package com.ypfr.loseweight.web.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class MealEntryVo {

  private Long id;
  private Long userId;
  private String mealType;
  private String foodName;
  private Integer calories;
  private BigDecimal proteinG;
  private BigDecimal fatG;
  private BigDecimal carbsG;
  private BigDecimal amountValue;
  private String amountUnit;
  private LocalDateTime recordedAt;
  private Long foodLibraryId;
  private LocalDateTime createdAt;

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

  public String getMealType() {
    return mealType;
  }

  public void setMealType(String mealType) {
    this.mealType = mealType;
  }

  public String getFoodName() {
    return foodName;
  }

  public void setFoodName(String foodName) {
    this.foodName = foodName;
  }

  public Integer getCalories() {
    return calories;
  }

  public void setCalories(Integer calories) {
    this.calories = calories;
  }

  public BigDecimal getProteinG() {
    return proteinG;
  }

  public void setProteinG(BigDecimal proteinG) {
    this.proteinG = proteinG;
  }

  public BigDecimal getFatG() {
    return fatG;
  }

  public void setFatG(BigDecimal fatG) {
    this.fatG = fatG;
  }

  public BigDecimal getCarbsG() {
    return carbsG;
  }

  public void setCarbsG(BigDecimal carbsG) {
    this.carbsG = carbsG;
  }

  public BigDecimal getAmountValue() {
    return amountValue;
  }

  public void setAmountValue(BigDecimal amountValue) {
    this.amountValue = amountValue;
  }

  public String getAmountUnit() {
    return amountUnit;
  }

  public void setAmountUnit(String amountUnit) {
    this.amountUnit = amountUnit;
  }

  public LocalDateTime getRecordedAt() {
    return recordedAt;
  }

  public void setRecordedAt(LocalDateTime recordedAt) {
    this.recordedAt = recordedAt;
  }

  public Long getFoodLibraryId() {
    return foodLibraryId;
  }

  public void setFoodLibraryId(Long foodLibraryId) {
    this.foodLibraryId = foodLibraryId;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }
}
