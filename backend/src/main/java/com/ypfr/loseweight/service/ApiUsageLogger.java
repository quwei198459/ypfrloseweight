package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.domain.ApiPriceConfig;
import com.ypfr.loseweight.domain.ApiUsageLog;
import com.ypfr.loseweight.mapper.ApiPriceConfigMapper;
import com.ypfr.loseweight.mapper.ApiUsageLogMapper;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * 记录一次第三方检测接口调用的用量与费用。
 *
 * <p>口径：成功才计费（billable=1），失败 cost=0；单价/单元数/免费额度来自 {@code api_price_config}
 * （管理员可在后台改），命中免费额度则 cost=0、free=1。落库走 {@link ApiUsagePersister}（REQUIRES_NEW），
 * 失败不影响主流程。
 */
@Component
public class ApiUsageLogger {

  private static final Logger log = LoggerFactory.getLogger(ApiUsageLogger.class);

  public static final String PROVIDER_FOOD = "aliyun_food";
  public static final String PROVIDER_SKIN = "yimei_skin";
  public static final String PROVIDER_TCM = "maijing_tcm";

  private final ApiPriceConfigMapper priceConfigMapper;
  private final ApiUsageLogMapper usageLogMapper;
  private final ApiUsagePersister persister;

  public ApiUsageLogger(
      ApiPriceConfigMapper priceConfigMapper,
      ApiUsageLogMapper usageLogMapper,
      ApiUsagePersister persister) {
    this.priceConfigMapper = priceConfigMapper;
    this.usageLogMapper = usageLogMapper;
    this.persister = persister;
  }

  /**
   * @param provider 供应商 PROVIDER_FOOD / PROVIDER_SKIN / PROVIDER_TCM
   * @param feature  food / skin / tcm
   * @param success  第三方是否成功返回可用结果（失败不计费）
   * @param error    失败原因（成功传 null）
   */
  public void record(
      String provider, String feature, Long userId, Long recordId, boolean success, String error) {
    try {
      ApiPriceConfig cfg = loadConfig(provider);
      int units = cfg != null && cfg.getUnitsPerCall() != null ? Math.max(0, cfg.getUnitsPerCall()) : 1;
      BigDecimal unitPrice =
          cfg != null && cfg.getUnitPriceCny() != null ? cfg.getUnitPriceCny() : BigDecimal.ZERO;
      boolean enabled = cfg == null || cfg.getEnabled() == null || cfg.getEnabled() == 1;

      ApiUsageLog row = new ApiUsageLog();
      row.setProvider(provider);
      row.setFeature(feature);
      row.setUserId(userId);
      row.setRecordId(recordId);
      row.setSuccess(success ? 1 : 0);
      row.setUnits(units);
      row.setUnitPriceCny(unitPrice);
      row.setError(clip(error, 255));
      row.setCreatedAt(LocalDateTime.now());

      if (!success) {
        row.setBillable(0);
        row.setFree(0);
        row.setCostCny(BigDecimal.ZERO);
      } else {
        boolean free = enabled && hitsFreeQuota(cfg, provider);
        row.setBillable(1);
        row.setFree(free ? 1 : 0);
        BigDecimal cost =
            (!enabled || free)
                ? BigDecimal.ZERO
                : unitPrice.multiply(BigDecimal.valueOf(units)).setScale(6, RoundingMode.HALF_UP);
        row.setCostCny(cost);
      }

      persister.save(row);
    } catch (Exception e) {
      log.warn(
          "API_USAGE persist_failed provider={} feature={} success={} reason={}",
          provider,
          feature,
          success,
          e.getMessage());
    }
  }

  private boolean hitsFreeQuota(ApiPriceConfig cfg, String provider) {
    if (cfg == null || cfg.getFreeQuota() == null || cfg.getFreeQuota() <= 0) {
      return false;
    }
    if (cfg.getFreeUntil() != null && LocalDate.now().isAfter(cfg.getFreeUntil())) {
      return false;
    }
    // 已发生的成功调用数 < 免费额度 → 本次免费
    Long usedSuccess =
        usageLogMapper.selectCount(
            new LambdaQueryWrapper<ApiUsageLog>()
                .eq(ApiUsageLog::getProvider, provider)
                .eq(ApiUsageLog::getSuccess, 1));
    return (usedSuccess == null ? 0L : usedSuccess) < cfg.getFreeQuota();
  }

  private ApiPriceConfig loadConfig(String provider) {
    try {
      return priceConfigMapper.selectOne(
          new LambdaQueryWrapper<ApiPriceConfig>()
              .eq(ApiPriceConfig::getProvider, provider)
              .last("LIMIT 1"));
    } catch (Exception e) {
      // api_price_config 未迁移时不阻断主流程，按未配置(0 价)处理
      log.warn("API_USAGE load_price_failed provider={} reason={}", provider, e.getMessage());
      return null;
    }
  }

  private static String clip(String s, int max) {
    if (s == null) {
      return null;
    }
    return s.length() <= max ? s : s.substring(0, max);
  }
}
