"""渠道图片下载到本地 uploads/food-images。"""
from __future__ import annotations

import re
from pathlib import Path
from typing import Tuple
from urllib.error import HTTPError, URLError
from urllib.parse import urlparse
from urllib.request import Request, urlopen

from config import config


def sanitize_food_id(channel_food_id: str) -> str:
    s = (channel_food_id or "").strip()
    s = re.sub(r'[<>:"/\\|?*\s]+', "_", s)
    return s or "unknown"


def _guess_ext_from_url(url: str) -> str | None:
    try:
        path = urlparse(url).path
        if "." in path:
            ext = path.rsplit(".", 1)[-1].lower()
            if 1 <= len(ext) <= 5 and ext.isalnum():
                return "." + ext
    except Exception:
        pass
    return None


def _ext_from_content_type(ct: str | None) -> str | None:
    if not ct:
        return None
    ct = ct.split(";")[0].strip().lower()
    mapping = {
        "image/jpeg": ".jpg",
        "image/jpg": ".jpg",
        "image/png": ".png",
        "image/webp": ".webp",
        "image/gif": ".gif",
    }
    return mapping.get(ct)


def download_food_image(
    url: str | None,
    fallback_cover: str | None,
    channel_food_id: str,
    *,
    force: bool = False,
) -> Tuple[str, str, str]:
    """
    返回 (image_download_status, image_download_msg, local_relative_path)
    local_relative_path 成功时为 /uploads/food-images/xxx.ext，否则空字符串。
    force=True 时删除已有 mxnzp_{id}.* 再重新下载。
    """
    base_dir = Path(config.food_image_local_dir)
    base_dir.mkdir(parents=True, exist_ok=True)

    chosen = (url or "").strip() or (fallback_cover or "").strip()
    if not chosen:
        return "skipped", "no_image_url", ""

    safe_id = sanitize_food_id(channel_food_id)
    existing = list(base_dir.glob(f"mxnzp_{safe_id}.*"))
    if force:
        for p in existing:
            if p.is_file():
                try:
                    p.unlink()
                except OSError:
                    pass
    else:
        for p in existing:
            if p.is_file() and p.stat().st_size > 0:
                return "success", "file_exists_skip", f"/uploads/food-images/{p.name}"

    ext = _guess_ext_from_url(chosen) or ".jpg"
    filename = f"mxnzp_{safe_id}{ext}"
    dest = base_dir / filename
    relative = f"/uploads/food-images/{filename}"

    req = Request(
        chosen,
        headers={
            "User-Agent": (
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
            ),
            "Accept": "image/avif,image/webp,image/apng,image/*,*/*;q=0.8",
        },
    )
    try:
        with urlopen(req, timeout=config.http_timeout) as resp:
            data = resp.read()
            ct = resp.headers.get("Content-Type")
            ext_ct = _ext_from_content_type(ct)
            if ext_ct:
                ext = ext_ct
            filename = f"mxnzp_{safe_id}{ext}"
            dest = base_dir / filename
            relative = f"/uploads/food-images/{filename}"
            dest.write_bytes(data)
        return "success", "ok", relative
    except HTTPError as e:
        return "failed", f"http_{e.code}", ""
    except URLError as e:
        return "failed", f"url_error:{e.reason!s}"[:500], ""
    except Exception as e:
        return "failed", str(e)[:500], ""
