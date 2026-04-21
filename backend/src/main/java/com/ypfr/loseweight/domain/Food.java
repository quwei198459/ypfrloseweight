package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("food")
public class Food {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long creatorUserId;
  private Long categoryId;
  private String name;
  private String image;
  private String giLevel;
  /** 库列 calories_per_100g；须显式映射，否则 MP 会生成错误的 calories_per100g */
  @TableField("calories_per_100g")
  private BigDecimal caloriesPer100g;

  private BigDecimal caloriesPerUnit;
  private String unitName;
  private BigDecimal standardWeightG;
  private BigDecimal ediblePortionRate;

  @TableField("protein_per_100g")
  private BigDecimal proteinPer100g;

  @TableField("fat_per_100g")
  private BigDecimal fatPer100g;

  @TableField("carb_per_100g")
  private BigDecimal carbPer100g;
  private String keywords;
  private Integer isCustom;
  private Integer status;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  @TableField(exist = false)
  private String category;

  @JsonProperty("caloriesPer100")
  public BigDecimal getCaloriesPer100g() {
    return caloriesPer100g;
  }

  public void setCaloriesPer100g(BigDecimal caloriesPer100g) {
    this.caloriesPer100g = caloriesPer100g;
  }

  @JsonProperty("protein")
  public BigDecimal getProteinPer100g() {
    return proteinPer100g;
  }

  public void setProteinPer100g(BigDecimal proteinPer100g) {
    this.proteinPer100g = proteinPer100g;
  }

  @JsonProperty("fat")
  public BigDecimal getFatPer100g() {
    return fatPer100g;
  }

  public void setFatPer100g(BigDecimal fatPer100g) {
    this.fatPer100g = fatPer100g;
  }

  @JsonProperty("carbs")
  public BigDecimal getCarbPer100g() {
    return carbPer100g;
  }

  public void setCarbPer100g(BigDecimal carbPer100g) {
    this.carbPer100g = carbPer100g;
  }

  @JsonProperty("unitLabel")
  public String getUnitName() {
    return unitName;
  }

  public void setUnitName(String unitName) {
    this.unitName = unitName;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Long getCreatorUserId() {
    return creatorUserId;
  }

  public void setCreatorUserId(Long creatorUserId) {
    this.creatorUserId = creatorUserId;
  }

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

  public BigDecimal getCaloriesPerUnit() {
    return caloriesPerUnit;
  }

  public void setCaloriesPerUnit(BigDecimal caloriesPerUnit) {
    this.caloriesPerUnit = caloriesPerUnit;
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

  public String getKeywords() {
    return keywords;
  }

  public void setKeywords(String keywords) {
    this.keywords = keywords;
  }

  public Integer getIsCustom() {
    return isCustom;
  }

  public void setIsCustom(Integer isCustom) {
    this.isCustom = isCustom;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  public String getCategory() {
    return category;
  }

  public void setCategory(String category) {
    this.category = category;
  }
}
