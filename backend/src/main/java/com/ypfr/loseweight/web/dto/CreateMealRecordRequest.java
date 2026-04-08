package com.ypfr.loseweight.web.dto;

import java.math.BigDecimal;

public class CreateMealRecordRequest {

  private String mealType;
  private String foodName;
  private Integer calories;
  private BigDecimal amountValue;
  private String amountUnit;
  /** ISO-8601 本地时间，如 2026-04-02T12:30:00 或 yyyy-MM-dd HH:mm:ss */
  private String recordedAt;
  private Long foodLibraryId;
  private BigDecimal proteinG;
  private BigDecimal fatG;
  private BigDecimal carbsG;

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

  public String getRecordedAt() {
    return recordedAt;
  }

  public void setRecordedAt(String recordedAt) {
    this.recordedAt = recordedAt;
  }

  public Long getFoodLibraryId() {
    return foodLibraryId;
  }

  public void setFoodLibraryId(Long foodLibraryId) {
    this.foodLibraryId = foodLibraryId;
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
}
