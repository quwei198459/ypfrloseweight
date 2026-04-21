"""
生成品牌 Logo 光栅（莲花 + 双圈断续环线稿）。

默认只写入 designs/_brand_build/，**不会**覆盖 frontend/src/static/logo 下你已替换的 PNG，
避免「每次跑脚本又变回生成图」。

需要写回小程序静态目录并同步 dist 时显式加参数：
  python designs/build_brand_logos.py --install

说明：登录页 image 为正方形视口 + aspectFit；输出 768×768 透明底。
"""
from __future__ import annotations

import argparse
import glob
import shutil
import sys
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.patches import Arc, Ellipse  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
BRAND_BUILD_DIR = ROOT / "designs" / "_brand_build"
FRONTEND_LOGO_DIR = ROOT / "frontend" / "src" / "static" / "logo"
OUT_DARK_INSTALL = FRONTEND_LOGO_DIR / "logo-c-dark.png"
OUT_CONTRAST_INSTALL = FRONTEND_LOGO_DIR / "logo-c-contrast.png"

# 正方形画板，与小程序内 logo 常见正方形展示一致，aspectFit 时图形铺满
W, H = 768, 768
CX, CY = W / 2, H / 2


def _broken_ring(ax, cx: float, cy: float, r: float, color: str, lw: float, gap_deg: float) -> None:
    """四象限各留一道缝的圆环（用 Arc 近似）。"""
    arc_span = 90.0 - gap_deg
    half = gap_deg / 2.0
    # 以「数学角」从 +x 逆时针：顶=90°。Matplotlib Arc 的 theta 与此一致。
    centers_deg = [90.0, 0.0, 270.0, 180.0]
    for c in centers_deg:
        t1 = c + half
        t2 = c + half + arc_span
        ax.add_patch(
            Arc(
                (cx, cy),
                2 * r,
                2 * r,
                angle=0.0,
                theta1=t1,
                theta2=t2,
                fill=False,
                edgecolor=color,
                linewidth=lw,
                capstyle="round",
            )
        )


def _lotus(
    ax,
    cx: float,
    cy: float,
    s: float,
    color: str,
    lw: float,
) -> None:
    """三瓣椭圆线稿；s 为相对旧基准 (R_outer=248) 的缩放。"""
    ax.add_patch(
        Ellipse(
            (cx, cy + 12 * s),
            width=92 * s,
            height=228 * s,
            angle=0,
            fill=False,
            edgecolor=color,
            linewidth=lw,
        )
    )
    ax.add_patch(
        Ellipse(
            (cx - 52 * s, cy + 38 * s),
            width=108 * s,
            height=178 * s,
            angle=48,
            fill=False,
            edgecolor=color,
            linewidth=lw,
        )
    )
    ax.add_patch(
        Ellipse(
            (cx + 52 * s, cy + 38 * s),
            width=108 * s,
            height=178 * s,
            angle=-48,
            fill=False,
            edgecolor=color,
            linewidth=lw,
        )
    )


def render(stroke: str, out_path: Path) -> None:
    dpi = 100.0
    fig = plt.figure(figsize=(W / dpi, H / dpi), dpi=dpi)
    fig.patch.set_alpha(0.0)
    ax = fig.add_axes((0, 0, 1, 1))
    ax.set_facecolor("none")
    ax.set_xlim(0, W)
    ax.set_ylim(0, H)
    ax.set_aspect("equal")
    ax.axis("off")
    ax.invert_yaxis()

    # 以短边为限铺满画布，仅留极少 inset，避免线宽裁切；杜绝大图心小圈的大面积透明边
    m = float(min(W, H))
    inset = max(16.0, m * 0.015)
    r_outer = m / 2.0 - inset
    r_inner = r_outer * (198.0 / 248.0)
    scale = r_outer / 248.0
    lw_outer = max(8.5, 14.0 * scale)
    lw_inner = max(7.0, 10.0 * scale)
    lw_lotus = max(7.0, 9.0 * scale)

    _broken_ring(ax, CX, CY, r_outer, stroke, lw_outer, 14.0)
    _broken_ring(ax, CX, CY, r_inner, stroke, lw_inner, 14.0)
    _lotus(ax, CX, CY - 6 * scale, scale, stroke, lw_lotus)

    fig.savefig(
        out_path,
        dpi=dpi,
        transparent=True,
        facecolor="none",
        edgecolor="none",
        bbox_inches=None,
        pad_inches=0,
    )
    plt.close(fig)


def _sync_into_mp_dist(out_dark: Path, out_contrast: Path) -> None:
    """uni-app 会把 /static/logo 打成 /assets/logo-*.[hash].png；只改 src 时真机仍读旧 dist，需同步。"""
    dist_dir = ROOT / "frontend" / "dist" / "dev" / "mp-weixin"
    if not dist_dir.is_dir():
        return
    assets = dist_dir / "assets"
    static_logo = dist_dir / "static" / "logo"
    for pattern, src in (
        ("logo-c-dark.*.png", out_dark),
        ("logo-c-contrast.*.png", out_contrast),
    ):
        for p in glob.glob(str(assets / pattern)):
            shutil.copy2(src, p)
            print("sync dist asset:", p)
    if static_logo.is_dir():
        shutil.copy2(out_dark, static_logo / "logo-c-dark.png")
        shutil.copy2(out_contrast, static_logo / "logo-c-contrast.png")
        print("sync dist static/logo")


def main() -> None:
    ap = argparse.ArgumentParser(description="生成莲花线稿 logo PNG")
    ap.add_argument(
        "--install",
        action="store_true",
        help="写入 frontend/src/static/logo 并尝试同步 dist/dev/mp-weixin（会覆盖同名 PNG）",
    )
    args = ap.parse_args()

    if args.install:
        FRONTEND_LOGO_DIR.mkdir(parents=True, exist_ok=True)
        out_dark = OUT_DARK_INSTALL
        out_contrast = OUT_CONTRAST_INSTALL
    else:
        BRAND_BUILD_DIR.mkdir(parents=True, exist_ok=True)
        out_dark = BRAND_BUILD_DIR / "logo-c-dark.png"
        out_contrast = BRAND_BUILD_DIR / "logo-c-contrast.png"

    # 登录页 #F7FBF7：略深的暖金线，保证对比度
    render("#A67C4A", out_dark)
    # 首页顶栏 #BFD9A3 + 半透明白底托：与 app-title 一致的深绿线
    render("#1F2A1F", out_contrast)
    print("written:", out_dark, out_contrast)
    if not args.install:
        print(
            "Tip: PNGs are only in designs/_brand_build. To overwrite frontend/src/static/logo and sync dist:",
            file=sys.stderr,
        )
        print("  python designs/build_brand_logos.py --install", file=sys.stderr)
        return
    _sync_into_mp_dist(out_dark, out_contrast)


if __name__ == "__main__":
    main()
