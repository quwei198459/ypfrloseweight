package com.ypfr.loseweight.web.dto;

public class FoodRecognizeResponse {

  private int httpStatus;
  private String body;

  public FoodRecognizeResponse() {}

  public FoodRecognizeResponse(int httpStatus, String body) {
    this.httpStatus = httpStatus;
    this.body = body;
  }

  public int getHttpStatus() {
    return httpStatus;
  }

  public void setHttpStatus(int httpStatus) {
    this.httpStatus = httpStatus;
  }

  public String getBody() {
    return body;
  }

  public void setBody(String body) {
    this.body = body;
  }
}
