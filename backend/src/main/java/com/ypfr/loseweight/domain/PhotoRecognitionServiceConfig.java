package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;

@TableName("photo_recognition_service_config")
public class PhotoRecognitionServiceConfig {

  @TableId(type = IdType.AUTO)
  private Long id;

  private String configKey;
  private String servicePhone;
  private String serviceWechat;
  private String qrImageUrl;
  private String qrImagePath;
  private String qrImageName;
  private Integer status;
  private String remark;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getConfigKey() {
    return configKey;
  }

  public void setConfigKey(String configKey) {
    this.configKey = configKey;
  }

  public String getServicePhone() {
    return servicePhone;
  }

  public void setServicePhone(String servicePhone) {
    this.servicePhone = servicePhone;
  }

  public String getServiceWechat() {
    return serviceWechat;
  }

  public void setServiceWechat(String serviceWechat) {
    this.serviceWechat = serviceWechat;
  }

  public String getQrImageUrl() {
    return qrImageUrl;
  }

  public void setQrImageUrl(String qrImageUrl) {
    this.qrImageUrl = qrImageUrl;
  }

  public String getQrImagePath() {
    return qrImagePath;
  }

  public void setQrImagePath(String qrImagePath) {
    this.qrImagePath = qrImagePath;
  }

  public String getQrImageName() {
    return qrImageName;
  }

  public void setQrImageName(String qrImageName) {
    this.qrImageName = qrImageName;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
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
