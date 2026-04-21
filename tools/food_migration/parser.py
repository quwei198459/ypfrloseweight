"""热量/单位轻量推理、GI 与宏量解析（规则为主，预留 AI 扩展点）。"""
from __future__ import annotations

import re
from decimal import Decimal
from typing import Any

# 液体倾向关键词（名称子串匹配）
LIQUID_KEYWORDS = (
    "牛奶",
    "饮料",
    "果汁",
    "豆浆",
    "奶茶",
    "茶",
    "咖啡",
    "酒",
    "汤",
    "露",
    "奶昔",
    "酸奶",
    "汽水",
    "可乐",
    "矿泉水",
    "纯净水",
    "椰汁",
    "椰奶",
    "米浆",
    "粥",
    "糊",
)

# (触发子串, 默认单位, 默认标准量, 标准量单位, 置信度备注)
_UNIT_RULES: list[tuple[str, str, Decimal, str, str]] = [
    ("酸奶", "盒", Decimal("200"), "g", "酸奶默认盒"),
    ("牛奶", "杯", Decimal("250"), "ml", "牛奶默认杯"),
    ("豆浆", "杯", Decimal("250"), "ml", "豆浆默认杯"),
    ("咖啡", "杯", Decimal("250"), "ml", "咖啡默认杯"),
    ("茶", "杯", Decimal("250"), "ml", "茶默认杯"),
    ("米饭", "碗", Decimal("150"), "g", "米饭默认碗"),
    ("稀饭", "碗", Decimal("250"), "g", "稀饭近似"),
    ("粥", "碗", Decimal("250"), "g", "粥近似"),
    ("面包", "片", Decimal("25"), "g", "面包默认片"),
    ("吐司", "片", Decimal("25"), "g", "吐司默认片"),
    ("鸡蛋", "个", Decimal("50"), "g", "鸡蛋默认个"),
    ("鸭蛋", "个", Decimal("60"), "g", "鸭蛋近似"),
    ("苹果", "个", Decimal("180"), "g", "苹果默认个"),
    ("梨", "个", Decimal("180"), "g", "梨近似个"),
    ("橙子", "个", Decimal("200"), "g", "橙子近似个"),
    ("香蕉", "根", Decimal("100"), "g", "香蕉默认根"),
    ("饮料", "瓶", Decimal("500"), "ml", "饮料默认瓶"),
    ("矿泉水", "瓶", Decimal("500"), "ml", "矿泉水默认瓶"),
    ("可乐", "罐", Decimal("330"), "ml", "罐装饮料"),
]


def _parse_number(s: str | None) -> Decimal | None:
    if s is None:
        return None
    t = str(s).strip().replace(",", "")
    if not t:
        return None
    m = re.search(r"-?\d+(\.\d+)?", t)
    if not m:
        return None
    try:
        return Decimal(m.group(0))
    except Exception:
        return None


def is_liquid_by_name(food_name: str) -> bool:
    name = (food_name or "").strip()
    return any(k in name for k in LIQUID_KEYWORDS)


# 仅「单位名称」→ 默认标准量（人工已填 unit_name、未填 standard 时用）
# 液体与固体对「碗/杯」等可能不同，见 infer_standard_weight_for_manual_unit
_DEFAULT_WEIGHT_BY_UNIT_SOLID: dict[str, tuple[Decimal, str]] = {
    "碗": (Decimal("150"), "g"),
    "碟": (Decimal("100"), "g"),
    "盘": (Decimal("200"), "g"),
    "份": (Decimal("150"), "g"),
    "块": (Decimal("50"), "g"),
    "根": (Decimal("100"), "g"),
    "条": (Decimal("50"), "g"),
    "片": (Decimal("25"), "g"),
    "颗": (Decimal("10"), "g"),
    "粒": (Decimal("5"), "g"),
    "勺": (Decimal("15"), "g"),
    "调羹": (Decimal("15"), "g"),
    "袋": (Decimal("100"), "g"),
    "包": (Decimal("80"), "g"),
    "盒": (Decimal("200"), "g"),
    "斤": (Decimal("500"), "g"),
    "两": (Decimal("50"), "g"),
    "个": (Decimal("100"), "g"),
    "只": (Decimal("120"), "g"),
    "枚": (Decimal("50"), "g"),
}

_DEFAULT_WEIGHT_BY_UNIT_LIQUID: dict[str, tuple[Decimal, str]] = {
    "杯": (Decimal("250"), "ml"),
    "碗": (Decimal("250"), "ml"),
    "瓶": (Decimal("500"), "ml"),
    "罐": (Decimal("330"), "ml"),
    "盒": (Decimal("200"), "ml"),
    "袋": (Decimal("200"), "ml"),
    "包": (Decimal("250"), "ml"),
}


