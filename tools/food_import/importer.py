"""采集编排：仅写 init_ 表。"""
from __future__ import annotations

import json
import logging
from datetime import datetime
from pathlib import Path
from typing import Any

import pymysql

from client import MxnzpClient
from config import config
from db import get_conn, json_val
from schemas import CHANNEL_NAME, SEARCH_CATEGORY_PLACEHOLDER, level_to_label

logger = logging.getLogger(__name__)


def _now() -> datetime:
    return datetime.now()


def _sv(x: Any) -> str | None:
    if x is None:
        return None
    s = str(x).strip()
    return s if s else None


def _parse_api(result: dict[str, Any]) -> tuple[bool, Any, dict | None]:
    """(业务是否成功, data 节点, 完整 body)"""
    if not result.get("_http_ok"):
        return False, None, None
    body = result.get("_body")
    if not isinstance(body, dict):
        return True, body, body if isinstance(body, dict) else None
    code = body.get("code")
    ok = code in (1, 200, "1", "200") or body.get("success") is True
    return (ok, body.get("data"), body)


def _data_as_list(data: Any) -> list[Any]:
    if data is None:
        return []
    if isinstance(data, list):
        return data
    if isinstance(data, dict):
        for k in ("list", "records", "rows", "items", "data"):
            v = data.get(k)
            if isinstance(v, list):
                return v
    return []


