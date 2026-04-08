package com.ypfr.loseweight.web.dto.photograph;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.util.List;

public class MealPhotoConfirmRequest {

  /** 已废弃：统一由 JWT 识别用户 */
  private Long userId;
  @NotNull private Long photoJobId;
  @NotBlank private String confirmedMealType;
  private String recordDate;
  @NotEmpty @Valid private List<MealPhotoConfirmItemDto> items;

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public Long getPhotoJobId() {
    return photoJobId;
  }

  public void setPhotoJobId(Long photoJobId) {
    this.photoJobId = photoJobId;
  }

  public String getConfirmedMealType() {
    return confirmedMealType;
  }

  public void setConfirmedMealType(String confirmedMealType) {
    this.confirmedMealType = confirmedMealType;
  }

  public String getRecordDate() {
    return recordDate;
  }

  public void setRecordDate(String recordDate) {
    this.recordDate = recordDate;
  }

  public List<MealPhotoConfirmItemDto> getItems() {
    return items;
  }

  public void setItems(List<MealPhotoConfirmItemDto> items) {
    this.items = items;
  }
}
