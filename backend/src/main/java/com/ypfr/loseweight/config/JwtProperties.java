package com.ypfr.loseweight.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.jwt")
public class JwtProperties {

  /** HS256 密钥字节长度需 ≥ 32（建议随机串） */
  private String secret = "";

  private long expireSeconds = 604800L;

  public String getSecret() {
    return secret;
  }

  public void setSecret(String secret) {
    this.secret = secret;
  }

  public long getExpireSeconds() {
    return expireSeconds;
  }

  public void setExpireSeconds(long expireSeconds) {
    this.expireSeconds = expireSeconds;
  }
}
