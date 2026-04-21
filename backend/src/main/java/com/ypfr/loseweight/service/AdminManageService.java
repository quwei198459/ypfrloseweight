package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.Food;
import com.ypfr.loseweight.domain.FoodCategory;
import com.ypfr.loseweight.domain.LoseWeightUser;
import com.ypfr.loseweight.domain.MealRecord;
import com.ypfr.loseweight.domain.SportItem;
import com.ypfr.loseweight.mapper.AdminUserQueryMapper;
import com.ypfr.loseweight.mapper.FoodCategoryMapper;
import com.ypfr.loseweight.mapper.FoodMapper;
import com.ypfr.loseweight.mapper.LoseWeightUserMapper;
import com.ypfr.loseweight.mapper.MealRecordMapper;
import com.ypfr.loseweight.mapper.SportItemMapper;
import com.ypfr.loseweight.web.dto.admin.AdminDashboardStatsVo;
import com.ypfr.loseweight.web.dto.admin.AdminFoodCategoryUpsertRequest;
import com.ypfr.loseweight.web.dto.admin.AdminFoodUpsertRequest;
import com.ypfr.loseweight.web.dto.admin.AdminPagedResult;
import com.ypfr.loseweight.web.dto.admin.AdminSportItemVo;
import com.ypfr.loseweight.web.dto.admin.AdminSportUpsertRequest;
import com.ypfr.loseweight.web.dto.admin.AdminUserListItemVo;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class AdminManageService {

  private static final ZoneId APP_ZONE = ZoneId.of("Asia/Shanghai");

  private final FoodCategoryMapper foodCategoryMapper;
  private final FoodMapper foodMapper;
  private final SportItemMapper sportItemMapper;
  private final AdminUserQueryMapper adminUserQueryMapper;
  private final LoseWeightUserMapper loseWeightUserMapper;
  private final MealRecordMapper mealRecordMapper;

  public AdminManageService(
      FoodCategoryMapper foodCategoryMapper,
      FoodMapper foodMapper,
      SportItemMapper sportItemMapper,
      AdminUserQueryMapper adminUserQueryMapper,
      LoseWeightUserMapper loseWeightUserMapper,
      MealRecordMapper mealRecordMapper) {
    this.foodCategoryMapper = foodCategoryMapper;
    this.foodMapper = foodMapper;
    this.sportItemMapper = sportItemMapper;
    this.adminUserQueryMapper = adminUserQueryMapper;
    this.loseWeightUserMapper = loseWeightUserMapper;
    this.mealRecordMapper = mealRecordMapper;
  }

  /** 首页统计：用户总数、食物条数、当日餐次记录数 */
  public AdminDashboardStatsVo dashboardStats() {
    long users = loseWeightUserMapper.selectCount(new LambdaQueryWrapper<LoseWeightUser>());
    long foods = foodMapper.selectCount(new LambdaQueryWrapper<Food>());
    LocalDate today = LocalDate.now(APP_ZONE);
    long todayMeals =
        mealRecordMapper.selectCount(
            new LambdaQueryWrapper<MealRecord>().eq(MealRecord::getRecordDate, today));
    AdminDashboardStatsVo vo = new AdminDashboardStatsVo();
    vo.setUserTotal(users);
    vo.setFoodTotal(foods);
    vo.setTodayMealRecordTotal(todayMeals);
    return vo;
  }

  public AdminPagedResult<AdminUserListItemVo> listUsers(String keyword, int page, int pageSize) {
    String kw = keyword == null ? "" : keyword.trim();
    int p = Math.max(page, 1);
    int ps = Math.min(Math.max(pageSize, 1), 100);
    int offset = (p - 1) * ps;
    long total = adminUserQueryMapper.count(kw);
    List<AdminUserListItemVo> rows = adminUserQueryMapper.list(kw, offset, ps);
    AdminPagedResult<AdminUserListItemVo> resp = new AdminPagedResult<>();
    resp.setTotal(total);
    resp.setPage(p);
    resp.setPageSize(ps);
    resp.setList(rows);
    return resp;
  }

  public List<FoodCategory> listFoodCategories() {
    return foodCategoryMapper.selectList(
        new LambdaQueryWrapper<FoodCategory>().orderByAsc(FoodCategory::getSortNo).orderByAsc(FoodCategory::getId));
  }

  public FoodCategory createFoodCategory(AdminFoodCategoryUpsertRequest req) {
    assertCategoryCodeUnique(req.getCode(), null);
    FoodCategory item = new FoodCategory();
    fillFoodCategory(item, req);
    foodCategoryMapper.insert(item);
    return item;
  }

  public FoodCategory updateFoodCategory(Long id, AdminFoodCategoryUpsertRequest req) {
    FoodCategory item = requireFoodCategory(id);
    assertCategoryCodeUnique(req.getCode(), id);
    fillFoodCategory(item, req);
    foodCategoryMapper.updateById(item);
    return item;
  }

  public void deleteFoodCategory(Long id) {
    long refCount =
        foodMapper.selectCount(new LambdaQueryWrapper<Food>().eq(Food::getCategoryId, id).last("LIMIT 1"));
    if (refCount > 0) {
      throw new ApiException(400, "该分类下存在食物，不能删除");
    }
    foodCategoryMapper.deleteById(id);
  }

  public List<Food> listFoods(String keyword, Integer status) {
    LambdaQueryWrapper<Food> w = new LambdaQueryWrapper<>();
    if (StringUtils.hasText(keyword)) {
      w.like(Food::getName, keyword.trim());
    }
    if (status != null) {
      w.eq(Food::getStatus, status);
    }
    w.orderByDesc(Food::getId).last("LIMIT 500");
    return foodMapper.selectList(w);
  }

  public Food createFood(AdminFoodUpsertRequest req) {
    Food item = new Food();
    fillFood(item, req);
    foodMapper.insert(item);
    return item;
  }

  public Food updateFood(Long id, AdminFoodUpsertRequest req) {
    Food item = requireFood(id);
    fillFood(item, req);
    foodMapper.updateById(item);
    return item;
  }

  public void deleteFood(Long id) {
    foodMapper.deleteById(id);
  }

  public List<AdminSportItemVo> listSports(String keyword, Integer status) {
    LambdaQueryWrapper<SportItem> w = new LambdaQueryWrapper<>();
    if (StringUtils.hasText(keyword)) {
      w.like(SportItem::getName, keyword.trim());
    }
    if (status != null) {
      w.eq(SportItem::getStatus, status);
    }
    w.orderByAsc(SportItem::getSortNo).orderByDesc(SportItem::getId).last("LIMIT 500");
    return sportItemMapper.selectList(w).stream().map(this::toSportVo).collect(Collectors.toList());
  }

  public AdminSportItemVo createSport(AdminSportUpsertRequest req) {
    SportItem item = new SportItem();
    fillSport(item, req);
    sportItemMapper.insert(item);
    SportItem saved = sportItemMapper.selectById(item.getId());
    return saved != null ? toSportVo(saved) : toSportVo(item);
  }

  public AdminSportItemVo updateSport(Long id, AdminSportUpsertRequest req) {
    SportItem item = requireSport(id);
    fillSport(item, req);
    sportItemMapper.updateById(item);
    SportItem saved = sportItemMapper.selectById(id);
    return saved != null ? toSportVo(saved) : toSportVo(item);
  }

  public void deleteSport(Long id) {
    sportItemMapper.deleteById(id);
  }

  private FoodCategory requireFoodCategory(Long id) {
    FoodCategory item = foodCategoryMapper.selectById(id);
    if (item == null) {
      throw new ApiException(404, "食物分类不存在");
    }
    return item;
  }

  private Food requireFood(Long id) {
    Food item = foodMapper.selectById(id);
    if (item == null) {
      throw new ApiException(404, "食物不存在");
    }
    return item;
  }

  private SportItem requireSport(Long id) {
    SportItem item = sportItemMapper.selectById(id);
    if (item == null) {
      throw new ApiException(404, "运动项目不存在");
    }
    return item;
  }

  private AdminSportItemVo toSportVo(SportItem s) {
    AdminSportItemVo v = new AdminSportItemVo();
    v.setId(s.getId());
    v.setCreatorUserId(s.getCreatorUserId());
    v.setName(s.getName());
    v.setIcon(s.getIcon());
    v.setCaloriesPer60min(s.getCaloriesPer60min());
    v.setCategory(s.getCategory());
    v.setIsCustom(s.getIsCustom());
    v.setStatus(s.getStatus());
    v.setSortNo(s.getSortNo());
    v.setCreatedAt(s.getCreatedAt());
    v.setUpdatedAt(s.getUpdatedAt());
    return v;
  }

  private void fillFoodCategory(FoodCategory item, AdminFoodCategoryUpsertRequest req) {
    item.setName(req.getName().trim());
    item.setCode(req.getCode().trim());
    item.setParentId(req.getParentId() != null && req.getParentId() > 0 ? req.getParentId() : 0L);
    item.setType(StringUtils.hasText(req.getType()) ? req.getType().trim() : "food");
    item.setSortNo(req.getSortNo() != null ? req.getSortNo() : 0);
    item.setStatus(req.getStatus());
  }

  private void fillFood(Food item, AdminFoodUpsertRequest req) {
    item.setCategoryId(req.getCategoryId());
    item.setName(req.getName().trim());
    item.setImage(defaultIfBlank(req.getImage(), "/api/v1/public/food-images/default.png"));
    item.setGiLevel(blankToNull(req.getGiLevel()));
    item.setCaloriesPer100g(nvl(req.getCaloriesPer100g()));
    item.setCaloriesPerUnit(nvl(req.getCaloriesPerUnit()));
    item.setUnitName(defaultIfBlank(req.getUnitName(), "份"));
    item.setStandardWeightG(nvl(req.getStandardWeightG()));
    item.setEdiblePortionRate(req.getEdiblePortionRate() != null ? req.getEdiblePortionRate() : BigDecimal.ONE);
    item.setProteinPer100g(nvl(req.getProteinPer100g()));
    item.setFatPer100g(nvl(req.getFatPer100g()));
    item.setCarbPer100g(nvl(req.getCarbPer100g()));
    item.setKeywords(defaultIfBlank(req.getKeywords(), item.getName()));
    item.setStatus(req.getStatus());
    item.setIsCustom(0);
    item.setCreatorUserId(null);
  }

  private void fillSport(SportItem item, AdminSportUpsertRequest req) {
    item.setName(req.getName().trim());
    item.setIcon(blankToNull(req.getIcon()));
    item.setCaloriesPer60min(req.getCaloriesPer60min());
    item.setCategory(defaultIfBlank(req.getCategory(), "other"));
    item.setSortNo(req.getSortNo() != null ? req.getSortNo() : 0);
    item.setStatus(req.getStatus());
    item.setIsCustom(0);
    item.setCreatorUserId(null);
  }

  private void assertCategoryCodeUnique(String code, Long excludeId) {
    String normalized = code == null ? "" : code.trim();
    if (!StringUtils.hasText(normalized)) {
      throw new ApiException(400, "分类编码不能为空");
    }
    LambdaQueryWrapper<FoodCategory> w = new LambdaQueryWrapper<FoodCategory>().eq(FoodCategory::getCode, normalized);
    if (excludeId != null) {
      w.ne(FoodCategory::getId, excludeId);
    }
    long count = foodCategoryMapper.selectCount(w);
    if (count > 0) {
      throw new ApiException(400, "分类编码已存在");
    }
  }

  private static String blankToNull(String value) {
    String v = value == null ? "" : value.trim();
    return v.isEmpty() ? null : v;
  }

  private static String defaultIfBlank(String value, String fallback) {
    String v = value == null ? "" : value.trim();
    return v.isEmpty() ? fallback : v;
  }

  private static BigDecimal nvl(BigDecimal v) {
    return v != null ? v : BigDecimal.ZERO;
  }
}
