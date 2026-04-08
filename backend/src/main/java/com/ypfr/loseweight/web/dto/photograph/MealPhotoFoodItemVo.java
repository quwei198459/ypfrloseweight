package com.ypfr.loseweight.web.dto.photograph;

import com.fasterxml.jackson.annotation.JsonInclude;

/** 与前端 PhotographMockFood / foods[] 对齐 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class MealPhotoFoodItemVo {

  private String lineId;
  private String foodName;
  /** 基准热量（千卡），整数与前端展示一致 */
  private Integer calories;
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
