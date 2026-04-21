package com.ypfr.loseweight.web.dto;

import java.util.List;

public class CreateMealRecordsBatchResponse {

  private Long mealRecordId;
  private List<MealEntryVo> entries;

  public Long getMealRecordId() {
    return mealRecordId;
  }

  public void setMealRecordId(Long mealRecordId) {
    this.mealRecordId = mealRecordId;
  }

  public List<MealEntryVo> getEntries() {
    return entries;
  }

  public void setEntries(List<MealEntryVo> entries) {
    this.entries = entries;
  }
}
