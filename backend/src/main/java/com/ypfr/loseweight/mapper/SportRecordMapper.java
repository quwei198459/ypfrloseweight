package com.ypfr.loseweight.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ypfr.loseweight.domain.SportRecord;
import com.ypfr.loseweight.mapper.row.StatDateCalories;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface SportRecordMapper extends BaseMapper<SportRecord> {

  @Select(
      "SELECT COALESCE(SUM(calories_burned), 0) FROM sport_record WHERE user_id = #{userId} "
          + "AND record_date = #{day}")
  BigDecimal sumCaloriesByUserAndDate(@Param("userId") Long userId, @Param("day") LocalDate day);

  @Select(
      "SELECT record_date AS stat_date, COALESCE(SUM(calories_burned), 0) AS total_calories "
          + "FROM sport_record WHERE user_id = #{userId} "
          + "AND record_date BETWEEN #{start} AND #{end} "
          + "GROUP BY record_date")
  List<StatDateCalories> sumCaloriesByDateRange(
      @Param("userId") Long userId,
      @Param("start") LocalDate start,
      @Param("end") LocalDate end);
}
