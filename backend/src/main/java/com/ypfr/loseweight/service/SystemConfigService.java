package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.domain.SystemConfig;
import com.ypfr.loseweight.mapper.SystemConfigMapper;
import com.ypfr.loseweight.web.dto.admin.SystemConfigUpdateRequest;
import com.ypfr.loseweight.web.dto.admin.SystemConfigVo;
import java.time.LocalDateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/** 系统级开关配置。白名单限制开关：开启=需在白名单内才可使用；关闭=所有用户放行。 */
@Service
public class SystemConfigService {

  private static final Logger log = LoggerFactory.getLogger(SystemConfigService.class);

  public static final String KEY_PHOTO_RECOGNITION_WHITELIST = "photo_recognition_whitelist_enabled";
  public static final String KEY_SKIN_DETECTION_WHITELIST = "skin_detection_whitelist_enabled";
  public static final String KEY_TCM_DETECTION_WHITELIST = "tcm_detection_whitelist_enabled";
  public static final String KEY_SKIN_DETECTION_ENTRY_VISIBLE = "skin_detection_entry_visible";
  public static final String KEY_TCM_DETECTION_ENTRY_VISIBLE = "tcm_detection_entry_visible";

  private final SystemConfigMapper systemConfigMapper;

  public SystemConfigService(SystemConfigMapper systemConfigMapper) {
    this.systemConfigMapper = systemConfigMapper;
  }

  /** 拍照识图白名单限制是否开启（默认开启）。 */
  public boolean isPhotoRecognitionWhitelistEnabled() {
    return getBool(KEY_PHOTO_RECOGNITION_WHITELIST, true);
  }

  /** 皮肤检测白名单限制是否开启（默认开启）。 */
  public boolean isSkinDetectionWhitelistEnabled() {
    return getBool(KEY_SKIN_DETECTION_WHITELIST, true);
  }

  /** 中医体检白名单限制是否开启（默认开启）。 */
  public boolean isTcmDetectionWhitelistEnabled() {
    return getBool(KEY_TCM_DETECTION_WHITELIST, true);
  }

  /** 首页皮肤检测入口是否显示（默认显示）。 */
  public boolean isSkinDetectionEntryVisible() {
    return getBool(KEY_SKIN_DETECTION_ENTRY_VISIBLE, true);
  }

  /** 首页舌诊(中医体检)入口是否显示（默认显示）。 */
  public boolean isTcmDetectionEntryVisible() {
    return getBool(KEY_TCM_DETECTION_ENTRY_VISIBLE, true);
  }

  public SystemConfigVo getConfig() {
    SystemConfigVo vo = new SystemConfigVo();
    vo.setPhotoRecognitionWhitelistEnabled(isPhotoRecognitionWhitelistEnabled());
    vo.setSkinDetectionWhitelistEnabled(isSkinDetectionWhitelistEnabled());
    vo.setTcmDetectionWhitelistEnabled(isTcmDetectionWhitelistEnabled());
    vo.setSkinDetectionEntryVisible(isSkinDetectionEntryVisible());
    vo.setTcmDetectionEntryVisible(isTcmDetectionEntryVisible());
    return vo;
  }

  public SystemConfigVo updateConfig(SystemConfigUpdateRequest req) {
    if (req.getPhotoRecognitionWhitelistEnabled() != null) {
      setBool(
          KEY_PHOTO_RECOGNITION_WHITELIST,
          req.getPhotoRecognitionWhitelistEnabled(),
          "拍照识图白名单限制开关：1=开启限制 0=关闭限制");
    }
    if (req.getSkinDetectionWhitelistEnabled() != null) {
      setBool(
          KEY_SKIN_DETECTION_WHITELIST,
          req.getSkinDetectionWhitelistEnabled(),
          "皮肤检测白名单限制开关：1=开启限制 0=关闭限制");
    }
    if (req.getTcmDetectionWhitelistEnabled() != null) {
      setBool(
          KEY_TCM_DETECTION_WHITELIST,
          req.getTcmDetectionWhitelistEnabled(),
          "中医体检白名单限制开关：1=开启限制 0=关闭限制");
    }
    if (req.getSkinDetectionEntryVisible() != null) {
      setBool(
          KEY_SKIN_DETECTION_ENTRY_VISIBLE,
          req.getSkinDetectionEntryVisible(),
          "首页皮肤检测入口显示开关：1=显示 0=隐藏");
    }
    if (req.getTcmDetectionEntryVisible() != null) {
      setBool(
          KEY_TCM_DETECTION_ENTRY_VISIBLE,
          req.getTcmDetectionEntryVisible(),
          "首页舌诊(中医体检)入口显示开关：1=显示 0=隐藏");
    }
    return getConfig();
  }

  /** 小程序首页入口可见性（仅返回展示开关，不含白名单内部配置）。 */
  public HomeEntryConfig getHomeEntryConfig() {
    return new HomeEntryConfig(isSkinDetectionEntryVisible(), isTcmDetectionEntryVisible());
  }

  /** 首页入口可见性视图。 */
  public record HomeEntryConfig(boolean skinDetectionEntryVisible, boolean tcmDetectionEntryVisible) {}

  private boolean getBool(String key, boolean defaultValue) {
    SystemConfig config = findByKey(key);
    if (config == null || config.getConfigValue() == null) {
      return defaultValue;
    }
    String value = config.getConfigValue().trim();
    return "1".equals(value) || "true".equalsIgnoreCase(value);
  }

  private void setBool(String key, boolean value, String remark) {
    String stored = value ? "1" : "0";
    SystemConfig existing = findByKey(key);
    if (existing != null) {
      existing.setConfigValue(stored);
      existing.setUpdatedAt(LocalDateTime.now());
      systemConfigMapper.updateById(existing);
      return;
    }
    SystemConfig created = new SystemConfig();
    created.setConfigKey(key);
    created.setConfigValue(stored);
    created.setRemark(remark);
    systemConfigMapper.insert(created);
  }

  private SystemConfig findByKey(String key) {
    try {
      return systemConfigMapper.selectOne(
          new LambdaQueryWrapper<SystemConfig>()
              .eq(SystemConfig::getConfigKey, key)
              .last("LIMIT 1"));
    } catch (Exception e) {
      // system_config 表尚未迁移时，读路径不应阻断功能，按默认（限制开启）兜底
      log.warn("读取系统配置失败，按默认处理。key={}, reason={}", key, e.getMessage());
      return null;
    }
  }
}
