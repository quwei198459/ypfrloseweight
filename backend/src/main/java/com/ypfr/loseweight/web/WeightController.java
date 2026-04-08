package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.WeightRecord;
import com.ypfr.loseweight.service.WeightService;
import com.ypfr.loseweight.web.dto.WeightUpsertRequest;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/users")
public class WeightController {

  private final WeightService weightService;

  public WeightController(WeightService weightService) {
    this.weightService = weightService;
  }

  @GetMapping("/{userId}/weight-records")
  public ApiResponse<List<WeightRecord>> listWeights(
      @PathVariable Long userId, @RequestParam(defaultValue = "30") int limit) {
    return ApiResponse.ok(weightService.listRecent(userId, Math.min(limit, 200)));
  }

  @PostMapping("/{userId}/weight-records")
  public ApiResponse<WeightRecord> saveWeight(
      @PathVariable Long userId, @RequestBody WeightUpsertRequest body) {
    return ApiResponse.ok(
        weightService.upsert(userId, body.getRecordDate(), body.getWeightKg()));
  }
}
