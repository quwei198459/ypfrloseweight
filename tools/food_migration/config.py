"""从环境变量加载配置（与 tools/food_import 共用 MYSQL_* 习惯）。"""
from __future__ import annotations

import os
from pathlib import Path

from dotenv import load_dotenv

_ROOT = Path(__file__).resolve().parent
_REPO = _ROOT.parent.parent
load_dotenv(_REPO / ".env", override=False)
load_dotenv(_ROOT / ".env", override=True)
load_dotenv(_REPO / "tools" / "food_import" / ".env", override=False)


def _g(name: str, default: str | None = None) -> str | None:
    v = os.environ.get(name)
    return v.strip() if v and str(v).strip() else default


def _gi(name: str, default: int) -> int:
    try:
        return int(_g(name, str(default)) or default)
    except ValueError:
        return default


class Config:
    mysql_host: str = _g("MYSQL_HOST", "127.0.0.1") or "127.0.0.1"
    mysql_port: int = _gi("MYSQL_PORT", 3306)
    mysql_user: str = _g("MYSQL_USER", "root") or "root"
    mysql_password: str = _g("MYSQL_PASSWORD", "198459") or "198459"
    mysql_database: str = _g("MYSQL_DATABASE", "loseweight") or "loseweight"

    # 默认与需求一致；可用 FOOD_IMAGE_LOCAL_DIR 覆盖
    food_image_local_dir: str = (
        _g("FOOD_IMAGE_LOCAL_DIR", r"D:\mycode\ypfrloseweight\backend\uploads\food-images")
        or r"D:\mycode\ypfrloseweight\backend\uploads\food-images"
    )

    http_timeout: float = float(_g("FOOD_MIGRATION_HTTP_TIMEOUT", "45") or "45")
    log_level: str = (_g("LOG_LEVEL", "INFO") or "INFO").upper()


config = Config()
