package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.domain.FoodCategory;
import com.ypfr.loseweight.mapper.FoodCategoryMapper;
import com.ypfr.loseweight.web.dto.FoodCategoryItemVo;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class FoodCategoryListService {

  private final FoodCategoryMapper foodCategoryMapper;

  public FoodCategoryListService(FoodCategoryMapper foodCategoryMapper) {
    this.foodCategoryMapper = foodCategoryMapper;
  }

  /** 仅返回已配置 code 且启用的分类，供食物查询页侧栏使用 */
  public List<FoodCategoryItemVo> listSidebarCategories() {
    LambdaQueryWrapper<FoodCategory> w = new LambdaQueryWrapper<>();
    w.eq(FoodCategory::getStatus, 1).isNotNull(FoodCategory::getCode).ne(FoodCategory::getCode, "");
    w.orderByAsc(FoodCategory::getSortNo).orderByAsc(FoodCategory::getId);
    return foodCategoryMapper.selectList(w).stream()
        .filter(c -> StringUtils.hasText(c.getCode()))
        .map(
            c ->
                new FoodCategoryItemVo(
                    c.getCode().trim(), c.getName(), c.getSortNo() != null ? c.getSortNo() : 0))
        .collect(Collectors.toList());
  }
}
