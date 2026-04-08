package com.ypfr.loseweight.web.dto;

import java.util.List;

/** 与小程序 WeekMetricChartCard 对齐的序列化结构 */
public class WeekStatsCardDto {

  private String title;
  private String unitLabel;
  private double totalValue;
  private String totalSuffix;
  private List<Double> values;
  private List<Double> yAxisLabels;
  private boolean showGuideLine;
  private double guideValue;
  private String guideLabel;
  private String barColor;
  private String guideColor;
  /** deficit | positive | empty */
  private String mode;

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getUnitLabel() {
    return unitLabel;
  }

  public void setUnitLabel(String unitLabel) {
    this.unitLabel = unitLabel;
  }

  public double getTotalValue() {
    return totalValue;
  }

  public void setTotalValue(double totalValue) {
    this.totalValue = totalValue;
  }

  public String getTotalSuffix() {
    return totalSuffix;
  }

  public void setTotalSuffix(String totalSuffix) {
    this.totalSuffix = totalSuffix;
  }

  public List<Double> getValues() {
    return values;
  }

  public void setValues(List<Double> values) {
    this.values = values;
  }

  public List<Double> getYAxisLabels() {
    return yAxisLabels;
  }

  public void setYAxisLabels(List<Double> yAxisLabels) {
    this.yAxisLabels = yAxisLabels;
  }

  public boolean isShowGuideLine() {
    return showGuideLine;
  }

  public void setShowGuideLine(boolean showGuideLine) {
    this.showGuideLine = showGuideLine;
  }

  public double getGuideValue() {
    return guideValue;
  }

  public void setGuideValue(double guideValue) {
    this.guideValue = guideValue;
  }

  public String getGuideLabel() {
    return guideLabel;
  }

  public void setGuideLabel(String guideLabel) {
    this.guideLabel = guideLabel;
  }

  public String getBarColor() {
    return barColor;
  }

  public void setBarColor(String barColor) {
    this.barColor = barColor;
  }

  public String getGuideColor() {
    return guideColor;
  }

  public void setGuideColor(String guideColor) {
    this.guideColor = guideColor;
  }

  public String getMode() {
    return mode;
  }

  public void setMode(String mode) {
    this.mode = mode;
  }
}
