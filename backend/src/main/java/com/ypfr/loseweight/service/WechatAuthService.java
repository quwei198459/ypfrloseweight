package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.config.WechatMiniappProperties;
import com.ypfr.loseweight.domain.LoseWeightUser;
import com.ypfr.loseweight.domain.WechatLoginLog;
import com.ypfr.loseweight.mapper.LoseWeightUserMapper;
import com.ypfr.loseweight.mapper.WechatLoginLogMapper;
import com.ypfr.loseweight.web.dto.AppUserDto;
import com.ypfr.loseweight.web.dto.WxLoginRequest;
import com.ypfr.loseweight.web.dto.WxLoginResponse;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

@Service
public class WechatAuthService {

  private static final String WX_CODE2SESSION = "https://api.weixin.qq.com/sns/jscode2session";
  private static final String WX_GET_PHONE = "https://api.weixin.qq.com/wxa/business/getuserphonenumber";

  private final RestTemplate restTemplate;
  private final ObjectMapper objectMapper;
  private final WechatMiniappProperties wechatProps;
  private final LoseWeightUserMapper loseWeightUserMapper;
  private final WechatLoginLogMapper wechatLoginLogMapper;
  private final JwtService jwtService;
  private final WechatAccessTokenService wechatAccessTokenService;
  private final UserService userService;

  public WechatAuthService(
      RestTemplate restTemplate,
      ObjectMapper objectMapper,
      WechatMiniappProperties wechatProps,
      LoseWeightUserMapper loseWeightUserMapper,
      WechatLoginLogMapper wechatLoginLogMapper,
      JwtService jwtService,
      WechatAccessTokenService wechatAccessTokenService,
      UserService userService) {
    this.restTemplate = restTemplate;
    this.objectMapper = objectMapper;
    this.wechatProps = wechatProps;
    this.loseWeightUserMapper = loseWeightUserMapper;
    this.wechatLoginLogMapper = wechatLoginLogMapper;
    this.jwtService = jwtService;
    this.wechatAccessTokenService = wechatAccessTokenService;
    this.userService = userService;
  }

  /**
   * 仅使用 wx.login 的 code：换 openid、查建用户、发 JWT。头像/昵称/手机号在个人信息页维护。
   */
  public WxLoginResponse loginWithWx(WxLoginRequest req, String clientIp, String clientUa) {
    String code = req.getCode();
    if (!StringUtils.hasText(wechatProps.getAppSecret())
        || "change-me".equals(wechatProps.getAppSecret())) {
      throw new ApiException(500, "未配置 wechat.miniapp.app-secret，请在 application-local.yml 填写");
    }

    String responseBody;
    try {
      URI uri =
          UriComponentsBuilder.fromUriString(WX_CODE2SESSION)
              .queryParam("appid", wechatProps.getAppId())
              .queryParam("secret", wechatProps.getAppSecret())
              .queryParam("js_code", code)
              .queryParam("grant_type", "authorization_code")
              .encode(StandardCharsets.UTF_8)
              .build()
              .toUri();
      responseBody = restTemplate.getForObject(uri, String.class);
    } catch (Exception e) {
      insertLoginLog(null, null, null, 0, trimErr(e.getMessage()), clientIp, clientUa);
      throw new ApiException(502, "请求微信接口失败");
    }

    JsonNode root;
    try {
      root = objectMapper.readTree(responseBody != null ? responseBody : "{}");
    } catch (Exception e) {
      insertLoginLog(null, null, null, 0, "解析微信响应失败", clientIp, clientUa);
      throw new ApiException(502, "微信响应无效");
    }

    if (!root.path("errcode").isMissingNode() && root.get("errcode").asInt() != 0) {
      String msg = root.path("errmsg").asText("登录失败");
      insertLoginLog(null, null, null, 0, msg, clientIp, clientUa);
      throw new ApiException(401, msg);
    }

    String openid = root.path("openid").asText(null);
    if (!StringUtils.hasText(openid)) {
      insertLoginLog(null, null, null, 0, "微信未返回 openid", clientIp, clientUa);
      throw new ApiException(401, "微信登录无效");
    }

    String unionId = root.path("unionid").asText(null);
    if ("".equals(unionId)) {
      unionId = null;
    }

    LoseWeightUser user =
        loseWeightUserMapper.selectOne(
            new LambdaQueryWrapper<LoseWeightUser>().eq(LoseWeightUser::getOpenid, openid));
    if (user == null) {
      user = new LoseWeightUser();
      user.setOpenid(openid);
      user.setUnionid(unionId);
      user.setNicknameSource("system_default");
      user.setNicknameAuthorized(0);
      user.setAvatarSource("system_default");
      user.setAvatarAuthorized(0);
      user.setPhoneBindStatus(0);
      user.setStatus(1);
      user.setRegisterSource("wx_miniprogram");
      loseWeightUserMapper.insert(user);
      userService.ensureProfile(user.getId());
      userService.ensureBudget(user.getId());
    } else {
      boolean needUpdate = false;
      if (StringUtils.hasText(unionId) && !StringUtils.hasText(user.getUnionid())) {
        user.setUnionid(unionId);
        needUpdate = true;
      }
      if (needUpdate) {
        loseWeightUserMapper.updateById(user);
      }
    }

    insertLoginLog(user.getId(), openid, unionId, 1, null, clientIp, clientUa);

    String token = jwtService.createToken(user.getId());
    AppUserDto dto = userService.getUser(user.getId());
    WxLoginResponse out = new WxLoginResponse();
    out.setUserId(user.getId());
    out.setToken(token);
    out.setOpenid(openid);
    out.setUserInfo(dto);
    out.setProfileCompleted(
        dto.getProfileCompleted() != null && Boolean.TRUE.equals(dto.getProfileCompleted()));
    return out;
  }

