package com.ypfr.loseweight.web.dto;

public class DailyMacroDto {

  private double proteinG;
  private double fatG;
  private double carbsG;
  /** 当日目标（来自 user_budget_config，缺省为产品默认克数） */
  private double proteinTargetG;
  private double fatTargetG;
  private double carbTargetG;

  public double getProteinG() {
    return proteinG;
  }

  public void setProteinG(double proteinG) {
    this.proteinG = proteinG;
  }

  public double getFatG() {
    return fatG;
  }

  public void setFatG(double fatG) {
    this.fatG = fatG;
  }

  public double getCarbsG() {
    return carbsG;
  }

  public void setCarbsG(double carbsG) {
    this.carbsG = carbsG;
  }

  public double getProteinTargetG() {
    return proteinTargetG;
  }

  public void setProteinTargetG(double proteinTargetG) {
    this.proteinTargetG = proteinTargetG;
  }

  public double getFatTargetG() {
    return fatTargetG;
  }

  public void setFatTargetG(double fatTargetG) {
    this.fatTargetG = fatTargetG;
  }

  public double getCarbTargetG() {
    return carbTargetG;
  }

  public void setCarbTargetG(double carbTargetG) {
    this.carbTargetG = carbTargetG;
  }
}
