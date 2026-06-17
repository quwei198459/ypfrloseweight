package com.ypfr.loseweight.service;

import java.util.ArrayList;
import java.util.List;

public class ParsedTcmDetectionResult {

  private String thirdPartyId;
  private String constitutionPrimary;
  private String constitutionJson;
  private Integer overallScore;
  private List<ParsedTcmDetectionItem> items = new ArrayList<>();

  public String getThirdPartyId() { return thirdPartyId; }
  public void setThirdPartyId(String thirdPartyId) { this.thirdPartyId = thirdPartyId; }
  public String getConstitutionPrimary() { return constitutionPrimary; }
  public void setConstitutionPrimary(String constitutionPrimary) { this.constitutionPrimary = constitutionPrimary; }
  public String getConstitutionJson() { return constitutionJson; }
  public void setConstitutionJson(String constitutionJson) { this.constitutionJson = constitutionJson; }
  public Integer getOverallScore() { return overallScore; }
  public void setOverallScore(Integer overallScore) { this.overallScore = overallScore; }
  public List<ParsedTcmDetectionItem> getItems() { return items; }
  public void setItems(List<ParsedTcmDetectionItem> items) { this.items = items; }
}
