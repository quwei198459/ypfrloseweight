package com.ypfr.loseweight.web.dto.photograph;

import jakarta.validation.constraints.AssertTrue;

/** 与前端提交识图、补充 PRD 入参对齐 */
public class MealPhotoSubmitRequest {

  /** 已废弃：统一由 JWT 识别用户 */
  private Long userId;

  /** camera / album */
  private String source;

  /** breakfast / lunch / dinner / snack，可空则服务端按时间推荐 */
  private String mealType;

  /** yyyy-MM-dd，可空为当日 */
  private String recordDate;

  private String imageBase64;
  private String imageUrl;

  public Long getUserId() {
    return userId;
  }

  public void setUserId(Long userId) {
    this.userId = userId;
  }

  public String getSource() {
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }

  public String getMealType() {
    return mealType;
  }

  public void setMealType(String mealType) {
    this.mealType = mealType;
  }

  public String getRecordDate() {
    return recordDate;
  }

  public void setRecordDate(String recordDate) {
    this.recordDate = recordDate;
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
