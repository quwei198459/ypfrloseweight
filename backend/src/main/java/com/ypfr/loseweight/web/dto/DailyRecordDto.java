package com.ypfr.loseweight.web.dto;

import java.util.List;

public class DailyRecordDto {

  private String date;
  private int intakeCalories;
  private int sportCalories;
  private DailyMacroDto macros;
  private List<DailyRecordItemDto> timeline;

  public String getDate() {
    return date;
  }

  public void setDate(String date) {
    this.date = date;
  }

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

  public DailyMacroDto getMacros() {
    return macros;
  }

  public void setMacros(DailyMacroDto macros) {
    this.macros = macros;
  }

  public List<DailyRecordItemDto> getTimeline() {
    return timeline;
  }

  public void setTimeline(List<DailyRecordItemDto> timeline) {
    this.timeline = timeline;
  }
}
