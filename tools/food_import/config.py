"""从 .env 加载配置。"""
from __future__ import annotations

import os
from pathlib import Path

from dotenv import load_dotenv

_ROOT = Path(__file__).resolve().parent
_REPO = _ROOT.parent.parent
load_dotenv(_REPO / ".env", override=False)
load_dotenv(_ROOT / ".env", override=True)


def _g(name: str, default: str | None = None) -> str | None:
    v = os.environ.get(name)
    return v.strip() if v and str(v).strip() else default


def _gi(name: str, default: int) -> int:
    try:
        return int(_g(name, str(default)) or default)
    except ValueError:
        return default


def _gf(name: str, default: float) -> float:
    try:
        return float(_g(name, str(default)) or default)
    except ValueError:
        return default


class Config:
    mxnzp_app_id: str = _g("MXNZP_APP_ID", "") or ""
    mxnzp_app_secret: str = _g("MXNZP_APP_SECRET", "") or ""

    mysql_host: str = _g("MYSQL_HOST", "127.0.0.1") or "127.0.0.1"
    mysql_port: int = _gi("MYSQL_PORT", 3306)
    mysql_user: str = _g("MYSQL_USER", "root") or "root"
    mysql_password: str = _g("MYSQL_PASSWORD", "") or ""
    mysql_database: str = _g("MYSQL_DATABASE", "loseweight") or "loseweight"

    request_timeout: float = _gf("REQUEST_TIMEOUT", 30.0)
    request_sleep_seconds: float = _gf("REQUEST_SLEEP_SECONDS", 0.35)
    request_retry_times: int = _gi("REQUEST_RETRY_TIMES", 3)

    api_base: str = (_g("MXNZP_API_BASE", "https://www.mxnzp.com") or "https://www.mxnzp.com").rstrip("/")

    log_level: str = (_g("LOG_LEVEL", "INFO") or "INFO").upper()


config = Config()
