package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.SkinDetectionAiPromptTemplate;
import com.ypfr.loseweight.domain.SkinDetectionItemConfig;
import com.ypfr.loseweight.service.SkinDetectionAiPromptTemplateService;
import com.ypfr.loseweight.service.SkinDetectionItemConfigService;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionAiPromptTemplateRequest;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionItemConfigRequest;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin/skin-detection-config")
public class AdminSkinDetectionConfigController {

  private final AdminAuthResolver adminAuthResolver;
  private final SkinDetectionItemConfigService itemConfigService;
  private final SkinDetectionAiPromptTemplateService promptTemplateService;

  public AdminSkinDetectionConfigController(
      AdminAuthResolver adminAuthResolver,
      SkinDetectionItemConfigService itemConfigService,
      SkinDetectionAiPromptTemplateService promptTemplateService) {
    this.adminAuthResolver = adminAuthResolver;
    this.itemConfigService = itemConfigService;
    this.promptTemplateService = promptTemplateService;
  }

  @GetMapping("/items")
  public ApiResponse<List<SkinDetectionItemConfig>> listItems(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(itemConfigService.listAll());
  }

  @PutMapping("/items/{id}")
  public ApiResponse<SkinDetectionItemConfig> updateItem(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @RequestBody @Valid SkinDetectionItemConfigRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(itemConfigService.update(id, req));
  }

  @GetMapping("/ai-prompts")
  public ApiResponse<List<SkinDetectionAiPromptTemplate>> listPrompts(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(promptTemplateService.listAll());
  }

  @PutMapping("/ai-prompts/{id}")
  public ApiResponse<SkinDetectionAiPromptTemplate> updatePrompt(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @RequestBody @Valid SkinDetectionAiPromptTemplateRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(promptTemplateService.update(id, req));
  }
}
