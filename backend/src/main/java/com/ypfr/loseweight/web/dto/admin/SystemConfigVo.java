package com.ypfr.loseweight.web.dto.admin;

/** 系统配置开关视图：true=白名单限制开启，false=关闭限制（所有用户可用）。 */
public class SystemConfigVo {

  private Boolean photoRecognitionWhitelistEnabled;
  private Boolean skinDetectionWhitelistEnabled;
  private Boolean tcmDetectionWhitelistEnabled;
  private Boolean skinDetectionEntryVisible;
  private Boolean tcmDetectionEntryVisible;

  public Boolean getSkinDetectionEntryVisible() {
    return skinDetectionEntryVisible;
  }

  public void setSkinDetectionEntryVisible(Boolean skinDetectionEntryVisible) {
    this.skinDetectionEntryVisible = skinDetectionEntryVisible;
  }

  public Boolean getTcmDetectionEntryVisible() {
    return tcmDetectionEntryVisible;
  }

  public void setTcmDetectionEntryVisible(Boolean tcmDetectionEntryVisible) {
    this.tcmDetectionEntryVisible = tcmDetectionEntryVisible;
  }

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
