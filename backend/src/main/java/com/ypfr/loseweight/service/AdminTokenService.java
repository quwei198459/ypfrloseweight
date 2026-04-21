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
public class AdminTokenService {

  private final SecretKey key;
  private final long expireSeconds;

  public AdminTokenService(JwtProperties properties) {
    byte[] bytes = properties.getSecret().getBytes(StandardCharsets.UTF_8);
    if (bytes.length < 32) {
      throw new IllegalStateException("app.jwt.secret 长度不足 32 字节，无法使用 HS256");
    }
    this.key = Keys.hmacShaKeyFor(bytes);
    this.expireSeconds = properties.getExpireSeconds();
  }

  public String createToken(Long adminId, String username) {
    Instant now = Instant.now();
    return Jwts.builder()
        .subject(String.valueOf(adminId))
        .claim("role", "admin")
        .claim("username", username)
        .issuedAt(Date.from(now))
        .expiration(Date.from(now.plusSeconds(expireSeconds)))
        .signWith(key)
        .compact();
  }

  public Long parseAdminId(String token) {
    if (token == null || token.isBlank()) {
      throw new ApiException(401, "请先登录管理后台");
    }
    try {
      var claims = Jwts.parser().verifyWith(key).build().parseSignedClaims(token.trim()).getPayload();
      Object role = claims.get("role");
      if (!"admin".equals(role)) {
        throw new ApiException(401, "无效的后台令牌");
      }
      return Long.parseLong(claims.getSubject());
    } catch (JwtException | IllegalArgumentException e) {
      throw new ApiException(401, "后台登录已失效，请重新登录");
    }
  }

  public long getExpireSeconds() {
    return expireSeconds;
  }
}
