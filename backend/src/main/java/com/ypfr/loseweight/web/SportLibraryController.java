package com.ypfr.loseweight.web;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.domain.SportItem;
import com.ypfr.loseweight.mapper.SportItemMapper;
import java.util.List;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/sport-library")
public class SportLibraryController {

  private final SportItemMapper sportItemMapper;

  public SportLibraryController(SportItemMapper sportItemMapper) {
    this.sportItemMapper = sportItemMapper;
  }

  @GetMapping("/search")
  public ApiResponse<List<SportItem>> search(
      @RequestParam(required = false) String q, @RequestParam(defaultValue = "50") int limit) {
    int lim = Math.min(Math.max(limit, 1), 200);
    LambdaQueryWrapper<SportItem> w = new LambdaQueryWrapper<>();
    if (StringUtils.hasText(q)) {
      w.like(SportItem::getName, q.trim());
    }
    w.orderByAsc(SportItem::getName).last("LIMIT " + lim);
    return ApiResponse.ok(sportItemMapper.selectList(w));
  }
}
