"""Write logo-c-dark / logo-c-contrast into src/static/logo (C scheme, transparent PNG)."""
from __future__ import annotations

import os
from PIL import Image, ImageDraw

W = H = 512
OUT = os.path.join(os.path.dirname(__file__), "..", "src", "static", "logo")


def logo_c_dark() -> Image.Image:
    im = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    cx, cy = W // 2, H // 2
    outer = 200
    x0, y0 = cx - outer // 2, cy - outer // 2
    x1, y1 = x0 + outer, y0 + outer
    dr = ImageDraw.Draw(im)
    dr.rounded_rectangle(
        (x0, y0, x1, y1),
        radius=56,
        outline=(61, 92, 54, 255),
        width=28,
        fill=(0, 0, 0, 0),
    )
    r_core = 58
    dr.ellipse(
        (cx - r_core, cy - r_core, cx + r_core, cy + r_core),
        fill=(94, 143, 82, 255),
        outline=(78, 124, 69, 255),
        width=8,
    )
    return im


def logo_c_contrast() -> Image.Image:
    im = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    cx, cy = W // 2, H // 2
    block = 210
    x0 = cx - block // 2
    y0 = cy - block // 2
    dr = ImageDraw.Draw(im)
    dr.rounded_rectangle(
        (x0, y0, x0 + block, y0 + block),
        radius=54,
        fill=(42, 63, 38, 255),
    )
    ro = 100
    dr.ellipse(
        (cx - ro, cy - ro, cx + ro, cy + ro),
        fill=(111, 160, 94, 255),
        outline=(196, 232, 120, 255),
        width=16,
    )
    ri = 52
    dr.ellipse(
        (cx - ri, cy - ri, cx + ri, cy + ri),
        fill=(42, 63, 38, 255),
    )
    return im


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    logo_c_dark().save(os.path.join(OUT, "logo-c-dark.png"), "PNG")
    logo_c_contrast().save(os.path.join(OUT, "logo-c-contrast.png"), "PNG")
    print("OK", OUT)


if __name__ == "__main__":
    main()
