package com.ypfr.loseweight.service;

import com.ypfr.loseweight.config.SkinDetectionProperties;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Component
public class YimeiSkinDetectionClient {

  private final RestTemplate restTemplate;
  private final SkinDetectionProperties properties;

  public YimeiSkinDetectionClient(RestTemplate restTemplate, SkinDetectionProperties properties) {
    this.restTemplate = restTemplate;
    this.properties = properties;
  }

  public String analyze(String imageBase64, long detectTypes) {
    if (detectTypes <= 0) {
      throw new IllegalStateException("皮肤检测 detect_types 配置不正确");
    }
    if (!StringUtils.hasText(properties.getYimeiClientId())
        || "change-me".equals(properties.getYimeiClientId())
        || !StringUtils.hasText(properties.getYimeiClientSecret())
        || "change-me".equals(properties.getYimeiClientSecret())) {
      throw new IllegalStateException("未配置宜远智能测肤应用 ID 或密钥");
    }
    String url = properties.getYimeiBaseUrl().replaceAll("/$", "")
        + "/v2/api/face/analysis/" + detectTypes;
    HttpHeaders headers = new HttpHeaders();
    headers.setAccept(java.util.List.of(MediaType.APPLICATION_JSON));
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);
    headers.setBasicAuth(properties.getYimeiClientId().trim(), properties.getYimeiClientSecret().trim(), StandardCharsets.UTF_8);

    HttpHeaders imageHeaders = new HttpHeaders();
    imageHeaders.setContentType(MediaType.IMAGE_JPEG);
    HttpEntity<InputStreamResource> imagePart = new HttpEntity<>(toImageResource(imageBase64), imageHeaders);
    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("image", imagePart);

    HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<>(body, headers);
    try {
      ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);
      String responseBody = response.getBody();
      if (!response.getStatusCode().is2xxSuccessful() || !StringUtils.hasText(responseBody)) {
        throw new IllegalStateException("宜远测肤接口返回异常：HTTP " + response.getStatusCode().value());
      }
      return responseBody;
    } catch (org.springframework.web.client.HttpStatusCodeException e) {
      throw new IllegalStateException("宜远测肤接口调用失败：HTTP "
          + e.getStatusCode().value() + "，" + summarizeBody(e.getStatusCode(), e.getResponseBodyAsString()), e);
    } catch (RestClientException e) {
      throw new IllegalStateException("宜远测肤接口调用失败：" + e.getMessage(), e);
    }
  }

  private static InputStreamResource toImageResource(String imageBase64) {
    byte[] bytes;
    try {
      bytes = Base64.getDecoder().decode(stripDataUrl(imageBase64));
    } catch (IllegalArgumentException e) {
      throw new IllegalStateException("图片 Base64 格式不正确", e);
    }
    return new InputStreamResource(new ByteArrayInputStream(bytes)) {
      @Override
      public String getFilename() {
        return "face.jpg";
      }

      @Override
      public long contentLength() throws IOException {
        return bytes.length;
      }
    };
  }

  private static String summarizeBody(HttpStatusCode status, String body) {
    if (!StringUtils.hasText(body)) {
      return "响应体为空";
    }
    String compact = body.replaceAll("\\s+", " ").trim();
    int maxLength = status.is4xxClientError() ? 300 : 160;
    return compact.length() <= maxLength ? compact : compact.substring(0, maxLength);
  }

  private static String stripDataUrl(String raw) {
    String value = raw == null ? "" : raw.trim();
    int comma = value.indexOf(',');
    if (value.startsWith("data:") && comma >= 0) {
      return value.substring(comma + 1);
    }
    return value;
  }
}
