package com.ypfr.loseweight.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ypfr.loseweight.domain.DeepSeekUsageLog;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

/**
 * 统一解析 DeepSeek /chat/completions 返回里的 usage，按官方价格折算单次费用并打印结构化日志。
 *
 * <p>价格来源：https://api-docs.deepseek.com/zh-cn/quick_start/pricing/ （单位：人民币元 / 百万 token）
 * <ul>
 *   <li>deepseek-chat → deepseek-v4-flash：缓存命中 ¥0.02、未命中 ¥1、输出 ¥2</li>
 *   <li>deepseek-reasoner → deepseek-v4-pro：缓存命中 ¥0.025、未命中 ¥3、输出 ¥6</li>
 * </ul>
 *
 * <p>日志统一前缀 {@code DEEPSEEK_USAGE}，便于按功能对账：
 * <pre>grep DEEPSEEK_USAGE app.log | grep feature=skin | awk -F'costCNY=' '{s+=$2} END{print s}'</pre>
 */
@Component
public class DeepSeekUsageLogger {

  private static final Logger log = LoggerFactory.getLogger(DeepSeekUsageLogger.class);

  // 单价：人民币元 / 百万 token
  private static final double FLASH_CACHE_HIT = 0.02;
  private static final double FLASH_CACHE_MISS = 1.0;
  private static final double FLASH_OUTPUT = 2.0;
  private static final double PRO_CACHE_HIT = 0.025;
  private static final double PRO_CACHE_MISS = 3.0;
  private static final double PRO_OUTPUT = 6.0;
  private static final double PER_MILLION = 1_000_000d;

  private final ObjectMapper objectMapper;
  private final DeepSeekUsagePersister persister;

  public DeepSeekUsageLogger(ObjectMapper objectMapper, DeepSeekUsagePersister persister) {
    this.objectMapper = objectMapper;
    this.persister = persister;
  }

  /**
   * @param feature 业务功能：food / skin / tcm
   * @param scene   细分场景：模板 promptKey 或餐次等
   * @param model   实际请求的模型名（如 deepseek-chat）
   * @param responseBody DeepSeek 原始响应体（含 usage）
   */
  public void record(String feature, String scene, String model, String responseBody) {
    if (!StringUtils.hasText(responseBody)) {
      return;
    }
    try {
      JsonNode usage = objectMapper.readTree(responseBody).path("usage");
      if (usage.isMissingNode() || usage.isNull()) {
        log.info("DEEPSEEK_USAGE feature={} scene={} model={} usage=NA", feature, scene, model);
        return;
      }
      long prompt = usage.path("prompt_tokens").asLong(0);
      long completion = usage.path("completion_tokens").asLong(0);
      long total = usage.path("total_tokens").asLong(prompt + completion);
      long cacheHit =
          usage.has("prompt_cache_hit_tokens")
              ? usage.path("prompt_cache_hit_tokens").asLong(0)
              : usage.path("prompt_tokens_details").path("cached_tokens").asLong(0);
      long cacheMiss =
          usage.has("prompt_cache_miss_tokens")
              ? usage.path("prompt_cache_miss_tokens").asLong(0)
              : Math.max(0, prompt - cacheHit);

      double[] price = priceOf(model);
      double cost =
          cacheHit / PER_MILLION * price[0]
              + cacheMiss / PER_MILLION * price[1]
              + completion / PER_MILLION * price[2];

      log.info(
          "DEEPSEEK_USAGE feature={} scene={} model={} billed={} prompt={} cacheHit={} cacheMiss={} completion={} total={} costCNY={}",
          feature,
          scene,
          model,
          billedName(model),
          prompt,
          cacheHit,
          cacheMiss,
          completion,
          total,
          String.format("%.6f", cost));

      try {
        DeepSeekUsageLog row = new DeepSeekUsageLog();
        row.setFeature(feature);
        row.setScene(clip(scene, 64));
        row.setModel(clip(model, 64));
        row.setBilledModel(billedName(model));
        DeepSeekUsageContext.Ctx ctx = DeepSeekUsageContext.get();
        if (ctx != null) {
          row.setUserId(ctx.userId());
          row.setRecordId(ctx.recordId());
        }
        row.setPromptTokens((int) prompt);
        row.setCacheHitTokens((int) cacheHit);
        row.setCacheMissTokens((int) cacheMiss);
        row.setCompletionTokens((int) completion);
        row.setTotalTokens((int) total);
        row.setCostCny(BigDecimal.valueOf(cost).setScale(6, RoundingMode.HALF_UP));
        row.setCreatedAt(LocalDateTime.now());
        persister.save(row);
      } catch (Exception persistError) {
        log.warn(
            "DEEPSEEK_USAGE persist_failed feature={} scene={} reason={}",
            feature,
            scene,
            persistError.getMessage());
      }
    } catch (Exception e) {
      log.warn(
          "DEEPSEEK_USAGE parse_failed feature={} scene={} model={} reason={}",
          feature,
          scene,
          model,
          e.getMessage());
    }
  }

  private static String clip(String s, int max) {
    if (s == null) {
      return null;
    }
    return s.length() <= max ? s : s.substring(0, max);
  }

  /** @return {缓存命中, 未命中, 输出} 单价（元/百万 token）。 */
  private static double[] priceOf(String model) {
    if (isPro(model)) {
      return new double[] {PRO_CACHE_HIT, PRO_CACHE_MISS, PRO_OUTPUT};
    }
    return new double[] {FLASH_CACHE_HIT, FLASH_CACHE_MISS, FLASH_OUTPUT};
  }

  private static String billedName(String model) {
    return isPro(model) ? "deepseek-v4-pro" : "deepseek-v4-flash";
  }

  private static boolean isPro(String model) {
    String m = model == null ? "" : model.toLowerCase();
    return m.contains("reasoner") || m.contains("pro");
  }
}
