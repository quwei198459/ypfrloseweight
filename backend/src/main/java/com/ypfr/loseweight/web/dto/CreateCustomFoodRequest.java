package com.ypfr.loseweight.web.dto;

import java.math.BigDecimal;

/** 用户自定义食物：名称 + 估重(g) + 该份量总热量(千卡) */
public class CreateCustomFoodRequest {

  private String name;
  /** 估重，单位 g，须大于 0 */
  private BigDecimal weightG;
  /** 该份量总热量（千卡），须大于 0 */
  private BigDecimal calories;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public BigDecimal getWeightG() {
    return weightG;
  }

  public void setWeightG(BigDecimal weightG) {
    this.weightG = weightG;
  }

  public BigDecimal getCalories() {
    return calories;
  }

  public void setCalories(BigDecimal calories) {
    this.calories = calories;
  }
}
