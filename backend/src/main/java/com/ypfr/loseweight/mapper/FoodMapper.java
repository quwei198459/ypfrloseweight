package com.ypfr.loseweight.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ypfr.loseweight.domain.Food;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface FoodMapper extends BaseMapper<Food> {

  @Select({
    "<script>",
    "SELECT f.*, c.name AS category FROM food f ",
    "LEFT JOIN food_category c ON c.id = f.category_id ",
    "WHERE f.name LIKE CONCAT('%', #{kw}, '%') ",
    "<choose><when test='uid != null'>",
    "AND (f.creator_user_id IS NULL OR f.creator_user_id = #{uid}) ",
    "</when><otherwise>",
    "AND f.creator_user_id IS NULL ",
    "</otherwise></choose>",
    "ORDER BY f.name ASC LIMIT #{lim}",
    "</script>"
  })
  List<Food> searchWithCategory(
      @Param("kw") String kw, @Param("lim") int lim, @Param("uid") Long uid);

  /** 「常用」：公共 common 分类 + 当前用户自定义食物；可选关键词 */
  @Select({
    "<script>",
    "SELECT f.*, cat.name AS category FROM food f ",
    "INNER JOIN food_category cat ON cat.id = f.category_id ",
    "<where>",
    "f.status = 1 ",
    "AND ( (cat.code = 'common' AND f.creator_user_id IS NULL) ",
    "<if test='uid != null'> OR (f.is_custom = 1 AND f.creator_user_id = #{uid}) </if>",
    ") ",
    "<if test='kw != null and kw.length() &gt; 0'> AND f.name LIKE CONCAT('%', #{kw}, '%') </if>",
    "</where>",
    "ORDER BY f.is_custom DESC, f.name ASC LIMIT #{lim}",
    "</script>"
  })
  List<Food> searchInCommonBucket(
      @Param("kw") String kw, @Param("lim") int lim, @Param("uid") Long uid);

  /** 指定分类 code（非 common）：仅公共库 */
  @Select({
    "<script>",
    "SELECT f.*, cat.name AS category FROM food f ",
    "INNER JOIN food_category cat ON cat.id = f.category_id ",
    "<where>",
    "f.status = 1 ",
    "AND cat.code = #{catCode} ",
    "AND (f.creator_user_id IS NULL ",
    "<if test='uid != null'> OR (f.is_custom = 1 AND f.creator_user_id = #{uid}) </if>",
    ") ",
    "<if test='kw != null and kw.length() &gt; 0'> AND f.name LIKE CONCAT('%', #{kw}, '%') </if>",
    "</where>",
    "ORDER BY f.name ASC LIMIT #{lim}",
    "</script>"
  })
  List<Food> searchInCategoryCode(
      @Param("catCode") String catCode,
      @Param("kw") String kw,
      @Param("lim") int lim,
      @Param("uid") Long uid);
}
