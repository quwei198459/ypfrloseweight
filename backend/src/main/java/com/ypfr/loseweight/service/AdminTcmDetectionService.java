package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.config.TcmDetectionProperties;
import com.ypfr.loseweight.domain.TcmDetectionItem;
import com.ypfr.loseweight.domain.TcmDetectionQuotaLog;
import com.ypfr.loseweight.domain.TcmDetectionRecord;
import com.ypfr.loseweight.domain.TcmDetectionWhitelist;
import com.ypfr.loseweight.mapper.TcmDetectionItemMapper;
import com.ypfr.loseweight.mapper.TcmDetectionQuotaLogMapper;
import com.ypfr.loseweight.mapper.TcmDetectionRecordMapper;
import com.ypfr.loseweight.mapper.TcmDetectionWhitelistMapper;
import com.ypfr.loseweight.web.dto.admin.AdminTcmDetectionRecordDetailVo;
import com.ypfr.loseweight.web.dto.admin.TcmDetectionQuotaAdjustRequest;
import com.ypfr.loseweight.web.dto.admin.TcmDetectionQuotaLogItemVo;
import com.ypfr.loseweight.web.dto.admin.TcmDetectionQuotaSummaryVo;
import com.ypfr.loseweight.web.dto.admin.TcmDetectionWhitelistUpsertRequest;
import com.ypfr.loseweight.web.dto.tcm.TcmDetectionItemVo;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class AdminTcmDetectionService {

  private final TcmDetectionWhitelistMapper whitelistMapper;
  private final TcmDetectionQuotaLogMapper quotaLogMapper;
  private final TcmDetectionRecordMapper recordMapper;
  private final TcmDetectionItemMapper itemMapper;
  private final TcmDetectionProperties properties;

  public AdminTcmDetectionService(
      TcmDetectionWhitelistMapper whitelistMapper,
      TcmDetectionQuotaLogMapper quotaLogMapper,
      TcmDetectionRecordMapper recordMapper,
      TcmDetectionItemMapper itemMapper,
      TcmDetectionProperties properties) {
    this.whitelistMapper = whitelistMapper;
    this.quotaLogMapper = quotaLogMapper;
    this.recordMapper = recordMapper;
    this.itemMapper = itemMapper;
    this.properties = properties;
  }

  public List<TcmDetectionWhitelist> listWhitelist(String keyword, Integer status) {
    LambdaQueryWrapper<TcmDetectionWhitelist> w = new LambdaQueryWrapper<>();
    if (StringUtils.hasText(keyword)) {
      w.like(TcmDetectionWhitelist::getPhone, normalizePhone(keyword));
    }
    if (status != null) {
      w.eq(TcmDetectionWhitelist::getStatus, status);
    }
    w.orderByDesc(TcmDetectionWhitelist::getId).last("LIMIT 500");
    return whitelistMapper.selectList(w);
  }

  @Transactional
  public TcmDetectionWhitelist createWhitelist(TcmDetectionWhitelistUpsertRequest req, Long adminId) {
    String phone = normalizeRequiredPhone(req.getPhone());
    long duplicated = whitelistMapper.selectCount(new LambdaQueryWrapper<TcmDetectionWhitelist>().eq(TcmDetectionWhitelist::getPhone, phone));
    if (duplicated > 0) {
      throw new ApiException(400, "该手机号已在中医体检白名单中");
    }
    int totalTimes = req.getTotalTimes() != null ? Math.max(0, req.getTotalTimes()) : properties.getDefaultTimes();
    TcmDetectionWhitelist item = new TcmDetectionWhitelist();
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

  public TcmDetectionWhitelist updateWhitelist(Long id, TcmDetectionWhitelistUpsertRequest req) {
    TcmDetectionWhitelist item = requireWhitelist(id);
    String phone = normalizeRequiredPhone(req.getPhone());
    long duplicated = whitelistMapper.selectCount(
        new LambdaQueryWrapper<TcmDetectionWhitelist>()
            .eq(TcmDetectionWhitelist::getPhone, phone)
            .ne(TcmDetectionWhitelist::getId, id));
    if (duplicated > 0) {
      throw new ApiException(400, "该手机号已在中医体检白名单中");
    }
    fillWhitelist(item, req, phone);
    whitelistMapper.updateById(item);
    return whitelistMapper.selectById(id);
  }

  @Transactional
  public TcmDetectionWhitelist adjustQuota(Long id, TcmDetectionQuotaAdjustRequest req, Long adminId) {
    int delta = req.getDelta() == null ? 0 : req.getDelta();
    if (delta == 0) {
      throw new ApiException(400, "调整次数不能为 0");
    }
    TcmDetectionWhitelist item = requireWhitelist(id);
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

  public TcmDetectionQuotaSummaryVo quotaSummary(Long id) {
    TcmDetectionWhitelist item = requireWhitelist(id);
    List<TcmDetectionQuotaLog> logs = listLogs(id, null);
    int grant = 0;
    int reduce = 0;
    for (TcmDetectionQuotaLog log : logs) {
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
    TcmDetectionQuotaSummaryVo vo = new TcmDetectionQuotaSummaryVo();
    vo.setGrantCount(grant);
    vo.setReduceCount(reduce);
    vo.setUsedCount(safeInt(item.getUsedTimes()));
    vo.setCurrentBalance(safeInt(item.getTotalTimes()) - safeInt(item.getUsedTimes()));
    return vo;
  }

  public List<TcmDetectionQuotaLogItemVo> listManualLogs(Long id) {
    requireWhitelist(id);
    return listLogs(id, false).stream().map(this::toLogVo).collect(Collectors.toList());
  }

  public List<TcmDetectionQuotaLogItemVo> listConsumeLogs(Long id) {
    requireWhitelist(id);
    return listLogs(id, true).stream().map(this::toLogVo).collect(Collectors.toList());
  }

  public List<TcmDetectionRecord> listRecords(
      String phone,
      String status,
      LocalDate startDate,
      LocalDate endDate,
      Integer minScore,
      Integer maxScore) {
    LambdaQueryWrapper<TcmDetectionRecord> w = new LambdaQueryWrapper<>();
    if (StringUtils.hasText(phone)) {
      w.like(TcmDetectionRecord::getPhone, normalizePhone(phone));
    }
    if (StringUtils.hasText(status)) {
      w.eq(TcmDetectionRecord::getStatus, status.trim());
    }
    if (startDate != null) {
      w.ge(TcmDetectionRecord::getCreatedAt, startDate.atStartOfDay());
    }
    if (endDate != null) {
      w.lt(TcmDetectionRecord::getCreatedAt, endDate.plusDays(1).atStartOfDay());
    }
    if (minScore != null) {
      w.ge(TcmDetectionRecord::getOverallScore, minScore);
    }
    if (maxScore != null) {
      w.le(TcmDetectionRecord::getOverallScore, maxScore);
    }
    w.orderByDesc(TcmDetectionRecord::getId).last("LIMIT 500");
    return recordMapper.selectList(w);
  }

  public AdminTcmDetectionRecordDetailVo recordDetail(Long id) {
    TcmDetectionRecord record = recordMapper.selectById(id);
    if (record == null) {
      throw new ApiException(404, "中医体检记录不存在");
    }
    List<TcmDetectionItem> items = itemMapper.selectList(
        new LambdaQueryWrapper<TcmDetectionItem>()
            .eq(TcmDetectionItem::getRecordId, id)
            .orderByAsc(TcmDetectionItem::getSortOrder)
            .orderByAsc(TcmDetectionItem::getId));
    AdminTcmDetectionRecordDetailVo vo = new AdminTcmDetectionRecordDetailVo();
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
    vo.setTongueImageUrl(record.getTongueImageUrl());
    vo.setFaceImageUrl(record.getFaceImageUrl());
    vo.setConstitutionPrimary(record.getConstitutionPrimary());
    vo.setOverallScore(record.getOverallScore());
    vo.setReportJson(record.getConstitutionJson());
    vo.setAiSummary(record.getAiSummary());
    vo.setDeepseekStatus(record.getDeepseekStatus());
    vo.setDeepseekError(record.getDeepseekError());
    vo.setCreatedAt(record.getCreatedAt());
    vo.setItems(items.stream().map(this::toItemVo).collect(Collectors.toList()));
    return vo;
  }

  private List<TcmDetectionQuotaLog> listLogs(Long whitelistId, Boolean consume) {
    LambdaQueryWrapper<TcmDetectionQuotaLog> w = new LambdaQueryWrapper<TcmDetectionQuotaLog>().eq(TcmDetectionQuotaLog::getWhitelistId, whitelistId);
    if (consume != null) {
      if (Boolean.TRUE.equals(consume)) {
        w.eq(TcmDetectionQuotaLog::getChangeType, "consume");
      } else {
        w.ne(TcmDetectionQuotaLog::getChangeType, "consume");
      }
    }
    w.orderByDesc(TcmDetectionQuotaLog::getId).last("LIMIT 200");
    return quotaLogMapper.selectList(w);
  }

  private void fillWhitelist(TcmDetectionWhitelist item, TcmDetectionWhitelistUpsertRequest req, String phone) {
    item.setPhone(phone);
    item.setRemark(blankToNull(req.getRemark()));
    item.setStatus(req.getStatus() != null && req.getStatus() == 0 ? 0 : 1);
  }

  private TcmDetectionWhitelist requireWhitelist(Long id) {
    TcmDetectionWhitelist item = whitelistMapper.selectById(id);
    if (item == null) {
      throw new ApiException(404, "中医体检白名单记录不存在");
    }
    return item;
  }

  private void insertQuotaLog(
      TcmDetectionWhitelist item,
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
    TcmDetectionQuotaLog log = new TcmDetectionQuotaLog();
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

  private TcmDetectionQuotaLogItemVo toLogVo(TcmDetectionQuotaLog log) {
    TcmDetectionQuotaLogItemVo vo = new TcmDetectionQuotaLogItemVo();
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

  private TcmDetectionItemVo toItemVo(TcmDetectionItem item) {
    TcmDetectionItemVo vo = new TcmDetectionItemVo();
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
