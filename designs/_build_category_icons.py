#!/usr/bin/env python3
"""Append CategoryIcons group to icons.pen + export 256 PNGs to frontend/static/category/."""
from __future__ import annotations

import json
import math
import struct
import zlib
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent
ICONS_PEN = ROOT / "icons.pen"
OUT_DIR = ROOT.parent / "frontend" / "static" / "category"
SRC_DIR = ROOT.parent / "frontend" / "src" / "static" / "category"

# Align with Tab / product greens
STROKE_INACTIVE = (180, 189, 180, 255)  # #B4BDB4
STROKE_ACTIVE = (95, 168, 84, 255)  # #5FA854
FILL_ACTIVE_LIGHT = (232, 244, 224, 255)  # #E8F4E0
FILL_ACTIVE_MID = (216, 235, 207, 255)  # #D8EBCF
FILL_DOT_ACTIVE = (111, 163, 98, 255)  # #6FA362

W = H = 256
# ~90% content in inner 230 box, centered
S = 230 / 200.0  # scale from design coords (200 logical) to 230px


def clamp_box(x0, y0, x1, y1, pad=12):
    return max(pad, x0), max(pad, y0), min(W - pad, x1), min(H - pad, y1)


def png_write_rgba(path: Path, pixels: list[list[tuple[int, int, int, int]]] | Image.Image) -> None:
    if isinstance(pixels, Image.Image):
        path.parent.mkdir(parents=True, exist_ok=True)
        pixels.save(path, "PNG", optimize=True)
        return
    h = len(pixels)
    w = len(pixels[0]) if h else 0
    raw = bytearray()
    for row in pixels:
        raw.append(0)
        for r, g, b, a in row:
            raw.extend((r, g, b, a))
    zlib_obj = zlib.compressobj(9, zlib.DEFLATED, zlib.MAX_WBITS, 9, zlib.Z_DEFAULT_STRATEGY)
    compressed = zlib_obj.compress(bytes(raw)) + zlib_obj.flush()
    def chunk(tag: bytes, data: bytes) -> bytes:
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("wb") as f:
        f.write(b"\x89PNG\r\n\x1a\n")
        f.write(chunk(b"IHDR", ihdr))
        f.write(chunk(b"IDAT", compressed))
        f.write(chunk(b"IEND", b""))


def line_aa(buf, x0, y0, x1, y1, col, th: float):
    """Simple Wu-like wide line in RGBA buffer."""
    import array

    def plot(x, y, a):
        xi, yi = int(round(x)), int(round(y))
        if 0 <= xi < W and 0 <= yi < H:
            r, g, b, ba = buf[yi][xi]
            na = min(255, ba + int(a * col[3]))
            if na == 0:
                return
            inv = (a * col[3]) / max(na, 1)
            buf[yi][xi] = (
                int(r * (1 - inv) + col[0] * inv),
                int(g * (1 - inv) + col[1] * inv),
                int(b * (1 - inv) + col[2] * inv),
                na,
            )

    def draw_thick_segment(px0, py0, px1, py1):
        dx, dy = px1 - px0, py1 - py0
        ln = math.hypot(dx, dy) or 1.0
        nx, ny = -dy / ln, dx / ln
        steps = max(1, int(th * 2))
        for s in range(-steps, steps + 1):
            off = s * 0.5
            ox, oy = nx * off, ny * off
            x, y = px0 + ox, py0 + oy
            xe, ye = px1 + ox, py1 + oy
            n = int(max(abs(xe - x), abs(ye - y)) * 2) + 1
            for i in range(n + 1):
                t = i / n
                plot(x + (xe - x) * t, y + (ye - y) * t, 0.85)

    draw_thick_segment(x0, y0, x1, y1)


def ellipse_stroke_aa(buf, cx, cy, rx, ry, col, th: float, start_deg=0, sweep_deg=360):
    """Raster ellipse outline (center cx,cy)."""
    steps = max(32, int(2 * math.pi * max(rx, ry) / 2))
    pts = []
    for i in range(steps + 1):
        t = (start_deg + sweep_deg * i / steps) * math.pi / 180
        pts.append((cx + rx * math.cos(t), cy + ry * math.sin(t)))
    for i in range(len(pts) - 1):
        line_aa(buf, pts[i][0], pts[i][1], pts[i + 1][0], pts[i + 1][1], col, th)


