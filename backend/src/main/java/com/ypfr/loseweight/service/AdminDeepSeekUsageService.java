package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.ypfr.loseweight.domain.DeepSeekUsageLog;
import com.ypfr.loseweight.domain.LoseWeightUser;
import com.ypfr.loseweight.mapper.DeepSeekUsageLogMapper;
import com.ypfr.loseweight.mapper.LoseWeightUserMapper;
import com.ypfr.loseweight.web.dto.admin.DeepSeekUsageSummaryVo;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class AdminDeepSeekUsageService {

  private final DeepSeekUsageLogMapper usageMapper;
  private final LoseWeightUserMapper userMapper;

  public AdminDeepSeekUsageService(DeepSeekUsageLogMapper usageMapper, LoseWeightUserMapper userMapper) {
    this.usageMapper = usageMapper;
    this.userMapper = userMapper;
  }

  /** 汇总：总计 + 按功能 + 按计费模型 + 每日趋势 + 费用最高用户。 */
  public DeepSeekUsageSummaryVo summary(LocalDate from, LocalDate to) {
    LocalDate[] range = normalizeRange(from, to);
    LocalDateTime fromTs = range[0].atStartOfDay();
    LocalDateTime toTs = range[1].plusDays(1).atStartOfDay();

    DeepSeekUsageSummaryVo vo = new DeepSeekUsageSummaryVo();
    vo.setFrom(range[0]);
    vo.setTo(range[1]);

    Map<String, Object> totals =
        first(
            usageMapper.selectMaps(
                base(fromTs, toTs)
                    .select("count(*) as calls", "sum(total_tokens) as tokens", "sum(cost_cny) as cost")));
    vo.setTotalCalls(asLong(totals.get("calls")));
    vo.setTotalTokens(asLong(totals.get("tokens")));
    vo.setTotalCostCny(asDecimal(totals.get("cost")));

    List<DeepSeekUsageSummaryVo.FeatureStat> byFeature = new ArrayList<>();
    for (Map<String, Object> r :
        usageMapper.selectMaps(
            base(fromTs, toTs)
                .select("feature", "count(*) as calls", "sum(total_tokens) as tokens", "sum(cost_cny) as cost")
                .groupBy("feature")
                .orderByDesc("cost"))) {
      byFeature.add(
          new DeepSeekUsageSummaryVo.FeatureStat(
              asStr(r.get("feature")), asLong(r.get("calls")), asLong(r.get("tokens")), asDecimal(r.get("cost"))));
    }
    vo.setByFeature(byFeature);

    List<DeepSeekUsageSummaryVo.ModelStat> byModel = new ArrayList<>();
    for (Map<String, Object> r :
        usageMapper.selectMaps(
            base(fromTs, toTs)
                .select("billed_model", "count(*) as calls", "sum(total_tokens) as tokens", "sum(cost_cny) as cost")
                .groupBy("billed_model")
                .orderByDesc("cost"))) {
      byModel.add(
          new DeepSeekUsageSummaryVo.ModelStat(
              asStr(r.get("billed_model")), asLong(r.get("calls")), asLong(r.get("tokens")), asDecimal(r.get("cost"))));
    }
    vo.setByBilledModel(byModel);

    List<DeepSeekUsageSummaryVo.DailyStat> daily = new ArrayList<>();
    for (Map<String, Object> r :
        usageMapper.selectMaps(
            base(fromTs, toTs)
                .select("date(created_at) as d", "count(*) as calls", "sum(cost_cny) as cost")
                .groupBy("date(created_at)")
                .orderByAsc("d"))) {
      daily.add(
          new DeepSeekUsageSummaryVo.DailyStat(
              asStr(r.get("d")), asLong(r.get("calls")), asDecimal(r.get("cost"))));
    }
    vo.setDaily(daily);

    List<Map<String, Object>> userRows =
        usageMapper.selectMaps(
            base(fromTs, toTs)
                .select("user_id", "count(*) as calls", "sum(cost_cny) as cost")
                .isNotNull("user_id")
                .groupBy("user_id")
                .orderByDesc("cost")
                .last("LIMIT 20"));
    Map<Long, LoseWeightUser> userMap = loadUsers(userRows);
    List<DeepSeekUsageSummaryVo.UserStat> topUsers = new ArrayList<>();
    for (Map<String, Object> r : userRows) {
      Long uid = asLongObj(r.get("user_id"));
      LoseWeightUser u = uid == null ? null : userMap.get(uid);
      topUsers.add(
          new DeepSeekUsageSummaryVo.UserStat(
              uid,
              u == null ? null : u.getNickname(),
              u == null ? null : u.getPhone(),
              asLong(r.get("calls")),
              asDecimal(r.get("cost"))));
    }
    vo.setTopUsers(topUsers);
    return vo;
  }

  /** 最近 N 条明细（默认 200，最多 1000），可按功能过滤。 */
  public List<DeepSeekUsageLog> recentLogs(LocalDate from, LocalDate to, String feature, Integer limit) {
    LocalDate[] range = normalizeRange(from, to);
    QueryWrapper<DeepSeekUsageLog> w = base(range[0].atStartOfDay(), range[1].plusDays(1).atStartOfDay());
    if (StringUtils.hasText(feature)) {
      w.eq("feature", feature.trim());
    }
    int n = limit == null ? 200 : Math.min(1000, Math.max(1, limit));
    w.orderByDesc("id").last("LIMIT " + n);
    return usageMapper.selectList(w);
  }

  private Map<Long, LoseWeightUser> loadUsers(List<Map<String, Object>> rows) {
    List<Long> ids = new ArrayList<>();
    for (Map<String, Object> r : rows) {
      Long id = asLongObj(r.get("user_id"));
      if (id != null) {
        ids.add(id);
      }
    }
    Map<Long, LoseWeightUser> map = new HashMap<>();
    if (!ids.isEmpty()) {
      for (LoseWeightUser u : userMapper.selectBatchIds(ids)) {
        map.put(u.getId(), u);
      }
    }
    return map;
  }

  private QueryWrapper<DeepSeekUsageLog> base(LocalDateTime fromTs, LocalDateTime toTs) {
    QueryWrapper<DeepSeekUsageLog> w = new QueryWrapper<>();
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

  private static Map<String, Object> first(List<Map<String, Object>> rows) {
    return rows == null || rows.isEmpty() || rows.get(0) == null ? new LinkedHashMap<>() : rows.get(0);
  }

  private static long asLong(Object o) {
    return o instanceof Number ? ((Number) o).longValue() : 0L;
  }

  private static Long asLongObj(Object o) {
    return o instanceof Number ? ((Number) o).longValue() : null;
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
