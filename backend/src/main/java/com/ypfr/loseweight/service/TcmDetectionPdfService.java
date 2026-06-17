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
import com.ypfr.loseweight.web.dto.admin.AdminTcmDetectionRecordDetailVo;
import com.ypfr.loseweight.web.dto.tcm.TcmDetectionItemVo;
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
public class TcmDetectionPdfService {

  private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
  private static final String LOGO_RESOURCE = "/static/pdf/baohu-logo.png";

  private final PhotoRecognitionAccessService photoRecognitionAccessService;
  private final UploadProperties uploadProperties;
  private final String publicBaseUrl;

  public TcmDetectionPdfService(
      PhotoRecognitionAccessService photoRecognitionAccessService,
      UploadProperties uploadProperties,
      @org.springframework.beans.factory.annotation.Value("${APP_PUBLIC_BASE_URL:https://api.baohukeji.com}")
          String publicBaseUrl) {
    this.photoRecognitionAccessService = photoRecognitionAccessService;
    this.uploadProperties = uploadProperties;
    this.publicBaseUrl = publicBaseUrl;
  }

  public byte[] generate(AdminTcmDetectionRecordDetailVo detail) {
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
      AdminTcmDetectionRecordDetailVo detail,
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
    Paragraph title = new Paragraph("中医体质健康报告", fonts.title);
    title.setAlignment(Element.ALIGN_CENTER);
    title.setSpacingAfter(8);
    titleCell.addElement(title);
    Paragraph sub = new Paragraph("宝护健康瘦 AI 中医体检 · 报告编号 " + value(detail.getRecordId()), fonts.muted);
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

  private void addBasicInfo(Document document, AdminTcmDetectionRecordDetailVo detail, Fonts fonts)
      throws DocumentException {
    addSectionTitle(document, "一、报告概览", fonts);
    PdfPTable scoreTable = new PdfPTable(3);
    scoreTable.setWidthPercentage(100);
    scoreTable.setWidths(new float[] {1.1f, 1.1f, 1.6f});
    addOverviewCell(scoreTable, "综合健康分", value(detail.getOverallScore()), fonts);
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
    addCell(table, "主体质", fonts.label);
    addCell(table, value(detail.getConstitutionPrimary()), fonts.normal);
    document.add(table);
  }

  private void addSummary(Document document, AdminTcmDetectionRecordDetailVo detail, Fonts fonts)
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
    addImagePair(document, detail, fonts);
  }

  /** 将舌象、面象图片直接嵌入 PDF（读本地上传文件），而非展示链接。 */
  private void addImagePair(Document document, AdminTcmDetectionRecordDetailVo detail, Fonts fonts)
      throws DocumentException {
    Image tongue = loadImageFromUploadPath(detail.getTongueImageUrl());
    Image face = loadImageFromUploadPath(detail.getFaceImageUrl());
    if (tongue == null && face == null) {
      return;
    }
    PdfPTable table = new PdfPTable(2);
    table.setWidthPercentage(100);
    table.setWidths(new float[] {1f, 1f});
    table.setSpacingBefore(8);
    table.setSpacingAfter(12);
    table.addCell(imageCell("舌象（点击查看原图）", tongue, detail.getTongueImageUrl(), fonts));
    table.addCell(imageCell("面象（点击查看原图）", face, detail.getFaceImageUrl(), fonts));
    document.add(table);
  }

  private PdfPCell imageCell(String caption, Image image, String relativeUrl, Fonts fonts) {
    PdfPCell cell = new PdfPCell();
    cell.setPadding(8);
    cell.setBorderColor(new Color(225, 232, 225));
    cell.setHorizontalAlignment(Element.ALIGN_CENTER);
    Paragraph cap = new Paragraph(caption, fonts.label);
    cap.setAlignment(Element.ALIGN_CENTER);
    cap.setSpacingAfter(6);
    cell.addElement(cap);
    if (image != null) {
      cell.addElement(clickableImage(image, relativeUrl, 220, 220));
    } else {
      Paragraph none = new Paragraph("暂无图片", fonts.muted);
      none.setAlignment(Element.ALIGN_CENTER);
      cell.addElement(none);
    }
    return cell;
  }

