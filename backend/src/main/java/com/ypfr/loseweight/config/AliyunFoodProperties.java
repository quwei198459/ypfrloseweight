package com.ypfr.loseweight.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "aliyun.food")
public class AliyunFoodProperties {

  /** 如 https://jmfdcl.market.alicloudapi.com */
  private String host = "https://jmfdcl.market.alicloudapi.com";

  private String path = "/food/calories/query";

  /** 云市场 APPCODE，勿提交真实值到 Git */
  private String appcode = "";

  public String getHost() {
    return host;
  }

  public void setHost(String host) {
    this.host = host;
  }

  public String getPath() {
    return path;
  }

  public void setPath(String path) {
    this.path = path;
  }

  public String getAppcode() {
    return appcode;
  }

  public void setAppcode(String appcode) {
    this.appcode = appcode;
  }

  public String fullUrl() {
    return host.replaceAll("/$", "") + path;
  }
}
