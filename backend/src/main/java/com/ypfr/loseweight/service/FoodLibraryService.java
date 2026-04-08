package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.domain.Food;
import com.ypfr.loseweight.mapper.FoodMapper;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class FoodLibraryService {

  private final FoodMapper foodMapper;

  public FoodLibraryService(FoodMapper foodMapper) {
    this.foodMapper = foodMapper;
  }

  /**
   * 食物库查询。
   *
   * <p>未传 categoryCode 时保持旧行为：关键词走全库模糊（含分类名 JOIN）；无关键词则按创建者过滤后 limit。
   *
   * <p>传入 categoryCode 时：按侧栏分类过滤；{@code common} 含公共「常用」+ 当前用户自定义食物。
   */
  public List<Food> search(String q, int limit, Long forUserId, String categoryCode) {
    int lim = Math.min(Math.max(limit, 1), 100);
    if (!StringUtils.hasText(categoryCode)) {
      if (StringUtils.hasText(q)) {
        return foodMapper.searchWithCategory(q.trim(), lim, forUserId);
      }
      LambdaQueryWrapper<Food> w = new LambdaQueryWrapper<>();
      if (forUserId != null) {
        w.and(
            x ->
                x.isNull(Food::getCreatorUserId)
                    .or()
                    .eq(Food::getCreatorUserId, forUserId));
      } else {
        w.isNull(Food::getCreatorUserId);
      }
      w.orderByAsc(Food::getName).last("LIMIT " + lim);
      return foodMapper.selectList(w);
    }
    String kw = StringUtils.hasText(q) ? q.trim() : null;
    String cat = categoryCode.trim();
    if ("common".equalsIgnoreCase(cat)) {
      return foodMapper.searchInCommonBucket(kw, lim, forUserId);
    }
    return foodMapper.searchInCategoryCode(cat, kw, lim, forUserId);
  }
}
