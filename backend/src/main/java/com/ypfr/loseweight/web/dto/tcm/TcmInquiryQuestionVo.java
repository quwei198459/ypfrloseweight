package com.ypfr.loseweight.web.dto.tcm;

/** 问诊问题/答案项（scene=1）：name=症状名，value=厂商问题 uuid。 */
public class TcmInquiryQuestionVo {

  private String name;
  private String value;

  public TcmInquiryQuestionVo() {}

  public TcmInquiryQuestionVo(String name, String value) {
    this.name = name;
    this.value = value;
  }

  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public String getValue() { return value; }
  public void setValue(String value) { this.value = value; }
}
