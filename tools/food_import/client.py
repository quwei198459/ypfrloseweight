"""MXNZP HTTP 客户端：固定路径、鉴权、重试、限流。"""
from __future__ import annotations

import logging
import time
from typing import Any

import requests

from config import config
from schemas import (
    PATH_FOOD_DETAILS,
    PATH_FOOD_LIST,
    PATH_FOOD_SEARCH,
    PATH_IMAGES_LIST,
    PATH_TYPE_LIST,
)

logger = logging.getLogger(__name__)


class MxnzpClient:
    def __init__(self) -> None:
        self.base = config.api_base.rstrip("/")
        self.session = requests.Session()
        self.session.headers["User-Agent"] = "ypfr-food-import/2.0"

    def _auth_params(self, extra: dict[str, Any] | None = None) -> dict[str, Any]:
        p: dict[str, Any] = {
            "app_id": config.mxnzp_app_id,
            "app_secret": config.mxnzp_app_secret,
        }
        if extra:
            p.update({k: v for k, v in extra.items() if v is not None})
        return p

    def _get(self, path: str, params: dict[str, Any] | None = None) -> dict[str, Any]:
        url = f"{self.base}{path}"
        merged = self._auth_params(params)
        last_err: Exception | None = None
        code: int | None = None
        text = ""
        for attempt in range(1, config.request_retry_times + 1):
            try:
                r = self.session.get(url, params=merged, timeout=config.request_timeout)
                code = r.status_code
                text = r.text or ""
                r.raise_for_status()
                try:
                    data = r.json()
                except ValueError:
                    data = {"_parse_error": True, "_raw": text[:2000]}
                time.sleep(max(0, config.request_sleep_seconds))
                return {"_http_ok": True, "_status": code, "_body": data, "_text": text}
            except requests.RequestException as e:
                last_err = e
                logger.warning("GET %s 失败 [%s/%s]: %s", path, attempt, config.request_retry_times, e)
                if attempt < config.request_retry_times:
                    time.sleep(min(2**attempt, 30))
        return {"_http_ok": False, "_status": code, "_body": None, "_text": text, "_error": str(last_err)}

    def get_category_list(self) -> dict[str, Any]:
        return self._get(PATH_TYPE_LIST, None)

    def get_food_list(self, category_id: str, page: int) -> dict[str, Any]:
        return self._get(PATH_FOOD_LIST, {"id": str(category_id), "page": int(page)})

    def search_food(self, keyword: str, page: int) -> dict[str, Any]:
        return self._get(PATH_FOOD_SEARCH, {"keyword": str(keyword), "page": int(page)})

    def get_food_detail(self, food_id: str) -> dict[str, Any]:
        return self._get(PATH_FOOD_DETAILS, {"foodId": str(food_id)})

    def get_food_images(self, food_ids: list[str]) -> dict[str, Any]:
        """GET /api/food_heat/images/list — 官方约定 ids 单次最多 10 个，超出会被忽略，本客户端直接拒绝多传。"""
        cleaned = [str(x).strip() for x in food_ids if str(x).strip()]
        if len(cleaned) > 10:
            raise ValueError("images/list 单次最多 10 个 foodId（接口规定，超出将被服务端忽略）")
        if not cleaned:
            return {
                "_http_ok": False,
                "_status": None,
                "_body": None,
                "_text": "",
                "_error": "empty food_ids",
            }
        ids = ",".join(cleaned)
        return self._get(PATH_IMAGES_LIST, {"ids": ids})
