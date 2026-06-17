package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.PhotoRecognitionAccessService;
import com.ypfr.loseweight.service.TcmDetectionQuotaService;
import com.ypfr.loseweight.service.TcmDetectionService;
import com.ypfr.loseweight.web.dto.PhotoRecognitionServiceConfigVo;
import com.ypfr.loseweight.web.dto.tcm.TcmDetectionCreateRequest;
import com.ypfr.loseweight.web.dto.tcm.TcmDetectionCreateResponseVo;
import com.ypfr.loseweight.web.dto.tcm.TcmDetectionQuotaVo;
import com.ypfr.loseweight.web.dto.tcm.TcmDetectionReportVo;
import com.ypfr.loseweight.web.dto.tcm.TcmInquirySubmitRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/tcm-detection")
public class TcmDetectionController {

  private final AuthUserResolver authUserResolver;
  private final TcmDetectionQuotaService quotaService;
  private final TcmDetectionService tcmDetectionService;
  private final PhotoRecognitionAccessService photoRecognitionAccessService;

  public TcmDetectionController(
      AuthUserResolver authUserResolver,
      TcmDetectionQuotaService quotaService,
      TcmDetectionService tcmDetectionService,
      PhotoRecognitionAccessService photoRecognitionAccessService) {
    this.authUserResolver = authUserResolver;
    this.quotaService = quotaService;
    this.tcmDetectionService = tcmDetectionService;
    this.photoRecognitionAccessService = photoRecognitionAccessService;
  }

  @GetMapping("/quota")
  public ApiResponse<TcmDetectionQuotaVo> quota(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    Long userId = authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(quotaService.getQuota(userId));
  }

  @PostMapping("/records")
  public ApiResponse<TcmDetectionCreateResponseVo> createRecord(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody TcmDetectionCreateRequest request) {
    Long userId = authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(tcmDetectionService.createRecord(userId, request));
  }

  @GetMapping("/records/{recordId}")
  public ApiResponse<TcmDetectionReportVo> getRecord(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long recordId) {
    Long userId = authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(tcmDetectionService.getReport(userId, recordId));
  }

  @PostMapping("/records/{recordId}/inquiry")
  public ApiResponse<TcmDetectionCreateResponseVo> submitInquiry(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long recordId,
      @RequestBody TcmInquirySubmitRequest request) {
    Long userId = authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(tcmDetectionService.submitInquiry(userId, recordId, request));
  }

  @GetMapping("/customer-service/current")
  public ApiResponse<PhotoRecognitionServiceConfigVo> currentCustomerService(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(photoRecognitionAccessService.getServiceConfig());
  }
}
