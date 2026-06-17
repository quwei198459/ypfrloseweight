package com.ypfr.loseweight.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 中医体检（AI 舌诊/面诊/体质检测/健康报告）配置。
 * 第三方为阿里云云市场「cmapi00066970（专业版）」，脉景 macrocura，APPCODE 鉴权，两步式：
 * createPath 创建舌面诊（传图片 URL + scene）→ session_id；reportPath 凭 session_id(+answers) 取体质报告。
 */
@ConfigurationProperties(prefix = "app.tcm-detection")
public class TcmDetectionProperties {

  /** 云市场 APPCODE，请用环境变量/application-local.yml 覆盖 */
  private String appcode = "";

  /** 厂商域名，如 https://ali-market-tongue-detect-v2.macrocura.com */
  private String host = "";

  /** api1 创建舌面诊 path */
  private String createPath = "";

  /** api2 获取报告 path */
  private String reportPath = "";

  /** 默认场景：1=先返回问诊问题再出报告（更准），2=直接出报告 */
  private int defaultScene = 2;

  /** true=不发真实请求、返回 stub（本地无公网图时联调用） */
  private boolean mock = false;

  /** 拼接给脉景的公网图片绝对地址前缀，如 https://api.baohukeji.com（本地为空时退化为相对路径） */
  private String publicBaseUrl = "";

  /** DeepSeek API Key */
  private String deepseekApiKey = "";

  /** DeepSeek 接口地址 */
  private String deepseekBaseUrl = "https://api.deepseek.com";

  /** 新增白名单手机号默认赠送次数 */
  private int defaultTimes = 3;

  /** 图片保存目录后缀（挂在 app.upload.avatar-dir 下） */
  private String imageDirSuffix = "tcm-detection";

  public String getAppcode() { return appcode; }
  public void setAppcode(String appcode) { this.appcode = appcode; }

  public String getHost() { return host; }
  public void setHost(String host) { this.host = host; }

  public String getCreatePath() { return createPath; }
  public void setCreatePath(String createPath) { this.createPath = createPath; }

  public String getReportPath() { return reportPath; }
  public void setReportPath(String reportPath) { this.reportPath = reportPath; }

  public int getDefaultScene() { return defaultScene; }
  public void setDefaultScene(int defaultScene) { this.defaultScene = defaultScene; }

  public boolean isMock() { return mock; }
  public void setMock(boolean mock) { this.mock = mock; }

  public String getPublicBaseUrl() { return publicBaseUrl; }
  public void setPublicBaseUrl(String publicBaseUrl) { this.publicBaseUrl = publicBaseUrl; }

  public String getDeepseekApiKey() { return deepseekApiKey; }
  public void setDeepseekApiKey(String deepseekApiKey) { this.deepseekApiKey = deepseekApiKey; }

  public String getDeepseekBaseUrl() { return deepseekBaseUrl; }
  public void setDeepseekBaseUrl(String deepseekBaseUrl) { this.deepseekBaseUrl = deepseekBaseUrl; }

  public int getDefaultTimes() { return defaultTimes; }
  public void setDefaultTimes(int defaultTimes) { this.defaultTimes = defaultTimes; }

  public String getImageDirSuffix() { return imageDirSuffix; }
  public void setImageDirSuffix(String imageDirSuffix) { this.imageDirSuffix = imageDirSuffix; }

  public String createUrl() { return host.replaceAll("/$", "") + createPath; }

  public String reportUrl() { return host.replaceAll("/$", "") + reportPath; }

  /** 把相对图片路径拼成给脉景用的公网绝对地址；未配置 publicBaseUrl 时原样返回。 */
  public String toPublicImageUrl(String relativeOrAbsolute) {
    if (relativeOrAbsolute == null || relativeOrAbsolute.isBlank()) {
      return relativeOrAbsolute;
    }
    if (relativeOrAbsolute.startsWith("http://") || relativeOrAbsolute.startsWith("https://")) {
      return relativeOrAbsolute;
    }
    if (publicBaseUrl == null || publicBaseUrl.isBlank()) {
      return relativeOrAbsolute;
    }
    return publicBaseUrl.replaceAll("/$", "") + relativeOrAbsolute;
  }
}
