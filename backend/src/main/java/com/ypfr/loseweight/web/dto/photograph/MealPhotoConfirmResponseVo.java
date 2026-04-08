package com.ypfr.loseweight.web.dto.photograph;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.time.LocalDateTime;
import java.util.List;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class MealPhotoConfirmResponseVo {

  private Long mealRecordId;
  private List<Long> dietRecordIds;
  private String confirmStatus;
  private LocalDateTime confirmedAt;
  private Integer intakeCaloriesToday;
  private Integer dailyBudgetCalories;

  public Long getMealRecordId() {
    return mealRecordId;
  }

  public void setMealRecordId(Long mealRecordId) {
    this.mealRecordId = mealRecordId;
  }

  public List<Long> getDietRecordIds() {
    return dietRecordIds;
  }

  public void setDietRecordIds(List<Long> dietRecordIds) {
    this.dietRecordIds = dietRecordIds;
  }

  public String getConfirmStatus() {
    return confirmStatus;
  }

  public void setConfirmStatus(String confirmStatus) {
    this.confirmStatus = confirmStatus;
  }

  public LocalDateTime getConfirmedAt() {
    return confirmedAt;
  }

  public void setConfirmedAt(LocalDateTime confirmedAt) {
    this.confirmedAt = confirmedAt;
  }

  public Integer getIntakeCaloriesToday() {
    return intakeCaloriesToday;
  }

  public void setIntakeCaloriesToday(Integer intakeCaloriesToday) {
    this.intakeCaloriesToday = intakeCaloriesToday;
  }

  public Integer getDailyBudgetCalories() {
    return dailyBudgetCalories;
  }

  public void setDailyBudgetCalories(Integer dailyBudgetCalories) {
    this.dailyBudgetCalories = dailyBudgetCalories;
  }
}
