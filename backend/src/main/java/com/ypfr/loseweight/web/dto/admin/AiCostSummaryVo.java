package com.ypfr.loseweight.web.dto.admin;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/** AI 与第三方接口费用统一总览。按功能合并「接口费 + DeepSeek 费」。 */
public class AiCostSummaryVo {

  private LocalDate from;
  private LocalDate to;
  private BigDecimal totalCostCny;
  private BigDecimal vendorCostCny;
  private BigDecimal deepseekCostCny;
  private List<FeatureCost> byFeature;
  private List<ProviderStat> byProvider;
  private List<DailyCost> daily;

  public LocalDate getFrom() {
    return from;
  }

  public void setFrom(LocalDate from) {
    this.from = from;
  }

  public LocalDate getTo() {
    return to;
  }

  public void setTo(LocalDate to) {
    this.to = to;
  }

  public BigDecimal getTotalCostCny() {
    return totalCostCny;
  }

  public void setTotalCostCny(BigDecimal totalCostCny) {
    this.totalCostCny = totalCostCny;
  }

  public BigDecimal getVendorCostCny() {
    return vendorCostCny;
  }

  public void setVendorCostCny(BigDecimal vendorCostCny) {
    this.vendorCostCny = vendorCostCny;
  }

  public BigDecimal getDeepseekCostCny() {
    return deepseekCostCny;
  }

  public void setDeepseekCostCny(BigDecimal deepseekCostCny) {
    this.deepseekCostCny = deepseekCostCny;
  }

  public List<FeatureCost> getByFeature() {
    return byFeature;
  }

  public void setByFeature(List<FeatureCost> byFeature) {
    this.byFeature = byFeature;
  }

  public List<ProviderStat> getByProvider() {
    return byProvider;
  }

  public void setByProvider(List<ProviderStat> byProvider) {
    this.byProvider = byProvider;
  }

  public List<DailyCost> getDaily() {
    return daily;
  }

  public void setDaily(List<DailyCost> daily) {
    this.daily = daily;
  }

  /** 每个功能：接口调用与费用 + DeepSeek 调用与费用 + 合计。 */
  public record FeatureCost(
      String feature,
      String displayName,
      long vendorCalls,
      long vendorSuccessCalls,
      BigDecimal vendorCostCny,
      long deepseekCalls,
      BigDecimal deepseekCostCny,
      BigDecimal totalCostCny) {}

  /** 每个第三方供应商：调用次数/成功/免费/费用。 */
  public record ProviderStat(
      String provider,
      String displayName,
      long calls,
      long successCalls,
      long freeCalls,
      BigDecimal costCny) {}

  /** 每日：接口费 + DeepSeek 费 + 合计。 */
  public record DailyCost(
      String date, BigDecimal vendorCostCny, BigDecimal deepseekCostCny, BigDecimal totalCostCny) {}
}
