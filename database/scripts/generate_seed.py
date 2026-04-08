# -*- coding: utf-8 -*-
"""生成 database/02_seed.sql：食物库≥30个分类且每类≥30条（数据见 food_library_data.py）；2026-02/03 饮食与运动；长跨度体重。"""
from __future__ import annotations

import random
from datetime import date, datetime, timedelta
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "02_seed.sql"
random.seed(20260203)

from food_library_data import CATEGORY_FOODS

# 每类 (kcal/100g 约, 蛋白, 脂肪, 碳水) — 与 food_library_data 中分类名一一对应
_MACRO: dict[str, tuple[float, float, float, float]] = {
    "主食": (280, 8, 3, 52),
    "杂粮粗粮": (330, 9, 3.5, 60),
    "畜肉类": (200, 22, 12, 1),
    "禽肉类": (175, 24, 8, 2),
    "加工肉制品": (260, 14, 20, 8),
    "蛋类制品": (150, 13, 10, 2),
    "牛乳发酵乳": (65, 3.5, 3.5, 5),
    "新鲜水果": (55, 0.8, 0.3, 13),
    "叶花菜类": (22, 2, 0.3, 4),
    "根茎茄果": (35, 1.5, 0.2, 7),
    "菌藻类": (30, 3, 0.5, 5),
    "鲜豆制品": (95, 10, 5, 4),
    "干豆面筋": (380, 35, 12, 40),
    "树坚果籽": (580, 18, 50, 20),
    "淡水鱼鲜": (125, 20, 4, 0),
    "海水鱼鲜": (155, 21, 7, 0),
    "虾蟹贝类": (95, 18, 2, 3),
    "头足软体": (85, 16, 2, 4),
    "汤煲炖品": (55, 4, 2.5, 5),
    "粥品糊类": (75, 2.5, 1.2, 14),
    "火锅串串": (210, 14, 14, 8),
    "油炸烧烤": (285, 12, 18, 20),
    "西式轻食": (140, 12, 6, 12),
    "日韩料理": (165, 11, 6, 18),
    "东南亚菜": (145, 10, 7, 15),
    "烘焙糕点": (380, 7, 18, 48),
    "冷饮冰品": (195, 3, 9, 26),
    "即饮茶咖": (38, 0.5, 0, 9),
    "酒类低度": (70, 0.5, 0, 5),
    "酱腌调味": (180, 4, 8, 22),
    "休闲零食": (430, 8, 20, 55),
}


def macro_for_category(cat: str) -> tuple[float, float, float, float]:
    """calories_per_100, protein, fat, carbs 粗略模板"""
    c, p, f, cb = _MACRO.get(cat, (150, 6, 6, 18))
    j = random.uniform(-0.12, 0.12)
    return (
        round(c * (1 + j), 1),
        round(max(0.1, p * (1 + j)), 1),
        round(max(0, f * (1 + j)), 1),
        round(max(0, cb * (1 + j)), 1),
    )


def unit_for_category(cat: str) -> str:
    ml_prefer = (
        "牛乳发酵乳",
        "即饮茶咖",
        "酒类低度",
        "汤煲炖品",
        "酱腌调味",
    )
    if cat in ml_prefer:
        return "100ml" if random.random() < 0.5 else "100g"
    return "100g"


def sql_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace("'", "''")


def build_food_inserts() -> str:
    lines = ["INSERT INTO food_library (name, calories_per_100, protein, fat, carbs, unit_label, category) VALUES"]
    rows: list[str] = []
    for cat, names in CATEGORY_FOODS.items():
        for name in names:
            cal, p, f, cb = macro_for_category(cat)
            unit = unit_for_category(cat)
            rows.append(
                f"('{sql_escape(name)}', {cal}, {p}, {f}, {cb}, '{unit}', '{sql_escape(cat)}')"
            )
    lines.append(",\n".join(rows) + ";")
    return "\n".join(lines)


SNACK_FOODS = [("酸奶", 120, 100, "g"), ("苹果", 80, 120, "g"), ("香蕉", 90, 100, "g"), ("坚果", 160, 30, "g"), ("牛奶", 110, 200, "ml")]


