package com.ypfr.loseweight.web.dto.photograph;

import jakarta.validation.constraints.NotNull;

public class MealPhotoResultQuery {

  @NotNull private Long photoJobId;

  public Long getPhotoJobId() {
    return photoJobId;
  }

  public void setPhotoJobId(Long photoJobId) {
    this.photoJobId = photoJobId;
  }
}
