package com.ypfr.loseweight.service;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.ypfr.loseweight.config.UploadProperties;
import com.ypfr.loseweight.web.dto.PhotoRecognitionServiceConfigVo;
import com.ypfr.loseweight.web.dto.admin.AdminSkinDetectionRecordDetailVo;
import com.ypfr.loseweight.web.dto.skin.SkinDetectionItemVo;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

@Service
public class SkinDetectionPdfService {

  private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
  private static final String LOGO_RESOURCE = "/static/pdf/baohu-logo.png";

  private final PhotoRecognitionAccessService photoRecognitionAccessService;
  private final UploadProperties uploadProperties;

  public SkinDetectionPdfService(
      PhotoRecognitionAccessService photoRecognitionAccessService,
      UploadProperties uploadProperties) {
    this.photoRecognitionAccessService = photoRecognitionAccessService;
    this.uploadProperties = uploadProperties;
  }

  public byte[] generate(AdminSkinDetectionRecordDetailVo detail) {
    try {
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      Document document = new Document(PageSize.A4, 42, 42, 42, 42);
      PdfWriter.getInstance(document, out);
      document.open();

      Fonts fonts = createFonts();
      PhotoRecognitionServiceConfigVo serviceConfig = loadServiceConfigSafely();
      addTitle(document, detail, serviceConfig, fonts);
      addBasicInfo(document, detail, fonts);
      addSummary(document, detail, fonts);
      addFocusItems(document, detail, fonts);
      addItems(document, detail, fonts);
      addDisclaimer(document, fonts);

      document.close();
      return out.toByteArray();
    } catch (DocumentException | IOException e) {
      throw new IllegalStateException("PDF 生成失败", e);
    }
  }

  private void addTitle(
      Document document,
      AdminSkinDetectionRecordDetailVo detail,
      PhotoRecognitionServiceConfigVo serviceConfig,
      Fonts fonts) throws DocumentException {
    PdfPTable header = new PdfPTable(3);
    header.setWidthPercentage(100);
    header.setWidths(new float[] {1.2f, 3.4f, 1.4f});
    header.setSpacingAfter(18);

    PdfPCell logoCell = borderlessCell();
    Image logo = loadLogoImage();
    if (logo != null) {
      logo.scaleToFit(54, 54);
      logo.setAlignment(Element.ALIGN_LEFT);
      logoCell.addElement(logo);
    }
    header.addCell(logoCell);

    PdfPCell titleCell = borderlessCell();
    titleCell.setHorizontalAlignment(Element.ALIGN_CENTER);
    Paragraph title = new Paragraph("皮肤检测结构化报告", fonts.title);
    title.setAlignment(Element.ALIGN_CENTER);
    title.setSpacingAfter(8);
    titleCell.addElement(title);
    Paragraph sub = new Paragraph("宝护健康瘦 AI 皮肤检测 · 报告编号 " + value(detail.getRecordId()), fonts.muted);
    sub.setAlignment(Element.ALIGN_CENTER);
    titleCell.addElement(sub);
    header.addCell(titleCell);

    PdfPCell serviceCell = borderlessCell();
    serviceCell.setHorizontalAlignment(Element.ALIGN_CENTER);
    Image qr = loadServiceQrImage(serviceConfig);
    if (qr != null) {
      qr.scaleToFit(64, 64);
      qr.setAlignment(Element.ALIGN_CENTER);
      serviceCell.addElement(qr);
    }
    String wechat = serviceConfig == null ? null : serviceConfig.getServiceWechat();
    if (hasText(wechat)) {
      Paragraph p = new Paragraph("客服微信：" + wechat.trim(), fonts.muted);
      p.setAlignment(Element.ALIGN_CENTER);
      p.setSpacingBefore(4);
      serviceCell.addElement(p);
    }
    header.addCell(serviceCell);

    document.add(header);
  }

