package com.ypfr.loseweight.web.dto.admin;

import jakarta.validation.constraints.Size;
import org.springframework.web.multipart.MultipartFile;

public class PhotoRecognitionServiceConfigRequest {

  @Size(max = 32, message = "客服电话最多 32 字")
  private String servicePhone;

  @Size(max = 64, message = "客服微信号最多 64 字")
  private String serviceWechat;

  private String serviceQrImageUrl;
  private MultipartFile serviceQrImageFile;
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

  public MultipartFile getServiceQrImageFile() {
    return serviceQrImageFile;
  }

  public void setServiceQrImageFile(MultipartFile serviceQrImageFile) {
    this.serviceQrImageFile = serviceQrImageFile;
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
