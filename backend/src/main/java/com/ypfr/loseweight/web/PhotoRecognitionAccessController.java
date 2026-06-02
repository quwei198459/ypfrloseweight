package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.PhotoRecognitionAccessService;
import com.ypfr.loseweight.web.dto.PhotoRecognitionAccessVo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/recognize")
public class PhotoRecognitionAccessController {

  private final AuthUserResolver authUserResolver;
  private final PhotoRecognitionAccessService accessService;

  public PhotoRecognitionAccessController(
      AuthUserResolver authUserResolver, PhotoRecognitionAccessService accessService) {
    this.authUserResolver = authUserResolver;
    this.accessService = accessService;
  }

  @GetMapping("/meal-photo/access")
  public ApiResponse<PhotoRecognitionAccessVo> checkAccess(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    Long userId = authUserResolver.requireUserId(authorization);
    return ApiResponse.ok(accessService.checkAccess(userId));
  }
}
