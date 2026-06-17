package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.TcmDetectionAiPromptTemplate;
import com.ypfr.loseweight.domain.TcmDetectionItemConfig;
import com.ypfr.loseweight.service.TcmDetectionAiPromptTemplateService;
import com.ypfr.loseweight.service.TcmDetectionItemConfigService;
import com.ypfr.loseweight.web.dto.admin.TcmDetectionAiPromptTemplateRequest;
import com.ypfr.loseweight.web.dto.admin.TcmDetectionItemConfigRequest;
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
@RequestMapping("/api/v1/admin/tcm-detection-config")
public class AdminTcmDetectionConfigController {

  private final AdminAuthResolver adminAuthResolver;
  private final TcmDetectionItemConfigService itemConfigService;
  private final TcmDetectionAiPromptTemplateService promptTemplateService;

  public AdminTcmDetectionConfigController(
      AdminAuthResolver adminAuthResolver,
      TcmDetectionItemConfigService itemConfigService,
      TcmDetectionAiPromptTemplateService promptTemplateService) {
    this.adminAuthResolver = adminAuthResolver;
    this.itemConfigService = itemConfigService;
    this.promptTemplateService = promptTemplateService;
  }

  @GetMapping("/items")
  public ApiResponse<List<TcmDetectionItemConfig>> listItems(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(itemConfigService.listAll());
  }

  @PutMapping("/items/{id}")
  public ApiResponse<TcmDetectionItemConfig> updateItem(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @RequestBody @Valid TcmDetectionItemConfigRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(itemConfigService.update(id, req));
  }

  @GetMapping("/ai-prompts")
  public ApiResponse<List<TcmDetectionAiPromptTemplate>> listPrompts(
      @RequestHeader(value = "Authorization", required = false) String authorization) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(promptTemplateService.listAll());
  }

  @PutMapping("/ai-prompts/{id}")
  public ApiResponse<TcmDetectionAiPromptTemplate> updatePrompt(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id,
      @RequestBody @Valid TcmDetectionAiPromptTemplateRequest req) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(promptTemplateService.update(id, req));
  }
}
