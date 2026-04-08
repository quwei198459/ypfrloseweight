package com.ypfr.loseweight.web.dto.photograph;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public class MealPhotoConfirmItemDto {

  @NotBlank private String lineId;
  private Long foodId;
  private String confirmedFoodName;
  /** 最终写入热量（千卡），已含食用比例 */
  @NotNull private BigDecimal confirmedCalories;
  /** 0~1，可空按 1 */
  private BigDecimal confirmedEatRatio;

  public String getLineId() {
    return lineId;
  }

  public void setLineId(String lineId) {
    this.lineId = lineId;
  }

  public Long getFoodId() {
    return foodId;
  }

  public void setFoodId(Long foodId) {
    this.foodId = foodId;
  }

  public String getConfirmedFoodName() {
    return confirmedFoodName;
  }

  public void setConfirmedFoodName(String confirmedFoodName) {
    this.confirmedFoodName = confirmedFoodName;
  }

  public BigDecimal getConfirmedCalories() {
    return confirmedCalories;
  }

  public void setConfirmedCalories(BigDecimal confirmedCalories) {
    this.confirmedCalories = confirmedCalories;
  }

  public BigDecimal getConfirmedEatRatio() {
    return confirmedEatRatio;
  }

  public void setConfirmedEatRatio(BigDecimal confirmedEatRatio) {
    this.confirmedEatRatio = confirmedEatRatio;
  }
}
