package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.LoseWeightUser;
import com.ypfr.loseweight.domain.PhotoRecognitionMemberPhone;
import com.ypfr.loseweight.domain.PhotoRecognitionQuotaLog;
import com.ypfr.loseweight.mapper.LoseWeightUserMapper;
import com.ypfr.loseweight.mapper.PhotoRecognitionMemberPhoneMapper;
import com.ypfr.loseweight.mapper.PhotoRecognitionQuotaLogMapper;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionQuotaAdjustRequest;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionQuotaLogItemVo;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionQuotaSummaryVo;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class PhotoRecognitionQuotaService {

  private final LoseWeightUserMapper loseWeightUserMapper;
  private final PhotoRecognitionMemberPhoneMapper memberPhoneMapper;
  private final PhotoRecognitionQuotaLogMapper quotaLogMapper;

  public PhotoRecognitionQuotaService(
      LoseWeightUserMapper loseWeightUserMapper,
      PhotoRecognitionMemberPhoneMapper memberPhoneMapper,
      PhotoRecognitionQuotaLogMapper quotaLogMapper) {
    this.loseWeightUserMapper = loseWeightUserMapper;
    this.memberPhoneMapper = memberPhoneMapper;
    this.quotaLogMapper = quotaLogMapper;
  }

  public PhotoRecognitionMemberPhone findEnabledMemberPhoneByPhone(String phone) {
    if (!StringUtils.hasText(phone)) {
      return null;
    }
    return memberPhoneMapper.selectOne(
        new LambdaQueryWrapper<PhotoRecognitionMemberPhone>()
            .eq(PhotoRecognitionMemberPhone::getPhone, phone)
            .eq(PhotoRecognitionMemberPhone::getStatus, 1)
            .last("LIMIT 1"));
  }

  public int remainingCount(PhotoRecognitionMemberPhone member) {
    return safeInt(member.getTotalQuota()) - safeInt(member.getUsedCount());
  }

  @Transactional
  public void grantInitialQuota(PhotoRecognitionMemberPhone member, int initialQuota) {
    if (initialQuota <= 0) {
      return;
    }
    insertLog(
        member,
        null,
        null,
        "grant",
        initialQuota,
        0,
        0,
        initialQuota,
        0,
        "admin",
        null,
        "新增手机号默认赠送");
  }

  @Transactional
  public PhotoRecognitionMemberPhone adjustQuota(Long id, PhotoRecognitionQuotaAdjustRequest req, Long adminId) {
    PhotoRecognitionMemberPhone member = requireMemberPhone(id);
    int delta = req.getDelta() == null ? 0 : req.getDelta();
    if (delta == 0) {
      throw new ApiException(400, "调整次数不能为 0");
    }
    int beforeTotal = safeInt(member.getTotalQuota());
    int beforeUsed = safeInt(member.getUsedCount());
    int afterTotal = beforeTotal + delta;
    if (afterTotal < beforeUsed) {
      throw new ApiException(400, "调减后总次数不能小于已使用次数");
    }
    member.setTotalQuota(afterTotal);
    member.setQuotaUpdatedAt(LocalDateTime.now());
    memberPhoneMapper.updateById(member);
    insertLog(
        member,
        null,
        null,
        delta > 0 ? "grant" : "reduce",
        delta,
        beforeTotal,
        beforeUsed,
        afterTotal,
        beforeUsed,
        "admin",
        adminId != null ? String.valueOf(adminId) : null,
        blankToNull(req.getRemark()));
    return memberPhoneMapper.selectById(id);
  }

  @Transactional
  public void consumeQuota(Long userId, Long photoJobId) {
    LoseWeightUser user = loseWeightUserMapper.selectById(userId);
    if (user == null) {
      throw new ApiException(404, "用户不存在");
    }
    String phone = normalizePhone(user.getPhone());
    PhotoRecognitionMemberPhone member = findEnabledMemberPhoneByPhone(phone);
    if (member == null) {
      throw new ApiException(4602, "当前手机号暂未开通拍照识别，请联系客服开通");
    }
    int beforeTotal = safeInt(member.getTotalQuota());
    int beforeUsed = safeInt(member.getUsedCount());
    if (beforeTotal - beforeUsed <= 0) {
      throw new ApiException(4602, "拍照识别次数已用完，请联系客服增加次数");
    }
    member.setUsedCount(beforeUsed + 1);
    memberPhoneMapper.updateById(member);
    insertLog(
        member,
        userId,
        photoJobId,
        "consume",
        -1,
        beforeTotal,
        beforeUsed,
        beforeTotal,
        beforeUsed + 1,
        "user",
        String.valueOf(userId),
        "创建识图任务成功扣减");
  }

  public PhotoRecognitionQuotaSummaryVo getSummary(Long id) {
    requireMemberPhone(id);
    List<PhotoRecognitionQuotaLog> logs =
        quotaLogMapper.selectList(
            new LambdaQueryWrapper<PhotoRecognitionQuotaLog>()
                .eq(PhotoRecognitionQuotaLog::getMemberPhoneId, id)
                .in(PhotoRecognitionQuotaLog::getChangeType, List.of("grant", "reduce"))
                .orderByAsc(PhotoRecognitionQuotaLog::getCreatedAt)
                .orderByAsc(PhotoRecognitionQuotaLog::getId));
    int grant = 0;
    int reduce = 0;
    for (PhotoRecognitionQuotaLog log : logs) {
      int count = safeInt(log.getChangeCount());
      if (count > 0) {
        grant += count;
      } else {
        reduce += Math.abs(count);
      }
    }
    PhotoRecognitionMemberPhone member = requireMemberPhone(id);
    PhotoRecognitionQuotaSummaryVo vo = new PhotoRecognitionQuotaSummaryVo();
    vo.setGrantCount(grant);
    vo.setReduceCount(reduce);
    vo.setUsedCount(safeInt(member.getUsedCount()));
    vo.setCurrentBalance(safeInt(member.getTotalQuota()) - safeInt(member.getUsedCount()));
    return vo;
  }

  public List<PhotoRecognitionQuotaLogItemVo> listManualLogs(Long id) {
    requireMemberPhone(id);
    List<PhotoRecognitionQuotaLog> logs =
        quotaLogMapper.selectList(
            new LambdaQueryWrapper<PhotoRecognitionQuotaLog>()
                .eq(PhotoRecognitionQuotaLog::getMemberPhoneId, id)
                .in(PhotoRecognitionQuotaLog::getChangeType, List.of("grant", "reduce"))
                .orderByAsc(PhotoRecognitionQuotaLog::getCreatedAt)
                .orderByAsc(PhotoRecognitionQuotaLog::getId));
    return toLogVos(logs);
  }

  public List<PhotoRecognitionQuotaLogItemVo> listConsumeLogs(Long id) {
    requireMemberPhone(id);
    List<PhotoRecognitionQuotaLog> logs =
        quotaLogMapper.selectList(
            new LambdaQueryWrapper<PhotoRecognitionQuotaLog>()
                .eq(PhotoRecognitionQuotaLog::getMemberPhoneId, id)
                .eq(PhotoRecognitionQuotaLog::getChangeType, "consume")
                .orderByDesc(PhotoRecognitionQuotaLog::getCreatedAt)
                .orderByDesc(PhotoRecognitionQuotaLog::getId)
                .last("LIMIT 500"));
    return toLogVos(logs);
  }

  private PhotoRecognitionMemberPhone requireMemberPhone(Long id) {
    PhotoRecognitionMemberPhone member = memberPhoneMapper.selectById(id);
    if (member == null) {
      throw new ApiException(404, "手机号记录不存在");
    }
    return member;
  }

  private void insertLog(
      PhotoRecognitionMemberPhone member,
      Long userId,
      Long photoJobId,
      String changeType,
      int changeCount,
      int beforeTotal,
      int beforeUsed,
      int afterTotal,
      int afterUsed,
      String operatorType,
      String operatorName,
      String remark) {
    PhotoRecognitionQuotaLog log = new PhotoRecognitionQuotaLog();
    log.setMemberPhoneId(member.getId());
    log.setPhone(member.getPhone());
    log.setUserId(userId);
    log.setPhotoJobId(photoJobId);
    log.setChangeType(changeType);
    log.setChangeCount(changeCount);
    log.setBeforeTotalQuota(beforeTotal);
    log.setBeforeUsedCount(beforeUsed);
    log.setAfterTotalQuota(afterTotal);
    log.setAfterUsedCount(afterUsed);
    log.setOperatorType(operatorType);
    log.setOperatorName(operatorName);
    log.setRemark(remark);
    quotaLogMapper.insert(log);
  }

  private static List<PhotoRecognitionQuotaLogItemVo> toLogVos(List<PhotoRecognitionQuotaLog> logs) {
    List<PhotoRecognitionQuotaLogItemVo> items = new ArrayList<>();
    for (PhotoRecognitionQuotaLog log : logs) {
      PhotoRecognitionQuotaLogItemVo vo = new PhotoRecognitionQuotaLogItemVo();
      vo.setId(log.getId());
      vo.setChangeType(log.getChangeType());
      vo.setChangeCount(log.getChangeCount());
      vo.setBeforeTotalQuota(log.getBeforeTotalQuota());
      vo.setBeforeUsedCount(log.getBeforeUsedCount());
      vo.setAfterTotalQuota(log.getAfterTotalQuota());
      vo.setAfterUsedCount(log.getAfterUsedCount());
      vo.setPhotoJobId(log.getPhotoJobId());
      vo.setRemark(log.getRemark());
      vo.setOperatorType(log.getOperatorType());
      vo.setOperatorName(log.getOperatorName());
      vo.setCreatedAt(log.getCreatedAt());
      items.add(vo);
    }
    return items;
  }

  private static int safeInt(Integer value) {
    return value == null ? 0 : value;
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
