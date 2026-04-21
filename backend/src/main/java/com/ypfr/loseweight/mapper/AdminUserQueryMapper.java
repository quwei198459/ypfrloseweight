package com.ypfr.loseweight.mapper;

import com.ypfr.loseweight.web.dto.admin.AdminUserListItemVo;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface AdminUserQueryMapper {

  @Select({
    "<script>",
    "SELECT u.id, u.nickname, u.phone, u.status, u.created_at AS createdAt, ",
    "p.gender, p.age, p.height_cm AS heightCm, p.current_weight_kg AS currentWeightKg, p.target_weight_kg AS targetWeightKg ",
    "FROM lw_user u ",
    "LEFT JOIN user_profile p ON p.user_id = u.id ",
    "<where>",
    "<if test='keyword != null and keyword != \"\"'>",
    "  (u.nickname LIKE CONCAT('%', #{keyword}, '%') OR u.phone LIKE CONCAT('%', #{keyword}, '%'))",
    "</if>",
    "</where>",
    "ORDER BY u.id DESC LIMIT #{offset}, #{limit}",
    "</script>"
  })
  List<AdminUserListItemVo> list(
      @Param("keyword") String keyword, @Param("offset") int offset, @Param("limit") int limit);

  @Select({
    "<script>",
    "SELECT COUNT(1) FROM lw_user u ",
    "<where>",
    "<if test='keyword != null and keyword != \"\"'>",
    "  (u.nickname LIKE CONCAT('%', #{keyword}, '%') OR u.phone LIKE CONCAT('%', #{keyword}, '%'))",
    "</if>",
    "</where>",
    "</script>"
  })
  long count(@Param("keyword") String keyword);
}
