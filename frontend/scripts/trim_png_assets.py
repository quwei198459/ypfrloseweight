#!/usr/bin/env python3
"""
Trim excess transparent margins from logo/tab PNGs; overwrite in place.
- Tab: uniform canvas size (from first tab file), content ~90% of side, centered.
- Logo: tight trim + ~3% pad on content bbox; no forced square.
"""
from __future__ import annotations

import os
import sys
from pathlib import Path

from PIL import Image

# Alpha below this is treated as empty
ALPHA_THRESH = 12
# Safety margin around tight bbox (fraction of max(content_w, content_h))
PAD_RATIO = 0.03
# Tab: graphic max side as fraction of canvas (88%–92% band, use 0.90)
TAB_FILL = 0.90

ROOT = Path(__file__).resolve().parents[1]
LOGO_DIR = ROOT / "src" / "static" / "logo"
TAB_DIR = ROOT / "src" / "static" / "tab"

LOGO_NAMES = [
    "logo-c-dark.png",
    "logo-c-contrast.png",
    "logo.png",
]

TAB_NAMES = [
    "tab-home.png",
    "tab-home-active.png",
    "tab-camera.png",
    "tab-camera-active.png",
    "tab-user.png",
    "tab-user-active.png",
]


def alpha_bbox(im: Image.Image) -> tuple[int, int, int, int] | None:
    if im.mode != "RGBA":
        im = im.convert("RGBA")
    a = im.split()[3]
    w, h = im.size
    pixels = a.load()
    xmin, ymin, xmax, ymax = w, h, 0, 0
    found = False
    for y in range(h):
        for x in range(w):
            if pixels[x, y] > ALPHA_THRESH:
                found = True
                xmin = min(xmin, x)
                xmax = max(xmax, x)
                ymin = min(ymin, y)
                ymax = max(ymax, y)
    if not found:
        return None
    return xmin, ymin, xmax + 1, ymax + 1


def trim_with_pad(im: Image.Image) -> Image.Image:
    box = alpha_bbox(im)
    if box is None:
        return im
    xmin, ymin, xmax, ymax = box
    cw, ch = xmax - xmin, ymax - ymin
    pad = max(1, int(round(max(cw, ch) * PAD_RATIO)))
    w, h = im.size
    left = max(0, xmin - pad)
    top = max(0, ymin - pad)
    right = min(w, xmax + pad)
    bottom = min(h, ymax + pad)
    return im.crop((left, top, right, bottom))


def fit_to_square_canvas(im: Image.Image, canvas: int, fill: float) -> Image.Image:
    """Uniform scale so max(w,h) == int(canvas * fill), center on canvas×canvas."""
    if im.mode != "RGBA":
        im = im.convert("RGBA")
    w, h = im.size
    if w == 0 or h == 0:
        return Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
    target = max(1, int(round(canvas * fill)))
    side = max(w, h)
    scale = target / side
    nw = max(1, int(round(w * scale)))
    nh = max(1, int(round(h * scale)))
    resized = im.resize((nw, nh), Image.Resampling.LANCZOS)
    out = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
    ox = (canvas - nw) // 2
    oy = (canvas - nh) // 2
    out.paste(resized, (ox, oy), resized)
    return out


def process_logo(path: Path) -> tuple[bool, str]:
    if not path.is_file():
        return False, "skip (missing)"
    im = Image.open(path)
    before = im.size
    trimmed = trim_with_pad(im)
    after = trimmed.size
    trimmed.save(path, "PNG", optimize=True)
    return True, f"{before} -> {after}"


def detect_tab_canvas() -> int:
    for name in TAB_NAMES:
        p = TAB_DIR / name
        if p.is_file():
            im = Image.open(p)
            s = max(im.size)
            return max(s, 1)
    return 81


def process_tab(path: Path, canvas: int) -> tuple[bool, str]:
    if not path.is_file():
        return False, "skip (missing)"
    im = Image.open(path)
    before = im.size
    trimmed = trim_with_pad(im)
    fitted = fit_to_square_canvas(trimmed, canvas, TAB_FILL)
    fitted.save(path, "PNG", optimize=True)
    after = fitted.size
    return True, f"{before} -> trim {trimmed.size} -> {after}"


def main() -> int:
    reports: list[str] = []

    canvas = detect_tab_canvas()
    reports.append(f"Tab canvas: {canvas}x{canvas}, fill={TAB_FILL:.0%}")

    for name in LOGO_NAMES:
        p = LOGO_DIR / name
        ok, msg = process_logo(p)
        reports.append(f"logo/{name}: {msg}")

    for name in TAB_NAMES:
        p = TAB_DIR / name
        ok, msg = process_tab(p, canvas)
        reports.append(f"tab/{name}: {msg}")

    for line in reports:
        print(line)
    return 0


if __name__ == "__main__":
    sys.exit(main())
