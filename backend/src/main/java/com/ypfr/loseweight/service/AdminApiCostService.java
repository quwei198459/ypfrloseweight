package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.ApiPriceConfig;
import com.ypfr.loseweight.domain.ApiUsageLog;
import com.ypfr.loseweight.mapper.ApiPriceConfigMapper;
import com.ypfr.loseweight.mapper.ApiUsageLogMapper;
import com.ypfr.loseweight.mapper.DeepSeekUsageLogMapper;
import com.ypfr.loseweight.web.dto.admin.AiCostSummaryVo;
import com.ypfr.loseweight.web.dto.admin.ApiPriceConfigUpdateRequest;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

/** 统一汇总：第三方接口费（api_usage_log）+ DeepSeek 费（deepseek_usage_log），按功能合并。 */
@Service
public class AdminApiCostService {

  private static final List<String> FEATURES = List.of("food", "skin", "tcm");

  private static final Map<String, String> FEATURE_NAMES =
      Map.of("food", "食物识别", "skin", "皮肤检测", "tcm", "舌诊");

  private final ApiUsageLogMapper apiUsageMapper;
  private final ApiPriceConfigMapper priceConfigMapper;
  private final DeepSeekUsageLogMapper deepseekMapper;

  public AdminApiCostService(
      ApiUsageLogMapper apiUsageMapper,
      ApiPriceConfigMapper priceConfigMapper,
      DeepSeekUsageLogMapper deepseekMapper) {
    this.apiUsageMapper = apiUsageMapper;
    this.priceConfigMapper = priceConfigMapper;
    this.deepseekMapper = deepseekMapper;
  }

  public AiCostSummaryVo summary(LocalDate from, LocalDate to) {
    LocalDate[] range = normalizeRange(from, to);
    LocalDateTime fromTs = range[0].atStartOfDay();
    LocalDateTime toTs = range[1].plusDays(1).atStartOfDay();

    // 接口费：按功能（成功调用计入 vendorSuccessCalls，cost 由免费/失败决定）
    Map<String, long[]> vendorCalls = new LinkedHashMap<>(); // feature -> [calls, successCalls]
    Map<String, BigDecimal> vendorCost = new LinkedHashMap<>();
    for (Map<String, Object> r :
        apiUsageMapper.selectMaps(
            apiBase(fromTs, toTs)
                .select(
                    "feature",
                    "count(*) as calls",
                    "sum(success) as succ",
                    "sum(cost_cny) as cost")
                .groupBy("feature"))) {
      String f = asStr(r.get("feature"));
      vendorCalls.put(f, new long[] {asLong(r.get("calls")), asLong(r.get("succ"))});
      vendorCost.put(f, asDecimal(r.get("cost")));
    }

    // DeepSeek 费：按功能
    Map<String, long[]> dsCalls = new LinkedHashMap<>(); // feature -> [calls]
    Map<String, BigDecimal> dsCost = new LinkedHashMap<>();
    for (Map<String, Object> r :
        deepseekMapper.selectMaps(
            dsBase(fromTs, toTs)
                .select("feature", "count(*) as calls", "sum(cost_cny) as cost")
                .groupBy("feature"))) {
      String f = asStr(r.get("feature"));
      dsCalls.put(f, new long[] {asLong(r.get("calls"))});
      dsCost.put(f, asDecimal(r.get("cost")));
    }

    List<AiCostSummaryVo.FeatureCost> byFeature = new ArrayList<>();
    BigDecimal totalVendor = BigDecimal.ZERO;
    BigDecimal totalDs = BigDecimal.ZERO;
    for (String f : FEATURES) {
      long[] vc = vendorCalls.getOrDefault(f, new long[] {0, 0});
      BigDecimal vCost = vendorCost.getOrDefault(f, BigDecimal.ZERO);
      long[] dc = dsCalls.getOrDefault(f, new long[] {0});
      BigDecimal dCost = dsCost.getOrDefault(f, BigDecimal.ZERO);
      totalVendor = totalVendor.add(vCost);
      totalDs = totalDs.add(dCost);
      byFeature.add(
          new AiCostSummaryVo.FeatureCost(
              f,
              FEATURE_NAMES.getOrDefault(f, f),
              vc[0],
              vc[1],
              vCost,
              dc[0],
              dCost,
              vCost.add(dCost)));
    }

    // 按供应商
    Map<String, String> providerNames = providerDisplayNames();
    List<AiCostSummaryVo.ProviderStat> byProvider = new ArrayList<>();
    for (Map<String, Object> r :
        apiUsageMapper.selectMaps(
            apiBase(fromTs, toTs)
                .select(
                    "provider",
                    "count(*) as calls",
                    "sum(success) as succ",
                    "sum(free) as freecnt",
                    "sum(cost_cny) as cost")
                .groupBy("provider")
                .orderByDesc("cost"))) {
      String p = asStr(r.get("provider"));
      byProvider.add(
          new AiCostSummaryVo.ProviderStat(
              p,
              providerNames.getOrDefault(p, p),
              asLong(r.get("calls")),
              asLong(r.get("succ")),
              asLong(r.get("freecnt")),
              asDecimal(r.get("cost"))));
    }

    // 每日：接口费 + DeepSeek 费
    Map<String, BigDecimal> vendorDaily = new LinkedHashMap<>();
    for (Map<String, Object> r :
        apiUsageMapper.selectMaps(
            apiBase(fromTs, toTs)
                .select("date(created_at) as d", "sum(cost_cny) as cost")
                .groupBy("date(created_at)"))) {
      vendorDaily.put(asStr(r.get("d")), asDecimal(r.get("cost")));
    }
    Map<String, BigDecimal> dsDaily = new LinkedHashMap<>();
    for (Map<String, Object> r :
        deepseekMapper.selectMaps(
            dsBase(fromTs, toTs)
                .select("date(created_at) as d", "sum(cost_cny) as cost")
                .groupBy("date(created_at)"))) {
      dsDaily.put(asStr(r.get("d")), asDecimal(r.get("cost")));
    }
    java.util.TreeSet<String> days = new java.util.TreeSet<>();
    days.addAll(vendorDaily.keySet());
    days.addAll(dsDaily.keySet());
    List<AiCostSummaryVo.DailyCost> daily = new ArrayList<>();
    for (String d : days) {
      BigDecimal v = vendorDaily.getOrDefault(d, BigDecimal.ZERO);
      BigDecimal s = dsDaily.getOrDefault(d, BigDecimal.ZERO);
      daily.add(new AiCostSummaryVo.DailyCost(d, v, s, v.add(s)));
    }

    AiCostSummaryVo vo = new AiCostSummaryVo();
    vo.setFrom(range[0]);
    vo.setTo(range[1]);
    vo.setVendorCostCny(totalVendor);
    vo.setDeepseekCostCny(totalDs);
    vo.setTotalCostCny(totalVendor.add(totalDs));
    vo.setByFeature(byFeature);
    vo.setByProvider(byProvider);
    vo.setDaily(daily);
    return vo;
  }

