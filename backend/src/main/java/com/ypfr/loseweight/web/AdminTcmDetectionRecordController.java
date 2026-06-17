package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.TcmDetectionRecord;
import com.ypfr.loseweight.service.AdminTcmDetectionService;
import com.ypfr.loseweight.service.TcmDetectionPdfService;
import com.ypfr.loseweight.web.dto.admin.AdminTcmDetectionRecordDetailVo;
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
@RequestMapping("/api/v1/admin/tcm-detection-records")
public class AdminTcmDetectionRecordController {

  private final AdminAuthResolver adminAuthResolver;
  private final AdminTcmDetectionService tcmDetectionService;
  private final TcmDetectionPdfService pdfService;

  public AdminTcmDetectionRecordController(
      AdminAuthResolver adminAuthResolver,
      AdminTcmDetectionService tcmDetectionService,
      TcmDetectionPdfService pdfService) {
    this.adminAuthResolver = adminAuthResolver;
    this.tcmDetectionService = tcmDetectionService;
    this.pdfService = pdfService;
  }

  @GetMapping
  public ApiResponse<List<TcmDetectionRecord>> list(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @RequestParam(required = false) String phone,
      @RequestParam(required = false) String status,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
      @RequestParam(required = false) Integer minScore,
      @RequestParam(required = false) Integer maxScore) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(tcmDetectionService.listRecords(phone, status, startDate, endDate, minScore, maxScore));
  }

  @GetMapping("/{id}")
  public ApiResponse<AdminTcmDetectionRecordDetailVo> detail(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    return ApiResponse.ok(tcmDetectionService.recordDetail(id));
  }

  @GetMapping("/{id}/pdf")
  public ResponseEntity<byte[]> exportPdf(
      @RequestHeader(value = "Authorization", required = false) String authorization,
      @PathVariable Long id) {
    adminAuthResolver.requireAdminId(authorization);
    AdminTcmDetectionRecordDetailVo detail = tcmDetectionService.recordDetail(id);
    byte[] bytes = pdfService.generate(detail);
    String filename = buildPdfFilename(detail, id);
    return ResponseEntity.ok()
        .contentType(MediaType.APPLICATION_PDF)
        .header(
            HttpHeaders.CONTENT_DISPOSITION,
            ContentDisposition.attachment().filename(filename, StandardCharsets.UTF_8).build().toString())
        .body(bytes);
  }

  private String buildPdfFilename(AdminTcmDetectionRecordDetailVo detail, Long id) {
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
    return date + "-" + name + "-中医体质报告.pdf";
  }
}
