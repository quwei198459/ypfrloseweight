package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.VipProductService;
import com.ypfr.loseweight.web.dto.VipProductVo;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/vip")
public class VipProductController {

  private final VipProductService vipProductService;

  public VipProductController(VipProductService vipProductService) {
    this.vipProductService = vipProductService;
  }

  /** 开通页档位列表（无需登录） */
  @GetMapping("/products")
  public ApiResponse<List<VipProductVo>> listProducts() {
    return ApiResponse.ok(vipProductService.listEnabledProducts());
  }
}
