package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.SkinDetectionAiPromptTemplate;
import com.ypfr.loseweight.mapper.SkinDetectionAiPromptTemplateMapper;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionAiPromptTemplateRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class SkinDetectionAiPromptTemplateService {

  public static final String OVERALL_PROMPT_KEY = "skin_overall_report";

  private final SkinDetectionAiPromptTemplateMapper mapper;

  public SkinDetectionAiPromptTemplateService(SkinDetectionAiPromptTemplateMapper mapper) {
    this.mapper = mapper;
  }

  public SkinDetectionAiPromptTemplate findEnabledByKey(String promptKey) {
    if (!StringUtils.hasText(promptKey)) {
      return null;
    }
    return mapper.selectOne(
        new LambdaQueryWrapper<SkinDetectionAiPromptTemplate>()
            .eq(SkinDetectionAiPromptTemplate::getPromptKey, promptKey)
            .eq(SkinDetectionAiPromptTemplate::getStatus, 1)
            .last("LIMIT 1"));
  }

  public SkinDetectionAiPromptTemplate findOverallTemplate() {
    return findEnabledByKey(OVERALL_PROMPT_KEY);
  }

  public Map<String, SkinDetectionAiPromptTemplate> listEnabledItemTemplatesByItemCode() {
    List<SkinDetectionAiPromptTemplate> templates = mapper.selectList(
        new LambdaQueryWrapper<SkinDetectionAiPromptTemplate>()
            .eq(SkinDetectionAiPromptTemplate::getPromptType, "item")
            .eq(SkinDetectionAiPromptTemplate::getStatus, 1));
    Map<String, SkinDetectionAiPromptTemplate> map = new HashMap<>();
    for (SkinDetectionAiPromptTemplate template : templates) {
      if (StringUtils.hasText(template.getItemCode())) {
        map.put(template.getItemCode(), template);
      }
    }
    return map;
  }

  public List<SkinDetectionAiPromptTemplate> listAll() {
    return mapper.selectList(
        new LambdaQueryWrapper<SkinDetectionAiPromptTemplate>()
            .orderByAsc(SkinDetectionAiPromptTemplate::getPromptType)
            .orderByAsc(SkinDetectionAiPromptTemplate::getId));
  }

  public SkinDetectionAiPromptTemplate update(Long id, SkinDetectionAiPromptTemplateRequest req) {
    SkinDetectionAiPromptTemplate template = mapper.selectById(id);
    if (template == null) {
      throw new ApiException(404, "AI 提示词模板不存在");
    }
    template.setPromptName(trimRequired(req.getPromptName(), "模板名称不能为空"));
    template.setTemplateContent(trimRequired(req.getTemplateContent(), "提示词内容不能为空"));
    template.setOutputSchema(blankToNull(req.getOutputSchema()));
    template.setModel(trimRequired(req.getModel(), "模型名不能为空"));
    template.setTemperature(req.getTemperature());
    template.setStatus(req.getStatus() != null && req.getStatus() == 1 ? 1 : 0);
    template.setRemark(blankToNull(req.getRemark()));
    template.setVersion(template.getVersion() == null ? 1 : template.getVersion() + 1);
    mapper.updateById(template);
    return mapper.selectById(id);
  }

  public String render(String template, Map<String, String> variables) {
    String result = template == null ? "" : template;
    for (Map.Entry<String, String> entry : variables.entrySet()) {
      result = result.replace("{{" + entry.getKey() + "}}", entry.getValue() == null ? "" : entry.getValue());
    }
    return result;
  }

  private static String trimRequired(String value, String message) {
    if (!StringUtils.hasText(value)) {
      throw new ApiException(400, message);
    }
    return value.trim();
  }

  private static String blankToNull(String value) {
    return StringUtils.hasText(value) ? value.trim() : null;
  }
}
