package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.TcmDetectionItemConfig;
import com.ypfr.loseweight.mapper.TcmDetectionItemConfigMapper;
import com.ypfr.loseweight.web.dto.admin.TcmDetectionItemConfigRequest;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class TcmDetectionItemConfigService {

  private final TcmDetectionItemConfigMapper mapper;

  public TcmDetectionItemConfigService(TcmDetectionItemConfigMapper mapper) {
    this.mapper = mapper;
  }

  public List<TcmDetectionItemConfig> listEnabled() {
    return mapper.selectList(
        new LambdaQueryWrapper<TcmDetectionItemConfig>()
            .eq(TcmDetectionItemConfig::getEnabled, 1)
            .orderByAsc(TcmDetectionItemConfig::getSortOrder)
            .orderByAsc(TcmDetectionItemConfig::getId));
  }

  public List<TcmDetectionItemConfig> listAll() {
    return mapper.selectList(
        new LambdaQueryWrapper<TcmDetectionItemConfig>()
            .orderByAsc(TcmDetectionItemConfig::getSortOrder)
            .orderByAsc(TcmDetectionItemConfig::getId));
  }

  public TcmDetectionItemConfig update(Long id, TcmDetectionItemConfigRequest req) {
    TcmDetectionItemConfig item = mapper.selectById(id);
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