  private void addBasicInfo(Document document, AdminSkinDetectionRecordDetailVo detail, Fonts fonts)
      throws DocumentException {
    addSectionTitle(document, "一、报告概览", fonts);
    PdfPTable scoreTable = new PdfPTable(3);
    scoreTable.setWidthPercentage(100);
    scoreTable.setWidths(new float[] {1.1f, 1.1f, 1.6f});
    addOverviewCell(scoreTable, "综合肤况分", value(detail.getOverallScore()), fonts);
    addOverviewCell(scoreTable, "报告状态", statusLabel(detail.getStatus()), fonts);
    addOverviewCell(scoreTable, "检测时间", detail.getCreatedAt() == null ? "--" : DATE_TIME_FORMATTER.format(detail.getCreatedAt()), fonts);
    scoreTable.setSpacingAfter(10);
    document.add(scoreTable);

    PdfPTable table = new PdfPTable(4);
    table.setWidthPercentage(100);
    table.setWidths(new float[] {1.1f, 1.6f, 1.1f, 1.6f});
    addCell(table, "记录ID", fonts.label);
    addCell(table, value(detail.getRecordId()), fonts.normal);
    addCell(table, "用户ID", fonts.label);
    addCell(table, value(detail.getUserId()), fonts.normal);
    addCell(table, "手机号", fonts.label);
    addCell(table, maskPhone(detail.getPhone()), fonts.normal);
    addCell(table, "姓名", fonts.label);
    addCell(table, value(detail.getUserName()), fonts.normal);
    addCell(table, "性别", fonts.label);
    addCell(table, genderLabel(detail.getGender()), fonts.normal);
    addCell(table, "年龄", fonts.label);
    addCell(table, value(detail.getAge()), fonts.normal);
    addCell(table, "居住地", fonts.label);
    addCell(table, value(detail.getResidence()), fonts.normal);
    addCell(table, "检测项组合", fonts.label);
    addCell(table, value(detail.getDetectTypes()), fonts.normal);
    document.add(table);
  }

  private void addSummary(Document document, AdminSkinDetectionRecordDetailVo detail, Fonts fonts)
      throws DocumentException {
    addSectionTitle(document, "二、综合结论", fonts);
    addTextBlock(document, value(detail.getAiSummary()), fonts.normal, new Color(236, 246, 232));

    if (hasText(detail.getFailReason())) {
      Paragraph p = new Paragraph("失败原因：" + detail.getFailReason(), fonts.warning);
      p.setSpacingAfter(8);
      document.add(p);
    }
    if (hasText(detail.getDeepseekError())) {
      Paragraph p = new Paragraph("AI 分析提示：" + detail.getDeepseekError(), fonts.warning);
      p.setSpacingAfter(8);
      document.add(p);
    }
    if (hasText(detail.getImageUrl())) {
      Paragraph p = new Paragraph("检测图片链接：" + detail.getImageUrl(), fonts.muted);
      p.setSpacingAfter(12);
      document.add(p);
    }
  }

  private void addFocusItems(Document document, AdminSkinDetectionRecordDetailVo detail, Fonts fonts)
      throws DocumentException {
    addSectionTitle(document, "三、重点关注项", fonts);
    java.util.List<SkinDetectionItemVo> focusItems = new java.util.ArrayList<>();
    for (SkinDetectionItemVo item : detail.getItems()) {
      if (item.getScore() != null && item.getScore() < 70) {
        focusItems.add(item);
      }
    }
    if (focusItems.isEmpty()) {
      addTextBlock(document, "本次检测未发现低于 70 分的明显短板项，建议继续保持规律清洁、保湿和防晒。", fonts.normal, new Color(246, 242, 255));
      return;
    }
    PdfPTable table = new PdfPTable(4);
    table.setWidthPercentage(100);
    table.setWidths(new float[] {1.2f, 0.8f, 1.0f, 3.6f});
    addHeaderCell(table, "检测项", fonts.header);
    addHeaderCell(table, "分数", fonts.header);
    addHeaderCell(table, "程度", fonts.header);
    addHeaderCell(table, "重点说明", fonts.header);
    for (SkinDetectionItemVo item : focusItems) {
      addCell(table, value(item.getItemName()), fonts.normal);
      addCell(table, value(item.getScore()), fonts.normal);
      addCell(table, levelLabel(item.getLevel()), fonts.normal);
      addCell(table, value(firstText(item.getAiConclusion(), item.getResultText(), item.getAiError())), fonts.normal);
    }
    document.add(table);
  }

  private void addItems(Document document, AdminSkinDetectionRecordDetailVo detail, Fonts fonts)
      throws DocumentException {
    addSectionTitle(document, "四、分项结构化分析", fonts);
    for (SkinDetectionItemVo item : detail.getItems()) {
      PdfPTable title = new PdfPTable(3);
      title.setWidthPercentage(100);
      title.setWidths(new float[] {1.5f, 0.8f, 1.0f});
      addCell(title, value(item.getItemName()), fonts.header, new Color(236, 246, 232));
      addCell(title, value(item.getScore()) + " 分", fonts.header, new Color(236, 246, 232));
      addCell(title, levelLabel(item.getLevel()), fonts.normal, new Color(236, 246, 232));
      title.setSpacingBefore(6);
      document.add(title);

      PdfPTable table = new PdfPTable(2);
      table.setWidthPercentage(100);
      table.setWidths(new float[] {1.0f, 4.2f});
      addCell(table, "诊断结论", fonts.label, new Color(246, 242, 255));
      addCell(table, value(firstText(item.getAiConclusion(), item.getResultText())), fonts.normal);
      addCell(table, "产生原因", fonts.label, new Color(246, 242, 255));
      addCell(table, value(firstText(item.getAiReason(), fallbackReason(item))), fonts.normal);
      addCell(table, "护理建议", fonts.label, new Color(246, 242, 255));
      addCell(table, value(firstText(item.getAiCareAdvice(), fallbackAdvice(item))), fonts.normal);
      table.setSpacingAfter(8);
      document.add(table);
    }
  }

