package com.ypfr.loseweight.mapper.row;

import java.math.BigDecimal;
import java.time.LocalDate;

public class StatDateMacros {

  private LocalDate statDate;
  private BigDecimal proteinG;
  private BigDecimal fatG;
  private BigDecimal carbsG;

  public LocalDate getStatDate() {
    return statDate;
  }

  public void setStatDate(LocalDate statDate) {
    this.statDate = statDate;
  }

  public BigDecimal getProteinG() {
    return proteinG;
  }

  public void setProteinG(BigDecimal proteinG) {
    this.proteinG = proteinG;
  }

  public BigDecimal getFatG() {
    return fatG;
  }

  public void setFatG(BigDecimal fatG) {
    this.fatG = fatG;
  }

  public BigDecimal getCarbsG() {
    return carbsG;
  }

  public void setCarbsG(BigDecimal carbsG) {
    this.carbsG = carbsG;
  }
}
