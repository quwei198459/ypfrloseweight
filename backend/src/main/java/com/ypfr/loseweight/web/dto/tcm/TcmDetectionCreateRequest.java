package com.ypfr.loseweight.web.dto.tcm;

import jakarta.validation.constraints.NotBlank;
import java.time.LocalDate;

public class TcmDetectionCreateRequest {

  @NotBlank(message = "舌象图片不能为空")
  private String tongueImageBase64;

  @NotBlank(message = "面象图片不能为空")
  private String faceImageBase64;

  /** 舌底图片（可选） */
  private String tongueBottomImageBase64;

  /** 1=问诊问答更准，2=直接出报告；为空走后端默认 */
  private Integer scene;

  private String name;
  private Integer gender;
  private LocalDate birthday;
  private Integer age;
  private String residence;

  public String getTongueImageBase64() { return tongueImageBase64; }
  public void setTongueImageBase64(String tongueImageBase64) { this.tongueImageBase64 = tongueImageBase64; }
  public String getFaceImageBase64() { return faceImageBase64; }
  public void setFaceImageBase64(String faceImageBase64) { this.faceImageBase64 = faceImageBase64; }
  public String getTongueBottomImageBase64() { return tongueBottomImageBase64; }
  public void setTongueBottomImageBase64(String tongueBottomImageBase64) { this.tongueBottomImageBase64 = tongueBottomImageBase64; }
  public Integer getScene() { return scene; }
  public void setScene(Integer scene) { this.scene = scene; }
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
