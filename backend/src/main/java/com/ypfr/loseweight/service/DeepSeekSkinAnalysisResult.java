package com.ypfr.loseweight.service;

import java.util.ArrayList;
import java.util.List;

public class DeepSeekSkinAnalysisResult {

  private DeepSeekAnalysisResult overall;
  private List<DeepSeekItemAnalysisResult> items = new ArrayList<>();

  public DeepSeekAnalysisResult getOverall() {
    return overall;
  }

  public void setOverall(DeepSeekAnalysisResult overall) {
    this.overall = overall;
  }

  public List<DeepSeekItemAnalysisResult> getItems() {
    return items;
  }

  public void setItems(List<DeepSeekItemAnalysisResult> items) {
    this.items = items;
  }
}
