package com.ypfr.loseweight.web.dto.admin;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** 管理后台运动列表/表单回显，避免直接序列化 {@link com.ypfr.loseweight.domain.SportItem} 的 Jackson 注解冲突 */
public class AdminSportItemVo {

  private Long id;
  private Long creatorUserId;
  private String name;
  private String icon;
  private BigDecimal caloriesPer60min;
  private String category;
  private Integer isCustom;
  private Integer status;
  private Integer sortNo;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

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
