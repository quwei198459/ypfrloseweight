package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.config.TcmDetectionProperties;
import com.ypfr.loseweight.domain.LoseWeightUser;
import com.ypfr.loseweight.domain.TcmDetectionItem;
import com.ypfr.loseweight.domain.TcmDetectionRecord;
import com.ypfr.loseweight.domain.TcmDetectionWhitelist;
import com.ypfr.loseweight.mapper.TcmDetectionItemMapper;
import com.ypfr.loseweight.mapper.TcmDetectionRecordMapper;
import com.ypfr.loseweight.web.dto.tcm.TcmDetectionCreateRequest;
import com.ypfr.loseweight.web.dto.tcm.TcmDetectionCreateResponseVo;
import com.ypfr.loseweight.web.dto.tcm.TcmDetectionItemVo;
import com.ypfr.loseweight.web.dto.tcm.TcmDetectionReportVo;
import com.ypfr.loseweight.web.dto.tcm.TcmInquiryQuestionVo;
import com.ypfr.loseweight.web.dto.tcm.TcmInquirySubmitRequest;
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class TcmDetectionService {

  private static final Logger log = LoggerFactory.getLogger(TcmDetectionService.class);

  private static final String STATUS_PROCESSING = "processing";
  private static final String STATUS_PENDING_INQUIRY = "pending_inquiry";
  private static final String STATUS_SUCCESS = "success";

  private final TcmDetectionQuotaService quotaService;
  private final TcmDetectionRecordMapper recordMapper;
  private final TcmDetectionItemMapper itemMapper;
  private final AvatarStorageService avatarStorageService;
  private final TcmDetectionProperties properties;
  private final MaijingTcmClient maijingClient;
  private final TcmDetectionResultParser resultParser;
  private final DeepSeekTcmAnalysisClient deepSeekClient;

  public TcmDetectionService(
      TcmDetectionQuotaService quotaService,
      TcmDetectionRecordMapper recordMapper,
      TcmDetectionItemMapper itemMapper,
      AvatarStorageService avatarStorageService,
      TcmDetectionProperties properties,
      MaijingTcmClient maijingClient,
      TcmDetectionResultParser resultParser,
      DeepSeekTcmAnalysisClient deepSeekClient) {
    this.quotaService = quotaService;
    this.recordMapper = recordMapper;
    this.itemMapper = itemMapper;
    this.avatarStorageService = avatarStorageService;
    this.properties = properties;
    this.maijingClient = maijingClient;
    this.resultParser = resultParser;
    this.deepSeekClient = deepSeekClient;
  }

  @Transactional
  public TcmDetectionCreateResponseVo createRecord(Long userId, TcmDetectionCreateRequest request) {
    LoseWeightUser user = quotaService.requireUser(userId);
    TcmDetectionWhitelist member = quotaService.requireAvailableQuota(userId);
    int scene = resolveScene(request.getScene());

    String tongueRel = saveImage(userId, request.getTongueImageBase64(), "tongue");
    String faceRel = saveImage(userId, request.getFaceImageBase64(), "face");
    String tongueBottomRel = saveImageOptional(userId, request.getTongueBottomImageBase64(), "tb");

    TcmDetectionRecord record = buildPendingRecord(user, request, tongueRel, faceRel);
    recordMapper.insert(record);

    try {
      String createRaw =
          maijingClient.createDiagnosis(
              scene,
              properties.toPublicImageUrl(tongueRel),
              properties.toPublicImageUrl(faceRel),
              properties.toPublicImageUrl(tongueBottomRel));

      if (scene == 1) {
        // scene=1：create 返回 session_id + 问诊问题，待用户作答后再调 report 出报告
        ParsedTcmCreate created = resultParser.parseCreate(createRaw);
        record.setThirdPartyId(created.getSessionId());
        record.setStatus(STATUS_PENDING_INQUIRY);
        recordMapper.updateById(record);
        TcmDetectionCreateResponseVo vo =
            createResponse(record.getId(), STATUS_PENDING_INQUIRY, null, null, "请回答问诊问题以获得更精准的报告");
        // 按性别过滤问诊选项：男性不出现女性专属症状，女性不出现男性专属症状
        Integer inquiryGender = record.getGender();
        List<ParsedTcmCreate.Question> questions =
            created.getQuestions().stream()
                .filter(q -> !resultParser.isOppositeGenderText(q.getName(), inquiryGender))
                .toList();
        vo.setInquiryQuestions(toQuestionVos(questions));
        return vo;
      }
      // scene=2：create 一步直接返回完整报告（无 session_id）
      return finishReportFromRaw(record, member, userId, createRaw);
    } catch (ApiException e) {
      markFailed(record, e.getMessage());
      log.warn("Tcm create failed. recordId={}, userId={}, reason={}", record.getId(), userId, e.getMessage());
      throw e;
    } catch (Exception e) {
      String reason = e.getMessage() != null ? e.getMessage() : "中医体检失败，请稍后重试";
      markFailed(record, reason);
      log.error("Tcm create failed. recordId={}, userId={}", record.getId(), userId, e);
      throw new ApiException(4801, reason);
    }
  }

  @Transactional
  public TcmDetectionCreateResponseVo submitInquiry(Long userId, Long recordId, TcmInquirySubmitRequest request) {
    TcmDetectionRecord record = recordMapper.selectById(recordId);
    if (record == null) {
      throw new ApiException(404, "检测记录不存在");
    }
    if (!userId.equals(record.getUserId())) {
      throw new ApiException(403, "无权操作该检测记录");
    }
    if (!STATUS_PENDING_INQUIRY.equals(record.getStatus())) {
      throw new ApiException(400, "该检测无需问诊或已完成");
    }
    if (!StringUtils.hasText(record.getThirdPartyId())) {
      throw new ApiException(400, "缺少会话信息，请重新发起检测");
    }
    TcmDetectionWhitelist member = quotaService.requireAvailableQuota(userId);
    try {
      String reportRaw = maijingClient.fetchReport(record.getThirdPartyId(), toAnswerMaps(request));
      return finishReportFromRaw(record, member, userId, reportRaw);
    } catch (ApiException e) {
      markFailed(record, e.getMessage());
      throw e;
    } catch (Exception e) {
      String reason = e.getMessage() != null ? e.getMessage() : "中医体检失败，请稍后重试";
      markFailed(record, reason);
      log.error("Tcm inquiry failed. recordId={}, userId={}", record.getId(), userId, e);
      throw new ApiException(4801, reason);
    }
  }

  public TcmDetectionReportVo getReport(Long userId, Long recordId) {
    TcmDetectionRecord record = recordMapper.selectById(recordId);
    if (record == null) {
      throw new ApiException(404, "检测记录不存在");
    }
    if (!userId.equals(record.getUserId())) {
      throw new ApiException(403, "无权查看该检测记录");
    }
    List<TcmDetectionItem> items = itemMapper.selectList(
        new LambdaQueryWrapper<TcmDetectionItem>()
            .eq(TcmDetectionItem::getRecordId, recordId)
            .orderByAsc(TcmDetectionItem::getSortOrder)
            .orderByAsc(TcmDetectionItem::getId));
    return toReportVo(record, items);
  }

  /** 共享收尾：解析报告 JSON → 落库 items + 记录 → DeepSeek 总结 → 扣次。 */
  private TcmDetectionCreateResponseVo finishReportFromRaw(
      TcmDetectionRecord record,
      TcmDetectionWhitelist member,
      Long userId,
      String reportRaw) {
    ParsedTcmDetectionResult parsed = resultParser.parseReport(reportRaw, record.getGender());
    replaceItems(record.getId(), parsed);

    DeepSeekAnalysisResult overall = deepSeekClient.summarize(parsed);
    record.setConstitutionPrimary(parsed.getConstitutionPrimary());
    record.setConstitutionJson(parsed.getConstitutionJson());
    record.setOverallScore(parsed.getOverallScore());
    record.setThirdPartyRaw(reportRaw);
    record.setAiSummary(overall.getSummary());
    record.setAiSummaryJson(overall.getRawJson());
    record.setStatus(STATUS_SUCCESS);
    record.setFailReason(null);
    record.setDeepseekStatus(overall.getStatus());
    record.setDeepseekError(limit(overall.getError(), 512));
    recordMapper.updateById(record);

    quotaService.consumeQuota(member, userId, record.getId());
    return createResponse(record.getId(), STATUS_SUCCESS, parsed.getOverallScore(), parsed.getConstitutionPrimary(), "检测成功");
  }

  private TcmDetectionRecord buildPendingRecord(
      LoseWeightUser user, TcmDetectionCreateRequest request, String tongueImageUrl, String faceImageUrl) {
    TcmDetectionRecord record = new TcmDetectionRecord();
    record.setUserId(user.getId());
    record.setPhone(TcmDetectionQuotaService.normalizePhone(user.getPhone()));
    record.setUserName(firstText(request.getName(), user.getNickname()));
    record.setGender(request.getGender());
    record.setBirthday(request.getBirthday());
    record.setAge(resolveAge(request));
    record.setResidence(blankToNull(request.getResidence()));
    record.setTongueImageUrl(tongueImageUrl);
    record.setFaceImageUrl(faceImageUrl);
    record.setStatus(STATUS_PROCESSING);
    record.setDeepseekStatus("skipped");
    return record;
  }

  private int resolveScene(Integer scene) {
    if (scene != null && (scene == 1 || scene == 2)) {
      return scene;
    }
    int def = properties.getDefaultScene();
    return def == 1 ? 1 : 2;
  }

  private Integer resolveAge(TcmDetectionCreateRequest request) {
    if (request.getBirthday() != null) {
      return Math.max(0, Period.between(request.getBirthday(), LocalDate.now()).getYears());
    }
    return request.getAge();
  }

  private void replaceItems(Long recordId, ParsedTcmDetectionResult parsed) {
    itemMapper.delete(new LambdaQueryWrapper<TcmDetectionItem>().eq(TcmDetectionItem::getRecordId, recordId));
    for (ParsedTcmDetectionItem parsedItem : parsed.getItems()) {
      TcmDetectionItem item = new TcmDetectionItem();
      item.setRecordId(recordId);
      item.setItemCode(parsedItem.getItemCode());
      item.setItemName(parsedItem.getItemName());
      item.setScore(parsedItem.getScore());
      item.setLevel(parsedItem.getLevel());
      item.setResultText(parsedItem.getResultText());
      item.setResultImage(parsedItem.getResultImage());
      item.setMetricsJson(parsedItem.getMetricsJson());
      item.setSortOrder(parsedItem.getSortOrder());
      item.setScaleType(parsedItem.getScaleType());
      item.setAiStatus("skipped");
      itemMapper.insert(item);
    }
  }

  private void markFailed(TcmDetectionRecord record, String reason) {
    record.setStatus("failed");
    record.setFailReason(limit(reason, 512));
    recordMapper.updateById(record);
  }

  private TcmDetectionReportVo toReportVo(TcmDetectionRecord record, List<TcmDetectionItem> items) {
    TcmDetectionReportVo vo = new TcmDetectionReportVo();
    vo.setRecordId(record.getId());
    vo.setStatus(record.getStatus());
    vo.setFailReason(record.getFailReason());
    vo.setPhone(record.getPhone());
    vo.setUserName(record.getUserName());
    vo.setGender(record.getGender());
    vo.setBirthday(record.getBirthday());
    vo.setAge(record.getAge());
    vo.setResidence(record.getResidence());
    vo.setTongueImageUrl(record.getTongueImageUrl());
    vo.setFaceImageUrl(record.getFaceImageUrl());
    vo.setConstitutionPrimary(record.getConstitutionPrimary());
    vo.setOverallScore(record.getOverallScore());
    vo.setReportJson(record.getConstitutionJson());
    vo.setAiSummary(record.getAiSummary());
    vo.setDeepseekStatus(record.getDeepseekStatus());
    vo.setDeepseekError(record.getDeepseekError());
    vo.setCreatedAt(record.getCreatedAt());
    List<TcmDetectionItemVo> itemVos = new ArrayList<>();
    for (TcmDetectionItem item : items) {
      TcmDetectionItemVo itemVo = new TcmDetectionItemVo();
      itemVo.setItemCode(item.getItemCode());
      itemVo.setItemName(item.getItemName());
      itemVo.setScore(item.getScore());
      itemVo.setLevel(item.getLevel());
      itemVo.setResultText(item.getResultText());
      itemVo.setResultImage(item.getResultImage());
      itemVo.setMetricsJson(item.getMetricsJson());
      itemVo.setSortOrder(item.getSortOrder());
      itemVo.setScaleType(item.getScaleType());
      itemVo.setAiConclusion(item.getAiConclusion());
      itemVo.setAiReason(item.getAiReason());
      itemVo.setAiCareAdvice(item.getAiCareAdvice());
      itemVo.setAiRawJson(item.getAiRawJson());
      itemVo.setAiStatus(item.getAiStatus());
      itemVo.setAiError(item.getAiError());
      itemVos.add(itemVo);
    }
    vo.setItems(itemVos);
    return vo;
  }

  private TcmDetectionCreateResponseVo createResponse(
      Long id, String status, Integer score, String constitutionPrimary, String message) {
    TcmDetectionCreateResponseVo vo = new TcmDetectionCreateResponseVo();
    vo.setRecordId(id);
    vo.setStatus(status);
    vo.setOverallScore(score);
    vo.setConstitutionPrimary(constitutionPrimary);
    vo.setMessage(message);
    return vo;
  }

  private List<TcmInquiryQuestionVo> toQuestionVos(List<ParsedTcmCreate.Question> questions) {
    List<TcmInquiryQuestionVo> list = new ArrayList<>();
    if (questions != null) {
      for (ParsedTcmCreate.Question q : questions) {
        list.add(new TcmInquiryQuestionVo(q.getName(), q.getValue()));
      }
    }
    return list;
  }

  private List<Map<String, String>> toAnswerMaps(TcmInquirySubmitRequest request) {
    List<Map<String, String>> list = new ArrayList<>();
    if (request != null && request.getAnswers() != null) {
      for (TcmInquiryQuestionVo a : request.getAnswers()) {
        if (a == null || !StringUtils.hasText(a.getName())) {
          continue;
        }
        Map<String, String> m = new LinkedHashMap<>();
        m.put("name", a.getName());
        m.put("value", a.getValue());
        list.add(m);
      }
    }
    return list;
  }

  private String saveImage(Long userId, String imageBase64, String kind) {
    String fileName = userId + "-" + System.currentTimeMillis() + "-" + kind + ".jpg";
    return avatarStorageService.saveBase64ToDir(imageBase64, properties.getImageDirSuffix(), fileName, 6_000_000);
  }

  private String saveImageOptional(Long userId, String imageBase64, String kind) {
    if (!StringUtils.hasText(imageBase64)) {
      return null;
    }
    return saveImage(userId, imageBase64, kind);
  }

  private static String firstText(String first, String second) {
    String v = blankToNull(first);
    return v != null ? v : blankToNull(second);
  }

  private static String blankToNull(String value) {
    if (!StringUtils.hasText(value)) {
      return null;
    }
    return value.trim();
  }

  private static String limit(String value, int max) {
    if (value == null) {
      return null;
    }
    return value.length() <= max ? value : value.substring(0, max);
  }
}
