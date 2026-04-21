package com.ypfr.loseweight.web.dto;

import java.math.BigDecimal;

/** 会员档位（前端开通页） */
public class VipProductVo {

  private String code;
  private String title;
  private String subtitle;
  private BigDecimal priceYuan;
  private BigDecimal originPriceYuan;
  private Integer durationDays;
  private String cornerTag;

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getSubtitle() {
    return subtitle;
  }

  public void setSubtitle(String subtitle) {
    this.subtitle = subtitle;
  }

  public BigDecimal getPriceYuan() {
    return priceYuan;
  }

  public void setPriceYuan(BigDecimal priceYuan) {
    this.priceYuan = priceYuan;
  }

  public BigDecimal getOriginPriceYuan() {
    return originPriceYuan;
  }

  public void setOriginPriceYuan(BigDecimal originPriceYuan) {
    this.originPriceYuan = originPriceYuan;
  }

  public Integer getDurationDays() {
    return durationDays;
  }

  public void setDurationDays(Integer durationDays) {
    this.durationDays = durationDays;
  }

  public String getCornerTag() {
    return cornerTag;
  }

  public void setCornerTag(String cornerTag) {
    this.cornerTag = cornerTag;
  }
}
