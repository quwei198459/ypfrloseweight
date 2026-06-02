package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.SkinDetectionItemConfig;
import com.ypfr.loseweight.mapper.SkinDetectionItemConfigMapper;
import com.ypfr.loseweight.web.dto.admin.SkinDetectionItemConfigRequest;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class SkinDetectionItemConfigService {

  private final SkinDetectionItemConfigMapper mapper;

  public SkinDetectionItemConfigService(SkinDetectionItemConfigMapper mapper) {
    this.mapper = mapper;
  }

  public List<SkinDetectionItemConfig> listEnabled() {
    return mapper.selectList(
        new LambdaQueryWrapper<SkinDetectionItemConfig>()
            .eq(SkinDetectionItemConfig::getEnabled, 1)
            .orderByAsc(SkinDetectionItemConfig::getSortOrder)
            .orderByAsc(SkinDetectionItemConfig::getId));
  }

  public List<SkinDetectionItemConfig> listAll() {
    return mapper.selectList(
        new LambdaQueryWrapper<SkinDetectionItemConfig>()
            .orderByAsc(SkinDetectionItemConfig::getSortOrder)
            .orderByAsc(SkinDetectionItemConfig::getId));
  }

  public long calculateEnabledDetectTypes() {
    long total = 0L;
    for (SkinDetectionItemConfig item : listEnabled()) {
      if (item.getDetectType() != null && item.getDetectType() > 0) {
        total += item.getDetectType();
      }
    }
    return total;
  }

  public SkinDetectionItemConfig update(Long id, SkinDetectionItemConfigRequest req) {
    SkinDetectionItemConfig item = mapper.selectById(id);
    if (item == null) {
      throw new ApiException(404, "检测项配置不存在");
    }
    item.setItemName(trimRequired(req.getItemName(), "展示名称不能为空"));
    item.setDisplayName(trimRequired(req.getDisplayName(), "短名称不能为空"));
    item.setSortOrder(req.getSortOrder());
    item.setEnabled(req.getEnabled() != null && req.getEnabled() == 1 ? 1 : 0);
    item.setScaleType(trimRequired(req.getScaleType(), "分档类型不能为空"));
    item.setScoreDirection(trimRequired(req.getScoreDirection(), "分数方向不能为空"));
    item.setPromptKey(trimRequired(req.getPromptKey(), "提示词 key 不能为空"));
    item.setRemark(blankToNull(req.getRemark()));
    mapper.updateById(item);
    return mapper.selectById(id);
  }

  private static String trimRequired(String value, String message) {
    if (!StringUtils.hasText(value)) {
      throw new ApiException(400, message);
    }
    return value.trim();
  }

  private static String blankToNull(String value) {
    return StringUtils.hasText(value) ? value.trim() : null;
  }
}
