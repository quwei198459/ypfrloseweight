package com.ypfr.loseweight.service;

import java.util.ArrayList;
import java.util.List;

/** api1 创建舌面诊的解析结果：session_id + 问诊问题（scene=1 时非空）。 */
public class ParsedTcmCreate {

  private String sessionId;
  private List<Question> questions = new ArrayList<>();

  public String getSessionId() { return sessionId; }
  public void setSessionId(String sessionId) { this.sessionId = sessionId; }
  public List<Question> getQuestions() { return questions; }
  public void setQuestions(List<Question> questions) { this.questions = questions; }

  public static class Question {
    private String name;
    private String value;

    public Question() {}

    public Question(String name, String value) {
      this.name = name;
      this.value = value;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getValue() { return value; }
    public void setValue(String value) { this.value = value; }
  }
}
