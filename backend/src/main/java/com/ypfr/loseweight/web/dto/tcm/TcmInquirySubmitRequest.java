package com.ypfr.loseweight.web.dto.tcm;

import java.util.ArrayList;
import java.util.List;

/** scene=1 问诊提交：用户从 inquiry_questions 中勾选的症状答案。 */
public class TcmInquirySubmitRequest {

  private List<TcmInquiryQuestionVo> answers = new ArrayList<>();

  public List<TcmInquiryQuestionVo> getAnswers() { return answers; }
  public void setAnswers(List<TcmInquiryQuestionVo> answers) { this.answers = answers; }
}
