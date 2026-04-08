"""Generate WeChat tabBar PNGs (81x81) matching product green / gray style."""
from __future__ import annotations

from PIL import Image, ImageDraw

W = H = 81

GRAY = (180, 189, 180, 255)
GREEN_D = (111, 163, 98, 255)
GREEN_M = (95, 168, 84, 255)
FILL_ROOF = (216, 235, 207, 255)
FILL_BODY = (232, 244, 224, 255)
FILL_CAM = (226, 243, 220, 255)
FILL_LENS = (200, 228, 184, 255)
FILL_USER_H = (223, 240, 213, 255)
FILL_USER_S = (208, 233, 196, 255)


def _new() -> Image.Image:
    return Image.new("RGBA", (W, H), (0, 0, 0, 0))


def _rr(
    d: ImageDraw.ImageDraw,
    box: tuple[int, int, int, int],
    radius: int,
    *,
    outline: tuple[int, int, int, int] | None = None,
    width: int = 3,
    fill: tuple[int, int, int, int] | None = None,
) -> None:
    d.rounded_rectangle(box, radius=radius, outline=outline, width=width, fill=fill)


def home_default() -> Image.Image:
    im = _new()
    dr = ImageDraw.Draw(im)
    _rr(dr, (18, 14, 63, 29), 6, outline=GRAY, width=3)
    _rr(dr, (20, 26, 61, 57), 8, outline=GRAY, width=3)
    return im


def home_active() -> Image.Image:
    im = _new()
    dr = ImageDraw.Draw(im)
    _rr(dr, (18, 14, 63, 29), 6, outline=GREEN_D, width=3, fill=FILL_ROOF)
    _rr(dr, (20, 26, 61, 57), 8, outline=GREEN_D, width=3, fill=FILL_BODY)
    return im


def camera_default() -> Image.Image:
    im = _new()
    dr = ImageDraw.Draw(im)
    _rr(dr, (15, 24, 66, 58), 12, outline=GRAY, width=3)
    dr.ellipse((28, 32, 53, 57), outline=GRAY, width=3)
    dr.ellipse((56, 28, 63, 35), fill=GRAY)
    return im


def camera_active() -> Image.Image:
    im = _new()
    dr = ImageDraw.Draw(im)
    _rr(dr, (13, 21, 68, 61), 14, outline=GREEN_M, width=4, fill=FILL_CAM)
    dr.ellipse((26, 30, 55, 59), outline=(78, 148, 70, 255), width=3, fill=FILL_LENS)
    dr.ellipse((57, 27, 65, 35), fill=GREEN_M)
    return im


def user_default() -> Image.Image:
    im = _new()
    dr = ImageDraw.Draw(im)
    dr.ellipse((25, 14, 56, 45), outline=GRAY, width=3)
    _rr(dr, (19, 38, 62, 62), 14, outline=GRAY, width=3)
    return im


def user_active() -> Image.Image:
    im = _new()
    dr = ImageDraw.Draw(im)
    dr.ellipse((25, 14, 56, 45), outline=GREEN_D, width=3, fill=FILL_USER_H)
    _rr(dr, (19, 38, 62, 62), 14, outline=GREEN_D, width=3, fill=FILL_USER_S)
    return im


def main() -> None:
    import os

    root = os.path.join(os.path.dirname(__file__), "..", "src", "static")
    tab = os.path.join(root, "tab")
    os.makedirs(tab, exist_ok=True)

    pairs = [
        ("tab-home.png", home_default),
        ("tab-home-active.png", home_active),
        ("tab-camera.png", camera_default),
        ("tab-camera-active.png", camera_active),
        ("tab-user.png", user_default),
        ("tab-user-active.png", user_active),
    ]
    for name, fn in pairs:
        fn().save(os.path.join(tab, name), "PNG")
        print("wrote", os.path.join(tab, name))

    # Logo 以 designs/icons.pen 导出为准，不再在此生成 logo-main / logo-icon


if __name__ == "__main__":
    main()
