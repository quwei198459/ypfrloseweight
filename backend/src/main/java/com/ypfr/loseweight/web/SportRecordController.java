package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.SportRecord;
import com.ypfr.loseweight.service.SportRecordService;
import com.ypfr.loseweight.web.dto.CreateSportRecordRequest;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/users/{userId}/sport-records")
public class SportRecordController {

  private final SportRecordService sportRecordService;

  public SportRecordController(SportRecordService sportRecordService) {
    this.sportRecordService = sportRecordService;
  }

  @PostMapping
  public ApiResponse<SportRecord> create(
      @PathVariable Long userId, @RequestBody CreateSportRecordRequest body) {
    return ApiResponse.ok(sportRecordService.create(userId, body));
  }

  @DeleteMapping("/{id}")
  public ApiResponse<Void> delete(@PathVariable Long userId, @PathVariable Long id) {
    sportRecordService.delete(userId, id);
    return ApiResponse.ok(null);
  }
}
