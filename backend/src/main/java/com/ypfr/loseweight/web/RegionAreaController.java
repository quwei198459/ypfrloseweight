package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.RegionAreaService;
import com.ypfr.loseweight.web.dto.RegionAreaVo;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/regions")
public class RegionAreaController {

  private final RegionAreaService regionAreaService;

  public RegionAreaController(RegionAreaService regionAreaService) {
    this.regionAreaService = regionAreaService;
  }

  @GetMapping("/tree")
  public ApiResponse<List<RegionAreaVo>> tree() {
    return ApiResponse.ok(regionAreaService.tree());
  }
}
