package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.PhotoRecognitionAccessService;
import com.ypfr.loseweight.web.dto.PhotoRecognitionServiceConfigVo;
import com.ypfr.loseweight.web.dto.admin.PhotoRecognitionServiceConfigRequest;
import jakarta.validation.Valid;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin/photo-recognition-service-config")
public class AdminPhotoRecognitionServiceConfigController {

  private final AdminAuthResolver adminAuthResolver;
  private final PhotoRecognitionAccessService accessService;

  public AdminPhotoRecognitionServiceConfigController(
      AdminAuthResolver adminAuthResolver, PhotoRecognitionAccessService accessService) {
    this.adminAuthResolver = adminAuthResolver;
    this.accessService = accessService;
  }

  @GetMapping
  public ApiResponse<PhotoRecognitionServiceConfigVo> get(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(accessService.getServiceConfig());
  }

  @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  public ApiResponse<PhotoRecognitionServiceConfigVo> update(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @ModelAttribute @Valid PhotoRecognitionServiceConfigRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(accessService.updateServiceConfig(req));
  }
}
