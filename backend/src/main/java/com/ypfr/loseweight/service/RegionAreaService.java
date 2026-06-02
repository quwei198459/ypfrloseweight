package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.domain.RegionArea;
import com.ypfr.loseweight.mapper.RegionAreaMapper;
import com.ypfr.loseweight.web.dto.RegionAreaVo;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;

@Service
public class RegionAreaService {

  private final RegionAreaMapper regionAreaMapper;

  public RegionAreaService(RegionAreaMapper regionAreaMapper) {
    this.regionAreaMapper = regionAreaMapper;
  }

  public List<RegionAreaVo> tree() {
    List<RegionArea> rows = regionAreaMapper.selectList(
        new LambdaQueryWrapper<RegionArea>()
            .eq(RegionArea::getStatus, 1)
            .orderByAsc(RegionArea::getLevel)
            .orderByAsc(RegionArea::getSortOrder)
            .orderByAsc(RegionArea::getCode));
    Map<String, RegionAreaVo> map = new LinkedHashMap<>();
    List<RegionAreaVo> roots = new ArrayList<>();
    for (RegionArea row : rows) {
      RegionAreaVo vo = toVo(row);
      map.put(row.getCode(), vo);
      if (row.getLevel() != null && row.getLevel() == 1) {
        roots.add(vo);
      }
    }
    for (RegionArea row : rows) {
      if (row.getLevel() != null && row.getLevel() > 1) {
        RegionAreaVo parent = map.get(row.getParentCode());
        RegionAreaVo child = map.get(row.getCode());
        if (parent != null && child != null) {
          parent.getChildren().add(child);
        }
      }
    }
    return roots;
  }

  private RegionAreaVo toVo(RegionArea row) {
    RegionAreaVo vo = new RegionAreaVo();
    vo.setCode(row.getCode());
    vo.setName(row.getName());
    vo.setLevel(row.getLevel());
    return vo;
  }
}
