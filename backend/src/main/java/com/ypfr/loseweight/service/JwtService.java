package com.ypfr.loseweight.service;

import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.config.JwtProperties;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;
import javax.crypto.SecretKey;
import org.springframework.stereotype.Service;

@Service
public class JwtService {

  private final SecretKey key;
  private final long expireSeconds;

  public JwtService(JwtProperties properties) {
    byte[] bytes = properties.getSecret().getBytes(StandardCharsets.UTF_8);
    if (bytes.length < 32) {
      throw new IllegalStateException("app.jwt.secret 长度不足 32 字节，无法使用 HS256，请在 application-local.yml 配置");
    }
    this.key = Keys.hmacShaKeyFor(bytes);
    this.expireSeconds = properties.getExpireSeconds();
  }

  public String createToken(Long userId) {
    Instant now = Instant.now();
    return Jwts.builder()
        .subject(String.valueOf(userId))
        .issuedAt(Date.from(now))
        .expiration(Date.from(now.plusSeconds(expireSeconds)))
        .signWith(key)
        .compact();
  }

  /** 校验 JWT，解析 subject 为用户 ID */
  public Long parseUserId(String token) {
    if (token == null || token.isBlank()) {
      throw new ApiException(401, "请先登录");
    }
    try {
      String sub =
          Jwts.parser()
              .verifyWith(key)
              .build()
              .parseSignedClaims(token.trim())
              .getPayload()
              .getSubject();
      return Long.parseLong(sub);
    } catch (JwtException | IllegalArgumentException e) {
      throw new ApiException(401, "登录已失效，请重新登录");
    }
  }
}
