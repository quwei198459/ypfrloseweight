package com.ypfr.loseweight.service;

import com.ypfr.loseweight.config.AliyunFoodProperties;
import java.nio.charset.StandardCharsets;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

@Component
public class AliyunFoodCalorieClient {

  private final RestTemplate restTemplate;
  private final AliyunFoodProperties properties;

  public AliyunFoodCalorieClient(RestTemplate restTemplate, AliyunFoodProperties properties) {
    this.restTemplate = restTemplate;
    this.properties = properties;
  }

  public ResponseEntity<String> query(String imageBase64, String imageUrl) {
    if (!StringUtils.hasText(properties.getAppcode()) || "change-me".equals(properties.getAppcode())) {
      throw new IllegalStateException("未配置 aliyun.food.appcode，请在 application-local.yml 中填写");
    }

    UriComponentsBuilder uri = UriComponentsBuilder.fromUriString(properties.fullUrl());
    if (StringUtils.hasText(imageUrl)) {
      uri.queryParam("imageUrl", imageUrl);
    }

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(new MediaType("application", "x-www-form-urlencoded", StandardCharsets.UTF_8));
    headers.set("Authorization", "APPCODE " + properties.getAppcode().trim());

    MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
    if (StringUtils.hasText(imageBase64)) {
      body.add("imageBase64", imageBase64);
    }

    HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(body, headers);
    return restTemplate.postForEntity(uri.toUriString(), entity, String.class);
  }
}
