package com.ypfr.loseweight.web.dto;

public class PhotoRecognitionAccessVo {

  private Boolean allowed;
  private Boolean phoneBound;
  private String reason;
  private String message;
  private String servicePhone;
  private String serviceWechat;
  private String serviceQrImageUrl;
  private String serviceQrImagePath;
  private String serviceQrImageName;
  private Integer totalQuota;
  private Integer usedCount;
  private Integer remainingCount;

  public Boolean getAllowed() {
    return allowed;
  }

  public void setAllowed(Boolean allowed) {
    this.allowed = allowed;
  }

  public Boolean getPhoneBound() {
    return phoneBound;
  }

  public void setPhoneBound(Boolean phoneBound) {
    this.phoneBound = phoneBound;
  }

  public String getReason() {
    return reason;
  }

  public void setReason(String reason) {
    this.reason = reason;
  }

  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
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

  public Integer getTotalQuota() {
    return totalQuota;
  }

  public void setTotalQuota(Integer totalQuota) {
    this.totalQuota = totalQuota;
  }

  public Integer getUsedCount() {
    return usedCount;
  }

  public void setUsedCount(Integer usedCount) {
    this.usedCount = usedCount;
  }

  public Integer getRemainingCount() {
    return remainingCount;
  }

  public void setRemainingCount(Integer remainingCount) {
    this.remainingCount = remainingCount;
  }
}
