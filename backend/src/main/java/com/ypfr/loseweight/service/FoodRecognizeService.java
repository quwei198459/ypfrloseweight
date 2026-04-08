package com.ypfr.loseweight.service;

import com.ypfr.loseweight.domain.MealPhotoRecognition;
import com.ypfr.loseweight.mapper.MealPhotoRecognitionMapper;
import com.ypfr.loseweight.web.dto.FoodRecognizeRequest;
import com.ypfr.loseweight.web.dto.FoodRecognizeResponse;
import java.time.LocalDate;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class FoodRecognizeService {

  private final AliyunFoodCalorieClient aliyunFoodCalorieClient;
  private final MealPhotoRecognitionMapper mealPhotoRecognitionMapper;

  public FoodRecognizeService(
      AliyunFoodCalorieClient aliyunFoodCalorieClient,
      MealPhotoRecognitionMapper mealPhotoRecognitionMapper) {
    this.aliyunFoodCalorieClient = aliyunFoodCalorieClient;
    this.mealPhotoRecognitionMapper = mealPhotoRecognitionMapper;
  }

  public FoodRecognizeResponse recognize(FoodRecognizeRequest req) {
    Long uid = req.getUserId() != null ? req.getUserId() : 1L;
    MealPhotoRecognition row = new MealPhotoRecognition();
    row.setUserId(uid);
    row.setMealType("snack");
    row.setRecordDate(LocalDate.now());
    row.setSource("camera");
    row.setVendor("aliyun");

    try {
      ResponseEntity<String> resp =
          aliyunFoodCalorieClient.query(
              StringUtils.hasText(req.getImageBase64()) ? req.getImageBase64() : null,
              StringUtils.hasText(req.getImageUrl()) ? req.getImageUrl() : null);
      row.setRecognizeStatus(resp.getStatusCode().is2xxSuccessful() ? "success" : "fail");
      row.setRawResult(resp.getBody());
      mealPhotoRecognitionMapper.insert(row);
      return new FoodRecognizeResponse(resp.getStatusCode().value(), resp.getBody());
    } catch (Exception e) {
      row.setRecognizeStatus("fail");
      String msg = e.getMessage() != null ? e.getMessage() : "error";
      row.setErrorMessage(msg.length() > 500 ? msg.substring(0, 500) : msg);
      mealPhotoRecognitionMapper.insert(row);
      throw e;
    }
  }
}
