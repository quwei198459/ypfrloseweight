"""常量与标签映射。"""
from __future__ import annotations

CHANNEL_NAME = "mxnzp"

# API 路径（相对域名，不含 host）
PATH_TYPE_LIST = "/api/food_heat/type/list"
PATH_FOOD_LIST = "/api/food_heat/food/list"
PATH_FOOD_SEARCH = "/api/food_heat/food/search"
PATH_FOOD_DETAILS = "/api/food_heat/food/details"
PATH_IMAGES_LIST = "/api/food_heat/images/list"

# 搜索补采时 item 的“虚拟分类”归属
SEARCH_CATEGORY_PLACEHOLDER = "special_search"


def level_to_label(v) -> str | None:
    """healthLevel / health_light / healthLight：1 推荐 2 适量 3 少吃"""
    if v is None:
        return None
    s = str(v).strip()
    if not s:
        return None
    return {"1": "推荐", "2": "适量", "3": "少吃"}.get(s)
