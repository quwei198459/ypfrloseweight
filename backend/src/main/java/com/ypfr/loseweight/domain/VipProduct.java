package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;

@TableName("vip_product")
public class VipProduct {

  @TableId(type = IdType.AUTO)
  private Long id;

  private String code;
  private String title;
  private String subtitle;
  private BigDecimal priceYuan;
  private BigDecimal originPriceYuan;
  private Integer durationDays;
  private String cornerTag;
  private Integer sortOrder;
  private Integer enabled;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

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

  public Integer getSortOrder() {
    return sortOrder;
  }

  public void setSortOrder(Integer sortOrder) {
    this.sortOrder = sortOrder;
  }

  public Integer getEnabled() {
    return enabled;
  }

  public void setEnabled(Integer enabled) {
    this.enabled = enabled;
  }
}
