package com.ypfr.loseweight.web.dto.photograph;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.math.BigDecimal;

/** 与前端 PhotographMockFood / foods[] 对齐 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class MealPhotoFoodItemVo {

  private String lineId;
  private String foodName;
  /** 兼容字段：初始展示热量（千卡），按 caloriesPer100 * quantity / 100 计算 */
  private Integer calories;
  /** 聚美类型：1=食物，2=营养成分 */
  private Integer type;
  /** 每 100g/ml 热量（千卡） */
  private BigDecimal caloriesPer100;
  /** 默认识别数量，当前统一为 100 */
  private BigDecimal quantity;
  /** 默认识别单位，当前统一为 g/ml */
  private String quantityUnit;
  /** 如「低 GI」 */
  private String giLabel;
  private Long foodId;
  private Double weightG;

  public String getLineId() {
    return lineId;
  }

  public void setLineId(String lineId) {
    this.lineId = lineId;
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

  public Integer getType() {
    return type;
  }

  public void setType(Integer type) {
    this.type = type;
  }

  public BigDecimal getCaloriesPer100() {
    return caloriesPer100;
  }

  public void setCaloriesPer100(BigDecimal caloriesPer100) {
    this.caloriesPer100 = caloriesPer100;
  }

  public BigDecimal getQuantity() {
    return quantity;
  }

  public void setQuantity(BigDecimal quantity) {
    this.quantity = quantity;
  }

  public String getQuantityUnit() {
    return quantityUnit;
  }

  public void setQuantityUnit(String quantityUnit) {
    this.quantityUnit = quantityUnit;
  }

  public String getGiLabel() {
    return giLabel;
  }

  public void setGiLabel(String giLabel) {
    this.giLabel = giLabel;
  }

  public Long getFoodId() {
    return foodId;
  }

  public void setFoodId(Long foodId) {
    this.foodId = foodId;
  }

  public Double getWeightG() {
    return weightG;
  }

  public void setWeightG(Double weightG) {
    this.weightG = weightG;
  }
}
