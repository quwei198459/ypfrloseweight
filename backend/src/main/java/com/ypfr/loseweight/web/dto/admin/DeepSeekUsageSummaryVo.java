package com.ypfr.loseweight.web.dto.admin;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/** DeepSeek 用量/费用看板汇总。 */
public class DeepSeekUsageSummaryVo {

  private LocalDate from;
  private LocalDate to;
  private long totalCalls;
  private long totalTokens;
  private BigDecimal totalCostCny;
  private List<FeatureStat> byFeature;
  private List<ModelStat> byBilledModel;
  private List<DailyStat> daily;
  private List<UserStat> topUsers;

  public LocalDate getFrom() { return from; }
  public void setFrom(LocalDate from) { this.from = from; }
  public LocalDate getTo() { return to; }
  public void setTo(LocalDate to) { this.to = to; }
  public long getTotalCalls() { return totalCalls; }
  public void setTotalCalls(long totalCalls) { this.totalCalls = totalCalls; }
  public long getTotalTokens() { return totalTokens; }
  public void setTotalTokens(long totalTokens) { this.totalTokens = totalTokens; }
  public BigDecimal getTotalCostCny() { return totalCostCny; }
  public void setTotalCostCny(BigDecimal totalCostCny) { this.totalCostCny = totalCostCny; }
  public List<FeatureStat> getByFeature() { return byFeature; }
  public void setByFeature(List<FeatureStat> byFeature) { this.byFeature = byFeature; }
  public List<ModelStat> getByBilledModel() { return byBilledModel; }
  public void setByBilledModel(List<ModelStat> byBilledModel) { this.byBilledModel = byBilledModel; }
  public List<DailyStat> getDaily() { return daily; }
  public void setDaily(List<DailyStat> daily) { this.daily = daily; }
  public List<UserStat> getTopUsers() { return topUsers; }
  public void setTopUsers(List<UserStat> topUsers) { this.topUsers = topUsers; }

  public record FeatureStat(String feature, long calls, long tokens, BigDecimal costCny) {}

  public record ModelStat(String billedModel, long calls, long tokens, BigDecimal costCny) {}

  public record DailyStat(String date, long calls, BigDecimal costCny) {}

  public record UserStat(Long userId, String nickname, String phone, long calls, BigDecimal costCny) {}
}
