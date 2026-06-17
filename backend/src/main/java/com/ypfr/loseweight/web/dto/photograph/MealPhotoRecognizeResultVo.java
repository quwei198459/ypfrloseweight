package com.ypfr.loseweight.web.dto.photograph;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.List;

/**
 * 与前端识图页、补充 PRD 出参对齐：photoJobId、状态、foods、预算快照、confirmStatus 等。
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class MealPhotoRecognizeResultVo {

  private Long photoJobId;
  /** uploading / recognizing / success / fail */
  private String recognizeStatus;
  /**
   * 异步或多段流水线时使用；同步成功完成时可为 null。可选值：uploading / recognizing_type /
   * recognizing_weight
   */
  private String recognizePhase;
  private String imageUrl;
  private String previewUrl;
  private String recommendedMealType;
  /** DeepSeek 个性化推荐用语（替代固定"推荐吃 X%"）；可能为 null */
  private String recommendText;
  private List<MealPhotoFoodItemVo> foods;
  /** 0~1，与前端 recommendedEatRatio 一致 */
  private Double recommendedEatRatio;
  private Integer intakeCaloriesToday;
  private Integer dailyBudgetCalories;
  /** 0~100 */
  private Double badgeProgressPercent;
  /** none / pending_confirm / confirmed / aborted */
  private String confirmStatus;
  private Integer totalRecognizedCalories;
  private String errorCode;
  private String errorMessage;

  public Long getPhotoJobId() {
    return photoJobId;
  }

  public void setPhotoJobId(Long photoJobId) {
    this.photoJobId = photoJobId;
  }

  public String getRecognizeStatus() {
    return recognizeStatus;
  }

  public void setRecognizeStatus(String recognizeStatus) {
    this.recognizeStatus = recognizeStatus;
  }

  public String getRecognizePhase() {
    return recognizePhase;
  }

  public void setRecognizePhase(String recognizePhase) {
    this.recognizePhase = recognizePhase;
  }

  public String getImageUrl() {
    return imageUrl;
  }

  public void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  public String getPreviewUrl() {
    return previewUrl;
  }

  public void setPreviewUrl(String previewUrl) {
    this.previewUrl = previewUrl;
  }

  public String getRecommendedMealType() {
    return recommendedMealType;
  }

  public void setRecommendedMealType(String recommendedMealType) {
    this.recommendedMealType = recommendedMealType;
  }

  public String getRecommendText() {
    return recommendText;
  }

  public void setRecommendText(String recommendText) {
    this.recommendText = recommendText;
  }

  public List<MealPhotoFoodItemVo> getFoods() {
    return foods;
  }

  public void setFoods(List<MealPhotoFoodItemVo> foods) {
    this.foods = foods;
  }

  public Double getRecommendedEatRatio() {
    return recommendedEatRatio;
  }

  public void setRecommendedEatRatio(Double recommendedEatRatio) {
    this.recommendedEatRatio = recommendedEatRatio;
  }

  public Integer getIntakeCaloriesToday() {
    return intakeCaloriesToday;
  }

  public void setIntakeCaloriesToday(Integer intakeCaloriesToday) {
    this.intakeCaloriesToday = intakeCaloriesToday;
  }

  public Integer getDailyBudgetCalories() {
    return dailyBudgetCalories;
  }

  public void setDailyBudgetCalories(Integer dailyBudgetCalories) {
    this.dailyBudgetCalories = dailyBudgetCalories;
  }

  public Double getBadgeProgressPercent() {
    return badgeProgressPercent;
  }

  public void setBadgeProgressPercent(Double badgeProgressPercent) {
    this.badgeProgressPercent = badgeProgressPercent;
  }

  public String getConfirmStatus() {
    return confirmStatus;
  }

  public void setConfirmStatus(String confirmStatus) {
    this.confirmStatus = confirmStatus;
  }

  public Integer getTotalRecognizedCalories() {
    return totalRecognizedCalories;
  }

  public void setTotalRecognizedCalories(Integer totalRecognizedCalories) {
    this.totalRecognizedCalories = totalRecognizedCalories;
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
}
