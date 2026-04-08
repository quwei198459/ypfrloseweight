package com.ypfr.loseweight.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.config.WechatMiniappProperties;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

/**
 * 小程序全局 access_token（与登录 code 无关），用于手机号快速验证等接口，内存缓存至过期前 1 分钟。
 */
@Service
public class WechatAccessTokenService {

  private static final String WX_TOKEN_URL = "https://api.weixin.qq.com/cgi-bin/token";

  private final RestTemplate restTemplate;
  private final ObjectMapper objectMapper;
  private final WechatMiniappProperties wechatProps;

  private String cachedToken;
  private long expireAtMillis;

  public WechatAccessTokenService(
      RestTemplate restTemplate,
      ObjectMapper objectMapper,
      WechatMiniappProperties wechatProps) {
    this.restTemplate = restTemplate;
    this.objectMapper = objectMapper;
    this.wechatProps = wechatProps;
  }

  public synchronized String getAccessToken() {
    long now = System.currentTimeMillis();
    if (StringUtils.hasText(cachedToken) && now < expireAtMillis - 60_000) {
      return cachedToken;
    }
    if (!StringUtils.hasText(wechatProps.getAppSecret())
        || "change-me".equals(wechatProps.getAppSecret())) {
      throw new ApiException(500, "未配置 wechat.miniapp.app-secret");
    }
    URI uri =
        UriComponentsBuilder.fromUriString(WX_TOKEN_URL)
            .queryParam("grant_type", "client_credential")
            .queryParam("appid", wechatProps.getAppId())
            .queryParam("secret", wechatProps.getAppSecret())
            .encode(StandardCharsets.UTF_8)
            .build()
            .toUri();
    String body;
    try {
      body = restTemplate.getForObject(uri, String.class);
    } catch (Exception e) {
      throw new ApiException(502, "获取微信 access_token 失败");
    }
    try {
      JsonNode root = objectMapper.readTree(body != null ? body : "{}");
      if (root.has("errcode") && root.get("errcode").asInt() != 0) {
        throw new ApiException(
            502, "微信 token 错误: " + root.path("errmsg").asText("unknown"));
      }
      String token = root.path("access_token").asText(null);
      int expiresIn = root.path("expires_in").asInt(7200);
      if (!StringUtils.hasText(token)) {
        throw new ApiException(502, "微信未返回 access_token");
      }
      cachedToken = token;
      expireAtMillis = now + expiresIn * 1000L;
      return cachedToken;
    } catch (ApiException e) {
      throw e;
    } catch (Exception e) {
      throw new ApiException(502, "解析 access_token 失败");
    }
  }
}