class FoodImporter:
    def __init__(self) -> None:
        self.client = MxnzpClient()
        self.channel = CHANNEL_NAME

    def _log_task(
        self,
        cur: pymysql.cursors.Cursor,
        *,
        api_name: str,
        request_params: dict[str, Any] | None,
        page_no: int | None,
        result: dict[str, Any],
        item_count: int,
        started: datetime,
        full_body: dict | None,
        biz_ok: bool,
    ) -> None:
        finished = _now()
        status = result.get("_status")
        msg = None
        if isinstance(full_body, dict):
            _m = _sv(full_body.get("msg"))
            msg = (_m[:255] if _m else None)
        if not msg and result.get("_error"):
            msg = str(result.get("_error"))[:255]
        is_ok = 1 if (result.get("_http_ok") and biz_ok) else 0
        rj = None
        try:
            rj = json_val(full_body) if full_body is not None else json_val({"_text": (result.get("_text") or "")[:8000]})
        except (TypeError, ValueError):
            rj = json_val({"error": "unserializable"})
        cur.execute(
            """
            INSERT INTO init_food_channel_pull_task (
              channel_name, api_name, request_params_json, page_no,
              response_code, response_msg, is_success, item_count, response_json,
              started_at, finished_at
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """,
            (
                self.channel,
                api_name,
                json_val(request_params),
                page_no,
                str(status) if status is not None else None,
                msg,
                is_ok,
                item_count,
                rj,
                started,
                finished,
            ),
        )

    def init_tables(self) -> None:
        path = Path(__file__).resolve().parent / "init_tables.sql"
        raw = path.read_text(encoding="utf-8")
        lines = [ln for ln in raw.splitlines() if not ln.strip().startswith("--")]
        sql = "\n".join(lines)
        with get_conn() as conn:
            cur = conn.cursor()
            for stmt in sql.split(";"):
                s = stmt.strip()
                if not s:
                    continue
                cur.execute(s)

    def import_categories(self) -> int:
        started = _now()
        res = self.client.get_category_list()
        biz_ok, data, body = _parse_api(res)
        rows = _data_as_list(data)
        n = 0
        with get_conn() as conn:
            cur = conn.cursor()
            self._log_task(
                cur,
                api_name="type_list",
                request_params={},
                page_no=None,
                result=res,
                item_count=len(rows),
                started=started,
                full_body=body,
                biz_ok=biz_ok,
            )
            if not res.get("_http_ok"):
                logger.error("分类接口 HTTP 失败")
                return 0
            if not biz_ok:
                logger.error("分类接口业务失败: %s", body)
                return 0
            for row in rows:
                if not isinstance(row, dict):
                    continue
                cid = _sv(row.get("id"))
                cname = _sv(row.get("name")) or ""
                icon = _sv(row.get("icon"))
                if not cid:
                    continue
                cur.execute(
                    """
                    INSERT INTO init_food_channel_category
                    (channel_name, channel_category_id, channel_category_name, icon, raw_json)
                    VALUES (%s,%s,%s,%s,%s)
                    ON DUPLICATE KEY UPDATE
                      channel_category_name=VALUES(channel_category_name),
                      icon=VALUES(icon),
                      raw_json=VALUES(raw_json),
                      updated_at=CURRENT_TIMESTAMP
                    """,
                    (self.channel, cid, cname, icon, json_val(row)),
                )
                n += 1
        logger.info("分类写入 %s 条", n)
        return n

    def import_foods_by_category(self, category_id: str, limit_per_category: int | None = None) -> int:
        total = 0
        page = 1
        while limit_per_category is None or total < limit_per_category:
            started = _now()
            res = self.client.get_food_list(category_id, page)
            biz_ok, data, body = _parse_api(res)
            rows = _data_as_list(data)
            with get_conn() as conn:
                cur = conn.cursor()
                self._log_task(
                    cur,
                    api_name="food_list",
                    request_params={"id": str(category_id), "page": page},
                    page_no=page,
                    result=res,
                    item_count=len(rows),
                    started=started,
                    full_body=body,
                    biz_ok=biz_ok,
                )
                if not res.get("_http_ok") or not biz_ok:
                    logger.warning("分类 %s 第 %s 页请求失败，停止", category_id, page)
                    break
                if not rows:
                    logger.info("分类 %s 第 %s 页无数据，结束", category_id, page)
                    break
                for row in rows:
                    if limit_per_category is not None and total >= limit_per_category:
                        break
                    if not isinstance(row, dict):
                        continue
                    fid = _sv(row.get("foodId"))
                    name = _sv(row.get("name")) or ""
                    if not fid:
                        continue
                    hl = _sv(row.get("healthLevel") or row.get("health_light") or row.get("healthLight"))
                    hll = level_to_label(hl)
                    cover = _sv(row.get("cover"))
                    cal = _sv(row.get("calory"))
                    cur.execute(
                        """
                        INSERT INTO init_food_channel_item (
                          channel_name, channel_food_id, channel_food_name, channel_category_id,
                          health_level, health_level_label, cover, calory_desc, raw_json, source_status, imported_at
                        ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,'success',%s)
                        ON DUPLICATE KEY UPDATE
                          channel_food_name=VALUES(channel_food_name),
                          health_level=VALUES(health_level),
                          health_level_label=VALUES(health_level_label),
                          cover=VALUES(cover),
                          calory_desc=VALUES(calory_desc),
                          raw_json=VALUES(raw_json),
                          source_status=VALUES(source_status),
                          imported_at=VALUES(imported_at),
                          updated_at=CURRENT_TIMESTAMP
                        """,
                        (
                            self.channel,
                            fid,
                            name,
                            str(category_id),
                            hl,
                            hll,
                            cover,
                            cal,
                            json_val(row),
                            _now(),
                        ),
                    )
                    total += 1
            if limit_per_category is not None and total >= limit_per_category:
                break
            page += 1
        logger.info("分类 %s 累计 item %s 条", category_id, total)
        return total

    def import_foods_all(self, limit_per_category: int | None = None) -> int:
        with get_conn() as conn:
            cur = conn.cursor()
            cur.execute(
                "SELECT channel_category_id FROM init_food_channel_category WHERE channel_name=%s ORDER BY id",
                (self.channel,),
            )
            cats = [str(r["channel_category_id"]) for r in cur.fetchall()]
        if not cats:
            logger.warning("无分类数据，请先 categories")
            return 0
        s = 0
        for cid in cats:
            s += self.import_foods_by_category(cid, limit_per_category=limit_per_category)
        return s

    def _detail_tuple(
        self, food_id: str, data: dict[str, Any], raw_envelope: dict | None, status: str, fetched: datetime | None
    ) -> tuple[Any, ...]:
        hl = _sv(data.get("health_light") or data.get("healthLight"))
        hll = level_to_label(hl)
        name = _sv(data.get("name"))
        return (
            self.channel,
            str(food_id),
            name,
            hl,
            hll,
            _sv(data.get("calory")),
            _sv(data.get("caloryUnit")),
            _sv(data.get("joule")),
            _sv(data.get("jouleUnit")),
            _sv(data.get("protein")),
            _sv(data.get("proteinUnit")),
            _sv(data.get("fat")),
            _sv(data.get("fatUnit")),
            _sv(data.get("saturatedFat")),
            _sv(data.get("saturatedFatUnit")),
            _sv(data.get("fattyAcid")),
            _sv(data.get("fattyAcidUnit")),
            _sv(data.get("mufa")),
            _sv(data.get("mufaUnit")),
            _sv(data.get("pufa")),
            _sv(data.get("pufaUnit")),
            _sv(data.get("cholesterol")),
            _sv(data.get("cholesterolUnit")),
            _sv(data.get("carbohydrate")),
            _sv(data.get("carbohydrateUnit")),
            _sv(data.get("sugar")),
            _sv(data.get("sugarUnit")),
            _sv(data.get("fiberDietary")),
            _sv(data.get("fiberDietaryUnit")),
            _sv(data.get("natrium")),
            _sv(data.get("natriumUnit")),
            _sv(data.get("alcohol")),
            _sv(data.get("alcoholUnit")),
            _sv(data.get("vitaminA")),
            _sv(data.get("vitaminAUnit")),
            _sv(data.get("carotene")),
            _sv(data.get("caroteneUnit")),
            _sv(data.get("vitaminD")),
            _sv(data.get("vitaminDUnit")),
            _sv(data.get("vitaminE")),
            _sv(data.get("vitaminEUnit")),
            _sv(data.get("vitaminK")),
            _sv(data.get("vitaminKUnit")),
            _sv(data.get("thiamine")),
            _sv(data.get("thiamineUnit")),
            _sv(data.get("lactoflavin")),
            _sv(data.get("lactoflavinUnit")),
            _sv(data.get("vitaminB6")),
            _sv(data.get("vitaminB6Unit")),
            _sv(data.get("vitaminB12")),
            _sv(data.get("vitaminB12Unit")),
            _sv(data.get("vitaminC")),
            _sv(data.get("vitaminCUnit")),
            _sv(data.get("niacin")),
            _sv(data.get("niacinUnit")),
            _sv(data.get("folacin")),
            _sv(data.get("folacinUnit")),
            _sv(data.get("pantothenic")),
            _sv(data.get("pantothenicUnit")),
            _sv(data.get("biotin")),
            _sv(data.get("biotinUnit")),
            _sv(data.get("choline")),
            _sv(data.get("cholineUnit")),
            _sv(data.get("phosphor")),
            _sv(data.get("phosphorUnit")),
            _sv(data.get("kalium")),
            _sv(data.get("kaliumUnit")),
            _sv(data.get("magnesium")),
            _sv(data.get("magnesiumUnit")),
            _sv(data.get("calcium")),
            _sv(data.get("calciumUnit")),
            _sv(data.get("iron")),
            _sv(data.get("ironUnit")),
            _sv(data.get("zinc")),
            _sv(data.get("zincUnit")),
            _sv(data.get("iodine")),
            _sv(data.get("iodineUnit")),
            _sv(data.get("selenium")),
            _sv(data.get("seleniumUnit")),
            _sv(data.get("copper")),
            _sv(data.get("copperUnit")),
            _sv(data.get("fluorine")),
            _sv(data.get("fluorineUnit")),
            _sv(data.get("manganese")),
            _sv(data.get("manganeseUnit")),
            json_val(data.get("glycemicInfoData")),
            _sv(data.get("healthTips")),
            _sv(data.get("healthSuggest")),
            json_val(data.get("cookBook")),
            json_val(raw_envelope if raw_envelope is not None else data),
            status,
            fetched,
        )

    def import_food_detail(self, food_id: str) -> bool:
        started = _now()
        res = self.client.get_food_detail(food_id)
        biz_ok, data, body = _parse_api(res)
        if isinstance(data, dict):
            payload = data
        else:
            payload = {}
        fid = _sv(payload.get("foodId") or payload.get("id")) or str(food_id)
        st = "success" if (res.get("_http_ok") and biz_ok and payload) else "error"
        ft = _now() if st == "success" else None
        tup = self._detail_tuple(fid, payload, body, st, ft)
        with get_conn() as conn:
            cur = conn.cursor()
            self._log_task(
                cur,
                api_name="food_details",
                request_params={"foodId": str(food_id)},
                page_no=None,
                result=res,
                item_count=1 if st == "success" else 0,
                started=started,
                full_body=body,
                biz_ok=biz_ok and bool(payload),
            )
            cur.execute(
                """
                INSERT INTO init_food_channel_detail (
                  channel_name, channel_food_id, channel_food_name, health_light, health_light_label,
                  calory, calory_unit, joule, joule_unit, protein, protein_unit, fat, fat_unit,
                  saturated_fat, saturated_fat_unit, fatty_acid, fatty_acid_unit, mufa, mufa_unit, pufa, pufa_unit,
                  cholesterol, cholesterol_unit, carbohydrate, carbohydrate_unit, sugar, sugar_unit,
                  fiber_dietary, fiber_dietary_unit, natrium, natrium_unit, alcohol, alcohol_unit,
                  vitamin_a, vitamin_a_unit, carotene, carotene_unit, vitamin_d, vitamin_d_unit,
                  vitamin_e, vitamin_e_unit, vitamin_k, vitamin_k_unit, thiamine, thiamine_unit,
                  lactoflavin, lactoflavin_unit, vitamin_b6, vitamin_b6_unit, vitamin_b12, vitamin_b12_unit,
                  vitamin_c, vitamin_c_unit, niacin, niacin_unit, folacin, folacin_unit,
                  pantothenic, pantothenic_unit, biotin, biotin_unit, choline, choline_unit,
                  phosphor, phosphor_unit, kalium, kalium_unit, magnesium, magnesium_unit,
                  calcium, calcium_unit, iron, iron_unit, zinc, zinc_unit, iodine, iodine_unit,
                  selenium, selenium_unit, copper, copper_unit, fluorine, fluorine_unit,
                  manganese, manganese_unit, glycemic_info_json, health_tips, health_suggest, cookbook_json,
                  raw_json, detail_status, detail_fetched_at
                ) VALUES (
                  %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s
                )
                ON DUPLICATE KEY UPDATE
                  channel_food_name=VALUES(channel_food_name),
                  health_light=VALUES(health_light),
                  health_light_label=VALUES(health_light_label),
                  calory=VALUES(calory),
                  calory_unit=VALUES(calory_unit),
                  joule=VALUES(joule),
                  joule_unit=VALUES(joule_unit),
                  protein=VALUES(protein),
                  protein_unit=VALUES(protein_unit),
                  fat=VALUES(fat),
                  fat_unit=VALUES(fat_unit),
                  saturated_fat=VALUES(saturated_fat),
                  saturated_fat_unit=VALUES(saturated_fat_unit),
                  fatty_acid=VALUES(fatty_acid),
                  fatty_acid_unit=VALUES(fatty_acid_unit),
                  mufa=VALUES(mufa),
                  mufa_unit=VALUES(mufa_unit),
                  pufa=VALUES(pufa),
                  pufa_unit=VALUES(pufa_unit),
                  cholesterol=VALUES(cholesterol),
                  cholesterol_unit=VALUES(cholesterol_unit),
                  carbohydrate=VALUES(carbohydrate),
                  carbohydrate_unit=VALUES(carbohydrate_unit),
                  sugar=VALUES(sugar),
                  sugar_unit=VALUES(sugar_unit),
                  fiber_dietary=VALUES(fiber_dietary),
                  fiber_dietary_unit=VALUES(fiber_dietary_unit),
                  natrium=VALUES(natrium),
                  natrium_unit=VALUES(natrium_unit),
                  alcohol=VALUES(alcohol),
                  alcohol_unit=VALUES(alcohol_unit),
                  vitamin_a=VALUES(vitamin_a),
                  vitamin_a_unit=VALUES(vitamin_a_unit),
                  carotene=VALUES(carotene),
                  carotene_unit=VALUES(carotene_unit),
                  vitamin_d=VALUES(vitamin_d),
                  vitamin_d_unit=VALUES(vitamin_d_unit),
                  vitamin_e=VALUES(vitamin_e),
                  vitamin_e_unit=VALUES(vitamin_e_unit),
                  vitamin_k=VALUES(vitamin_k),
                  vitamin_k_unit=VALUES(vitamin_k_unit),
                  thiamine=VALUES(thiamine),
                  thiamine_unit=VALUES(thiamine_unit),
                  lactoflavin=VALUES(lactoflavin),
                  lactoflavin_unit=VALUES(lactoflavin_unit),
                  vitamin_b6=VALUES(vitamin_b6),
                  vitamin_b6_unit=VALUES(vitamin_b6_unit),
                  vitamin_b12=VALUES(vitamin_b12),
                  vitamin_b12_unit=VALUES(vitamin_b12_unit),
                  vitamin_c=VALUES(vitamin_c),
                  vitamin_c_unit=VALUES(vitamin_c_unit),
                  niacin=VALUES(niacin),
                  niacin_unit=VALUES(niacin_unit),
                  folacin=VALUES(folacin),
                  folacin_unit=VALUES(folacin_unit),
                  pantothenic=VALUES(pantothenic),
                  pantothenic_unit=VALUES(pantothenic_unit),
                  biotin=VALUES(biotin),
                  biotin_unit=VALUES(biotin_unit),
                  choline=VALUES(choline),
                  choline_unit=VALUES(choline_unit),
                  phosphor=VALUES(phosphor),
                  phosphor_unit=VALUES(phosphor_unit),
                  kalium=VALUES(kalium),
                  kalium_unit=VALUES(kalium_unit),
                  magnesium=VALUES(magnesium),
                  magnesium_unit=VALUES(magnesium_unit),
                  calcium=VALUES(calcium),
                  calcium_unit=VALUES(calcium_unit),
                  iron=VALUES(iron),
                  iron_unit=VALUES(iron_unit),
                  zinc=VALUES(zinc),
                  zinc_unit=VALUES(zinc_unit),
                  iodine=VALUES(iodine),
                  iodine_unit=VALUES(iodine_unit),
                  selenium=VALUES(selenium),
                  selenium_unit=VALUES(selenium_unit),
                  copper=VALUES(copper),
                  copper_unit=VALUES(copper_unit),
                  fluorine=VALUES(fluorine),
                  fluorine_unit=VALUES(fluorine_unit),
                  manganese=VALUES(manganese),
                  manganese_unit=VALUES(manganese_unit),
                  glycemic_info_json=VALUES(glycemic_info_json),
                  health_tips=VALUES(health_tips),
                  health_suggest=VALUES(health_suggest),
                  cookbook_json=VALUES(cookbook_json),
                  raw_json=VALUES(raw_json),
                  detail_status=VALUES(detail_status),
                  detail_fetched_at=VALUES(detail_fetched_at),
                  updated_at=CURRENT_TIMESTAMP
                """,
                tup,
            )
        return st == "success"

    def import_food_detail_batch(self, limit: int | None = None, only_missing: bool = True) -> tuple[int, int]:
        lim = limit or 500
        with get_conn() as conn:
            cur = conn.cursor()
            if only_missing:
                cur.execute(
                    """
                    SELECT DISTINCT i.channel_food_id FROM init_food_channel_item i
                    WHERE i.channel_name=%s
                    AND NOT EXISTS (
                      SELECT 1 FROM init_food_channel_detail d
                      WHERE d.channel_name=i.channel_name AND d.channel_food_id=i.channel_food_id
                        AND d.detail_status='success'
                    )
                    ORDER BY i.channel_food_id
                    LIMIT %s
                    """,
                    (self.channel, lim),
                )
            else:
                cur.execute(
                    """
                    SELECT DISTINCT channel_food_id FROM init_food_channel_item
                    WHERE channel_name=%s
                    ORDER BY channel_food_id
                    LIMIT %s
                    """,
                    (self.channel, lim),
                )
            ids = [r["channel_food_id"] for r in cur.fetchall()]
        ok = err = 0
        for fid in ids:
            if self.import_food_detail(str(fid)):
                ok += 1
            else:
                err += 1
        return ok, err

    NO_IMAGE_MARKER = "ID不存在，无图片"

    def _upsert_image_row(
        self,
        cur: pymysql.cursors.Cursor,
        *,
        food_id: str,
        image_url: str | None,
        image_status: str,
        raw_obj: Any,
    ) -> None:
        cur.execute(
            """
            INSERT INTO init_food_channel_image
            (channel_name, channel_food_id, image_url, image_status, raw_json, fetched_at)
            VALUES (%s,%s,%s,%s,%s,%s)
            ON DUPLICATE KEY UPDATE
              image_url=VALUES(image_url),
              image_status=VALUES(image_status),
              raw_json=VALUES(raw_json),
              fetched_at=VALUES(fetched_at),
              updated_at=CURRENT_TIMESTAMP
            """,
            (self.channel, food_id, image_url, image_status, json_val(raw_obj), _now()),
        )

    def _upsert_image_api_error_batch(
        self,
        cur: pymysql.cursors.Cursor,
        food_ids: list[str],
        body: dict | None,
        res: dict[str, Any],
    ) -> int:
        """HTTP/业务失败时仍为每个请求的 foodId 落库，便于对账；额度恢复后 only_missing 会重试（非 api_error 终态）。"""
        env = body if isinstance(body, dict) else {}
        n = 0
        for fid in food_ids:
            if not fid:
                continue
            raw_obj = {
                "foodId": fid,
                "_api_error": True,
                "_api_envelope": env,
                "_http_status": res.get("_status"),
                "_http_ok": res.get("_http_ok"),
            }
            self._upsert_image_row(
                cur,
                food_id=fid,
                image_url=None,
                image_status="api_error",
                raw_obj=raw_obj,
            )
            n += 1
        return n

    def import_food_images(self, food_ids: list[str]) -> int:
        if not food_ids:
            return 0
        ids_clean = [str(x).strip() for x in food_ids if str(x).strip()]
        if not ids_clean:
            return 0
        if len(ids_clean) > 10:
            raise ValueError("单次最多 10 个 foodId（与 mxnzp images/list 一致）")
        started = _now()
        res = self.client.get_food_images(ids_clean)
        biz_ok, data, body = _parse_api(res)
        rows = _data_as_list(data)
        n = 0
        with get_conn() as conn:
            cur = conn.cursor()
            self._log_task(
                cur,
                api_name="images_list",
                request_params={"ids": ",".join(ids_clean)},
                page_no=None,
                result=res,
                item_count=len(rows),
                started=started,
                full_body=body,
                biz_ok=biz_ok,
            )
            if not res.get("_http_ok"):
                return self._upsert_image_api_error_batch(cur, ids_clean, body, res)

            if not rows:
                if biz_ok:
                    logger.info("图片接口返回空列表")
                return self._upsert_image_api_error_batch(cur, ids_clean, body, res)

            seen: set[str] = set()
            for row in rows:
                if not isinstance(row, dict):
                    continue
                fid = _sv(row.get("foodId"))
                img = row.get("image")
                img_s = _sv(img) if img is not None else None
                st = "success"
                url = img_s
                if img_s == self.NO_IMAGE_MARKER or (img_s and "不存在" in img_s and "无图片" in img_s):
                    st = "invalid_id"
                    url = None
                elif not img_s:
                    st = "no_image"
                    url = None
                if not fid:
                    continue
                seen.add(fid)
                self._upsert_image_row(
                    cur, food_id=fid, image_url=url, image_status=st, raw_obj=row
                )
                n += 1
            for fid in ids_clean:
                if fid not in seen:
                    raw_obj = {
                        "foodId": fid,
                        "_missing_in_response": True,
                        "_api_envelope": body if isinstance(body, dict) else {},
                    }
                    self._upsert_image_row(
                        cur, food_id=fid, image_url=None, image_status="api_error", raw_obj=raw_obj
                    )
                    n += 1
        return n

    def import_food_images_batch(
        self,
        limit: int | None = None,
        only_missing: bool = True,
        batch_size: int = 10,
        *,
        id_source: str = "item",
    ) -> int:
        """id_source: item=从 init_food_channel_item 取 id；detail=仅从 init_food_channel_detail 且 detail_status=success 取 id（推荐明细已齐后专用）。

        图片接口 ids 单次最多 10 个，批量拉取时**固定每请求 10 个 id**（最后一批可不足 10）。batch_size 参数保留兼容旧调用，实际不使用。
        """
        if id_source not in ("item", "detail"):
            raise ValueError("id_source 只能是 item 或 detail")
        _ = batch_size
        lim = limit or 500
        bs = 10
        with get_conn() as conn:
            cur = conn.cursor()
            if id_source == "detail":
                if only_missing:
                    cur.execute(
                        """
                        SELECT DISTINCT d.channel_food_id FROM init_food_channel_detail d
                        WHERE d.channel_name=%s AND d.detail_status='success'
                        AND NOT EXISTS (
                          SELECT 1 FROM init_food_channel_image img
                          WHERE img.channel_name=d.channel_name AND img.channel_food_id=d.channel_food_id
                            AND img.image_status <> 'api_error'
                        )
                        ORDER BY d.channel_food_id
                        LIMIT %s
                        """,
                        (self.channel, lim),
                    )
                else:
                    cur.execute(
                        """
                        SELECT DISTINCT channel_food_id FROM init_food_channel_detail
                        WHERE channel_name=%s AND detail_status='success'
                        ORDER BY channel_food_id
                        LIMIT %s
                        """,
                        (self.channel, lim),
                    )
            elif only_missing:
                cur.execute(
                    """
                    SELECT DISTINCT i.channel_food_id FROM init_food_channel_item i
                    WHERE i.channel_name=%s
                    AND NOT EXISTS (
                      SELECT 1 FROM init_food_channel_image img
                      WHERE img.channel_name=i.channel_name AND img.channel_food_id=i.channel_food_id
                        AND img.image_status <> 'api_error'
                    )
                    ORDER BY i.channel_food_id
                    LIMIT %s
                    """,
                    (self.channel, lim),
                )
            else:
                cur.execute(
                    """
                    SELECT DISTINCT channel_food_id FROM init_food_channel_item
                    WHERE channel_name=%s
                    ORDER BY channel_food_id
                    LIMIT %s
                    """,
                    (self.channel, lim),
                )
            ids = [str(r["channel_food_id"]) for r in cur.fetchall()]
        total = 0
        for i in range(0, len(ids), bs):
            chunk = ids[i : i + bs]
            total += self.import_food_images(chunk)
        return total

    def search_and_import(self, keyword: str, max_pages: int = 1) -> int:
        total = 0
        for page in range(1, max(1, int(max_pages)) + 1):
            started = _now()
            res = self.client.search_food(keyword, page)
            biz_ok, data, body = _parse_api(res)
            rows = _data_as_list(data)
            with get_conn() as conn:
                cur = conn.cursor()
                self._log_task(
                    cur,
                    api_name="food_search",
                    request_params={"keyword": keyword, "page": page},
                    page_no=page,
                    result=res,
                    item_count=len(rows),
                    started=started,
                    full_body=body,
                    biz_ok=biz_ok,
                )
                if not res.get("_http_ok") or not biz_ok:
                    break
                if not rows:
                    break
                for row in rows:
                    if not isinstance(row, dict):
                        continue
                    fid = _sv(row.get("foodId"))
                    name = _sv(row.get("name")) or ""
                    if not fid:
                        continue
                    hl = _sv(row.get("healthLevel") or row.get("health_light") or row.get("healthLight"))
                    hll = level_to_label(hl)
                    cover = _sv(row.get("cover"))
                    cal = _sv(row.get("calory"))
                    cur.execute(
                        """
                        INSERT INTO init_food_channel_item (
                          channel_name, channel_food_id, channel_food_name, channel_category_id,
                          health_level, health_level_label, cover, calory_desc, raw_json, source_status, imported_at
                        ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,'success',%s)
                        ON DUPLICATE KEY UPDATE
                          channel_food_name=VALUES(channel_food_name),
                          health_level=VALUES(health_level),
                          health_level_label=VALUES(health_level_label),
                          cover=VALUES(cover),
                          calory_desc=VALUES(calory_desc),
                          raw_json=VALUES(raw_json),
                          imported_at=VALUES(imported_at),
                          updated_at=CURRENT_TIMESTAMP
                        """,
                        (
                            self.channel,
                            fid,
                            name,
                            SEARCH_CATEGORY_PLACEHOLDER,
                            hl,
                            hll,
                            cover,
                            cal,
                            json_val(row),
                            _now(),
                        ),
                    )
                    total += 1
        logger.info("搜索「%s」写入 item %s 条", keyword, total)
        return total

    def stats(self) -> dict[str, int]:
        with get_conn() as conn:
            cur = conn.cursor()

            def one(sql: str, params: tuple = ()) -> int:
                cur.execute(sql, params)
                r = cur.fetchone()
                return int(list(r.values())[0]) if r else 0

            return {
                "categories": one(
                    "SELECT COUNT(*) c FROM init_food_channel_category WHERE channel_name=%s", (self.channel,)
                ),
                "items": one("SELECT COUNT(*) c FROM init_food_channel_item WHERE channel_name=%s", (self.channel,)),
                "details": one(
                    "SELECT COUNT(*) c FROM init_food_channel_detail WHERE channel_name=%s AND detail_status='success'",
                    (self.channel,),
                ),
                "images": one(
                    "SELECT COUNT(*) c FROM init_food_channel_image WHERE channel_name=%s AND image_status='success'",
                    (self.channel,),
                ),
                "images_no_image": one(
                    "SELECT COUNT(*) c FROM init_food_channel_image WHERE channel_name=%s AND image_status='no_image'",
                    (self.channel,),
                ),
                "images_invalid_id": one(
                    "SELECT COUNT(*) c FROM init_food_channel_image WHERE channel_name=%s AND image_status='invalid_id'",
                    (self.channel,),
                ),
                "images_api_error": one(
                    "SELECT COUNT(*) c FROM init_food_channel_image WHERE channel_name=%s AND image_status='api_error'",
                    (self.channel,),
                ),
            }
