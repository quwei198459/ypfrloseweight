package com.ypfr.loseweight.service;

import java.util.ArrayList;
import java.util.List;

public class ParsedSkinDetectionResult {

  private String thirdPartyId;
  private Integer overallScore;
  private List<ParsedSkinDetectionItem> items = new ArrayList<>();

  public String getThirdPartyId() { return thirdPartyId; }
  public void setThirdPartyId(String thirdPartyId) { this.thirdPartyId = thirdPartyId; }
  public Integer getOverallScore() { return overallScore; }
  public void setOverallScore(Integer overallScore) { this.overallScore = overallScore; }
  public List<ParsedSkinDetectionItem> getItems() { return items; }
  public void setItems(List<ParsedSkinDetectionItem> items) { this.items = items; }
}
