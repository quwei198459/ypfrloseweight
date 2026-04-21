package com.ypfr.loseweight.web.dto;

import java.util.List;

/**
 * 同一用户、同一日历日、同一餐次下批量追加饮食明细；若该餐次头不存在则创建。
 *
 * <p>recordDate：yyyy-MM-dd；recordedAt：行级可覆盖，否则用本字段作为各条 record_time（ISO 或 yyyy-MM-dd
 * HH:mm:ss）。
 */
public class CreateMealRecordsBatchRequest {

  private String recordDate;
  private String mealType;
  private String recordedAt;
  private List<BatchMealItemRequest> items;

  public String getRecordDate() {
    return recordDate;
  }

  public void setRecordDate(String recordDate) {
    this.recordDate = recordDate;
  }

  public String getMealType() {
    return mealType;
  }

  public void setMealType(String mealType) {
    this.mealType = mealType;
  }

  public String getRecordedAt() {
    return recordedAt;
  }

  public void setRecordedAt(String recordedAt) {
    this.recordedAt = recordedAt;
  }

  public List<BatchMealItemRequest> getItems() {
    return items;
  }

  public void setItems(List<BatchMealItemRequest> items) {
    this.items = items;
  }
}