def infer_standard_weight_for_manual_unit(
    food_name: str,
    unit_name: str | None,
    energy_basis: str | None,
    is_liquid: int | bool,
) -> tuple[Decimal | None, str | None, str]:
    """
    人工补全 unit_name 后，若未填 standard_weight_*，用规则猜标准量。
    返回 (standard_weight_value, standard_weight_unit, reason_note)。
    """
    name = (food_name or "").strip()
    u = (unit_name or "").strip()
    if not u:
        return None, None, "无单位"
    basis = (energy_basis or "unknown").strip()
    liquid = bool(is_liquid) or basis == "100ml"

    for kw, un, sv, su, note in _UNIT_RULES:
        if un == u and kw in name:
            return sv, su, note

    if u in ("个", "只"):
        if "蛋" in name:
            return Decimal("50"), "g", "个+蛋→50g"
        if "苹果" in name:
            return Decimal("180"), "g", "个+苹果→180g"
        if "梨" in name and "雪" not in name:
            return Decimal("180"), "g", "个+梨→180g"
        if "橙" in name or "橘子" in name:
            return Decimal("200"), "g", "个+柑橘→200g"
        if "香蕉" in name:
            return Decimal("100"), "g", "根/个香蕉→100g"
        if any(x in name for x in ("土豆", "马铃薯", "红薯", "山药", "芋头")):
            return Decimal("150"), "g", "个+薯类→150g"
        if "玉米" in name:
            return Decimal("200"), "g", "个+玉米→200g"
        return Decimal("100"), "g", "个→默认100g"

    tab = _DEFAULT_WEIGHT_BY_UNIT_LIQUID if liquid else _DEFAULT_WEIGHT_BY_UNIT_SOLID
    hit = tab.get(u)
    if hit:
        tag = "液体默认表" if liquid else "固体默认表"
        return hit[0], hit[1], tag
    if liquid and u in _DEFAULT_WEIGHT_BY_UNIT_SOLID:
        sv, su = _DEFAULT_WEIGHT_BY_UNIT_SOLID[u]
        if su == "g":
            return sv, "ml", "液体且仅固体表→按ml近似"
        return sv, su, "液体回退固体表"
    return None, None, "无映射"


def compute_calories_per_unit_from_row(
    _energy_basis: str | None,
    calories_per_100g: Decimal | None,
    calories_per_100ml: Decimal | None,
    standard_weight_value: Decimal | None,
    standard_weight_unit: str | None,
) -> Decimal | None:
    """
    calories_per_unit ≈ 每百克/百毫升热量 × 标准量 / 100。
    - 标准为 g：优先用 calories_per_100g。
    - 标准为 ml：优先用 calories_per_100ml；若无则用 calories_per_100g 近似（与 staging 口径一致时的折中）。
    """
    if standard_weight_value is None or not standard_weight_unit:
        return None
    su = str(standard_weight_unit).strip().lower()
    sv = Decimal(str(standard_weight_value))

    if su in ("g", "克"):
        if calories_per_100g is None:
            return None
        return (calories_per_100g * sv / Decimal(100)).quantize(Decimal("0.01"))

    if su in ("ml", "毫升"):
        ref = calories_per_100ml
        if ref is None:
            ref = calories_per_100g
        if ref is None:
            return None
        return (ref * sv / Decimal(100)).quantize(Decimal("0.01"))

    return None


def infer_energy_and_unit(
    food_name: str,
    raw_calory_value: Decimal | None,
    raw_calory_desc: str | None,
) -> dict[str, Any]:
    """
    返回候选字段字典，供写入 check_food_staging；需人工审核后再入正式表。
    """
    name = (food_name or "").strip()
    desc = (raw_calory_desc or "").strip()
    liquid = is_liquid_by_name(name)

    cal: Decimal | None = raw_calory_value
    if cal is None and desc:
        cal = _parse_number(desc)

    basis = "unknown"
    c100g: Decimal | None = None
    c100ml: Decimal | None = None
    confidence = "低"
    reason_parts: list[str] = []

    hint = (desc or "").lower()
    if "100ml" in hint or "百毫升" in desc or "/100ml" in hint:
        liquid = True
        reason_parts.append("描述暗示100ml")
    if "100g" in hint or "100克" in hint or "百克" in desc:
        liquid = False
        reason_parts.append("描述暗示100g")

    if liquid:
        basis = "100ml"
        c100ml = cal
        if cal is not None:
            reason_parts.append("按名称判液体→energy_basis=100ml")
    else:
        basis = "100g"
        c100g = cal
        if cal is not None:
            reason_parts.append("按名称判固体→energy_basis=100g")

    unit_name: str | None = None
    std_val: Decimal | None = None
    std_unit: str | None = None
    matched_rule = False
    for kw, u, sv, su, note in _UNIT_RULES:
        if kw in name:
            unit_name, std_val, std_unit = u, sv, su
            matched_rule = True
            reason_parts.append(note)
            break

    if not matched_rule:
        if "饭" in name and "米" in name:
            unit_name, std_val, std_unit = "碗", Decimal("150"), "g"
            reason_parts.append("泛化米饭类")
        elif liquid and any(x in name for x in ("饮料", "汁", "饮", "水", "奶", "茶", "咖啡", "酒")):
            unit_name, std_val, std_unit = "瓶", Decimal("500"), "ml"
            reason_parts.append("泛化液体默认瓶")

    if name and len(name) >= 2 and matched_rule:
        confidence = "高"
    elif name and (matched_rule or cal is not None):
        confidence = "中"
    else:
        confidence = "低"

    cpu: Decimal | None = None
    if cal is not None and std_val is not None:
        if basis == "100g" and c100g is not None:
            cpu = (c100g * std_val / Decimal(100)).quantize(Decimal("0.01"))
        elif basis == "100ml" and c100ml is not None:
            cpu = (c100ml * std_val / Decimal(100)).quantize(Decimal("0.01"))

    if cal is None:
        reason_parts.append("未解析到热量数值")

    conf_score = {"高": Decimal("0.9"), "中": Decimal("0.6"), "低": Decimal("0.3")}.get(
        confidence, Decimal("0.3")
    )

    return {
        "is_liquid": 1 if liquid else 0,
        "energy_basis": basis,
        "calories_per_100g": c100g,
        "calories_per_100ml": c100ml,
        "calories_per_unit": cpu,
        "unit_name": unit_name,
        "standard_weight_value": std_val,
        "standard_weight_unit": std_unit,
        "confidence_score": conf_score,
        "inference_reason": "; ".join(reason_parts) if reason_parts else "无",
    }


