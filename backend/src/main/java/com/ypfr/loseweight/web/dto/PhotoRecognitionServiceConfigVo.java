package com.ypfr.loseweight.web.dto;

public class PhotoRecognitionServiceConfigVo {

  private String servicePhone;
  private String serviceWechat;
  private String serviceQrImageUrl;
  private String serviceQrImagePath;
  private String serviceQrImageName;
  private String remark;
  private Integer status;

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

  public String getServiceQrImageUrl() {
    return serviceQrImageUrl;
  }

  public void setServiceQrImageUrl(String serviceQrImageUrl) {
    this.serviceQrImageUrl = serviceQrImageUrl;
  }

  public String getServiceQrImagePath() {
    return serviceQrImagePath;
  }

  public void setServiceQrImagePath(String serviceQrImagePath) {
    this.serviceQrImagePath = serviceQrImagePath;
  }

  public String getServiceQrImageName() {
    return serviceQrImageName;
  }

  public void setServiceQrImageName(String serviceQrImageName) {
    this.serviceQrImageName = serviceQrImageName;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
  }
}
