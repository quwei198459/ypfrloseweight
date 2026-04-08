package com.ypfr.loseweight.web.dto;

/** 食物查询页侧栏分类项（与前端 key/label 对应） */
public class FoodCategoryItemVo {

  private String code;
  private String name;
  private int sortNo;

  public FoodCategoryItemVo() {}

  public FoodCategoryItemVo(String code, String name, int sortNo) {
    this.code = code;
    this.name = name;
    this.sortNo = sortNo;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public int getSortNo() {
    return sortNo;
  }

  public void setSortNo(int sortNo) {
    this.sortNo = sortNo;
  }
}