def _gi_label_to_level(label: str | None) -> str | None:
    if not label:
        return None
    s = str(label).strip()
    if not s:
        return None
    if "高" in s:
        return "high"
    if "中" in s:
        return "medium"
    if "低" in s:
        return "low"
    sl = s.lower()
    if sl in ("high", "h"):
        return "high"
    if sl in ("medium", "mid", "m"):
        return "medium"
    if sl in ("low", "l"):
        return "low"
    return None


def _gi_value_to_level(val: Any) -> str | None:
    n = _parse_number(str(val) if val is not None else "")
    if n is None:
        return None
    if n < Decimal("55"):
        return "low"
    if n <= Decimal("70"):
        return "medium"
    return "high"


def parse_gi_level_from_detail(glycemic_info: Any) -> str | None:
    """
    仅从 glycemicInfoData JSON 解析，禁止名称推理。
    兼容 gi.lable（接口拼写）与 gi.label。
    """
    data = glycemic_info
    if isinstance(data, str):
        try:
            import json

            data = json.loads(data)
        except Exception:
            return None
    if not isinstance(data, dict):
        return None
    inner = data.get("glycemicInfoData")
    if isinstance(inner, dict):
        data = inner
    gi = data.get("gi")
    if isinstance(gi, dict):
        lv = gi.get("lable") or gi.get("label")
        level = _gi_label_to_level(str(lv) if lv is not None else None)
        if level:
            return level
        level = _gi_value_to_level(gi.get("value"))
        if level:
            return level
    return None


def _unit_is_per_100g(unit: str | None) -> bool:
    if not unit:
        return False
    u = unit.strip().lower()
    return "100g" in u or "100克" in unit or u in ("g", "克") or "/100g" in u or "克/100" in unit


def parse_macros_per_100g(
    protein: str | None,
    protein_unit: str | None,
    fat: str | None,
    fat_unit: str | None,
    carb: str | None,
    carb_unit: str | None,
) -> tuple[Decimal | None, Decimal | None, Decimal | None]:
    """仅当单位可判断为每 100g 口径时返回。"""
    p = f = c = None
    if _unit_is_per_100g(protein_unit):
        p = _parse_number(protein)
    if _unit_is_per_100g(fat_unit):
        f = _parse_number(fat)
    if _unit_is_per_100g(carb_unit):
        c = _parse_number(carb)
    return p, f, c


def parse_calory_from_detail(calory: str | None, calory_unit: str | None) -> tuple[Decimal | None, str | None]:
    v = _parse_number(calory)
    u = calory_unit.strip() if calory_unit else None
    return v, u


def light_clean_name(name: str) -> str:
    s = (name or "").strip()
    s = re.sub(r"[（(].*?[）)]", "", s)
    s = re.sub(r"\s+", "", s)
    return s


def build_keywords(
    formal_name: str,
    channel_food_name: str,
    category_name: str | None,
    max_len: int = 256,
) -> str:
    parts: list[str] = []
    seen: set[str] = set()

    def add(x: str) -> None:
        t = light_clean_name(x)
        if len(t) < 1:
            return
        if t not in seen:
            seen.add(t)
            parts.append(t)

    add(formal_name)
    add(channel_food_name)
    if category_name:
        add(category_name)
    out = " ".join(parts)
    if len(out) <= max_len:
        return out
    return out[: max_len - 1] + "…"