  private void addDisclaimer(Document document, Fonts fonts) throws DocumentException {
    addSectionTitle(document, "五、免责声明", fonts);
    Paragraph p = new Paragraph(
        "本报告由 AI 皮肤检测能力生成，仅用于日常护肤参考，不作为医疗诊断依据。如存在严重皮肤问题，请咨询专业医生。",
        fonts.muted);
    p.setLeading(18);
    document.add(p);
  }

  private PdfPCell borderlessCell() {
    PdfPCell cell = new PdfPCell();
    cell.setBorder(Rectangle.NO_BORDER);
    cell.setPadding(0);
    cell.setVerticalAlignment(Rectangle.ALIGN_TOP);
    return cell;
  }

  private PhotoRecognitionServiceConfigVo loadServiceConfigSafely() {
    try {
      return photoRecognitionAccessService.getServiceConfig();
    } catch (Exception e) {
      return null;
    }
  }

  private Image loadLogoImage() {
    try (InputStream in = getClass().getResourceAsStream(LOGO_RESOURCE)) {
      if (in == null) {
        return null;
      }
      return Image.getInstance(in.readAllBytes());
    } catch (Exception e) {
      return null;
    }
  }

  private Image loadServiceQrImage(PhotoRecognitionServiceConfigVo cfg) {
    if (cfg == null || (cfg.getStatus() != null && cfg.getStatus() == 0)) {
      return null;
    }
    Image local = loadImageFromUploadPath(cfg.getServiceQrImagePath());
    if (local != null) {
      return local;
    }
    local = loadImageFromUploadPath(cfg.getServiceQrImageUrl());
    if (local != null) {
      return local;
    }
    return loadImageFromUrl(cfg.getServiceQrImageUrl());
  }

  private Image loadImageFromUploadPath(String rawPath) {
    if (!hasText(rawPath)) {
      return null;
    }
    String path = rawPath.trim();
    if (path.startsWith("http://") || path.startsWith("https://")) {
      return null;
    }
    int idx = path.indexOf("/public/avatars/");
    if (idx >= 0) {
      path = path.substring(idx + "/public/avatars/".length());
    } else if (path.startsWith("/api/v1/public/avatars/")) {
      path = path.substring("/api/v1/public/avatars/".length());
    } else if (path.startsWith("/public/avatars/")) {
      path = path.substring("/public/avatars/".length());
    }
    if (path.startsWith("/")) {
      path = path.substring(1);
    }
    try {
      Path baseDir = Paths.get(uploadProperties.getAvatarDir()).toAbsolutePath().normalize();
      Path file = baseDir.resolve(path).normalize();
      if (!file.startsWith(baseDir) || !Files.exists(file)) {
        return null;
      }
      return Image.getInstance(Files.readAllBytes(file));
    } catch (Exception e) {
      return null;
    }
  }

  private Image loadImageFromUrl(String imageUrl) {
    if (!hasText(imageUrl) || !(imageUrl.startsWith("http://") || imageUrl.startsWith("https://"))) {
      return null;
    }
    try (InputStream in = new URL(imageUrl.trim()).openStream()) {
      return Image.getInstance(in.readAllBytes());
    } catch (Exception e) {
      return null;
    }
  }

  private void addSectionTitle(Document document, String text, Fonts fonts) throws DocumentException {
    Paragraph p = new Paragraph(text, fonts.section);
    p.setSpacingBefore(14);
    p.setSpacingAfter(8);
    document.add(p);
  }

  private void addHeaderCell(PdfPTable table, String text, Font font) {
    PdfPCell cell = new PdfPCell(new Phrase(text, font));
    cell.setBackgroundColor(new Color(236, 246, 232));
    cell.setPadding(7);
    cell.setBorderColor(new Color(220, 230, 218));
    table.addCell(cell);
  }

  private void addCell(PdfPTable table, String text, Font font) {
    addCell(table, text, font, Color.WHITE);
  }

