package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("diet_record")
public class DietRecordRow {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long mealId;
  private Long userId;
  private LocalDate recordDate;
  private String mealType;
  private Long foodId;
  private String foodNameSnapshot;
  private String imageSnapshot;
  private String giLevelSnapshot;
  private BigDecimal amount;
  private String amountUnit;
  private BigDecimal weightG;
  private BigDecimal caloriesTotal;
  private BigDecimal carbTotalG;
  private BigDecimal proteinTotalG;
  private BigDecimal fatTotalG;
  private String source;
  private LocalDateTime recordTime;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Long getMealId() {
    return mealId;
  }

  public void setMealId(Long mealId) {
    this.mealId = mealId;
  }

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public LocalDate getRecordDate() {
    return recordDate;
  }

  public void setRecordDate(LocalDate recordDate) {
    this.recordDate = recordDate;
  }

  public String getMealType() {
    return mealType;
  }

  public void setMealType(String mealType) {
    this.mealType = mealType;
  }

  public Long getFoodId() {
    return foodId;
  }

  public void setFoodId(Long foodId) {
    this.foodId = foodId;
  }

  public String getFoodNameSnapshot() {
    return foodNameSnapshot;
  }

  public void setFoodNameSnapshot(String foodNameSnapshot) {
    this.foodNameSnapshot = foodNameSnapshot;
  }

  public String getImageSnapshot() {
    return imageSnapshot;
  }

  public void setImageSnapshot(String imageSnapshot) {
    this.imageSnapshot = imageSnapshot;
  }

  public String getGiLevelSnapshot() {
    return giLevelSnapshot;
  }

  public void setGiLevelSnapshot(String giLevelSnapshot) {
    this.giLevelSnapshot = giLevelSnapshot;
  }

  public BigDecimal getAmount() {
    return amount;
  }

  public void setAmount(BigDecimal amount) {
    this.amount = amount;
  }

  public String getAmountUnit() {
    return amountUnit;
  }

  public void setAmountUnit(String amountUnit) {
    this.amountUnit = amountUnit;
  }

  public BigDecimal getWeightG() {
    return weightG;
  }

  public void setWeightG(BigDecimal weightG) {
    this.weightG = weightG;
  }

  public BigDecimal getCaloriesTotal() {
    return caloriesTotal;
  }

  public void setCaloriesTotal(BigDecimal caloriesTotal) {
    this.caloriesTotal = caloriesTotal;
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

  public String getSource() {
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }

  public LocalDateTime getRecordTime() {
    return recordTime;
  }

  public void setRecordTime(LocalDateTime recordTime) {
    this.recordTime = recordTime;
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
