package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.config.SkinDetectionProperties;
import com.ypfr.loseweight.domain.LoseWeightUser;
import com.ypfr.loseweight.domain.SkinDetectionItem;
import com.ypfr.loseweight.domain.SkinDetectionRecord;
import com.ypfr.loseweight.domain.SkinDetectionWhitelist;
import com.ypfr.loseweight.mapper.SkinDetectionItemMapper;
import com.ypfr.loseweight.mapper.SkinDetectionRecordMapper;
import com.ypfr.loseweight.web.dto.skin.SkinDetectionCreateRequest;
import com.ypfr.loseweight.web.dto.skin.SkinDetectionCreateResponseVo;
import com.ypfr.loseweight.web.dto.skin.SkinDetectionItemVo;
import com.ypfr.loseweight.web.dto.skin.SkinDetectionReportVo;
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class SkinDetectionService {

  private static final Logger log = LoggerFactory.getLogger(SkinDetectionService.class);

  private final SkinDetectionQuotaService quotaService;
  private final SkinDetectionRecordMapper recordMapper;
  private final SkinDetectionItemMapper itemMapper;
  private final AvatarStorageService avatarStorageService;
  private final SkinDetectionProperties properties;
  private final YimeiSkinDetectionClient yimeiClient;
  private final SkinDetectionResultParser resultParser;
  private final DeepSeekSkinAnalysisClient deepSeekClient;
  private final SkinDetectionItemConfigService itemConfigService;
  private final ApiUsageLogger apiUsageLogger;

  public SkinDetectionService(
      SkinDetectionQuotaService quotaService,
      SkinDetectionRecordMapper recordMapper,
      SkinDetectionItemMapper itemMapper,
      AvatarStorageService avatarStorageService,
      SkinDetectionProperties properties,
      YimeiSkinDetectionClient yimeiClient,
      SkinDetectionResultParser resultParser,
      DeepSeekSkinAnalysisClient deepSeekClient,
      SkinDetectionItemConfigService itemConfigService,
      ApiUsageLogger apiUsageLogger) {
    this.quotaService = quotaService;
    this.recordMapper = recordMapper;
    this.itemMapper = itemMapper;
    this.avatarStorageService = avatarStorageService;
    this.properties = properties;
    this.yimeiClient = yimeiClient;
    this.resultParser = resultParser;
    this.deepSeekClient = deepSeekClient;
    this.itemConfigService = itemConfigService;
    this.apiUsageLogger = apiUsageLogger;
  }

  @Transactional
  public SkinDetectionCreateResponseVo createRecord(Long userId, SkinDetectionCreateRequest request) {
    LoseWeightUser user = quotaService.requireUser(userId);
    SkinDetectionWhitelist member = quotaService.requireAvailableQuota(userId);
    String imageUrl = saveImage(userId, request.getImageBase64());
    SkinDetectionRecord record = buildPendingRecord(user, request, imageUrl);
    long detectTypes = resolveDetectTypes();
    record.setDetectTypes(detectTypes);
    recordMapper.insert(record);

    DeepSeekUsageContext.set(userId, record.getId());
    try {
      String raw;
      try {
        raw = yimeiClient.analyze(request.getImageBase64(), detectTypes);
        apiUsageLogger.record(ApiUsageLogger.PROVIDER_SKIN, "skin", userId, record.getId(), true, null);
      } catch (Exception ye) {
        apiUsageLogger.record(
            ApiUsageLogger.PROVIDER_SKIN, "skin", userId, record.getId(), false, ye.getMessage());
        throw ye;
      }
      ParsedSkinDetectionResult parsed = resultParser.parse(raw);
      saveItems(record.getId(), parsed);
      DeepSeekSkinAnalysisResult ai = deepSeekClient.analyze(parsed);
      updateItemAiResults(record.getId(), ai.getItems());
      DeepSeekAnalysisResult overallAi = ai.getOverall();
      record.setThirdPartyId(parsed.getThirdPartyId());
      record.setDetectTypes(detectTypes);
      record.setOverallScore(parsed.getOverallScore());
      record.setThirdPartyRaw(raw);
      record.setAiSummary(overallAi.getSummary());
      record.setAiSummaryJson(overallAi.getRawJson());
      record.setStatus("success");
      record.setFailReason(null);
      record.setDeepseekStatus(overallAi.getStatus());
      record.setDeepseekError(overallAi.getError());
      recordMapper.updateById(record);
      quotaService.consumeQuota(member, userId, record.getId());
      return createResponse(record.getId(), "success", parsed.getOverallScore(), "检测成功");
    } catch (ApiException e) {
      markFailed(record, e.getMessage());
      log.warn("Skin detection business failed. recordId={}, userId={}, reason={}", record.getId(), userId, e.getMessage());
      throw e;
    } catch (Exception e) {
      String reason = e.getMessage() != null ? e.getMessage() : "皮肤检测失败，请稍后重试";
      markFailed(record, reason);
      log.error("Skin detection failed. recordId={}, userId={}", record.getId(), userId, e);
      throw new ApiException(4701, reason);
    } finally {
      DeepSeekUsageContext.clear();
    }
  }

  public SkinDetectionReportVo getReport(Long userId, Long recordId) {
    SkinDetectionRecord record = recordMapper.selectById(recordId);
    if (record == null) {
      throw new ApiException(404, "检测记录不存在");
    }
    if (!userId.equals(record.getUserId())) {
      throw new ApiException(403, "无权查看该检测记录");
    }
    List<SkinDetectionItem> items = itemMapper.selectList(
        new LambdaQueryWrapper<SkinDetectionItem>()
            .eq(SkinDetectionItem::getRecordId, recordId)
            .orderByAsc(SkinDetectionItem::getSortOrder)
            .orderByAsc(SkinDetectionItem::getId));
    return toReportVo(record, items);
  }

  private SkinDetectionRecord buildPendingRecord(LoseWeightUser user, SkinDetectionCreateRequest request, String imageUrl) {
    SkinDetectionRecord record = new SkinDetectionRecord();
    record.setUserId(user.getId());
    record.setPhone(SkinDetectionQuotaService.normalizePhone(user.getPhone()));
    record.setUserName(firstText(request.getName(), user.getNickname()));
    record.setGender(request.getGender());
    record.setBirthday(request.getBirthday());
    record.setAge(resolveAge(request));
    record.setResidence(blankToNull(request.getResidence()));
    record.setImageUrl(imageUrl);
    record.setStatus("pending");
    record.setDeepseekStatus("skipped");
    return record;
  }

  private Integer resolveAge(SkinDetectionCreateRequest request) {
    if (request.getBirthday() != null) {
      return Math.max(0, Period.between(request.getBirthday(), LocalDate.now()).getYears());
    }
    return request.getAge();
  }

  private long resolveDetectTypes() {
    if (properties.getDetectTypes() > 0) {
      return properties.getDetectTypes();
    }
    long detectTypes = itemConfigService.calculateEnabledDetectTypes();
    if (detectTypes <= 0) {
      throw new ApiException(500, "皮肤检测项目配置为空");
    }
    return detectTypes;
  }

  private void saveItems(Long recordId, ParsedSkinDetectionResult parsed) {
    for (ParsedSkinDetectionItem parsedItem : parsed.getItems()) {
      SkinDetectionItem item = new SkinDetectionItem();
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

  private void updateItemAiResults(Long recordId, List<DeepSeekItemAnalysisResult> results) {
    if (results == null || results.isEmpty()) {
      return;
    }
    Map<String, DeepSeekItemAnalysisResult> byCode = results.stream()
        .filter(result -> StringUtils.hasText(result.getItemCode()))
        .collect(Collectors.toMap(DeepSeekItemAnalysisResult::getItemCode, Function.identity(), (a, b) -> a));
    List<SkinDetectionItem> items = itemMapper.selectList(
        new LambdaQueryWrapper<SkinDetectionItem>().eq(SkinDetectionItem::getRecordId, recordId));
    for (SkinDetectionItem item : items) {
      DeepSeekItemAnalysisResult result = byCode.get(item.getItemCode());
      if (result == null) {
        continue;
      }
      item.setAiConclusion(result.getConclusion());
      item.setAiReason(result.getReason());
      item.setAiCareAdvice(result.getCareAdvice());
      item.setAiRawJson(result.getRawJson());
      item.setAiStatus(result.getStatus());
      item.setAiError(limit(result.getError(), 512));
      itemMapper.updateById(item);
    }
  }

  private void markFailed(SkinDetectionRecord record, String reason) {
    record.setStatus("failed");
    record.setFailReason(limit(reason, 512));
    record.setDeepseekStatus("skipped");
    recordMapper.updateById(record);
  }

  private SkinDetectionReportVo toReportVo(SkinDetectionRecord record, List<SkinDetectionItem> items) {
    SkinDetectionReportVo vo = new SkinDetectionReportVo();
    vo.setRecordId(record.getId());
    vo.setStatus(record.getStatus());
    vo.setFailReason(record.getFailReason());
    vo.setPhone(record.getPhone());
    vo.setUserName(record.getUserName());
    vo.setGender(record.getGender());
    vo.setBirthday(record.getBirthday());
    vo.setAge(record.getAge());
    vo.setResidence(record.getResidence());
    vo.setImageUrl(record.getImageUrl());
    vo.setDetectTypes(record.getDetectTypes());
    vo.setOverallScore(record.getOverallScore());
    vo.setAiSummary(record.getAiSummary());
    vo.setDeepseekStatus(record.getDeepseekStatus());
    vo.setDeepseekError(record.getDeepseekError());
    vo.setCreatedAt(record.getCreatedAt());
    List<SkinDetectionItemVo> itemVos = new ArrayList<>();
    for (SkinDetectionItem item : items) {
      SkinDetectionItemVo itemVo = new SkinDetectionItemVo();
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

  private SkinDetectionCreateResponseVo createResponse(Long id, String status, Integer score, String message) {
    SkinDetectionCreateResponseVo vo = new SkinDetectionCreateResponseVo();
    vo.setRecordId(id);
    vo.setStatus(status);
    vo.setOverallScore(score);
    vo.setMessage(message);
    return vo;
  }

  private String saveImage(Long userId, String imageBase64) {
    String fileName = userId + "-" + System.currentTimeMillis() + ".jpg";
    return avatarStorageService.saveBase64ToDir(imageBase64, properties.getImageDirSuffix(), fileName, 6_000_000);
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
