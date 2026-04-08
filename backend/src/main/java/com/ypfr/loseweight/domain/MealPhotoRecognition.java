package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("meal_photo_recognition")
public class MealPhotoRecognition {

  @TableId(type = IdType.AUTO)
  private Long id;

  private Long userId;
  private String mealType;
  private String recommendedMealType;
  private String confirmedMealType;
  private LocalDate recordDate;
  private String source;
  private String imageUrl;
  private String recognizedFoodName;
  private String confirmedFoodName;
  private BigDecimal recognizedCalories;
  private BigDecimal confirmedCalories;
  private BigDecimal recommendedEatRatio;
  private BigDecimal confirmedEatRatio;
  private BigDecimal badgeProgressPercent;
  private String recognizeStatus;
  private String confirmStatus;
  private LocalDateTime confirmedAt;
  private Long mealRecordId;
  private Long dietRecordId;
  private String vendor;
  private String vendorRequestId;
  private String rawResult;
  private String parsedResultJson;
  private String resultType;
  private String errorCode;
  private String errorMessage;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

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

  public String getMealType() {
    return mealType;
  }

  public void setMealType(String mealType) {
    this.mealType = mealType;
  }

  public String getRecommendedMealType() {
    return recommendedMealType;
  }

  public void setRecommendedMealType(String recommendedMealType) {
    this.recommendedMealType = recommendedMealType;
  }

  public String getConfirmedMealType() {
    return confirmedMealType;
  }

  public void setConfirmedMealType(String confirmedMealType) {
    this.confirmedMealType = confirmedMealType;
  }

  public LocalDate getRecordDate() {
    return recordDate;
  }

  public void setRecordDate(LocalDate recordDate) {
    this.recordDate = recordDate;
  }

  public String getSource() {
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }

  public String getImageUrl() {
    return imageUrl;
  }

  public void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  public String getRecognizedFoodName() {
    return recognizedFoodName;
  }

  public void setRecognizedFoodName(String recognizedFoodName) {
    this.recognizedFoodName = recognizedFoodName;
  }

  public String getConfirmedFoodName() {
    return confirmedFoodName;
  }

  public void setConfirmedFoodName(String confirmedFoodName) {
    this.confirmedFoodName = confirmedFoodName;
  }

  public BigDecimal getRecognizedCalories() {
    return recognizedCalories;
  }

  public void setRecognizedCalories(BigDecimal recognizedCalories) {
    this.recognizedCalories = recognizedCalories;
  }

  public BigDecimal getConfirmedCalories() {
    return confirmedCalories;
  }

  public void setConfirmedCalories(BigDecimal confirmedCalories) {
    this.confirmedCalories = confirmedCalories;
  }

  public BigDecimal getRecommendedEatRatio() {
    return recommendedEatRatio;
  }

  public void setRecommendedEatRatio(BigDecimal recommendedEatRatio) {
    this.recommendedEatRatio = recommendedEatRatio;
  }

  public BigDecimal getConfirmedEatRatio() {
    return confirmedEatRatio;
  }

  public void setConfirmedEatRatio(BigDecimal confirmedEatRatio) {
    this.confirmedEatRatio = confirmedEatRatio;
  }

  public BigDecimal getBadgeProgressPercent() {
    return badgeProgressPercent;
  }

  public void setBadgeProgressPercent(BigDecimal badgeProgressPercent) {
    this.badgeProgressPercent = badgeProgressPercent;
  }

  public String getRecognizeStatus() {
    return recognizeStatus;
  }

  public void setRecognizeStatus(String recognizeStatus) {
    this.recognizeStatus = recognizeStatus;
  }

  public String getConfirmStatus() {
    return confirmStatus;
  }

  public void setConfirmStatus(String confirmStatus) {
    this.confirmStatus = confirmStatus;
  }

  public LocalDateTime getConfirmedAt() {
    return confirmedAt;
  }

  public void setConfirmedAt(LocalDateTime confirmedAt) {
    this.confirmedAt = confirmedAt;
  }

  public Long getMealRecordId() {
    return mealRecordId;
  }

  public void setMealRecordId(Long mealRecordId) {
    this.mealRecordId = mealRecordId;
  }

  public Long getDietRecordId() {
    return dietRecordId;
  }

  public void setDietRecordId(Long dietRecordId) {
    this.dietRecordId = dietRecordId;
  }

  public String getVendor() {
    return vendor;
  }

  public void setVendor(String vendor) {
    this.vendor = vendor;
  }

  public String getVendorRequestId() {
    return vendorRequestId;
  }

  public void setVendorRequestId(String vendorRequestId) {
    this.vendorRequestId = vendorRequestId;
  }

  public String getRawResult() {
    return rawResult;
  }

  public void setRawResult(String rawResult) {
    this.rawResult = rawResult;
  }

  public String getParsedResultJson() {
    return parsedResultJson;
  }

  public void setParsedResultJson(String parsedResultJson) {
    this.parsedResultJson = parsedResultJson;
  }

  public String getResultType() {
    return resultType;
  }

  public void setResultType(String resultType) {
    this.resultType = resultType;
  }

  public String getErrorCode() {
    return errorCode;
  }

  public void setErrorCode(String errorCode) {
    this.errorCode = errorCode;
  }

  public String getErrorMessage() {
    return errorMessage;
  }

  public void setErrorMessage(String errorMessage) {
    this.errorMessage = errorMessage;
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
