package com.ypfr.loseweight.service;

import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.config.UploadProperties;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Base64;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class AvatarStorageService {

  private final UploadProperties uploadProperties;

  public AvatarStorageService(UploadProperties uploadProperties) {
    this.uploadProperties = uploadProperties;
  }

  /** 将 Base64 写入 {avatarDir}/{userId}.jpg，返回可访问路径前缀已由调用方拼接 */
  public void saveUserAvatar(long userId, String raw) {
    if (!StringUtils.hasText(raw)) {
      return;
    }
    String b64 = raw.trim();
    int comma = b64.indexOf(',');
    if (b64.startsWith("data:") && comma >= 0) {
      b64 = b64.substring(comma + 1);
    }
    byte[] data;
    try {
      data = Base64.getDecoder().decode(b64);
    } catch (IllegalArgumentException e) {
      throw new ApiException(400, "头像数据无效");
    }
    if (data.length > 2_500_000) {
      throw new ApiException(400, "头像过大");
    }
    try {
      Path dir = Paths.get(uploadProperties.getAvatarDir()).toAbsolutePath().normalize();
      Files.createDirectories(dir);
      Path file = dir.resolve(userId + ".jpg").normalize();
      if (!file.startsWith(dir)) {
        throw new ApiException(500, "头像路径无效");
      }
      Files.write(file, data, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
    } catch (ApiException e) {
      throw e;
    } catch (Exception e) {
      throw new ApiException(500, "保存头像失败");
    }
  }
}
