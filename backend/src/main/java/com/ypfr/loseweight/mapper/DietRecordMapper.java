package com.ypfr.loseweight.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ypfr.loseweight.domain.DietRecordRow;
import com.ypfr.loseweight.mapper.row.StatDateCalories;
import com.ypfr.loseweight.mapper.row.StatDateMacros;
import com.ypfr.loseweight.mapper.row.StatDateMealWindow;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface DietRecordMapper extends BaseMapper<DietRecordRow> {

  @Select(
      "SELECT COALESCE(SUM(calories_total), 0) FROM diet_record WHERE user_id = #{userId} "
          + "AND record_date = #{day}")
  BigDecimal sumCaloriesByUserAndDate(@Param("userId") Long userId, @Param("day") LocalDate day);

  @Select(
      "SELECT record_date AS stat_date, COALESCE(SUM(calories_total), 0) AS total_calories "
          + "FROM diet_record WHERE user_id = #{userId} "
          + "AND record_date BETWEEN #{start} AND #{end} "
          + "GROUP BY record_date")
  List<StatDateCalories> sumCaloriesByDateRange(
      @Param("userId") Long userId,
      @Param("start") LocalDate start,
      @Param("end") LocalDate end);

  @Select(
      "SELECT record_date AS stat_date, MIN(record_time) AS first_at, MAX(record_time) AS last_at "
          + "FROM diet_record WHERE user_id = #{userId} "
          + "AND record_date BETWEEN #{start} AND #{end} "
          + "GROUP BY record_date")
  List<StatDateMealWindow> selectMealWindowsByDateRange(
      @Param("userId") Long userId,
      @Param("start") LocalDate start,
      @Param("end") LocalDate end);

  @Select(
      "SELECT record_date AS stat_date, "
          + "COALESCE(SUM(protein_total_g), 0) AS protein_g, COALESCE(SUM(fat_total_g), 0) AS fat_g, "
          + "COALESCE(SUM(carb_total_g), 0) AS carbs_g "
          + "FROM diet_record WHERE user_id = #{userId} "
          + "AND record_date BETWEEN #{start} AND #{end} "
          + "GROUP BY record_date")
  List<StatDateMacros> sumMacrosByDateRange(
      @Param("userId") Long userId,
      @Param("start") LocalDate start,
      @Param("end") LocalDate end);
}
