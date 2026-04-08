package com.ypfr.loseweight.web;

import com.ypfr.loseweight.common.ApiResponse;
import com.ypfr.loseweight.service.UserService;
import com.ypfr.loseweight.service.WeekStatsService;
import com.ypfr.loseweight.web.dto.AppUserDto;
import com.ypfr.loseweight.web.dto.WeekStatsDto;
import java.time.LocalDate;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/users")
public class UserController {

  private final UserService userService;
  private final WeekStatsService weekStatsService;

  public UserController(UserService userService, WeekStatsService weekStatsService) {
    this.userService = userService;
    this.weekStatsService = weekStatsService;
  }

  @GetMapping("/{id}")
  public ApiResponse<AppUserDto> getUser(@PathVariable Long id) {
    return ApiResponse.ok(userService.getUser(id));
  }

  @GetMapping("/{userId}/week-stats")
  public ApiResponse<WeekStatsDto> weekStats(
      @PathVariable Long userId,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
      @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
    return ApiResponse.ok(weekStatsService.build(userId, startDate, endDate));
  }
}
