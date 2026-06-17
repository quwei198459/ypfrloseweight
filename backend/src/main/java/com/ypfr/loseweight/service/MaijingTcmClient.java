package com.ypfr.loseweight.service;

import com.ypfr.loseweight.config.TcmDetectionProperties;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

/**
 * 中医体检第三方客户端（脉景 macrocura，云市场 cmapi00066970 专业版，APPCODE 鉴权）。两步式：
 * <ul>
 *   <li>{@link #createDiagnosis} POST createPath，body {scene, tf_image, ff_image, tb_image}(图片为公网URL) → session_id + inquiry_questions</li>
 *   <li>{@link #fetchReport} POST reportPath，body {session_id, answers} → 体质报告</li>
 * </ul>
 * mock=true 或 appcode/endpoint 未配置时返回与真实结构一致的 stub，便于本地无公网图联调。
 */
@Component
public class MaijingTcmClient {

  private static final Logger log = LoggerFactory.getLogger(MaijingTcmClient.class);

  private final RestTemplate restTemplate;
  private final TcmDetectionProperties properties;

  public MaijingTcmClient(RestTemplate restTemplate, TcmDetectionProperties properties) {
    this.restTemplate = restTemplate;
    this.properties = properties;
  }

  /** 创建舌面诊任务，返回厂商原始 JSON（含 session_id + inquiry_questions）。 */
  public String createDiagnosis(
      int scene, String tongueImageUrl, String faceImageUrl, String tongueBottomImageUrl) {
    if (useStub()) {
      log.warn("中医体检走 stub（mock={} 或未配置 appcode/endpoint），返回假数据。", properties.isMock());
      // scene=2 的 create 直接返回报告；scene=1 返回 session_id + 问诊问题
      return scene == 2 ? stubReport() : stubCreate(scene);
    }
    Map<String, Object> body = new LinkedHashMap<>();
    body.put("scene", scene);
    if (StringUtils.hasText(tongueImageUrl)) {
      body.put("tf_image", tongueImageUrl);
    }
    if (StringUtils.hasText(faceImageUrl)) {
      body.put("ff_image", faceImageUrl);
    }
    if (StringUtils.hasText(tongueBottomImageUrl)) {
      body.put("tb_image", tongueBottomImageUrl);
    }
    return post(properties.createUrl(), body, "创建舌面诊");
  }

  /** 凭 session_id（+问诊答案）获取体质报告，返回厂商原始 JSON。answers 可为空列表。 */
  public String fetchReport(String sessionId, List<Map<String, String>> answers) {
    if (useStub()) {
      return stubReport();
    }
    Map<String, Object> body = new LinkedHashMap<>();
    body.put("session_id", sessionId);
    body.put("answers", answers == null ? new ArrayList<>() : answers);
    return post(properties.reportUrl(), body, "获取体质报告");
  }

  private String post(String url, Map<String, Object> body, String label) {
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(new MediaType("application", "json", StandardCharsets.UTF_8));
    headers.set("Authorization", "APPCODE " + properties.getAppcode().trim());
    try {
      ResponseEntity<String> response =
          restTemplate.postForEntity(url, new HttpEntity<>(body, headers), String.class);
      String responseBody = response.getBody();
      if (!response.getStatusCode().is2xxSuccessful() || !StringUtils.hasText(responseBody)) {
        throw new IllegalStateException(label + "接口返回异常：HTTP " + response.getStatusCode().value());
      }
      return responseBody;
    } catch (org.springframework.web.client.HttpStatusCodeException e) {
      throw new IllegalStateException(
          label + "接口调用失败：HTTP " + e.getStatusCode().value() + "，" + e.getResponseBodyAsString(), e);
    } catch (RestClientException e) {
      throw new IllegalStateException(label + "接口调用失败：" + e.getMessage(), e);
    }
  }

  private boolean useStub() {
    if (properties.isMock()) {
      return true;
    }
    boolean appcodeMissing =
        !StringUtils.hasText(properties.getAppcode()) || "change-me".equals(properties.getAppcode());
    boolean endpointMissing =
        !StringUtils.hasText(properties.getHost())
            || properties.getHost().contains("xxx.market.alicloudapi.com")
            || !StringUtils.hasText(properties.getCreatePath())
            || !StringUtils.hasText(properties.getReportPath());
    return appcodeMissing || endpointMissing;
  }

