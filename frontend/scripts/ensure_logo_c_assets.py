"""已弃用：旧版会生成「绿方框+圆」并覆盖 src/static/logo，导致新 logo 被冲掉。

请使用仓库根下：`python designs/build_brand_logos.py`（默认只输出到 designs/_brand_build）
需要覆盖 frontend 内 PNG 并同步 dist 时：`python designs/build_brand_logos.py --install`

本脚本保留为兼容：执行时将透传命令行参数给 build_brand_logos.py。
"""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BUILD = ROOT / "designs" / "build_brand_logos.py"


def main() -> None:
    if not BUILD.is_file():
        raise SystemExit(f"missing {BUILD}")
    subprocess.check_call([sys.executable, str(BUILD), *sys.argv[1:]], cwd=str(ROOT))


if __name__ == "__main__":
    main()
