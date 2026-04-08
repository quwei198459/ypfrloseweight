package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("sport_record")
public class SportRecord {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long userId;
  private LocalDate recordDate;
  private Long sportItemId;
  private String sportNameSnapshot;
  private String iconSnapshot;
  private Integer durationMin;
  private BigDecimal caloriesBurned;
  private String source;
  private LocalDateTime recordTime;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public LocalDate getRecordDate() {
    return recordDate;
  }

  public void setRecordDate(LocalDate recordDate) {
    this.recordDate = recordDate;
  }

  public Long getSportItemId() {
    return sportItemId;
  }

  public void setSportItemId(Long sportItemId) {
    this.sportItemId = sportItemId;
  }

  public String getSportNameSnapshot() {
    return sportNameSnapshot;
  }

  public void setSportNameSnapshot(String sportNameSnapshot) {
    this.sportNameSnapshot = sportNameSnapshot;
  }

  public String getIconSnapshot() {
    return iconSnapshot;
  }

  public void setIconSnapshot(String iconSnapshot) {
    this.iconSnapshot = iconSnapshot;
  }

  public Integer getDurationMin() {
    return durationMin;
  }

  public void setDurationMin(Integer durationMin) {
    this.durationMin = durationMin;
  }

  public BigDecimal getCaloriesBurned() {
    return caloriesBurned;
  }

  public void setCaloriesBurned(BigDecimal caloriesBurned) {
    this.caloriesBurned = caloriesBurned;
  }

  public String getSource() {
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }

  public LocalDateTime getRecordTime() {
    return recordTime;
  }

  public void setRecordTime(LocalDateTime recordTime) {
    this.recordTime = recordTime;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }
}