def random_meal_rows(user_id: int, d: date) -> list[tuple]:
    """返回 (meal_type, food_name, calories, amount_value, amount_unit, recorded_at)"""
    out: list[tuple] = []
    # 早餐
    bt = datetime(d.year, d.month, d.day, 7, random.randint(10, 45), 0)
    out.append(("breakfast", "燕麦粥", random.randint(140, 220), random.randint(180, 260), "g", bt))
    out.append(("breakfast", "鸡蛋", random.randint(140, 180), random.randint(80, 120), "g", bt))
    if random.random() < 0.7:
        out.append(("breakfast", "牛奶", random.randint(90, 130), random.randint(180, 250), "ml", bt))
    # 午餐
    lt = datetime(d.year, d.month, d.day, 12, random.randint(0, 40), 0)
    out.append(("lunch", "米饭", random.randint(220, 320), random.randint(160, 240), "g", lt))
    lunch_mains = [
        ("番茄炒蛋", 160, 180, "g"),
        ("青椒肉丝", 220, 150, "g"),
        ("清蒸鲈鱼", 180, 200, "g"),
        ("宫保鸡丁", 240, 160, "g"),
        ("麻婆豆腐", 190, 200, "g"),
        ("蒜蓉西兰花", 90, 200, "g"),
    ]
    m = random.choice(lunch_mains)
    out.append(("lunch", m[0], m[1] + random.randint(-25, 25), m[2], m[3], lt))
    out.append(("lunch", "青菜", random.randint(25, 55), random.randint(80, 150), "g", lt))
    if random.random() < 0.55:
        out.append(("lunch", "紫菜蛋汤", random.randint(60, 100), random.randint(250, 350), "ml", lt))
    # 晚餐
    dt = datetime(d.year, d.month, d.day, 18, random.randint(0, 50), 0)
    if random.random() < 0.5:
        out.append(("dinner", "杂粮粥", random.randint(130, 200), random.randint(200, 300), "g", dt))
    else:
        out.append(("dinner", "荞麦面", random.randint(170, 240), random.randint(180, 260), "g", dt))
    out.append(("dinner", "鸡胸肉沙拉", random.randint(150, 220), random.randint(120, 200), "g", dt))
    if random.random() < 0.65:
        out.append(("dinner", "豆腐汤", random.randint(70, 120), random.randint(280, 380), "ml", dt))
    # 加餐
    if random.random() < 0.72:
        st = datetime(d.year, d.month, d.day, random.choice([10, 15, 16, 21]), random.randint(0, 55), 0)
        sf = random.choice(SNACK_FOODS)
        out.append(("snack", sf[0], sf[1] + random.randint(-20, 20), sf[2], sf[3], st))
    if random.random() < 0.25:
        st2 = datetime(d.year, d.month, d.day, 20, random.randint(10, 40), 0)
        out.append(("snack", "无糖酸奶", random.randint(70, 100), 150, "g", st2))
    return out


def build_meal_sql(user_id: int) -> str:
    start = date(2026, 2, 1)
    end = date(2026, 3, 31)
    values: list[str] = []
    d = start
    while d <= end:
        for row in random_meal_rows(user_id, d):
            mt, fn, cal, amt, unit, ts = row
            values.append(
                f"({user_id}, '{mt}', '{sql_escape(fn)}', {cal}, {amt}, '{unit}', '{ts.strftime('%Y-%m-%d %H:%M:%S')}')"
            )
        d += timedelta(days=1)
    return (
        "-- 2026年2月–3月 每日饮食（用户1）\n"
        "INSERT INTO meal_record (user_id, meal_type, food_name, calories, amount_value, amount_unit, recorded_at) VALUES\n"
        + ",\n".join(values)
        + ";"
    )


SPORTS = [
    ("跑步", "🏃", 6.8),
    ("跳绳", "🤸", 8.2),
    ("游泳", "🏊", 7.1),
    ("骑行", "🚴", 5.6),
    ("健步走", "🚶", 4.2),
    ("瑜伽", "🧘", 3.2),
    ("椭圆机", "🏃", 6.0),
    ("爬楼梯", "🪜", 7.5),
]

def build_sport_sql(user_id: int) -> str:
    start = date(2026, 2, 1)
    end = date(2026, 3, 31)
    values: list[str] = []
    d = start
    while d <= end:
        n = 0
        if random.random() < 0.12:
            n = 0
        elif random.random() < 0.78:
            n = 1
        else:
            n = 2
        times = sorted(
            [
                datetime(d.year, d.month, d.day, random.choice([6, 7, 12, 17, 19]), random.randint(0, 55), 0)
                for _ in range(n)
            ]
        )
        for ts in times:
            name, icon, per_min = random.choice(SPORTS)
            mins = random.randint(18, 52)
            cal = int(round(per_min * mins))
            values.append(
                f"({user_id}, '{sql_escape(name)}', {mins}, {cal}, '{icon}', '{ts.strftime('%Y-%m-%d %H:%M:%S')}')"
            )
        d += timedelta(days=1)
    return (
        "-- 2026年2月–3月 运动记录（用户1）\n"
        "INSERT INTO sport_record (user_id, sport_name, duration_min, calories, icon, recorded_at) VALUES\n"
        + ",\n".join(values)
        + ";"
    )


