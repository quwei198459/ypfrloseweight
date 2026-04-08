package com.ypfr.loseweight.web.dto;

public class DashboardDto {

  private int intakeCalories;
  private int sportCalories;
  private int dailyBudget;
  private int remainingCalories;

  public int getIntakeCalories() {
    return intakeCalories;
  }

  public void setIntakeCalories(int intakeCalories) {
    this.intakeCalories = intakeCalories;
  }

  public int getSportCalories() {
    return sportCalories;
  }

  public void setSportCalories(int sportCalories) {
    this.sportCalories = sportCalories;
  }

  public int getDailyBudget() {
    return dailyBudget;
  }

  public void setDailyBudget(int dailyBudget) {
    this.dailyBudget = dailyBudget;
  }

  public int getRemainingCalories() {
    return remainingCalories;
  }

  public void setRemainingCalories(int remainingCalories) {
    this.remainingCalories = remainingCalories;
  }
}
