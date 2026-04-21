package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.domain.VipProduct;
import com.ypfr.loseweight.mapper.VipProductMapper;
import com.ypfr.loseweight.web.dto.VipProductVo;
import java.util.Collections;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class VipProductService {

  private static final Logger log = LoggerFactory.getLogger(VipProductService.class);

  private final VipProductMapper vipProductMapper;

  public VipProductService(VipProductMapper vipProductMapper) {
    this.vipProductMapper = vipProductMapper;
  }

  public List<VipProductVo> listEnabledProducts() {
    try {
      List<VipProduct> rows =
          vipProductMapper.selectList(
              new LambdaQueryWrapper<VipProduct>()
                  .eq(VipProduct::getEnabled, 1)
                  .orderByAsc(VipProduct::getSortOrder)
                  .orderByAsc(VipProduct::getId));
      if (rows == null || rows.isEmpty()) {
        return Collections.emptyList();
      }
      return rows.stream().map(this::toVo).toList();
    } catch (Exception e) {
      log.warn("vip_product 查询失败（是否已执行 V020 迁移？）: {}", e.toString());
      return Collections.emptyList();
    }
  }

  private VipProductVo toVo(VipProduct p) {
    VipProductVo v = new VipProductVo();
    v.setCode(p.getCode());
    v.setTitle(p.getTitle());
    v.setSubtitle(p.getSubtitle());
    v.setPriceYuan(p.getPriceYuan());
    v.setOriginPriceYuan(p.getOriginPriceYuan());
    v.setDurationDays(p.getDurationDays());
    v.setCornerTag(p.getCornerTag());
    return v;
  }
}
