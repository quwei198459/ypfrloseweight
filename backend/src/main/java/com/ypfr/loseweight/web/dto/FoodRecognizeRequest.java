package com.ypfr.loseweight.web.dto;

import jakarta.validation.constraints.AssertTrue;

public class FoodRecognizeRequest {

  /** 可选：联调用户，默认 1 */
  private Long userId;

  private String imageBase64;
  private String imageUrl;

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public String getImageBase64() {
    return imageBase64;
  }

  public void setImageBase64(String imageBase64) {
    this.imageBase64 = imageBase64;
  }

  public String getImageUrl() {
    return imageUrl;
  }

  public void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  @AssertTrue(message = "imageBase64 与 imageUrl 至少填一个")
  public boolean isImagePresent() {
    return (imageBase64 != null && !imageBase64.isBlank())
        || (imageUrl != null && !imageUrl.isBlank());
  }
}