  /** 把图片缩放后包成可点击 Chunk（锚点为公网原图地址），点击在浏览器打开原图。 */
  private Paragraph clickableImage(Image image, String relativeUrl, float maxW, float maxH) {
    image.scaleToFit(maxW, maxH);
    com.lowagie.text.Chunk chunk = new com.lowagie.text.Chunk(image, 0, 0, true);
    String abs = absoluteUrl(relativeUrl);
    if (hasText(abs)) {
      chunk.setAnchor(abs);
    }
    Paragraph p = new Paragraph(chunk);
    p.setAlignment(Element.ALIGN_CENTER);
    return p;
  }

  private String absoluteUrl(String rawPath) {
    if (!hasText(rawPath)) {
      return null;
    }
    String p = rawPath.trim();
    if (p.startsWith("http://") || p.startsWith("https://")) {
      return p;
    }
    if (!p.startsWith("/")) {
      p = "/" + p;
    }
    return publicBaseUrl.replaceAll("/$", "") + p;
  }

  private void addFocusItems(Document document, AdminTcmDetectionRecordDetailVo detail, Fonts fonts)
      throws DocumentException {
    addSectionTitle(document, "三、重点体质倾向", fonts);
    java.util.List<TcmDetectionItemVo> focusItems = new java.util.ArrayList<>();
    for (TcmDetectionItemVo item : detail.getItems()) {
      // 平和质为正向体质不计入偏颇关注项；其余体质倾向分较高者重点提示
      if ("pinghe".equals(item.getItemCode())) {
        continue;
      }
      if (item.getScore() != null && item.getScore() >= 60) {
        focusItems.add(item);
      }
    }
    if (focusItems.isEmpty()) {
      addTextBlock(document, "本次检测未发现明显偏颇的体质倾向，建议继续保持规律作息、均衡饮食与适度运动。", fonts.normal, new Color(246, 242, 255));
      return;
    }
    PdfPTable table = new PdfPTable(4);
    table.setWidthPercentage(100);
    table.setWidths(new float[] {1.2f, 0.8f, 1.0f, 3.6f});
    addHeaderCell(table, "体质", fonts.header);
    addHeaderCell(table, "倾向", fonts.header);
    addHeaderCell(table, "程度", fonts.header);
    addHeaderCell(table, "重点说明", fonts.header);
    for (TcmDetectionItemVo item : focusItems) {
      addCell(table, value(item.getItemName()), fonts.normal);
      addCell(table, value(item.getScore()), fonts.normal);
      addCell(table, levelLabel(item.getLevel()), fonts.normal);
      addCell(table, value(firstText(item.getAiConclusion(), item.getResultText(), item.getAiError())), fonts.normal);
    }
    document.add(table);
  }

  private void addItems(Document document, AdminTcmDetectionRecordDetailVo detail, Fonts fonts)
      throws DocumentException {
    addSectionTitle(document, "四、分项结构化分析", fonts);
    for (TcmDetectionItemVo item : detail.getItems()) {
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
      addCell(table, "调理建议", fonts.label, new Color(246, 242, 255));
      addCell(table, value(firstText(item.getAiCareAdvice(), fallbackAdvice(item))), fonts.normal);
      table.setSpacingAfter(8);
      document.add(table);
    }
  }

  private void addDisclaimer(Document document, Fonts fonts) throws DocumentException {
    addSectionTitle(document, "五、免责声明", fonts);
    Paragraph p = new Paragraph(
        "本报告由 AI 中医体检能力生成，仅用于日常养生与体质调理参考，不作为医疗诊断依据。如有不适或慢性疾病，请咨询专业中医师或前往正规医疗机构就诊。",
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

  private static String fallbackReason(TcmDetectionItemVo item) {
    return "根据当前检测数据，" + value(item.getItemName()) + "倾向需要结合饮食、起居、运动、情志和环境因素综合判断。";
  }

  private static String fallbackAdvice(TcmDetectionItemVo item) {
    return "建议顺应" + value(item.getItemName()) + "特点调整饮食起居，规律作息、适度运动、调畅情志。如需更细致方案，可联系客服定制。";
  }

  private static String levelLabel(String level) {
    if (!hasText(level)) return "--";
    return switch (level.trim()) {
      case "none" -> "无明显倾向";
      case "mild" -> "轻度倾向";
      case "tendency" -> "倾向较明显";
      case "obvious" -> "明显倾向";
      case "basic" -> "基础尚可";
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
