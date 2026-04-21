#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成食物占位图：default.png + 库中 TOP50 对应的 {id}.png（与 V018 image 字段一致）。
用法（在项目根目录）:
  pip install -r tools/requirements-food-images.txt
  python tools/gen_food_image_assets.py --mysql-password YOUR_PWD
环境变量 MYSQL_PWD 可代替 --mysql-password。
输出目录默认: backend/uploads/food-images
"""
from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("请先执行: pip install -r tools/requirements-food-images.txt", file=sys.stderr)
    sys.exit(1)

SIZE = 256
BG = (232, 245, 233)  # #e8f5e9
BORDER = (184, 217, 140)  # #b8d98c
TEXT = (33, 33, 33)


def load_font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        r"C:\Windows\Fonts\msyh.ttc",
        r"C:\Windows\Fonts\msyhbd.ttc",
        r"C:\Windows\Fonts\simhei.ttf",
        "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc",
        "/System/Library/Fonts/PingFang.ttc",
    ]
    for p in candidates:
        if os.path.isfile(p):
            try:
                return ImageFont.truetype(p, size)
            except OSError:
                continue
    return ImageFont.load_default()


def draw_card(name: str, subtitle: str | None = None) -> Image.Image:
    img = Image.new("RGB", (SIZE, SIZE), BG)
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle((4, 4, SIZE - 5, SIZE - 5), radius=16, outline=BORDER, width=3)
    font_title = load_font(22)
    font_sub = load_font(14)
    text = name.strip() or "食物"
    # 简单换行
    lines: list[str] = []
    max_chars = 8
    i = 0
    while i < len(text):
        lines.append(text[i : i + max_chars])
        i += max_chars
    if len(lines) > 3:
        lines = lines[:2] + [lines[2][:6] + "…"]
    y = 72
    for line in lines:
        bbox = draw.textbbox((0, 0), line, font=font_title)
        w = bbox[2] - bbox[0]
        draw.text(((SIZE - w) // 2, y), line, fill=TEXT, font=font_title)
        y += 30
    if subtitle:
        bbox = draw.textbbox((0, 0), subtitle, font=font_sub)
        w = bbox[2] - bbox[0]
        draw.text(((SIZE - w) // 2, SIZE - 48), subtitle, fill=(97, 97, 97), font=font_sub)
    return img


def mysql_top50_rows(mysql_bin: str, password: str) -> list[tuple[int, str]]:
    q = (
        "SELECT f.id, f.name FROM food f "
        "INNER JOIN ( "
        "SELECT id FROM ( "
        "SELECT f2.id AS id, COALESCE(d.cnt, 0) AS cnt "
        "FROM food f2 "
        "LEFT JOIN ( "
        "SELECT food_id, COUNT(*) AS cnt FROM diet_record WHERE food_id IS NOT NULL GROUP BY food_id "
        ") d ON d.food_id = f2.id "
        "WHERE f2.status = 1 "
        "ORDER BY cnt DESC, f2.id ASC "
        "LIMIT 50 "
        ") AS ranked "
        ") AS t ON f.id = t.id "
        "ORDER BY f.id"
    )
    cmd = [
        mysql_bin,
        "-h",
        "127.0.0.1",
        "-P",
        "3306",
        "-u",
        "root",
        f"-p{password}",
        "-N",
        "-e",
        f"USE loseweight; {q}",
    ]
    out = subprocess.check_output(cmd, stderr=subprocess.STDOUT, text=True, encoding="utf-8")
    rows: list[tuple[int, str]] = []
    for line in out.strip().splitlines():
        parts = line.split("\t", 1)
        if len(parts) != 2:
            continue
        rows.append((int(parts[0].strip()), parts[1].strip()))
    return rows


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--out-dir",
        type=Path,
        default=root / "backend" / "uploads" / "food-images",
        help="PNG 输出目录（与 app.upload.food-image-dir 一致）",
    )
    parser.add_argument("--mysql-bin", default="mysql", help="mysql 客户端可执行文件")
    parser.add_argument(
        "--mysql-password",
        default=os.environ.get("MYSQL_PWD", ""),
        help="MySQL 密码；也可用环境变量 MYSQL_PWD",
    )
    args = parser.parse_args()
    out_dir: Path = args.out_dir
    out_dir.mkdir(parents=True, exist_ok=True)

    draw_card("食物", "占位图").save(out_dir / "default.png", format="PNG")
    print(f"Wrote {out_dir / 'default.png'}")

    pwd = args.mysql_password
    if not pwd:
        print("未提供 MySQL 密码，仅生成 default.png。使用 --mysql-password 或 MYSQL_PWD 可生成 TOP50。", file=sys.stderr)
        return

    try:
        rows = mysql_top50_rows(args.mysql_bin, pwd)
    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        print(f"查询 TOP50 失败: {e}", file=sys.stderr)
        sys.exit(1)

    for fid, name in rows:
        path = out_dir / f"{fid}.png"
        draw_card(name, "热门食物").save(path, format="PNG")
        print(f"Wrote {path}")
    print(f"Done. {len(rows)} food thumbnails.")


if __name__ == "__main__":
    main()
