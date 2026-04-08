package com.ypfr.loseweight.web.dto;

public class DailyRecordItemDto {

  /** meal | sport */
  private String kind;
  private Long id;
  private String recordedAt;
  private String title;
  private String subtitle;
  private Integer calories;

  public String getKind() {
    return kind;
  }

  public void setKind(String kind) {
    this.kind = kind;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getRecordedAt() {
    return recordedAt;
  }

  public void setRecordedAt(String recordedAt) {
    this.recordedAt = recordedAt;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getSubtitle() {
    return subtitle;
  }

  public void setSubtitle(String subtitle) {
    this.subtitle = subtitle;
  }

  public Integer getCalories() {
    return calories;
  }

  public void setCalories(Integer calories) {
    this.calories = calories;
  }
}
