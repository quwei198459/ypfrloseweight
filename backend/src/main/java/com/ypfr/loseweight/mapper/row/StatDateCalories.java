package com.ypfr.loseweight.mapper.row;

import java.math.BigDecimal;
import java.time.LocalDate;

public class StatDateCalories {

  private LocalDate statDate;
  private BigDecimal totalCalories;

  public LocalDate getStatDate() {
    return statDate;
  }

  public void setStatDate(LocalDate statDate) {
    this.statDate = statDate;
  }

  public BigDecimal getTotalCalories() {
    return totalCalories;
  }

  public void setTotalCalories(BigDecimal totalCalories) {
    this.totalCalories = totalCalories;
  }
}
