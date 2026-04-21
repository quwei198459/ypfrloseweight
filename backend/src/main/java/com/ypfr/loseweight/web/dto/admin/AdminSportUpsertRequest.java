package com.ypfr.loseweight.web.dto.admin;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public class AdminSportUpsertRequest {

  @NotBlank(message = "name 不能为空")
  private String name;

  private String icon;

  @NotNull(message = "caloriesPer60min 不能为空")
  private BigDecimal caloriesPer60min;

  private String category;
  private Integer sortNo;

  @NotNull(message = "status 不能为空")
  private Integer status;

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

  public Integer getSortNo() {
    return sortNo;
  }

  public void setSortNo(Integer sortNo) {
    this.sortNo = sortNo;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
  }
}
