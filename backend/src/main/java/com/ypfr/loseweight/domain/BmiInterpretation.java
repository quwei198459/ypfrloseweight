package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;

@TableName("bmi_interpretation")
public class BmiInterpretation {

  @TableId(value = "bucket_code", type = IdType.INPUT)
  private String bucketCode;

  private String bodyText;
  private Integer revision;
  private String source;
  private LocalDateTime updatedAt;

  public String getBucketCode() {
    return bucketCode;
  }

  public void setBucketCode(String bucketCode) {
    this.bucketCode = bucketCode;
  }

  public String getBodyText() {
    return bodyText;
  }

  public void setBodyText(String bodyText) {
    this.bodyText = bodyText;
  }

  public Integer getRevision() {
    return revision;
  }

  public void setRevision(Integer revision) {
    this.revision = revision;
  }

  public String getSource() {
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }
}