  private void addCell(PdfPTable table, String text, Font font, Color backgroundColor) {
    PdfPCell cell = new PdfPCell(new Phrase(text, font));
    cell.setPadding(7);
    cell.setBorderColor(new Color(225, 232, 225));
    cell.setBackgroundColor(backgroundColor);
    cell.setVerticalAlignment(Rectangle.ALIGN_MIDDLE);
    cell.setLeading(4, 1.35f);
    table.addCell(cell);
  }

  private void addOverviewCell(PdfPTable table, String label, String text, Fonts fonts) {
    Paragraph paragraph = new Paragraph();
    paragraph.add(new Phrase(label + "\n", fonts.muted));
    paragraph.add(new Phrase(text, fonts.score));
    PdfPCell cell = new PdfPCell(paragraph);
    cell.setPadding(12);
    cell.setBorderColor(new Color(225, 232, 225));
    cell.setBackgroundColor(new Color(236, 246, 232));
    cell.setHorizontalAlignment(Element.ALIGN_CENTER);
    cell.setVerticalAlignment(Rectangle.ALIGN_MIDDLE);
    table.addCell(cell);
  }

  private void addTextBlock(Document document, String text, Font font, Color backgroundColor) throws DocumentException {
    PdfPTable table = new PdfPTable(1);
    table.setWidthPercentage(100);
    PdfPCell cell = new PdfPCell(new Phrase(value(text), font));
    cell.setPadding(10);
    cell.setLeading(4, 1.5f);
    cell.setBorderColor(new Color(225, 232, 225));
    cell.setBackgroundColor(backgroundColor);
    table.addCell(cell);
    table.setSpacingAfter(8);
    document.add(table);
  }

  private Fonts createFonts() throws IOException, DocumentException {
    BaseFont baseFont = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
    Fonts fonts = new Fonts();
    fonts.title = new Font(baseFont, 20, Font.BOLD, new Color(31, 42, 31));
    fonts.section = new Font(baseFont, 13, Font.BOLD, new Color(31, 42, 31));
    fonts.header = new Font(baseFont, 11, Font.BOLD, new Color(31, 42, 31));
    fonts.label = new Font(baseFont, 10, Font.BOLD, new Color(60, 75, 60));
    fonts.normal = new Font(baseFont, 10, Font.NORMAL, new Color(45, 55, 45));
    fonts.muted = new Font(baseFont, 9, Font.NORMAL, new Color(100, 116, 100));
    fonts.warning = new Font(baseFont, 10, Font.NORMAL, new Color(180, 90, 0));
    fonts.score = new Font(baseFont, 16, Font.BOLD, new Color(95, 168, 84));
    return fonts;
  }

  private static String firstText(String... values) {
    for (String value : values) {
      if (hasText(value)) {
        return value;
      }
    }
    return null;
  }

  private static String fallbackReason(SkinDetectionItemVo item) {
    return "根据当前检测数据，" + value(item.getItemName()) + "状态需要结合清洁、保湿、防晒、作息和环境因素综合判断。";
  }

  private static String fallbackAdvice(SkinDetectionItemVo item) {
    return "建议围绕" + value(item.getItemName()) + "做好温和清洁、基础保湿和日间防晒，避免频繁刺激皮肤。如需更细致方案，可联系客服定制。";
  }

  private static String levelLabel(String level) {
    if (!hasText(level)) return "--";
    return switch (level.trim()) {
      case "severe" -> "严重";
      case "moderately" -> "中度";
      case "lightly" -> "轻度";
      case "none" -> "无明显问题";
      case "oil" -> "油性";
      case "dry" -> "干性";
      case "mid" -> "中性";
      case "mix" -> "混合性";
      case "mid_oil" -> "中性偏油";
      case "mid_dry" -> "中性偏干";
      default -> level;
    };
  }

  private static String maskPhone(String phone) {
    if (!hasText(phone) || phone.length() < 7) {
      return value(phone);
    }
    return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
  }

  private static String statusLabel(String status) {
    if ("success".equals(status)) return "成功";
    if ("failed".equals(status)) return "失败";
    if ("pending".equals(status)) return "处理中";
    return value(status);
  }

  private static String genderLabel(Integer gender) {
    if (gender != null && gender == 1) return "男";
    if (gender != null && gender == 2) return "女";
    return "--";
  }

  private static String value(Object value) {
    if (value == null) {
      return "--";
    }
    String s = String.valueOf(value).trim();
    return s.isEmpty() ? "--" : s;
  }

  private static boolean hasText(String value) {
    return value != null && !value.trim().isEmpty();
  }

  private static class Fonts {
    private Font title;
    private Font section;
    private Font header;
    private Font label;
    private Font normal;
    private Font muted;
    private Font warning;
    private Font score;
  }
}
