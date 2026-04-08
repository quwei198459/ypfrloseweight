package com.ypfr.loseweight.util;

import com.ypfr.loseweight.common.ApiException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import org.springframework.util.StringUtils;

public final class RecordedAtParser {

  private static final DateTimeFormatter LEGACY =
      DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

  private RecordedAtParser() {}

  public static LocalDateTime parse(String recordedAt) {
    if (!StringUtils.hasText(recordedAt)) {
      throw new ApiException(400, "recordedAt 必填");
    }
    String t = recordedAt.trim();
    try {
      return LocalDateTime.parse(t);
    } catch (Exception ignored) {
      /* */
    }
    try {
      return LocalDateTime.parse(t, LEGACY);
    } catch (Exception e) {
      throw new ApiException(400, "recordedAt 格式无效，需 ISO 本地时间或 yyyy-MM-dd HH:mm:ss");
    }
  }
}
