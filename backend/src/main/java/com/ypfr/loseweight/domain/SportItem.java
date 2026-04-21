package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;

@TableName("sport_item")
public class SportItem {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long creatorUserId;
  private String name;
  private String icon;

  /** 库列 calories_per_60min；含数字段名时 MP 默认驼峰易误生成 calories_per60min */
  @TableField("calories_per_60min")
  private BigDecimal caloriesPer60min;
  private String category;
  private Integer isCustom;
  private Integer status;
  private Integer sortNo;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  /** 兼容旧前端：每分钟消耗 */
  @JsonProperty("caloriesPerMin")
  public BigDecimal getCaloriesPerMinForApi() {
    if (caloriesPer60min == null) {
      return null;
    }
    return caloriesPer60min.divide(BigDecimal.valueOf(60), 4, RoundingMode.HALF_UP);
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

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getIcon() {
    return icon;
  }

  public void setIcon(String icon) {
    this.icon = icon;
  }

  @JsonIgnore
  public BigDecimal getCaloriesPer60min() {
    return caloriesPer60min;
  }

  public void setCaloriesPer60min(BigDecimal caloriesPer60min) {
    this.caloriesPer60min = caloriesPer60min;
  }

  public String getCategory() {
    return category;
  }

  public void setCategory(String category) {
    this.category = category;
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

  public Integer getSortNo() {
    return sortNo;
  }

  public void setSortNo(Integer sortNo) {
    this.sortNo = sortNo;
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
}
