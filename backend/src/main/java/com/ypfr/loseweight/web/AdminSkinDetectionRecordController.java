package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.SkinDetectionRecord;
import com.ypfr.loseweight.service.AdminSkinDetectionService;
import com.ypfr.loseweight.service.SkinDetectionPdfService;
import com.ypfr.loseweight.web.dto.admin.AdminSkinDetectionRecordDetailVo;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin/skin-detection-records")
public class AdminSkinDetectionRecordController {

  private final AdminAuthResolver adminAuthResolver;
  private final AdminSkinDetectionService skinDetectionService;
  private final SkinDetectionPdfService pdfService;

  public AdminSkinDetectionRecordController(
      AdminAuthResolver adminAuthResolver,
      AdminSkinDetectionService skinDetectionService,
      SkinDetectionPdfService pdfService) {
    this.adminAuthResolver = adminAuthResolver;
    this.skinDetectionService = skinDetectionService;
    this.pdfService = pdfService;
  }

  @GetMapping
  public ApiResponse<List<SkinDetectionRecord>> list(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestParam(required = false) String phone,
      @RequestParam(required = false) String status,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
      @RequestParam(required = false) Integer minScore,
      @RequestParam(required = false) Integer maxScore) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(skinDetectionService.listRecords(phone, status, startDate, endDate, minScore, maxScore));
  }

  @GetMapping("/{id}")
  public ApiResponse<AdminSkinDetectionRecordDetailVo> detail(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(skinDetectionService.recordDetail(id));
  }

  @GetMapping("/{id}/pdf")
  public ResponseEntity<byte[]> exportPdf(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    AdminSkinDetectionRecordDetailVo detail = skinDetectionService.recordDetail(id);
    byte[] bytes = pdfService.generate(detail);
    String filename = buildPdfFilename(detail, id);
    return ResponseEntity.ok()
        .contentType(MediaType.APPLICATION_PDF)
        .header(
            HttpHeaders.CONTENT_DISPOSITION,
            ContentDisposition.attachment().filename(filename, StandardCharsets.UTF_8).build().toString())
        .body(bytes);
  }

  private String buildPdfFilename(AdminSkinDetectionRecordDetailVo detail, Long id) {
    String date = detail.getCreatedAt() == null
        ? LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE)
        : detail.getCreatedAt().toLocalDate().format(DateTimeFormatter.BASIC_ISO_DATE);
    String name = detail.getUserName();
    if (name == null || name.trim().isEmpty()) {
      name = "用户" + id;
    }
    name = name.replaceAll("[\\\\/:*?\"<>|\\s]+", "");
    if (name.isEmpty()) {
      name = "用户" + id;
    }
    return date + "-" + name + "-皮肤诊断报告.pdf";
  }
}