  private String stubCreate(int scene) {
    String questions =
        scene == 1
            ? "[{\"name\":\"喜好热饮\",\"value\":\"q-1\"},{\"name\":\"四肢冰冷\",\"value\":\"q-2\"},"
                + "{\"name\":\"面色晦暗\",\"value\":\"q-3\"},{\"name\":\"记忆力差\",\"value\":\"q-4\"},"
                + "{\"name\":\"易感冒\",\"value\":\"q-5\"},{\"name\":\"身痛\",\"value\":\"q-6\"}]"
            : "[]";
    return "{\"code\":20000,\"success\":true,\"msg\":\"成功\",\"data\":{"
        + "\"session_id\":\"tcm-stub-session\",\"inquiry_questions\":" + questions + "},\"reason\":null}";
  }

  /** stub 报告：结构与 api2 真实成功响应一致，便于本地跑通解析与 UI。 */
  private String stubReport() {
    return """
        {
          "code": 20000,
          "success": true,
          "msg": "成功",
          "data": {
            "score": 86.0,
            "physique_name": "气虚体质、痰湿体质",
            "physique_analysis": "您的体质主要为气虚兼痰湿，多与脾胃运化偏弱、水湿代谢不畅有关，常表现为易疲乏、身重困倦。建议从健脾益气、化湿和中入手进行日常调理。",
            "typical_symptom": "易疲乏；气短懒言；食后腹胀；身重困倦；舌体偏胖有齿痕；大便偏溏。",
            "risk_warning": "气虚与痰湿并见，长期可能影响消化吸收与体重管理，出现易感冒、嗜睡、血脂偏高等倾向，建议规律作息、清淡饮食、适度运动。",
            "syndrome_name": "脾虚湿困证",
            "syndrome_introduction": "因饮食、劳倦或思虑过度伤脾，脾运化水湿功能失常所致，临床以脘腹痞胀、食少纳呆、身重困倦、大便稀溏、舌淡胖有齿痕为特征。",
            "features": [
              {"feature_category":"面部","feature_group":"面色","feature_name":"面色少华","feature_situation":"异常","feature_interpret":"面色偏黄少光泽，多与气血生化不足、脾胃偏弱相关。"},
              {"feature_category":"面部","feature_group":"眼神","feature_name":"略乏神","feature_situation":"异常","feature_interpret":"目光稍显倦怠，多与气虚、休息不足相关。"},
              {"feature_category":"面部","feature_group":"唇色","feature_name":"唇色淡","feature_situation":"异常","feature_interpret":"唇色偏淡，多见于气血不足者。"},
              {"feature_category":"舌部","feature_group":"舌色","feature_name":"舌色淡","feature_situation":"异常","feature_interpret":"舌色偏淡，多见于气血不足或阳虚。"},
              {"feature_category":"舌部","feature_group":"舌形胖瘦","feature_name":"舌体偏胖","feature_situation":"异常","feature_interpret":"舌体偏大，多因水湿代谢不良、痰湿偏重。"},
              {"feature_category":"舌部","feature_group":"舌齿痕","feature_name":"舌部齿痕","feature_situation":"异常","feature_interpret":"舌边齿痕，多见于脾虚、湿气偏重。"},
              {"feature_category":"舌部","feature_group":"苔质","feature_name":"舌苔白腻","feature_situation":"异常","feature_interpret":"苔白而腻，多提示痰湿内蕴。"},
              {"feature_category":"舌部","feature_group":"舌裂纹","feature_name":"正常","feature_situation":"正常","feature_interpret":"无明显裂纹。"}
            ],
            "advices": {
              "food": [
                {"title":"建议饮食","advice":"以健脾益气、化湿之品为宜，如山药、莲子、薏苡仁、茯苓、红枣、鸡肉。"},
                {"title":"禁忌饮食","advice":"少食生冷油腻、甜腻及过咸之品，避免加重痰湿。"}
              ],
              "sleep": [
                {"title":"生活建议","advice":"起居有常，避免久坐久卧；保持环境干爽，避免潮湿。"},
                {"title":"情志建议","advice":"保持心情舒畅，适度疏导压力。"}
              ],
              "sport": [
                {"title":"运动建议","advice":"选择八段锦、快走、慢跑等温和有氧运动，循序渐进、微微汗出为宜。"}
              ],
              "treatment": [
                {"title":"穴位按摩","advice":"按揉足三里、中脘、脾俞、丰隆，每穴 2-3 分钟，每日 1-2 次。"}
              ],
              "music": [
                {"title":"音乐建议","advice":"宫音入脾，舒缓平和之曲有助健脾安神。"}
              ]
            },
            "goods": [
              {"name":"茯苓山药代用茶","introduction":"","img1":"","img2":"","img3":"","customized_mapping":[]}
            ],
            "tf_detect_matches": {"detect_boxes": [], "url": ""}
          },
          "reason": null,
          "log_id": "tcm-stub-report"
        }
        """;
  }
}
