package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.LoseWeightUser;
import com.ypfr.loseweight.domain.SkinDetectionQuotaLog;
import com.ypfr.loseweight.domain.SkinDetectionWhitelist;
import com.ypfr.loseweight.mapper.LoseWeightUserMapper;
import com.ypfr.loseweight.mapper.SkinDetectionQuotaLogMapper;
import com.ypfr.loseweight.mapper.SkinDetectionWhitelistMapper;
import com.ypfr.loseweight.web.dto.skin.SkinDetectionQuotaVo;
import java.time.LocalDateTime;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class SkinDetectionQuotaService {

  private static final String REASON_ALLOWED = "allowed";
  private static final String REASON_PHONE_REQUIRED = "phone_required";
  private static final String REASON_NOT_MEMBER = "not_member";
  private static final String REASON_QUOTA_EXHAUSTED = "quota_exhausted";

  private final LoseWeightUserMapper userMapper;
  private final SkinDetectionWhitelistMapper whitelistMapper;
  private final SkinDetectionQuotaLogMapper quotaLogMapper;

  public SkinDetectionQuotaService(
      LoseWeightUserMapper userMapper,
      SkinDetectionWhitelistMapper whitelistMapper,
      SkinDetectionQuotaLogMapper quotaLogMapper) {
    this.userMapper = userMapper;
    this.whitelistMapper = whitelistMapper;
    this.quotaLogMapper = quotaLogMapper;
  }

  public SkinDetectionQuotaVo getQuota(Long userId) {
    LoseWeightUser user = requireUser(userId);
    String phone = normalizePhone(user.getPhone());
    if (!StringUtils.hasText(phone)) {
      return buildVo(false, false, REASON_PHONE_REQUIRED, "使用皮肤检测前，请先绑定手机号", null);
    }
    SkinDetectionWhitelist member = findEnabledByPhone(phone);
    if (member == null) {
      return buildVo(false, true, REASON_NOT_MEMBER, "当前手机号暂未开通皮肤检测，请联系客服开通", null);
    }
    if (remainingTimes(member) <= 0) {
      return buildVo(false, true, REASON_QUOTA_EXHAUSTED, "皮肤检测次数已用完，请联系客服增加次数", member);
    }
    return buildVo(true, true, REASON_ALLOWED, "ok", member);
  }

  public SkinDetectionWhitelist requireAvailableQuota(Long userId) {
    LoseWeightUser user = requireUser(userId);
    String phone = normalizePhone(user.getPhone());
    if (!StringUtils.hasText(phone)) {
      throw new ApiException(4601, "使用皮肤检测前，请先绑定手机号");
    }
    SkinDetectionWhitelist member = findEnabledByPhone(phone);
    if (member == null) {
      throw new ApiException(4602, "当前手机号暂未开通皮肤检测，请联系客服开通");
    }
    if (remainingTimes(member) <= 0) {
      throw new ApiException(4602, "皮肤检测次数已用完，请联系客服增加次数");
    }
    return member;
  }

  @Transactional
  public void consumeQuota(SkinDetectionWhitelist member, Long userId, Long recordId) {
    SkinDetectionWhitelist current = whitelistMapper.selectById(member.getId());
    if (current == null || safeInt(current.getStatus()) != 1) {
      throw new ApiException(4602, "当前手机号暂未开通皮肤检测，请联系客服开通");
    }
    int beforeTotal = safeInt(current.getTotalTimes());
    int beforeUsed = safeInt(current.getUsedTimes());
    if (beforeTotal - beforeUsed <= 0) {
      throw new ApiException(4602, "皮肤检测次数已用完，请联系客服增加次数");
    }
    current.setUsedTimes(beforeUsed + 1);
    current.setQuotaUpdatedAt(LocalDateTime.now());
    whitelistMapper.updateById(current);

    SkinDetectionQuotaLog log = new SkinDetectionQuotaLog();
    log.setWhitelistId(current.getId());
    log.setPhone(current.getPhone());
    log.setUserId(userId);
    log.setRecordId(recordId);
    log.setChangeType("consume");
    log.setChangeCount(-1);
    log.setBeforeTotalTimes(beforeTotal);
    log.setBeforeUsedTimes(beforeUsed);
    log.setAfterTotalTimes(beforeTotal);
    log.setAfterUsedTimes(beforeUsed + 1);
    log.setOperatorType("user");
    log.setOperatorName(String.valueOf(userId));
    log.setRemark("皮肤检测成功扣减");
    quotaLogMapper.insert(log);
  }

  public SkinDetectionWhitelist findEnabledByPhone(String phone) {
    if (!StringUtils.hasText(phone)) {
      return null;
    }
    return whitelistMapper.selectOne(
        new LambdaQueryWrapper<SkinDetectionWhitelist>()
            .eq(SkinDetectionWhitelist::getPhone, normalizePhone(phone))
            .eq(SkinDetectionWhitelist::getStatus, 1)
            .last("LIMIT 1"));
  }

  public int remainingTimes(SkinDetectionWhitelist member) {
    return safeInt(member.getTotalTimes()) - safeInt(member.getUsedTimes());
  }

  public LoseWeightUser requireUser(Long userId) {
    LoseWeightUser user = userMapper.selectById(userId);
    if (user == null) {
      throw new ApiException(404, "用户不存在");
    }
    return user;
  }

  private SkinDetectionQuotaVo buildVo(
      boolean allowed,
      boolean phoneBound,
      String reason,
      String message,
      SkinDetectionWhitelist member) {
    SkinDetectionQuotaVo vo = new SkinDetectionQuotaVo();
    vo.setAllowed(allowed);
    vo.setPhoneBound(phoneBound);
    vo.setReason(reason);
    vo.setMessage(message);
    if (member != null) {
      vo.setTotalTimes(safeInt(member.getTotalTimes()));
      vo.setUsedTimes(safeInt(member.getUsedTimes()));
      vo.setRemainingTimes(remainingTimes(member));
    } else {
      vo.setTotalTimes(0);
      vo.setUsedTimes(0);
      vo.setRemainingTimes(0);
    }
    return vo;
  }

  static int safeInt(Integer value) {
    return value == null ? 0 : value;
  }

  static String normalizePhone(String value) {
    if (value == null) {
      return "";
    }
    String digits = value.replaceAll("\\D", "");
    if (digits.length() == 13 && digits.startsWith("86")) {
      return digits.substring(2);
    }
    return digits;
  }
}