def build_weight_sql(user_id: int) -> str:
    """2025-06-01 至 2026-03-31 每日体重，缓慢下降 + 小幅波动"""
    start = date(2025, 6, 1)
    end = date(2026, 3, 31)
    days = (end - start).days + 1
    w0 = 79.4
    w1 = 71.2
    values: list[str] = []
    d = start
    i = 0
    while d <= end:
        t = i / max(1, days - 1)
        base = w0 + (w1 - w0) * t
        noise = random.uniform(-0.35, 0.35)
        # 周末略波动
        if d.weekday() >= 5:
            noise += random.uniform(-0.15, 0.25)
        w = round(base + noise, 2)
        w = max(70.5, min(80.0, w))
        values.append(f"({user_id}, '{d.isoformat()}', {w})")
        d += timedelta(days=1)
        i += 1
    return (
        "-- 体重历史：2025-06-01 至 2026-03-31（用户1）\n"
        "INSERT INTO weight_record (user_id, record_date, weight_kg) VALUES\n"
        + ",\n".join(values)
        + "\nON DUPLICATE KEY UPDATE weight_kg = VALUES(weight_kg);"
    )


def main() -> None:
    if len(CATEGORY_FOODS) < 30:
        raise SystemExit(f"食物分类仅 {len(CATEGORY_FOODS)} 种，需至少 30 种")
    for cat, names in CATEGORY_FOODS.items():
        if len(names) < 30:
            raise SystemExit(f"分类「{cat}」仅 {len(names)} 条，需至少 30 条")
        if cat not in _MACRO:
            raise SystemExit(f"分类「{cat}」未配置 _MACRO 营养模板")
    n_food = sum(len(v) for v in CATEGORY_FOODS.values())
    n_cat = len(CATEGORY_FOODS)
    header = f"""-- 示例与基础数据（食物库 {n_cat} 个分类、每类≥30条；2026年2-3月饮食/运动；长跨度体重）
-- 由 database/scripts/generate_seed.py 生成，修改后请运行: python database/scripts/generate_seed.py
USE loseweight;

SET NAMES utf8mb4;

-- 可重复执行：清理用户1 的示例数据（保留 app_user）
DELETE FROM sport_record WHERE user_id = 1;
DELETE FROM meal_record WHERE user_id = 1;
DELETE FROM weight_record WHERE user_id = 1;
DELETE FROM food_library;

-- 测试用户 id=1
INSERT INTO app_user (
  id, openid, nickname, gender, age, height_cm,
  current_weight_kg, target_weight_kg, initial_weight_kg, target_date,
  bmr, tdee, daily_calorie_goal, profile_completed
) VALUES (
  1, 'dev_user_1', '小明', 1, 25, 175.00,
  71.20, 65.00, 80.00, '2026-12-31',
  1750, 2100, 1600, 1
) ON DUPLICATE KEY UPDATE
  nickname = VALUES(nickname),
  height_cm = VALUES(height_cm),
  current_weight_kg = VALUES(current_weight_kg),
  target_weight_kg = VALUES(target_weight_kg),
  initial_weight_kg = VALUES(initial_weight_kg),
  daily_calorie_goal = VALUES(daily_calorie_goal),
  profile_completed = VALUES(profile_completed);

-- 食物库（{n_cat} 个分类，每类 {min(len(v) for v in CATEGORY_FOODS.values())}～{max(len(v) for v in CATEGORY_FOODS.values())} 条，共 {n_food} 条）
"""
    sport_lib = """
-- 运动库（示例）
INSERT INTO sport_library (id, name, calories_per_min, icon, category) VALUES
(1, '跑步', 6.5, '🏃', '有氧'),
(2, '跳绳', 8.0, '🤸', '有氧'),
(3, '游泳', 7.0, '🏊', '有氧'),
(4, '骑行', 5.5, '🚴', '有氧'),
(5, '健步走', 4.0, '🚶', '有氧'),
(6, '瑜伽', 3.0, '🧘', '柔韧'),
(7, '俯卧撑', 5.0, '💪', '力量'),
(8, '深蹲', 5.5, '🏋️', '力量'),
(9, '椭圆机', 6.0, '🏃', '有氧'),
(10, '爬楼梯', 7.5, '🪜', '有氧')
ON DUPLICATE KEY UPDATE calories_per_min = VALUES(calories_per_min);
"""
    body = "\n".join(
        [
            header,
            build_food_inserts(),
            "",
            sport_lib.strip(),
            "",
            build_meal_sql(1),
            "",
            build_sport_sql(1),
            "",
            build_weight_sql(1),
            "",
        ]
    )
    OUT.write_text(body, encoding="utf-8")
    print(f"Wrote {OUT} ({n_food} foods, categories={len(CATEGORY_FOODS)})")


if __name__ == "__main__":
    main()