  /** 使用 getPhoneNumber 返回的 code 换手机号（需全局 access_token） */
  public void bindPhoneForUser(Long userId, String phoneCode) {
    String accessToken = wechatAccessTokenService.getAccessToken();
    String url = WX_GET_PHONE + "?access_token=" + accessToken;
    ObjectNode payload = objectMapper.createObjectNode();
    payload.put("code", phoneCode);
    String json;
    try {
      json = objectMapper.writeValueAsString(payload);
    } catch (Exception e) {
      throw new ApiException(500, "构建请求失败");
    }
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    HttpEntity<String> entity = new HttpEntity<>(json, headers);
    String resp;
    try {
      resp = restTemplate.postForObject(url, entity, String.class);
    } catch (Exception e) {
      throw new ApiException(502, "请求微信手机号接口失败");
    }
    JsonNode root;
    try {
      root = objectMapper.readTree(resp != null ? resp : "{}");
    } catch (Exception e) {
      throw new ApiException(502, "解析手机号响应失败");
    }
    if (root.path("errcode").asInt(0) != 0) {
      throw new ApiException(400, root.path("errmsg").asText("获取手机号失败"));
    }
    String phone = root.path("phone_info").path("purePhoneNumber").asText(null);
    if (!StringUtils.hasText(phone)) {
      phone = root.path("phone_info").path("phoneNumber").asText(null);
    }
    if (!StringUtils.hasText(phone)) {
      throw new ApiException(502, "微信未返回手机号");
    }
    LoseWeightUser user = loseWeightUserMapper.selectById(userId);
    if (user == null) {
      throw new ApiException(404, "用户不存在");
    }
    if (phone.length() > 20) {
      phone = phone.substring(0, 20);
    }
    user.setPhone(phone);
    user.setPhoneBindStatus(1);
    user.setPhoneSource("wx_phone");
    user.setPhoneBindTime(LocalDateTime.now());
    loseWeightUserMapper.updateById(user);
  }

  private static String trimErr(String msg) {
    if (msg == null) {
      return "error";
    }
    return msg.length() > 250 ? msg.substring(0, 250) : msg;
  }

  private void insertLoginLog(
      Long userId,
      String openid,
      String unionId,
      int success,
      String errorMessage,
      String clientIp,
      String clientUa) {
    WechatLoginLog row = new WechatLoginLog();
    row.setUserId(userId);
    row.setOpenid(openid);
    row.setUnionId(unionId);
    row.setSuccess(success);
    row.setErrorMessage(errorMessage);
    row.setLoginAt(LocalDateTime.now());
    row.setClientIp(clientIp);
    row.setClientUa(clientUa != null && clientUa.length() > 500 ? clientUa.substring(0, 500) : clientUa);
    wechatLoginLogMapper.insert(row);
  }
}
