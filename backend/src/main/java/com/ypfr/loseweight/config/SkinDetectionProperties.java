package com.ypfr.loseweight.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.skin-detection")
public class SkinDetectionProperties {

  /** 宜远智能测肤 API 地址，如 https://api.yimei.ai */
  private String yimeiBaseUrl = "https://api.yimei.ai";

  /** 宜远应用 ID，必须由后端安全配置或环境变量覆盖 */
  private String yimeiClientId = "";

  /** 宜远应用密钥，必须由后端安全配置或环境变量覆盖 */
  private String yimeiClientSecret = "";

  /** 本次固定检测项兜底值；大于 0 时优先使用，否则按启用检测项动态计算 */
  private long detectTypes = 0L;

  /** DeepSeek API Key，必须由后端安全配置或环境变量覆盖 */
  private String deepseekApiKey = "";

  /** DeepSeek 接口地址 */
  private String deepseekBaseUrl = "https://api.deepseek.com";

  /** 新增皮肤检测白名单手机号时默认赠送次数 */
  private int defaultTimes = 3;

  /** 皮肤检测图片保存目录后缀，实际根目录复用 app.upload.avatar-dir 或后续独立上传根目录 */
  private String imageDirSuffix = "skin-detection";

  public String getYimeiBaseUrl() {
    return yimeiBaseUrl;
  }

  public void setYimeiBaseUrl(String yimeiBaseUrl) {
    this.yimeiBaseUrl = yimeiBaseUrl;
  }

  public String getYimeiClientId() {
    return yimeiClientId;
  }

  public void setYimeiClientId(String yimeiClientId) {
    this.yimeiClientId = yimeiClientId;
  }

  public String getYimeiClientSecret() {
    return yimeiClientSecret;
  }

  public void setYimeiClientSecret(String yimeiClientSecret) {
    this.yimeiClientSecret = yimeiClientSecret;
  }

  public long getDetectTypes() {
    return detectTypes;
  }

  public void setDetectTypes(long detectTypes) {
    this.detectTypes = detectTypes;
  }

  public String getDeepseekApiKey() {
    return deepseekApiKey;
  }

  public void setDeepseekApiKey(String deepseekApiKey) {
    this.deepseekApiKey = deepseekApiKey;
  }

  public String getDeepseekBaseUrl() {
    return deepseekBaseUrl;
  }

  public void setDeepseekBaseUrl(String deepseekBaseUrl) {
    this.deepseekBaseUrl = deepseekBaseUrl;
  }

  public int getDefaultTimes() {
    return defaultTimes;
  }

  public void setDefaultTimes(int defaultTimes) {
    this.defaultTimes = defaultTimes;
  }

  public String getImageDirSuffix() {
    return imageDirSuffix;
  }

  public void setImageDirSuffix(String imageDirSuffix) {
    this.imageDirSuffix = imageDirSuffix;
  }
}
