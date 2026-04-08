package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.DailyRecordService;
import com.ypfr.loseweight.web.dto.DailyRecordDto;
import java.time.LocalDate;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/users")
public class DailyRecordController {

  private final DailyRecordService dailyRecordService;
  private final AuthUserResolver authUserResolver;

  public DailyRecordController(
      DailyRecordService dailyRecordService, AuthUserResolver authUserResolver) {
    this.dailyRecordService = dailyRecordService;
    this.authUserResolver = authUserResolver;
  }

  @GetMapping("/{userId}/daily-records")
  public ApiResponse<DailyRecordDto> daily(
      @org.springframework.web.bind.annotation.RequestHeader(
              value = "Authorization", required = false)
          String authorization,
      @PathVariable Long userId,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
          LocalDate date) {
    authUserResolver.requirePathUser(authorization, userId);
    LocalDate day = date != null ? date : LocalDate.now();
    return ApiResponse.ok(dailyRecordService.getDay(userId, day));
  }
}
