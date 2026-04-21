package com.ypfr.loseweight.common;

import java.sql.SQLException;
import org.apache.ibatis.type.TypeException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

  private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

  @ExceptionHandler(ApiException.class)
  public ResponseEntity<ApiResponse<Void>> handleApi(ApiException e) {
    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ApiResponse.fail(e.getCode(), e.getMessage()));
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<ApiResponse<Void>> handleValid(MethodArgumentNotValidException e) {
    String msg =
        e.getBindingResult().getFieldErrors().stream()
            .findFirst()
            .map(err -> err.getField() + ": " + err.getDefaultMessage())
            .orElse("参数错误");
    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ApiResponse.fail(400, msg));
  }

  @ExceptionHandler(DataAccessException.class)
  public ResponseEntity<ApiResponse<Void>> handleDataAccess(DataAccessException e) {
    log.error("Database error", e);
    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        .body(ApiResponse.fail(500, friendlySqlMessage(e.getMostSpecificCause())));
  }

  /** 常见：vip_product.enabled 为 TINYINT(1) 时 JDBC 当 Boolean，与 Integer 映射冲突 */
  @ExceptionHandler(TypeException.class)
  public ResponseEntity<ApiResponse<Void>> handleMyBatisType(TypeException e) {
    log.error("MyBatis type mapping", e);
    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        .body(
            ApiResponse.fail(
                500,
                "数据库列与类型映射失败。若涉及会员表 vip_product，请在 MySQL 执行 "
                    + "database/migrations/V021__vip_product_enabled_int.sql 后重启后端。详情见服务端日志。"));
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<ApiResponse<Void>> handleOther(Exception e) {
    log.error("Unhandled error", e);
    Throwable root = e;
    while (root.getCause() != null && root.getCause() != root) {
      root = root.getCause();
    }
    if (root instanceof SQLException) {
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
          .body(ApiResponse.fail(500, friendlySqlMessage(root)));
    }
    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        .body(ApiResponse.fail(500, "服务器内部错误"));
  }

  private static String friendlySqlMessage(Throwable cause) {
    if (cause == null) {
      return "数据访问失败";
    }
    String m = cause.getMessage() != null ? cause.getMessage() : "";
    String ml = m.toLowerCase();
    if (m.contains("vip_product") && (ml.contains("doesn't exist") || m.contains("不存在"))) {
      return "缺少会员档位表或结构不匹配。请在 MySQL 对库 loseweight 依次执行 database/migrations/V020__vip_product.sql、"
          + "V021__vip_product_enabled_int.sql 后重启后端。原始错误: "
          + shortenForClient(m, 220);
    }
    if (m.contains("Unknown column") || ml.contains("doesn't exist")) {
      if (m.contains("'code'") && ml.contains("field list")) {
        return "food_category 等表缺少 code 列（食物分类接口需要）。请在 MySQL 对库 loseweight 执行 "
            + "database/migrations/V017__food_category_code_sidebar_seed.sql 后重启后端。原始错误: "
            + shortenForClient(m, 200);
      }
      if (m.contains("profile_completed")) {
        return "用户表缺少 profile_completed 等列。若仍使用 app_user，请执行 database/05_app_user_profile_completed.sql 后重启后端。原始错误: "
            + shortenForClient(m, 200);
      }
      if (m.contains("'phone'") && ml.contains("field list")) {
        return "用户表缺少 phone 列。若仍使用 app_user，请执行 database/04_app_user_phone.sql 后重启后端。原始错误: "
            + shortenForClient(m, 200);
      }
      return "数据库结构落后于后端代码，请对照 database/migrations 执行尚未应用的脚本后重启后端。原始错误: "
          + shortenForClient(m, 220);
    }
    return "数据保存失败，请查看后端日志或检查数据库结构是否最新";
  }

  private static String shortenForClient(String s, int max) {
    if (s == null || s.isEmpty()) {
      return "(无详情)";
    }
    String t = s.replace('\n', ' ').trim();
    return t.length() <= max ? t : t.substring(0, max) + "...";
  }
}
