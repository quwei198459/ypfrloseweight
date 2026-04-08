#!/usr/bin/env python3
"""Raster export for icon_search / icon_camera → frontend/static/icons + src/static/icons."""
from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent
OUT_STATIC = ROOT.parent / "frontend" / "static" / "icons"
OUT_SRC = ROOT.parent / "frontend" / "src" / "static" / "icons"

W = H = 256
GREEN = "#4E7C45"
MINT = "#9CCB86"


def draw_search() -> Image.Image:
    from PIL import ImageDraw

    im = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    dr = ImageDraw.Draw(im)
    dr.ellipse([56, 56, 188, 188], outline=GREEN, width=3)
    dr.line([(162, 162), (240, 240)], fill=MINT, width=3)
    return im


def draw_camera() -> Image.Image:
    from PIL import ImageDraw

    im = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    dr = ImageDraw.Draw(im)
    dr.rounded_rectangle([44, 78, 212, 190], radius=14, outline=GREEN, width=3)
    dr.ellipse([98, 108, 158, 168], outline=GREEN, width=3)
    dr.ellipse([174, 90, 188, 104], outline=GREEN, width=2, fill=MINT)
    return im


def alpha_bbox(im: Image.Image) -> tuple[int, int, int, int] | None:
    if im.mode != "RGBA":
        im = im.convert("RGBA")
    return im.split()[3].getbbox()


def fit_canvas(im: Image.Image, canvas: int = 256, fill: float = 0.88) -> Image.Image:
    box = alpha_bbox(im)
    if not box:
        return im
    cropped = im.crop(box)
    w, h = cropped.size
    side = max(w, h)
    target = max(1, int(round(canvas * fill)))
    scale = target / side
    nw, nh = max(1, int(round(w * scale))), max(1, int(round(h * scale)))
    resized = cropped.resize((nw, nh), Image.Resampling.LANCZOS)
    out = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
    ox = (canvas - nw) // 2
    oy = (canvas - nh) // 2
    out.paste(resized, (ox, oy), resized)
    return out


def main() -> None:
    pairs = [("search.png", draw_search), ("camera.png", draw_camera)]
    for name, fn in pairs:
        raw = fn()
        final = fit_canvas(raw, 256, 0.88)
        for d in (OUT_STATIC, OUT_SRC):
            d.mkdir(parents=True, exist_ok=True)
            final.save(d / name, "PNG", optimize=True)
        print("wrote", name)


if __name__ == "__main__":
    main()
