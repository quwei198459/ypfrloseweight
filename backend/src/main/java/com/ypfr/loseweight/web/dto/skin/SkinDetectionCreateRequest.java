package com.ypfr.loseweight.web.dto.skin;

import jakarta.validation.constraints.NotBlank;
import java.time.LocalDate;

public class SkinDetectionCreateRequest {

  @NotBlank(message = "图片不能为空")
  private String imageBase64;

  private String name;
  private Integer gender;
  private LocalDate birthday;
  private Integer age;
  private String residence;

  public String getImageBase64() { return imageBase64; }
  public void setImageBase64(String imageBase64) { this.imageBase64 = imageBase64; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public Integer getGender() { return gender; }
  public void setGender(Integer gender) { this.gender = gender; }
  public LocalDate getBirthday() { return birthday; }
  public void setBirthday(LocalDate birthday) { this.birthday = birthday; }
  public Integer getAge() { return age; }
  public void setAge(Integer age) { this.age = age; }
  public String getResidence() { return residence; }
  public void setResidence(String residence) { this.residence = residence; }
}
