package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.SkinDetectionItem;
import com.ypfr.loseweight.domain.SkinDetectionQuotaLog;
import com.ypfr.loseweight.domain.SkinDetectionRecord;
import com.ypfr.loseweight.domain.SkinDetectionWhitelist;
import com.ypfr.loseweight.mapper.SkinDetectionItemMapper;
import com.ypfr.loseweight.mapper.SkinDetectionQuotaLogMapper;
import com.ypfr.loseweight.mapper.SkinDetectionRecordMapper;
import com.ypfr.loseweight.mapper.SkinDetectionWhitelistMapper;
import com.ypfr.loseweight.web.dto.admin.AdminSkinDetectionRecordDetailVo;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionQuotaAdjustRequest;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionQuotaLogItemVo;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionQuotaSummaryVo;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionWhitelistUpsertRequest;
import com.ypfr.loseweight.web.dto.skin.SkinDetectionItemVo;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class AdminSkinDetectionService {

  private static final int DEFAULT_TOTAL_TIMES = 3;

  private final SkinDetectionWhitelistMapper whitelistMapper;
  private final SkinDetectionQuotaLogMapper quotaLogMapper;
  private final SkinDetectionRecordMapper recordMapper;
  private final SkinDetectionItemMapper itemMapper;

  public AdminSkinDetectionService(
      SkinDetectionWhitelistMapper whitelistMapper,
      SkinDetectionQuotaLogMapper quotaLogMapper,
      SkinDetectionRecordMapper recordMapper,
      SkinDetectionItemMapper itemMapper) {
    this.whitelistMapper = whitelistMapper;
    this.quotaLogMapper = quotaLogMapper;
    this.recordMapper = recordMapper;
    this.itemMapper = itemMapper;
  }

  public List<SkinDetectionWhitelist> listWhitelist(String keyword, Integer status) {
    LambdaQueryWrapper<SkinDetectionWhitelist> w = new LambdaQueryWrapper<>();
    if (StringUtils.hasText(keyword)) {
      w.like(SkinDetectionWhitelist::getPhone, normalizePhone(keyword));
    }
    if (status != null) {
      w.eq(SkinDetectionWhitelist::getStatus, status);
    }
    w.orderByDesc(SkinDetectionWhitelist::getId).last("LIMIT 500");
    return whitelistMapper.selectList(w);
  }

  @Transactional
  public SkinDetectionWhitelist createWhitelist(SkinDetectionWhitelistUpsertRequest req, Long adminId) {
    String phone = normalizeRequiredPhone(req.getPhone());
    long duplicated = whitelistMapper.selectCount(new LambdaQueryWrapper<SkinDetectionWhitelist>().eq(SkinDetectionWhitelist::getPhone, phone));
    if (duplicated > 0) {
      throw new ApiException(400, "该手机号已在皮肤检测白名单中");
    }
    int totalTimes = req.getTotalTimes() != null ? Math.max(0, req.getTotalTimes()) : DEFAULT_TOTAL_TIMES;
    SkinDetectionWhitelist item = new SkinDetectionWhitelist();
    fillWhitelist(item, req, phone);
    item.setTotalTimes(totalTimes);
    item.setUsedTimes(0);
    item.setQuotaUpdatedAt(LocalDateTime.now());
    whitelistMapper.insert(item);
    if (totalTimes > 0) {
      insertQuotaLog(item, null, null, "grant", totalTimes, 0, 0, totalTimes, 0, "admin", String.valueOf(adminId), "新增手机号默认次数");
    }
    return whitelistMapper.selectById(item.getId());
  }

  public SkinDetectionWhitelist updateWhitelist(Long id, SkinDetectionWhitelistUpsertRequest req) {
    SkinDetectionWhitelist item = requireWhitelist(id);
    String phone = normalizeRequiredPhone(req.getPhone());
    long duplicated = whitelistMapper.selectCount(
        new LambdaQueryWrapper<SkinDetectionWhitelist>()
            .eq(SkinDetectionWhitelist::getPhone, phone)
            .ne(SkinDetectionWhitelist::getId, id));
    if (duplicated > 0) {
      throw new ApiException(400, "该手机号已在皮肤检测白名单中");
    }
    fillWhitelist(item, req, phone);
    whitelistMapper.updateById(item);
    return whitelistMapper.selectById(id);
  }

  @Transactional
  public SkinDetectionWhitelist adjustQuota(Long id, SkinDetectionQuotaAdjustRequest req, Long adminId) {
    int delta = req.getDelta() == null ? 0 : req.getDelta();
    if (delta == 0) {
      throw new ApiException(400, "调整次数不能为 0");
    }
    SkinDetectionWhitelist item = requireWhitelist(id);
    int beforeTotal = safeInt(item.getTotalTimes());
    int beforeUsed = safeInt(item.getUsedTimes());
    int afterTotal = beforeTotal + delta;
    if (afterTotal < beforeUsed) {
      throw new ApiException(400, "调整后总次数不能小于已使用次数");
    }
    item.setTotalTimes(afterTotal);
    item.setQuotaUpdatedAt(LocalDateTime.now());
    whitelistMapper.updateById(item);
    insertQuotaLog(
        item,
        null,
        null,
        delta > 0 ? "grant" : "reduce",
        delta,
        beforeTotal,
        beforeUsed,
        afterTotal,
        beforeUsed,
        "admin",
        String.valueOf(adminId),
        blankToNull(req.getRemark()));
    return whitelistMapper.selectById(id);
  }

  public SkinDetectionQuotaSummaryVo quotaSummary(Long id) {
    SkinDetectionWhitelist item = requireWhitelist(id);
    List<SkinDetectionQuotaLog> logs = listLogs(id, null);
    int grant = 0;
    int reduce = 0;
    for (SkinDetectionQuotaLog log : logs) {
      int count = safeInt(log.getChangeCount());
      if ("consume".equals(log.getChangeType())) {
        continue;
      }
      if (count > 0) {
        grant += count;
      } else {
        reduce += -count;
      }
    }
    SkinDetectionQuotaSummaryVo vo = new SkinDetectionQuotaSummaryVo();
    vo.setGrantCount(grant);
    vo.setReduceCount(reduce);
    vo.setUsedCount(safeInt(item.getUsedTimes()));
    vo.setCurrentBalance(safeInt(item.getTotalTimes()) - safeInt(item.getUsedTimes()));
    return vo;
  }

  public List<SkinDetectionQuotaLogItemVo> listManualLogs(Long id) {
    requireWhitelist(id);
    return listLogs(id, false).stream().map(this::toLogVo).collect(Collectors.toList());
  }

  public List<SkinDetectionQuotaLogItemVo> listConsumeLogs(Long id) {
    requireWhitelist(id);
    return listLogs(id, true).stream().map(this::toLogVo).collect(Collectors.toList());
  }

  public List<SkinDetectionRecord> listRecords(
      String phone,
      String status,
      LocalDate startDate,
      LocalDate endDate,
      Integer minScore,
      Integer maxScore) {
    LambdaQueryWrapper<SkinDetectionRecord> w = new LambdaQueryWrapper<>();
    if (StringUtils.hasText(phone)) {
      w.like(SkinDetectionRecord::getPhone, normalizePhone(phone));
    }
    if (StringUtils.hasText(status)) {
      w.eq(SkinDetectionRecord::getStatus, status.trim());
    }
    if (startDate != null) {
      w.ge(SkinDetectionRecord::getCreatedAt, startDate.atStartOfDay());
    }
    if (endDate != null) {
      w.lt(SkinDetectionRecord::getCreatedAt, endDate.plusDays(1).atStartOfDay());
    }
    if (minScore != null) {
      w.ge(SkinDetectionRecord::getOverallScore, minScore);
    }
    if (maxScore != null) {
      w.le(SkinDetectionRecord::getOverallScore, maxScore);
    }
    w.orderByDesc(SkinDetectionRecord::getId).last("LIMIT 500");
    return recordMapper.selectList(w);
  }

  public AdminSkinDetectionRecordDetailVo recordDetail(Long id) {
    SkinDetectionRecord record = recordMapper.selectById(id);
    if (record == null) {
      throw new ApiException(404, "皮肤检测记录不存在");
    }
    List<SkinDetectionItem> items = itemMapper.selectList(
        new LambdaQueryWrapper<SkinDetectionItem>()
            .eq(SkinDetectionItem::getRecordId, id)
            .orderByAsc(SkinDetectionItem::getSortOrder)
            .orderByAsc(SkinDetectionItem::getId));
    AdminSkinDetectionRecordDetailVo vo = new AdminSkinDetectionRecordDetailVo();
    vo.setRecordId(record.getId());
    vo.setUserId(record.getUserId());
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
    vo.setItems(items.stream().map(this::toItemVo).collect(Collectors.toList()));
    return vo;
  }

  private List<SkinDetectionQuotaLog> listLogs(Long whitelistId, Boolean consume) {
    LambdaQueryWrapper<SkinDetectionQuotaLog> w = new LambdaQueryWrapper<SkinDetectionQuotaLog>().eq(SkinDetectionQuotaLog::getWhitelistId, whitelistId);
    if (consume != null) {
      if (Boolean.TRUE.equals(consume)) {
        w.eq(SkinDetectionQuotaLog::getChangeType, "consume");
      } else {
        w.ne(SkinDetectionQuotaLog::getChangeType, "consume");
      }
    }
    w.orderByDesc(SkinDetectionQuotaLog::getId).last("LIMIT 200");
    return quotaLogMapper.selectList(w);
  }

  private void fillWhitelist(SkinDetectionWhitelist item, SkinDetectionWhitelistUpsertRequest req, String phone) {
    item.setPhone(phone);
    item.setRemark(blankToNull(req.getRemark()));
    item.setStatus(req.getStatus() != null && req.getStatus() == 0 ? 0 : 1);
  }

  private SkinDetectionWhitelist requireWhitelist(Long id) {
    SkinDetectionWhitelist item = whitelistMapper.selectById(id);
    if (item == null) {
      throw new ApiException(404, "皮肤检测白名单记录不存在");
    }
    return item;
  }

  private void insertQuotaLog(
      SkinDetectionWhitelist item,
      Long userId,
      Long recordId,
      String changeType,
      int changeCount,
      int beforeTotal,
      int beforeUsed,
      int afterTotal,
      int afterUsed,
      String operatorType,
      String operatorName,
      String remark) {
    SkinDetectionQuotaLog log = new SkinDetectionQuotaLog();
    log.setWhitelistId(item.getId());
    log.setPhone(item.getPhone());
    log.setUserId(userId);
    log.setRecordId(recordId);
    log.setChangeType(changeType);
    log.setChangeCount(changeCount);
    log.setBeforeTotalTimes(beforeTotal);
    log.setBeforeUsedTimes(beforeUsed);
    log.setAfterTotalTimes(afterTotal);
    log.setAfterUsedTimes(afterUsed);
    log.setOperatorType(operatorType);
    log.setOperatorName(operatorName);
    log.setRemark(remark);
    quotaLogMapper.insert(log);
  }

  private SkinDetectionQuotaLogItemVo toLogVo(SkinDetectionQuotaLog log) {
    SkinDetectionQuotaLogItemVo vo = new SkinDetectionQuotaLogItemVo();
    vo.setId(log.getId());
    vo.setChangeType(log.getChangeType());
    vo.setChangeCount(log.getChangeCount());
    vo.setBeforeTotalTimes(log.getBeforeTotalTimes());
    vo.setBeforeUsedTimes(log.getBeforeUsedTimes());
    vo.setAfterTotalTimes(log.getAfterTotalTimes());
    vo.setAfterUsedTimes(log.getAfterUsedTimes());
    vo.setUserId(log.getUserId());
    vo.setRecordId(log.getRecordId());
    vo.setOperatorType(log.getOperatorType());
    vo.setOperatorName(log.getOperatorName());
    vo.setRemark(log.getRemark());
    vo.setCreatedAt(log.getCreatedAt());
    return vo;
  }

  private SkinDetectionItemVo toItemVo(SkinDetectionItem item) {
    SkinDetectionItemVo vo = new SkinDetectionItemVo();
    vo.setItemCode(item.getItemCode());
    vo.setItemName(item.getItemName());
    vo.setScore(item.getScore());
    vo.setLevel(item.getLevel());
    vo.setResultText(item.getResultText());
    vo.setResultImage(item.getResultImage());
    vo.setMetricsJson(item.getMetricsJson());
    vo.setSortOrder(item.getSortOrder());
    vo.setScaleType(item.getScaleType());
    vo.setAiConclusion(item.getAiConclusion());
    vo.setAiReason(item.getAiReason());
    vo.setAiCareAdvice(item.getAiCareAdvice());
    vo.setAiRawJson(item.getAiRawJson());
    vo.setAiStatus(item.getAiStatus());
    vo.setAiError(item.getAiError());
    return vo;
  }

  private static int safeInt(Integer value) {
    return value == null ? 0 : value;
  }

  private static String normalizeRequiredPhone(String value) {
    String phone = normalizePhone(value);
    if (!StringUtils.hasText(phone)) {
      throw new ApiException(400, "手机号不能为空");
    }
    if (!phone.matches("^1\\d{10}$")) {
      throw new ApiException(400, "请输入 11 位中国大陆手机号");
    }
    return phone;
  }

  private static String normalizePhone(String value) {
    if (value == null) {
      return "";
    }
    String digits = value.replaceAll("\\D", "");
    if (digits.length() == 13 && digits.startsWith("86")) {
      return digits.substring(2);
    }
    return digits;
  }

  private static String blankToNull(String value) {
    String v = value == null ? "" : value.trim();
    return v.isEmpty() ? null : v;
  }
}
