package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.config.PhotoRecognitionProperties;
import com.ypfr.loseweight.domain.LoseWeightUser;
import com.ypfr.loseweight.domain.PhotoRecognitionMemberPhone;
import com.ypfr.loseweight.domain.PhotoRecognitionServiceConfig;
import com.ypfr.loseweight.mapper.LoseWeightUserMapper;
import com.ypfr.loseweight.mapper.PhotoRecognitionMemberPhoneMapper;
import com.ypfr.loseweight.mapper.PhotoRecognitionServiceConfigMapper;
import com.ypfr.loseweight.web.dto.PhotoRecognitionAccessVo;
import com.ypfr.loseweight.web.dto.PhotoRecognitionServiceConfigVo;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionMemberPhoneUpsertRequest;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionQuotaAdjustRequest;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionQuotaLogItemVo;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionQuotaSummaryVo;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionServiceConfigRequest;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class PhotoRecognitionAccessService {

  private static final String REASON_ALLOWED = "allowed";
  private static final String REASON_PHONE_REQUIRED = "phone_required";
  private static final String REASON_NOT_MEMBER = "not_member";
  private static final String REASON_QUOTA_EXHAUSTED = "quota_exhausted";
  private static final String SERVICE_CONFIG_KEY = "default";
  private static final int DEFAULT_TOTAL_QUOTA = 100;

  private final LoseWeightUserMapper loseWeightUserMapper;
  private final PhotoRecognitionMemberPhoneMapper memberPhoneMapper;
  private final PhotoRecognitionServiceConfigMapper serviceConfigMapper;
  private final PhotoRecognitionProperties properties;
  private final AvatarStorageService avatarStorageService;
  private final PhotoRecognitionQuotaService quotaService;

  public PhotoRecognitionAccessService(
      LoseWeightUserMapper loseWeightUserMapper,
      PhotoRecognitionMemberPhoneMapper memberPhoneMapper,
      PhotoRecognitionServiceConfigMapper serviceConfigMapper,
      PhotoRecognitionProperties properties,
      AvatarStorageService avatarStorageService,
      PhotoRecognitionQuotaService quotaService) {
    this.loseWeightUserMapper = loseWeightUserMapper;
    this.memberPhoneMapper = memberPhoneMapper;
    this.serviceConfigMapper = serviceConfigMapper;
    this.properties = properties;
    this.avatarStorageService = avatarStorageService;
    this.quotaService = quotaService;
  }

  public PhotoRecognitionAccessVo checkAccess(Long userId) {
    LoseWeightUser user = loseWeightUserMapper.selectById(userId);
    if (user == null) {
      throw new ApiException(404, "用户不存在");
    }
    String phone = normalizePhone(user.getPhone());
    if (!StringUtils.hasText(phone)) {
      return buildVo(false, false, REASON_PHONE_REQUIRED, "使用拍照识别前，请先绑定手机号", loadServiceConfig(), null);
    }
    PhotoRecognitionMemberPhone member = quotaService.findEnabledMemberPhoneByPhone(phone);
    if (member == null) {
      PhotoRecognitionServiceConfig cfg = loadServiceConfig();
      return buildVo(false, true, REASON_NOT_MEMBER, "当前手机号暂未开通拍照识别，请联系客服开通", cfg, null);
    }
    if (quotaService.remainingCount(member) <= 0) {
      return buildVo(
          false,
          true,
          REASON_QUOTA_EXHAUSTED,
          "拍照识别次数已用完，请联系客服增加次数",
          loadServiceConfig(),
          member);
    }
    return buildVo(true, true, REASON_ALLOWED, "ok", loadServiceConfig(), member);
  }

  public void requireAccess(Long userId) {
    PhotoRecognitionAccessVo access = checkAccess(userId);
    if (Boolean.TRUE.equals(access.getAllowed())) {
      return;
    }
    int code = REASON_PHONE_REQUIRED.equals(access.getReason()) ? 4601 : 4602;
    throw new ApiException(code, access.getMessage());
  }

  public void consumeQuota(Long userId, Long photoJobId) {
    quotaService.consumeQuota(userId, photoJobId);
  }

  public List<PhotoRecognitionMemberPhone> listMemberPhones(String keyword, Integer status) {
    LambdaQueryWrapper<PhotoRecognitionMemberPhone> w = new LambdaQueryWrapper<>();
    if (StringUtils.hasText(keyword)) {
      w.like(PhotoRecognitionMemberPhone::getPhone, normalizePhone(keyword));
    }
    if (status != null) {
      w.eq(PhotoRecognitionMemberPhone::getStatus, status);
    }
    w.orderByDesc(PhotoRecognitionMemberPhone::getId).last("LIMIT 500");
    return memberPhoneMapper.selectList(w);
  }

  @Transactional
  public PhotoRecognitionMemberPhone createMemberPhone(PhotoRecognitionMemberPhoneUpsertRequest req) {
    String phone = normalizeRequiredPhone(req.getPhone());
    if (memberPhoneMapper.selectCount(new LambdaQueryWrapper<PhotoRecognitionMemberPhone>().eq(PhotoRecognitionMemberPhone::getPhone, phone)) > 0) {
      throw new ApiException(400, "该手机号已在清单中");
    }
    PhotoRecognitionMemberPhone item = new PhotoRecognitionMemberPhone();
    fillMemberPhone(item, req, phone);
    int initialQuota = req.getTotalQuota() != null ? Math.max(0, req.getTotalQuota()) : DEFAULT_TOTAL_QUOTA;
    item.setTotalQuota(initialQuota);
    item.setUsedCount(0);
    item.setQuotaUpdatedAt(LocalDateTime.now());
    memberPhoneMapper.insert(item);
    quotaService.grantInitialQuota(item, initialQuota);
    return memberPhoneMapper.selectById(item.getId());
  }

  public PhotoRecognitionMemberPhone updateMemberPhone(Long id, PhotoRecognitionMemberPhoneUpsertRequest req) {
    PhotoRecognitionMemberPhone item = requireMemberPhone(id);
    String phone = normalizeRequiredPhone(req.getPhone());
    long duplicated =
        memberPhoneMapper.selectCount(
            new LambdaQueryWrapper<PhotoRecognitionMemberPhone>()
                .eq(PhotoRecognitionMemberPhone::getPhone, phone)
                .ne(PhotoRecognitionMemberPhone::getId, id));
    if (duplicated > 0) {
      throw new ApiException(400, "该手机号已在清单中");
    }
    fillMemberPhone(item, req, phone);
    memberPhoneMapper.updateById(item);
    return memberPhoneMapper.selectById(id);
  }

  public void deleteMemberPhone(Long id) {
    requireMemberPhone(id);
    memberPhoneMapper.deleteById(id);
  }

  public PhotoRecognitionMemberPhone adjustQuota(Long id, PhotoRecognitionQuotaAdjustRequest req, Long adminId) {
    return quotaService.adjustQuota(id, req, adminId);
  }

  public PhotoRecognitionQuotaSummaryVo getQuotaSummary(Long id) {
    return quotaService.getSummary(id);
  }

  public List<PhotoRecognitionQuotaLogItemVo> listManualQuotaLogs(Long id) {
    return quotaService.listManualLogs(id);
  }

  public List<PhotoRecognitionQuotaLogItemVo> listConsumeQuotaLogs(Long id) {
    return quotaService.listConsumeLogs(id);
  }

  public PhotoRecognitionServiceConfigVo getServiceConfig() {
    return toVo(loadServiceConfig());
  }

  public PhotoRecognitionServiceConfigVo updateServiceConfig(PhotoRecognitionServiceConfigRequest req) {
    PhotoRecognitionServiceConfig cfg = loadServiceConfig();
    if (StringUtils.hasText(req.getServicePhone())) {
      cfg.setServicePhone(req.getServicePhone().trim());
    }
    if (StringUtils.hasText(req.getServiceWechat())) {
      cfg.setServiceWechat(req.getServiceWechat().trim());
    }
    if (StringUtils.hasText(req.getServiceQrImageUrl())) {
      cfg.setQrImageUrl(req.getServiceQrImageUrl().trim());
      cfg.setQrImagePath(null);
      cfg.setQrImageName(null);
    }
    if (req.getServiceQrImageFile() != null && !req.getServiceQrImageFile().isEmpty()) {
      String path = avatarStorageService.saveMultipartToDir(
          req.getServiceQrImageFile(),
          "photo-recognition",
          "service-qr.png",
          2_500_000);
      cfg.setQrImagePath(path);
      cfg.setQrImageUrl(null);
      cfg.setQrImageName("service-qr.png");
    }
    if (req.getStatus() != null) {
      cfg.setStatus(req.getStatus() == 0 ? 0 : 1);
    }
    if (StringUtils.hasText(req.getRemark())) {
      cfg.setRemark(req.getRemark().trim());
    }
    serviceConfigMapper.updateById(cfg);
    syncProperties(cfg);
    return toVo(cfg);
  }

  private void syncProperties(PhotoRecognitionServiceConfig cfg) {
    properties.setServicePhone(cfg.getServicePhone());
    properties.setServiceWechat(cfg.getServiceWechat());
    properties.setServiceQrImageUrl(cfg.getQrImageUrl());
    properties.setServiceQrImagePath(cfg.getQrImagePath());
    properties.setServiceQrImageName(cfg.getQrImageName());
  }

  private PhotoRecognitionServiceConfig loadServiceConfig() {
    PhotoRecognitionServiceConfig cfg =
        serviceConfigMapper.selectOne(
            new LambdaQueryWrapper<PhotoRecognitionServiceConfig>()
                .eq(PhotoRecognitionServiceConfig::getConfigKey, SERVICE_CONFIG_KEY)
                .last("LIMIT 1"));
    if (cfg != null) {
      syncProperties(cfg);
      return cfg;
    }
    cfg = new PhotoRecognitionServiceConfig();
    cfg.setConfigKey(SERVICE_CONFIG_KEY);
    cfg.setServicePhone(properties.getServicePhone());
    cfg.setServiceWechat(properties.getServiceWechat());
    cfg.setQrImageUrl(properties.getServiceQrImageUrl());
    cfg.setQrImagePath(properties.getServiceQrImagePath());
    cfg.setQrImageName(properties.getServiceQrImageName());
    cfg.setStatus(1);
    serviceConfigMapper.insert(cfg);
    return serviceConfigMapper.selectOne(
        new LambdaQueryWrapper<PhotoRecognitionServiceConfig>()
            .eq(PhotoRecognitionServiceConfig::getConfigKey, SERVICE_CONFIG_KEY)
            .last("LIMIT 1"));
  }

  private PhotoRecognitionMemberPhone requireMemberPhone(Long id) {
    PhotoRecognitionMemberPhone item = memberPhoneMapper.selectById(id);
    if (item == null) {
      throw new ApiException(404, "手机号记录不存在");
    }
    return item;
  }

  private void fillMemberPhone(
      PhotoRecognitionMemberPhone item, PhotoRecognitionMemberPhoneUpsertRequest req, String phone) {
    item.setPhone(phone);
    item.setRemark(blankToNull(req.getRemark()));
    item.setStatus(req.getStatus() != null && req.getStatus() == 0 ? 0 : 1);
  }

  private PhotoRecognitionAccessVo buildVo(
      boolean allowed, boolean phoneBound, String reason, String message, PhotoRecognitionServiceConfig cfg, PhotoRecognitionMemberPhone member) {
    PhotoRecognitionAccessVo vo = new PhotoRecognitionAccessVo();
    vo.setAllowed(allowed);
    vo.setPhoneBound(phoneBound);
    vo.setReason(reason);
    vo.setMessage(message);
    vo.setServicePhone(cfg != null ? cfg.getServicePhone() : properties.getServicePhone());
    vo.setServiceWechat(cfg != null ? cfg.getServiceWechat() : properties.getServiceWechat());
    vo.setServiceQrImageUrl(cfg != null ? cfg.getQrImageUrl() : properties.getServiceQrImageUrl());
    vo.setServiceQrImagePath(cfg != null ? cfg.getQrImagePath() : properties.getServiceQrImagePath());
    vo.setServiceQrImageName(cfg != null ? cfg.getQrImageName() : properties.getServiceQrImageName());
    if (member != null) {
      vo.setTotalQuota(member.getTotalQuota());
      vo.setUsedCount(member.getUsedCount());
      vo.setRemainingCount(quotaService.remainingCount(member));
    }
    return vo;
  }

  private static PhotoRecognitionServiceConfigVo toVo(PhotoRecognitionServiceConfig cfg) {
    PhotoRecognitionServiceConfigVo vo = new PhotoRecognitionServiceConfigVo();
    vo.setServicePhone(cfg.getServicePhone());
    vo.setServiceWechat(cfg.getServiceWechat());
    vo.setServiceQrImageUrl(cfg.getQrImageUrl());
    vo.setServiceQrImagePath(cfg.getQrImagePath());
    vo.setServiceQrImageName(cfg.getQrImageName());
    vo.setRemark(cfg.getRemark());
    vo.setStatus(cfg.getStatus());
    return vo;
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
