package com.ypfr.loseweight.mapper.row;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class StatDateMealWindow {

  private LocalDate statDate;
  private LocalDateTime firstAt;
  private LocalDateTime lastAt;

  public LocalDate getStatDate() {
    return statDate;
  }

  public void setStatDate(LocalDate statDate) {
    this.statDate = statDate;
  }

  public LocalDateTime getFirstAt() {
    return firstAt;
  }

  public void setFirstAt(LocalDateTime firstAt) {
    this.firstAt = firstAt;
  }

  public LocalDateTime getLastAt() {
    return lastAt;
  }

  public void setLastAt(LocalDateTime lastAt) {
    this.lastAt = lastAt;
  }
}
