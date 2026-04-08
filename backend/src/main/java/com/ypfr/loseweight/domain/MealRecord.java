package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/** PRD 餐次头，表 meal_record */
@TableName("meal_record")
public class MealRecord {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long userId;
  private LocalDate recordDate;
  private String mealType;
  private BigDecimal totalCalories;
  private BigDecimal totalCarbG;
  private BigDecimal totalProteinG;
  private BigDecimal totalFatG;
  private Integer foodCount;
  private String status;
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

  public BigDecimal getTotalCalories() {
    return totalCalories;
  }

  public void setTotalCalories(BigDecimal totalCalories) {
    this.totalCalories = totalCalories;
  }

  public BigDecimal getTotalCarbG() {
    return totalCarbG;
  }

  public void setTotalCarbG(BigDecimal totalCarbG) {
    this.totalCarbG = totalCarbG;
  }

  public BigDecimal getTotalProteinG() {
    return totalProteinG;
  }

  public void setTotalProteinG(BigDecimal totalProteinG) {
    this.totalProteinG = totalProteinG;
  }

  public BigDecimal getTotalFatG() {
    return totalFatG;
  }

  public void setTotalFatG(BigDecimal totalFatG) {
    this.totalFatG = totalFatG;
  }

  public Integer getFoodCount() {
    return foodCount;
  }

  public void setFoodCount(Integer foodCount) {
    this.foodCount = foodCount;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
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