def rounded_rect_stroke_aa(buf, x0, y0, x1, y1, r, col, th: float):
    r = min(r, (x1 - x0) / 2, (y1 - y0) / 2)
    # straight + 4 corners arcs
    # top edge
    line_aa(buf, x0 + r, y0, x1 - r, y0, col, th)
    line_aa(buf, x1, y0 + r, x1, y1 - r, col, th)
    line_aa(buf, x1 - r, y1, x0 + r, y1, col, th)
    line_aa(buf, x0, y1 - r, x0, y0 + r, col, th)
    # corner arcs as short line segments
    for cx, cy, a0, a1 in [
        (x1 - r, y0 + r, -90, 0),
        (x1 - r, y1 - r, 0, 90),
        (x0 + r, y1 - r, 90, 180),
        (x0 + r, y0 + r, 180, 270),
    ]:
        arc_pts = 12
        for i in range(arc_pts):
            t0 = math.radians(a0 + (a1 - a0) * i / arc_pts)
            t1 = math.radians(a0 + (a1 - a0) * (i + 1) / arc_pts)
            line_aa(
                buf,
                cx + r * math.cos(t0),
                cy + r * math.sin(t0),
                cx + r * math.cos(t1),
                cy + r * math.sin(t1),
                col,
                th,
            )


def flood_fill_shape(buf, seed_x, seed_y, rgba):
    if not (0 <= seed_x < W and 0 <= seed_y < H):
        return
    if buf[seed_y][seed_x][3] > 200:
        return
    stack = [(seed_x, seed_y)]
    vis = set()
    while stack:
        x, y = stack.pop()
        if (x, y) in vis:
            continue
        vis.add((x, y))
        if not (0 <= x < W and 0 <= y < H):
            continue
        if buf[y][x][3] > 80:
            continue
        buf[y][x] = rgba
        stack.extend([(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)])


def draw_breakfast(buf, active: bool):
    cx, cy = W / 2, H / 2
    col = STROKE_ACTIVE if active else STROKE_INACTIVE
    th = 10.5 if active else 9.0
    # sun (small circle top)
    ellipse_stroke_aa(buf, cx, cy - 52 * S, 34 * S, 34 * S, col, th)
    # bowl
    x0, y0 = cx - 58 * S, cy + 18 * S
    x1, y1 = cx + 58 * S, cy + 72 * S
    rounded_rect_stroke_aa(buf, x0, y0, x1, y1, 18 * S, col, th)
    if active:
        flood_fill_shape(buf, int(cx), int(cy + 45 * S), FILL_ACTIVE_LIGHT)


def draw_lunch(buf, active: bool):
    cx, cy = W / 2, H / 2
    col = STROKE_ACTIVE if active else STROKE_INACTIVE
    th = 10.5 if active else 9.0
    # plate
    ellipse_stroke_aa(buf, cx, cy + 28 * S, 72 * S, 26 * S, col, th)
    if active:
        flood_fill_shape(buf, int(cx), int(cy + 28 * S), FILL_ACTIVE_MID)
    # chopsticks (two strokes)
    line_aa(buf, cx - 8 * S, cy - 58 * S, cx + 38 * S, cy - 8 * S, col, th * 0.55)
    line_aa(buf, cx + 8 * S, cy - 62 * S, cx + 52 * S, cy - 12 * S, col, th * 0.55)


def draw_dinner(buf, active: bool):
    cx, cy = W / 2, H / 2
    col = STROKE_ACTIVE if active else STROKE_INACTIVE
    th = 10.5 if active else 9.0
    ellipse_stroke_aa(buf, cx, cy + 30 * S, 70 * S, 24 * S, col, th)
    if active:
        flood_fill_shape(buf, int(cx), int(cy + 30 * S), FILL_ACTIVE_MID)
    # 轻量「晚间」符号：右上角小圆（月亮意象，非写实）
    ellipse_stroke_aa(buf, cx + 46 * S, cy - 44 * S, 18 * S, 18 * S, col, th * 0.85)


def draw_snack(buf, active: bool):
    cx, cy = W / 2, H / 2
    col = STROKE_ACTIVE if active else STROKE_INACTIVE
    th = 10.5 if active else 9.0
    x0, y0 = cx - 44 * S, cy - 18 * S
    x1, y1 = cx + 44 * S, cy + 38 * S
    rounded_rect_stroke_aa(buf, x0, y0, x1, y1, 22 * S, col, th)
    if active:
        flood_fill_shape(buf, int(cx), int(cy + 6 * S), FILL_ACTIVE_LIGHT)
    # chip dot
    dr = 7 * S
    ellipse_stroke_aa(buf, cx + 26 * S, cy - 32 * S, dr, dr, col, th * 0.7)
    if active:
        flood_fill_shape(buf, int(cx + 26 * S), int(cy - 32 * S), FILL_DOT_ACTIVE)


def draw_sport(buf, active: bool):
    cx, cy = W / 2, H / 2
    col = STROKE_ACTIVE if active else STROKE_INACTIVE
    th = 10.5 if active else 9.0
    # activity ring
    ellipse_stroke_aa(buf, cx, cy, 62 * S, 62 * S, col, th)
    # swoosh
    pts = []
    for i in range(25):
        t = i / 24
        ang = math.radians(-120 + 200 * t)
        rr = 48 * S + 8 * S * math.sin(t * math.pi)
        pts.append((cx + rr * math.cos(ang), cy + rr * math.sin(ang)))
    for i in range(len(pts) - 1):
        line_aa(buf, pts[i][0], pts[i][1], pts[i + 1][0], pts[i + 1][1], col, th * 0.92)
    if active:
        flood_fill_shape(buf, int(cx - 35 * S), int(cy - 35 * S), FILL_ACTIVE_MID)


