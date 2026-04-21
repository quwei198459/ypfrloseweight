package com.ypfr.loseweight.web.dto.admin;

/** 管理后台首页统计 */
public class AdminDashboardStatsVo {

  /** lw_user 行数 */
  private long userTotal;
  /** food 行数 */
  private long foodTotal;
  /** 当日 meal_record 行数（按 Asia/Shanghai 的「今天」与 record_date 对齐） */
  private long todayMealRecordTotal;

  public long getUserTotal() {
    return userTotal;
  }

  public void setUserTotal(long userTotal) {
    this.userTotal = userTotal;
  }

  public long getFoodTotal() {
    return foodTotal;
  }

  public void setFoodTotal(long foodTotal) {
    this.foodTotal = foodTotal;
  }

  public long getTodayMealRecordTotal() {
    return todayMealRecordTotal;
  }

  public void setTodayMealRecordTotal(long todayMealRecordTotal) {
    this.todayMealRecordTotal = todayMealRecordTotal;
  }
}
