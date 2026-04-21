package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.domain.BmiInterpretation;
import com.ypfr.loseweight.mapper.BmiInterpretationMapper;
import java.math.BigDecimal;
import java.math.RoundingMode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class BmiInterpretationService {

  private static final Logger log = LoggerFactory.getLogger(BmiInterpretationService.class);

  public static final String BUCKET_UNDERWEIGHT = "UNDERWEIGHT";
  public static final String BUCKET_NORMAL = "NORMAL";
  public static final String BUCKET_OVERWEIGHT = "OVERWEIGHT";
  public static final String BUCKET_OBESE = "OBESE";

  private final BmiInterpretationMapper bmiInterpretationMapper;

  public BmiInterpretationService(BmiInterpretationMapper bmiInterpretationMapper) {
    this.bmiInterpretationMapper = bmiInterpretationMapper;
  }

  /** WHO 常用分界：&lt;18.5 / [18.5,24) / [24,28) / ≥28 */
  public static String bucketCodeForBmi(double bmi) {
    if (Double.isNaN(bmi) || bmi <= 0) {
      return BUCKET_NORMAL;
    }
    if (bmi < 18.5) {
      return BUCKET_UNDERWEIGHT;
    }
    if (bmi < 24) {
      return BUCKET_NORMAL;
    }
    if (bmi < 28) {
      return BUCKET_OVERWEIGHT;
    }
    return BUCKET_OBESE;
  }

  public static double bmiFromProfile(BigDecimal heightCm, BigDecimal weightKg) {
    if (heightCm == null || weightKg == null) {
      return 0;
    }
    double h = heightCm.doubleValue();
    double w = weightKg.doubleValue();
    if (h <= 0 || w <= 0) {
      return 0;
    }
    double m = h / 100.0;
    return BigDecimal.valueOf(w / (m * m)).setScale(1, RoundingMode.HALF_UP).doubleValue();
  }

  /**
   * 按 BMI 分桶读取库中文案；表或行缺失时返回内置兜底（与历史前端 copy 语义接近）。
   */
  public String resolveInterpretationText(BigDecimal heightCm, BigDecimal currentWeightKg) {
    double bmi = bmiFromProfile(heightCm, currentWeightKg);
    if (bmi <= 0) {
      return "完善身高与当前体重后，可查看更准确的 BMI 解读与饮食建议。";
    }
    String bucket = bucketCodeForBmi(bmi);
    try {
      BmiInterpretation row =
          bmiInterpretationMapper.selectOne(
              new LambdaQueryWrapper<BmiInterpretation>().eq(BmiInterpretation::getBucketCode, bucket));
      if (row != null && StringUtils.hasText(row.getBodyText())) {
        return row.getBodyText().trim();
      }
    } catch (Exception e) {
      log.warn("读取 bmi_interpretation 失败，使用兜底文案: {}", e.toString());
    }
    return fallbackBody(bucket);
  }

  private static String fallbackBody(String bucket) {
    return switch (bucket) {
      case BUCKET_UNDERWEIGHT ->
          "体重偏轻时建议保证充足热量与优质蛋白，避免过度节食，可结合力量训练增肌。";
      case BUCKET_NORMAL -> "体重在健康范围内，建议保持均衡饮食与规律运动，巩固当前状态。";
      case BUCKET_OVERWEIGHT ->
          "您的体重超重，处于肥胖前期。建议控制总能量摄入，注重均衡，增加蔬果、谷物及优质蛋白质摄入，并保持规律运动。";
      case BUCKET_OBESE ->
          "建议在医生或营养师指导下制定减重计划，循序渐进降低体重并关注代谢健康。";
      default -> "完善身高与当前体重后，可查看更准确的 BMI 解读与饮食建议。";
    };
  }
}