def trim_and_pad(im: list[list[tuple[int, int, int, int]]], pad_ratio=0.03):
    xs = []
    ys = []
    for y in range(H):
        for x in range(W):
            if im[y][x][3] > 20:
                xs.append(x)
                ys.append(y)
    if not xs:
        return im
    minx, maxx, miny, maxy = min(xs), max(xs), min(ys), max(ys)
    cw, ch = maxx - minx + 1, maxy - miny + 1
    pad = max(2, int(round(max(cw, ch) * pad_ratio)))
    minx = max(0, minx - pad)
    miny = max(0, miny - pad)
    maxx = min(W - 1, maxx + pad)
    maxy = min(H - 1, maxy + pad)
    cw, ch = maxx - minx + 1, maxy - miny + 1
    side = max(cw, ch)
    # center on square canvas side
    out = [[(0, 0, 0, 0) for _ in range(side)] for _ in range(side)]
    ox = (side - cw) // 2
    oy = (side - ch) // 2
    for y in range(miny, maxy + 1):
        for x in range(minx, maxx + 1):
            out[oy + y - miny][ox + x - minx] = im[y][x]
    return out


def render_icon(name: str, active: bool) -> list[list[tuple[int, int, int, int]]]:
    buf = [[(0, 0, 0, 0) for _ in range(W)] for _ in range(H)]
    if "breakfast" in name:
        draw_breakfast(buf, active)
    elif "lunch" in name:
        draw_lunch(buf, active)
    elif "dinner" in name:
        draw_dinner(buf, active)
    elif "snack" in name:
        draw_snack(buf, active)
    else:
        draw_sport(buf, active)
    return trim_and_pad(buf)


def upscale_to_256(small: list[list[tuple[int, int, int, int]]]) -> Image.Image:
    s = len(small)
    if s == 0:
        return Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    flat = bytes()
    for row in small:
        flat += bytes(sum(([r, g, b, a] for r, g, b, a in row), start=[]))
    im = Image.frombytes("RGBA", (s, s), flat)
    target = max(1, int(round(256 * 0.90)))
    scale = target / s
    nw = nh = max(1, int(round(s * scale)))
    im = im.resize((nw, nh), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    ox = (256 - nw) // 2
    oy = (256 - nh) // 2
    canvas.paste(im, (ox, oy), im)
    return canvas


def pen_append_category_group() -> None:
    doc = json.loads(ICONS_PEN.read_text(encoding="utf-8"))
    # Remove existing CategoryIcons if re-run
    doc["children"] = [c for c in doc["children"] if c.get("name") != "CategoryIcons"]

    gap = 24
    cell = 256
    names = [
        "category-breakfast",
        "category-lunch",
        "category-dinner",
        "category-snack",
        "category-sport",
    ]
    row_h = cell + gap
    group_w = 5 * cell + 4 * gap
    group_h = 2 * cell + gap
    base_y = 900

    frames = []
    for row, suffix in enumerate(["", "-active"]):
        for i, base in enumerate(names):
            nm = base + (suffix if suffix else "")
            fid = f"cat{row}{i}"
            frames.append(
                {
                    "type": "frame",
                    "id": fid,
                    "name": nm,
                    "context": f"导出 {nm}.png · 256（光栅由 designs/_build_category_icons.py 生成，与 Tab 线宽/色板一致）",
                    "x": i * (cell + gap),
                    "y": row * row_h,
                    "width": cell,
                    "height": cell,
                    "fill": "#FFFFFF00",
                    "clip": True,
                    "layout": "none",
                    "children": [],
                }
            )

    group = {
        "type": "frame",
        "id": "CatGrp",
        "name": "CategoryIcons",
        "context": "分组：饮食分类图标（早/午/晚/加餐/运动）· 默认+选中",
        "x": 0,
        "y": base_y,
        "width": group_w,
        "height": group_h,
        "fill": "#F7FBF7",
        "layout": "none",
        "children": frames,
    }
    doc["children"].append(group)
    ICONS_PEN.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("Updated", ICONS_PEN)


def main() -> None:
    pen_append_category_group()
    pairs = [
        ("category-breakfast", False),
        ("category-breakfast-active", True),
        ("category-lunch", False),
        ("category-lunch-active", True),
        ("category-dinner", False),
        ("category-dinner-active", True),
        ("category-snack", False),
        ("category-snack-active", True),
        ("category-sport", False),
        ("category-sport-active", True),
    ]
    for name, active in pairs:
        small = render_icon(name, active)
        img256 = upscale_to_256(small)
        for d in (OUT_DIR, SRC_DIR):
            png_write_rgba(d / f"{name}.png", img256)
        print("wrote", name)
    print("Done ->", OUT_DIR, SRC_DIR)


if __name__ == "__main__":
    main()
