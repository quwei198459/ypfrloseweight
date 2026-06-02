package com.ypfr.loseweight.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.photo-recognition")
public class PhotoRecognitionProperties {

  /** 未开通拍照识别时展示给用户的客服电话 */
  private String servicePhone = "400-000-0000";

  /** 未开通拍照识别时展示给用户的客服微信号 */
  private String serviceWechat = "baohu-service";

  /** 未开通拍照识别时展示给用户的客服二维码图片地址 */
  private String serviceQrImageUrl = "";

  /** 客服二维码图片 Base64 上传后的本地访问地址 */
  private String serviceQrImagePath = "";

  /** 客服二维码图片文件名 */
  private String serviceQrImageName = "";

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
}