  public List<ApiPriceConfig> listPrices() {
    return priceConfigMapper.selectList(
        new LambdaQueryWrapper<ApiPriceConfig>().orderByAsc(ApiPriceConfig::getId));
  }

  public ApiPriceConfig updatePrice(Long id, ApiPriceConfigUpdateRequest req) {
    ApiPriceConfig cfg = priceConfigMapper.selectById(id);
    if (cfg == null) {
      throw new ApiException(404, "单价配置不存在");
    }
    if (req.getUnitPriceCny() != null) {
      if (req.getUnitPriceCny().signum() < 0) {
        throw new ApiException(400, "单价不能为负");
      }
      cfg.setUnitPriceCny(req.getUnitPriceCny());
    }
    if (req.getUnitsPerCall() != null) {
      cfg.setUnitsPerCall(Math.max(0, req.getUnitsPerCall()));
    }
    if (req.getFreeQuota() != null) {
      cfg.setFreeQuota(Math.max(0, req.getFreeQuota()));
    }
    if (req.getFreeUntil() != null) {
      cfg.setFreeUntil(req.getFreeUntil());
    }
    if (req.getEnabled() != null) {
      cfg.setEnabled(req.getEnabled() == 0 ? 0 : 1);
    }
    if (req.getRemark() != null) {
      cfg.setRemark(req.getRemark().trim());
    }
    priceConfigMapper.updateById(cfg);
    return priceConfigMapper.selectById(id);
  }

  public List<ApiUsageLog> recentLogs(
      LocalDate from, LocalDate to, String feature, String provider, Integer limit) {
    LocalDate[] range = normalizeRange(from, to);
    QueryWrapper<ApiUsageLog> w = apiBase(range[0].atStartOfDay(), range[1].plusDays(1).atStartOfDay());
    if (StringUtils.hasText(feature)) {
      w.eq("feature", feature.trim());
    }
    if (StringUtils.hasText(provider)) {
      w.eq("provider", provider.trim());
    }
    int n = limit == null ? 200 : Math.min(1000, Math.max(1, limit));
    w.orderByDesc("id").last("LIMIT " + n);
    return apiUsageMapper.selectList(w);
  }

  private Map<String, String> providerDisplayNames() {
    Map<String, String> map = new LinkedHashMap<>();
    for (ApiPriceConfig c : listPrices()) {
      map.put(c.getProvider(), c.getDisplayName());
    }
    return map;
  }

  private QueryWrapper<ApiUsageLog> apiBase(LocalDateTime fromTs, LocalDateTime toTs) {
    QueryWrapper<ApiUsageLog> w = new QueryWrapper<>();
    w.ge("created_at", fromTs).lt("created_at", toTs);
    return w;
  }

  private QueryWrapper<com.ypfr.loseweight.domain.DeepSeekUsageLog> dsBase(
      LocalDateTime fromTs, LocalDateTime toTs) {
    QueryWrapper<com.ypfr.loseweight.domain.DeepSeekUsageLog> w = new QueryWrapper<>();
    w.ge("created_at", fromTs).lt("created_at", toTs);
    return w;
  }

  private static LocalDate[] normalizeRange(LocalDate from, LocalDate to) {
    LocalDate today = LocalDate.now();
    LocalDate f = from != null ? from : today.withDayOfMonth(1);
    LocalDate t = to != null ? to : today;
    if (t.isBefore(f)) {
      LocalDate tmp = f;
      f = t;
      t = tmp;
    }
    return new LocalDate[] {f, t};
  }

  private static long asLong(Object o) {
    return o instanceof Number ? ((Number) o).longValue() : 0L;
  }

  private static BigDecimal asDecimal(Object o) {
    if (o instanceof BigDecimal) {
      return (BigDecimal) o;
    }
    if (o instanceof Number) {
      return BigDecimal.valueOf(((Number) o).doubleValue());
    }
    return BigDecimal.ZERO;
  }

  private static String asStr(Object o) {
    return o == null ? null : String.valueOf(o);
  }
}
