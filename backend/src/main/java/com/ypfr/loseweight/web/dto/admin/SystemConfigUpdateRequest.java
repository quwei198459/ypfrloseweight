package com.ypfr.loseweight.web.dto.admin;

/** 更新系统配置开关；字段为 null 表示本次不修改该项。 */
public class SystemConfigUpdateRequest {

  private Boolean photoRecognitionWhitelistEnabled;
  private Boolean skinDetectionWhitelistEnabled;
  private Boolean tcmDetectionWhitelistEnabled;

  public Boolean getPhotoRecognitionWhitelistEnabled() {
    return photoRecognitionWhitelistEnabled;
  }

  public void setPhotoRecognitionWhitelistEnabled(Boolean photoRecognitionWhitelistEnabled) {
    this.photoRecognitionWhitelistEnabled = photoRecognitionWhitelistEnabled;
  }

  public Boolean getSkinDetectionWhitelistEnabled() {
    return skinDetectionWhitelistEnabled;
  }

  public void setSkinDetectionWhitelistEnabled(Boolean skinDetectionWhitelistEnabled) {
    this.skinDetectionWhitelistEnabled = skinDetectionWhitelistEnabled;
  }

  public Boolean getTcmDetectionWhitelistEnabled() {
    return tcmDetectionWhitelistEnabled;
  }

  public void setTcmDetectionWhitelistEnabled(Boolean tcmDetectionWhitelistEnabled) {
    this.tcmDetectionWhitelistEnabled = tcmDetectionWhitelistEnabled;
  }
}
