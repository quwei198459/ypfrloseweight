package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.PhotoRecognitionMemberPhone;
import com.ypfr.loseweight.service.PhotoRecognitionAccessService;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionMemberPhoneUpsertRequest;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionQuotaAdjustRequest;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionQuotaLogItemVo;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionQuotaSummaryVo;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin/photo-recognition-members")
public class AdminPhotoRecognitionMemberController {

  private final AdminAuthResolver adminAuthResolver;
  private final PhotoRecognitionAccessService accessService;

  public AdminPhotoRecognitionMemberController(
      AdminAuthResolver adminAuthResolver, PhotoRecognitionAccessService accessService) {
    this.adminAuthResolver = adminAuthResolver;
    this.accessService = accessService;
  }

  @GetMapping
  public ApiResponse<List<PhotoRecognitionMemberPhone>> list(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestParam(required = false) String keyword,
      @RequestParam(required = false) Integer status) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(accessService.listMemberPhones(keyword, status));
  }

  @PostMapping
  public ApiResponse<PhotoRecognitionMemberPhone> create(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @Valid @RequestBody PhotoRecognitionMemberPhoneUpsertRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(accessService.createMemberPhone(req));
  }

  @PutMapping("/{id}")
  public ApiResponse<PhotoRecognitionMemberPhone> update(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @Valid @RequestBody PhotoRecognitionMemberPhoneUpsertRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(accessService.updateMemberPhone(id, req));
  }

  @DeleteMapping("/{id}")
  public ApiResponse<Boolean> delete(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    accessService.deleteMemberPhone(id);
    return ApiResponse.ok(Boolean.TRUE);
  }

  @PostMapping("/{id}/quota-adjustments")
  public ApiResponse<PhotoRecognitionMemberPhone> adjustQuota(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @Valid @RequestBody PhotoRecognitionQuotaAdjustRequest req) {
    Long adminId = adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(accessService.adjustQuota(id, req, adminId));
  }

  @GetMapping("/{id}/quota-summary")
  public ApiResponse<PhotoRecognitionQuotaSummaryVo> quotaSummary(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(accessService.getQuotaSummary(id));
  }

  @GetMapping("/{id}/quota-logs/manual")
  public ApiResponse<List<PhotoRecognitionQuotaLogItemVo>> manualLogs(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(accessService.listManualQuotaLogs(id));
  }

  @GetMapping("/{id}/quota-logs/consume")
  public ApiResponse<List<PhotoRecognitionQuotaLogItemVo>> consumeLogs(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(accessService.listConsumeQuotaLogs(id));
  }
}
