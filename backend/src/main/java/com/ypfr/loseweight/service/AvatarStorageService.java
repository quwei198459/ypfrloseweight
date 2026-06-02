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
import org.springframework.web.multipart.MultipartFile;

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
    writeBase64(uploadProperties.getAvatarDir(), userId + ".jpg", raw, 2_500_000, "头像");
  }

  public String saveBase64ToDir(String raw, String dirSuffix, String fileName, int maxBytes) {
    if (!StringUtils.hasText(raw)) {
      throw new ApiException(400, "图片数据无效");
    }
    Path dir = Paths.get(uploadProperties.getAvatarDir()).resolve(dirSuffix).toAbsolutePath().normalize();
    writeBase64(dir.toString(), fileName, raw, maxBytes, "图片");
    return "/api/v1/public/avatars/" + dirSuffix + "/" + fileName;
  }

  public String saveMultipartToDir(MultipartFile file, String dirSuffix, String fileName, int maxBytes) {
    if (file == null || file.isEmpty()) {
      throw new ApiException(400, "图片文件不能为空");
    }
    if (file.getSize() > maxBytes) {
      throw new ApiException(400, "图片过大");
    }
    String contentType = file.getContentType();
    if (contentType == null || !(contentType.equals("image/png") || contentType.equals("image/jpeg"))) {
      throw new ApiException(400, "仅支持 PNG 或 JPG 图片");
    }
    try {
      Path dir = Paths.get(uploadProperties.getAvatarDir()).resolve(dirSuffix).toAbsolutePath().normalize();
      Files.createDirectories(dir);
      Path target = dir.resolve(fileName).normalize();
      if (!target.startsWith(dir)) {
        throw new ApiException(500, "图片路径无效");
      }
      Files.write(target, file.getBytes(), StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
      return "/api/v1/public/avatars/" + dirSuffix + "/" + fileName;
    } catch (ApiException e) {
      throw e;
    } catch (Exception e) {
      throw new ApiException(500, "保存图片失败");
    }
  }

  private void writeBase64(String dirPath, String fileName, String raw, int maxBytes, String label) {
    String b64 = raw.trim();
    int comma = b64.indexOf(',');
    if (b64.startsWith("data:") && comma >= 0) {
      b64 = b64.substring(comma + 1);
    }
    byte[] data;
    try {
      data = Base64.getDecoder().decode(b64);
    } catch (IllegalArgumentException e) {
      throw new ApiException(400, label + "数据无效");
    }
    if (data.length > maxBytes) {
      throw new ApiException(400, label + "过大");
    }
    try {
      Path dir = Paths.get(dirPath).toAbsolutePath().normalize();
      Files.createDirectories(dir);
      Path file = dir.resolve(fileName).normalize();
      if (!file.startsWith(dir)) {
        throw new ApiException(500, label + "路径无效");
      }
      Files.write(file, data, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
    } catch (ApiException e) {
      throw e;
    } catch (Exception e) {
      throw new ApiException(500, "保存" + label + "失败");
    }
  }
}
