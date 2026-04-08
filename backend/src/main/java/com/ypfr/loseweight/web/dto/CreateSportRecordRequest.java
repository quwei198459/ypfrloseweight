package com.ypfr.loseweight.web.dto;

public class CreateSportRecordRequest {

  private String sportName;
  private Integer durationMin;
  private Integer calories;
  private String icon;
  private String recordedAt;

  public String getSportName() {
    return sportName;
  }

  public void setSportName(String sportName) {
    this.sportName = sportName;
  }

  public Integer getDurationMin() {
    return durationMin;
  }

  public void setDurationMin(Integer durationMin) {
    this.durationMin = durationMin;
  }

  public Integer getCalories() {
    return calories;
  }

  public void setCalories(Integer calories) {
    this.calories = calories;
  }

  public String getIcon() {
    return icon;
  }

  public void setIcon(String icon) {
    this.icon = icon;
  }

  public String getRecordedAt() {
    return recordedAt;
  }

  public void setRecordedAt(String recordedAt) {
    this.recordedAt = recordedAt;
  }
}
