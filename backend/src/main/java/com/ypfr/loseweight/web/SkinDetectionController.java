package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.PhotoRecognitionAccessService;
import com.ypfr.loseweight.service.SkinDetectionQuotaService;
import com.ypfr.loseweight.service.SkinDetectionService;
import com.ypfr.loseweight.web.dto.PhotoRecognitionServiceConfigVo;
import com.ypfr.loseweight.web.dto.skin.SkinDetectionCreateRequest;
import com.ypfr.loseweight.web.dto.skin.SkinDetectionCreateResponseVo;
import com.ypfr.loseweight.web.dto.skin.SkinDetectionQuotaVo;
import com.ypfr.loseweight.web.dto.skin.SkinDetectionReportVo;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/skin-detection")
public class SkinDetectionController {

  private final AuthUserResolver authUserResolver;
  private final SkinDetectionQuotaService quotaService;
  private final SkinDetectionService skinDetectionService;
  private final PhotoRecognitionAccessService photoRecognitionAccessService;

  public SkinDetectionController(
      AuthUserResolver authUserResolver,
      SkinDetectionQuotaService quotaService,
      SkinDetectionService skinDetectionService,
      PhotoRecognitionAccessService photoRecognitionAccessService) {
    this.authUserResolver = authUserResolver;
    this.quotaService = quotaService;
    this.skinDetectionService = skinDetectionService;
    this.photoRecognitionAccessService = photoRecognitionAccessService;
  }

  @GetMapping("/quota")
  public ApiResponse<SkinDetectionQuotaVo> quota(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    Long userId = authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(quotaService.getQuota(userId));
  }

  @PostMapping("/records")
  public ApiResponse<SkinDetectionCreateResponseVo> createRecord(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody SkinDetectionCreateRequest request) {
    Long userId = authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(skinDetectionService.createRecord(userId, request));
  }

  @GetMapping("/records/{recordId}")
  public ApiResponse<SkinDetectionReportVo> getRecord(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long recordId) {
    Long userId = authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(skinDetectionService.getReport(userId, recordId));
  }

  @GetMapping("/customer-service/current")
  public ApiResponse<PhotoRecognitionServiceConfigVo> currentCustomerService(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(photoRecognitionAccessService.getServiceConfig());
  }
}
