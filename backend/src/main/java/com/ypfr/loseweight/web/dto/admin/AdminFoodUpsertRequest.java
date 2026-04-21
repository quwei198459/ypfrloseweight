package com.ypfr.loseweight.web.dto.admin;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public class AdminFoodUpsertRequest {

  @NotNull(message = "categoryId 不能为空")
  private Long categoryId;

  @NotBlank(message = "name 不能为空")
  private String name;

  private String image;
  private String giLevel;
  private BigDecimal caloriesPer100g;
  private BigDecimal caloriesPerUnit;
  private String unitName;
  private BigDecimal standardWeightG;
  private BigDecimal ediblePortionRate;
  private BigDecimal proteinPer100g;
  private BigDecimal fatPer100g;
  private BigDecimal carbPer100g;
  private String keywords;

  @NotNull(message = "status 不能为空")
  private Integer status;

  public Long getCategoryId() {
    return categoryId;
  }

  public void setCategoryId(Long categoryId) {
    this.categoryId = categoryId;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getImage() {
    return image;
  }

  public void setImage(String image) {
    this.image = image;
  }

  public String getGiLevel() {
    return giLevel;
  }

  public void setGiLevel(String giLevel) {
    this.giLevel = giLevel;
  }

  public BigDecimal getCaloriesPer100g() {
    return caloriesPer100g;
  }

  public void setCaloriesPer100g(BigDecimal caloriesPer100g) {
    this.caloriesPer100g = caloriesPer100g;
  }

  public BigDecimal getCaloriesPerUnit() {
    return caloriesPerUnit;
  }

  public void setCaloriesPerUnit(BigDecimal caloriesPerUnit) {
    this.caloriesPerUnit = caloriesPerUnit;
  }

  public String getUnitName() {
    return unitName;
  }

  public void setUnitName(String unitName) {
    this.unitName = unitName;
  }

  public BigDecimal getStandardWeightG() {
    return standardWeightG;
  }

  public void setStandardWeightG(BigDecimal standardWeightG) {
    this.standardWeightG = standardWeightG;
  }

  public BigDecimal getEdiblePortionRate() {
    return ediblePortionRate;
  }

  public void setEdiblePortionRate(BigDecimal ediblePortionRate) {
    this.ediblePortionRate = ediblePortionRate;
  }

  public BigDecimal getProteinPer100g() {
    return proteinPer100g;
  }

  public void setProteinPer100g(BigDecimal proteinPer100g) {
    this.proteinPer100g = proteinPer100g;
  }

  public BigDecimal getFatPer100g() {
    return fatPer100g;
  }

  public void setFatPer100g(BigDecimal fatPer100g) {
    this.fatPer100g = fatPer100g;
  }

  public BigDecimal getCarbPer100g() {
    return carbPer100g;
  }

  public void setCarbPer100g(BigDecimal carbPer100g) {
    this.carbPer100g = carbPer100g;
  }

  public String getKeywords() {
    return keywords;
  }

  public void setKeywords(String keywords) {
    this.keywords = keywords;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
  }
}
