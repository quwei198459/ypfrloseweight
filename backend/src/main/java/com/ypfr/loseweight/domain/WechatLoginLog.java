package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;

@TableName("wechat_login_log")
public class WechatLoginLog {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long userId;
  private String openid;
  private String unionId;
  private Integer success;
  private String errorMessage;
  private LocalDateTime loginAt;
  private String clientIp;
  private String clientUa;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public String getOpenid() {
    return openid;
  }

  public void setOpenid(String openid) {
    this.openid = openid;
  }

  public String getUnionId() {
    return unionId;
  }

  public void setUnionId(String unionId) {
    this.unionId = unionId;
  }

  public Integer getSuccess() {
    return success;
  }

  public void setSuccess(Integer success) {
    this.success = success;
  }

  public String getErrorMessage() {
    return errorMessage;
  }

  public void setErrorMessage(String errorMessage) {
    this.errorMessage = errorMessage;
  }

  public LocalDateTime getLoginAt() {
    return loginAt;
  }

  public void setLoginAt(LocalDateTime loginAt) {
    this.loginAt = loginAt;
  }

  public String getClientIp() {
    return clientIp;
  }

  public void setClientIp(String clientIp) {
    this.clientIp = clientIp;
  }

  public String getClientUa() {
    return clientUa;
  }

  public void setClientUa(String clientUa) {
    this.clientUa = clientUa;
  }
}
