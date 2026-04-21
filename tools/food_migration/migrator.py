"""分类迁移、check_food_staging 生成、正式 food 迁移、补图与统计。"""
from __future__ import annotations

import logging
import re
from decimal import Decimal
from pathlib import Path
from typing import Any

import pymysql
from pymysql.err import IntegrityError

from config import config
from db import get_conn, json_val, parse_json_col
from image_downloader import download_food_image
from parser import (
    build_keywords,
    compute_calories_per_unit_from_row,
    infer_energy_and_unit,
    infer_standard_weight_for_manual_unit,
    parse_calory_from_detail,
    parse_gi_level_from_detail,
    parse_macros_per_100g,
)

logger = logging.getLogger(__name__)

_ROOT = Path(__file__).resolve().parent


class CheckTablesNotInitializedError(RuntimeError):
    """check_* 表尚未执行 migration_tables.sql 创建。"""


def _table_exists(cur: Any, table_name: str) -> bool:
    cur.execute(
        """
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = DATABASE() AND table_name = %s
        LIMIT 1
        """,
        (table_name,),
    )
    return cur.fetchone() is not None


def require_check_tables(cur: Any) -> None:
    if not _table_exists(cur, "check_food_category_source_mapping"):
        raise CheckTablesNotInitializedError(
            "数据库中还没有 check_* 中间表（例如 check_food_category_source_mapping）。\n"
            "请先执行：python tools/food_migration/run_migration.py init"
        )


def run_migration_tables_sql() -> None:
    path = _ROOT / "migration_tables.sql"
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


def migrate_categories() -> int:
    """init_food_channel_category -> food_category + check_food_category_source_mapping。可重复执行。"""
    n = 0
    with get_conn() as conn:
        cur = conn.cursor()
        require_check_tables(cur)
        cur.execute(
            """
            SELECT c.id, c.channel_name, c.channel_category_id, c.channel_category_name
            FROM init_food_channel_category c
            LEFT JOIN check_food_category_source_mapping m
              ON m.channel_name = c.channel_name AND m.channel_category_id = c.channel_category_id
            WHERE m.id IS NULL
            ORDER BY c.id
            """
        )
        rows = cur.fetchall()
        for row in rows:
            ch = row["channel_name"]
            ccid = row["channel_category_id"]
            cname = (row["channel_category_name"] or "").strip() or ccid
            cname = cname[:64]
            code = ("mxnzp_" + ccid)[:64]

            cur.execute("SELECT id FROM food_category WHERE code = %s LIMIT 1", (code,))
            hit = cur.fetchone()
            if hit:
                tid = hit["id"]
            else:
                cur.execute("SELECT id FROM food_category WHERE name = %s LIMIT 1", (cname,))
                name_hit = cur.fetchone()
                if name_hit:
                    tid = name_hit["id"]
                    cur.execute(
                        """
                        INSERT INTO check_food_category_source_mapping
                          (channel_name, channel_category_id, target_category_id)
                        VALUES (%s, %s, %s)
                        """,
                        (ch, ccid, tid),
                    )
                    n += 1
                    continue

                insert_name = cname
                for attempt in range(5):
                    try:
                        cur.execute(
                            """
                            INSERT INTO food_category (name, code, parent_id, type, sort_no, status)
                            VALUES (%s, %s, NULL, 'channel', 0, 1)
                            """,
                            (insert_name, code),
                        )
                        tid = cur.lastrowid
                        break
                    except IntegrityError as e:
                        msg = str(e).lower()
                        if "duplicate" in msg and "name" in msg:
                            insert_name = f"{cname[:50]}·{ch}"[:64]
                            continue
                        if "duplicate" in msg and "code" in msg:
                            code = (code[:50] + "_" + ch[:8])[:64]
                            continue
                        raise
                else:
                    logger.error("分类插入失败: channel=%s category_id=%s", ch, ccid)
                    continue

            cur.execute(
                """
                INSERT INTO check_food_category_source_mapping
                  (channel_name, channel_category_id, target_category_id)
                VALUES (%s, %s, %s)
                """,
                (ch, ccid, tid),
            )
            n += 1
    return n


def _row_for_staging(cur: Any, channel_name: str, channel_food_id: str) -> dict[str, Any] | None:
    cur.execute(
        """
        SELECT
          i.channel_name,
          i.channel_food_id,
          i.channel_food_name,
          i.channel_category_id,
          i.cover AS item_cover,
          i.calory_desc AS item_calory_desc,
          i.raw_json AS item_raw_json,
          d.calory AS detail_calory,
          d.calory_unit AS detail_calory_unit,
          d.protein AS detail_protein,
          d.protein_unit AS detail_protein_unit,
          d.fat AS detail_fat,
          d.fat_unit AS detail_fat_unit,
          d.carbohydrate AS detail_carb,
          d.carbohydrate_unit AS detail_carb_unit,
          d.glycemic_info_json AS glycemic_info_json,
          d.raw_json AS detail_raw_json,
          img.image_url AS image_image_url,
          img.raw_json AS image_raw_json,
          m.target_category_id AS target_category_id,
          fc.name AS category_name
        FROM init_food_channel_item i
        LEFT JOIN init_food_channel_detail d
          ON d.channel_name = i.channel_name AND d.channel_food_id = i.channel_food_id
        LEFT JOIN init_food_channel_image img
          ON img.channel_name = i.channel_name AND img.channel_food_id = i.channel_food_id
        LEFT JOIN check_food_category_source_mapping m
          ON m.channel_name = i.channel_name AND m.channel_category_id = i.channel_category_id
        LEFT JOIN food_category fc ON fc.id = m.target_category_id
        WHERE i.channel_name = %s AND i.channel_food_id = %s
        LIMIT 1
        """,
        (channel_name, channel_food_id),
    )
    return cur.fetchone()


def generate_food_staging(limit: int | None = None, only_new: bool = True) -> int:
    inserted = 0
    with get_conn() as conn:
        cur = conn.cursor()
        require_check_tables(cur)
        sql = """
          SELECT i.channel_name, i.channel_food_id
          FROM init_food_channel_item i
        """
        if only_new:
            sql += """
          LEFT JOIN check_food_staging s
            ON s.channel_name = i.channel_name AND s.channel_food_id = i.channel_food_id
          WHERE s.id IS NULL
            """
        else:
            sql += " WHERE 1=1 "
        sql += " ORDER BY i.id "
        if limit is not None:
            sql += " LIMIT %s "
            cur.execute(sql, (limit,))
        else:
            cur.execute(sql)
        keys = cur.fetchall()

        for k in keys:
            ch, fid = k["channel_name"], k["channel_food_id"]
            row = _row_for_staging(cur, ch, fid)
            if not row:
                continue

            fname = (row["channel_food_name"] or "").strip()
            item_raw = parse_json_col(row.get("item_raw_json"))
            detail_raw = parse_json_col(row.get("detail_raw_json"))
            image_raw = parse_json_col(row.get("image_raw_json"))
            gly = parse_json_col(row.get("glycemic_info_json"))

            cal_v, cal_u = parse_calory_from_detail(row.get("detail_calory"), row.get("detail_calory_unit"))
            inf = infer_energy_and_unit(fname, cal_v, row.get("item_calory_desc"))

            p, f, c = parse_macros_per_100g(
                row.get("detail_protein"),
                row.get("detail_protein_unit"),
                row.get("detail_fat"),
                row.get("detail_fat_unit"),
                row.get("detail_carb"),
                row.get("detail_carb_unit"),
            )
            gi = parse_gi_level_from_detail(gly)

            img_url = row.get("image_image_url")
            cover = row.get("item_cover")
            primary_url = ((img_url or "").strip() or (cover or "").strip() or None)
            st, msg, rel_path = download_food_image(img_url, cover, fid)
            kw_preview = build_keywords(fname, fname, row.get("category_name"))

            try:
                cur.execute(
                    """
                    INSERT INTO check_food_staging (
                      channel_name, channel_food_id, channel_food_name, channel_category_id,
                      target_category_id,
                      source_image_url, local_image_path, image_download_status, image_download_msg,
                      raw_calory_value, raw_calory_unit, raw_calory_desc,
                      is_liquid, energy_basis, calories_per_100g, calories_per_100ml, calories_per_unit,
                      unit_name, standard_weight_value, standard_weight_unit,
                      confidence_score, inference_reason,
                      protein_per_100g, fat_per_100g, carb_per_100g,
                      gi_level, edible_portion_rate, keywords, is_custom, status,
                      stage_status, manual_review_status, formal_migrate_status,
                      source_item_json, source_detail_json, source_image_json
                    ) VALUES (
                      %s,%s,%s,%s,%s,
                      %s,%s,%s,%s,
                      %s,%s,%s,
                      %s,%s,%s,%s,%s,
                      %s,%s,%s,
                      %s,%s,
                      %s,%s,%s,
                      %s,%s,%s,%s,%s,
                      %s,%s,%s,
                      %s,%s,%s
                    )
                    """,
                    (
                        ch,
                        fid,
                        fname,
                        row["channel_category_id"],
                        row.get("target_category_id"),
                        primary_url,
                        rel_path or None,
                        st,
                        msg[:512] if msg else None,
                        cal_v,
                        cal_u,
                        row.get("item_calory_desc"),
                        inf["is_liquid"],
                        inf["energy_basis"],
                        inf["calories_per_100g"],
                        inf["calories_per_100ml"],
                        inf["calories_per_unit"],
                        inf["unit_name"],
                        inf["standard_weight_value"],
                        inf["standard_weight_unit"],
                        inf["confidence_score"],
                        inf["inference_reason"][:512] if inf["inference_reason"] else None,
                        p,
                        f,
                        c,
                        gi,
                        None,
                        kw_preview[:256] if kw_preview else None,
                        0,
                        1,
                        "generated",
                        "pending",
                        "not_migrated",
                        json_val(item_raw),
                        json_val(detail_raw),
                        json_val(image_raw),
                    ),
                )
                inserted += 1
            except IntegrityError:
                logger.debug("跳过重复 staging: %s %s", ch, fid)
            except Exception as e:
                logger.exception("写入 check_food_staging 失败 %s %s: %s", ch, fid, e)
    return inserted


def repair_images(limit: int | None = None) -> int:
    """对已有 staging 行补下载或重试失败项。"""
    n = 0
    with get_conn() as conn:
        cur = conn.cursor()
        require_check_tables(cur)
        q = """
          SELECT id, channel_food_id, source_image_url, channel_name
          FROM check_food_staging
          WHERE image_download_status IN ('failed','pending','skipped')
             OR (local_image_path IS NULL OR local_image_path = '')
          ORDER BY id
        """
        if limit is not None:
            q += " LIMIT %s"
            cur.execute(q, (limit,))
        else:
            cur.execute(q)
        rows = cur.fetchall()
        for r in rows:
            cur.execute(
                "SELECT cover FROM init_food_channel_item WHERE channel_name=%s AND channel_food_id=%s LIMIT 1",
                (r["channel_name"], r["channel_food_id"]),
            )
            it = cur.fetchone()
            cover = it["cover"] if it else None
            url = r.get("source_image_url") or cover
            st, msg, rel = download_food_image(url, cover, r["channel_food_id"])
            cur.execute(
                """
                UPDATE check_food_staging SET
                  source_image_url = COALESCE(NULLIF(%s,''), source_image_url),
                  local_image_path = %s,
                  image_download_status = %s,
                  image_download_msg = %s,
                  updated_at = CURRENT_TIMESTAMP
                WHERE id = %s
                """,
                (url, rel or None, st, msg[:512] if msg else None, r["id"]),
            )
            n += 1
    return n


def refetch_images_from_init(limit: int | None = None, force: bool = False) -> int:
    """
    按 init_food_channel_image.image_url 刷新 check_food_staging 的图片字段并下载。
    无 image_url 时退回 init_food_channel_item.cover。
    """
    n = 0
    with get_conn() as conn:
        cur = conn.cursor()
        require_check_tables(cur)
        q = """
          SELECT s.id, s.channel_name, s.channel_food_id
          FROM check_food_staging s
          ORDER BY s.id
        """
        if limit is not None:
            q += " LIMIT %s"
            cur.execute(q, (limit,))
        else:
            cur.execute(q)
        rows = cur.fetchall()
        for r in rows:
            cur.execute(
                """
                SELECT image_url FROM init_food_channel_image
                WHERE channel_name = %s AND channel_food_id = %s
                LIMIT 1
                """,
                (r["channel_name"], r["channel_food_id"]),
            )
            img_row = cur.fetchone()
            url_init = (img_row.get("image_url") or "").strip() if img_row else ""

            cur.execute(
                """
                SELECT cover FROM init_food_channel_item
                WHERE channel_name = %s AND channel_food_id = %s
                LIMIT 1
                """,
                (r["channel_name"], r["channel_food_id"]),
            )
            it = cur.fetchone()
            cover = it["cover"] if it else None

            st, msg, rel = download_food_image(
                url_init or None,
                cover,
                r["channel_food_id"],
                force=force,
            )
            cur.execute(
                """
                UPDATE check_food_staging SET
                  source_image_url = %s,
                  local_image_path = %s,
                  image_download_status = %s,
                  image_download_msg = %s,
                  updated_at = CURRENT_TIMESTAMP
                WHERE id = %s
                """,
                (
                    url_init or None,
                    rel or None,
                    st,
                    msg[:512] if msg else None,
                    r["id"],
                ),
            )
            n += 1
    return n


def _to_dec(x: Any) -> Decimal | None:
    if x is None:
        return None
    try:
        return Decimal(str(x))
    except Exception:
        return None


def recalc_staging_unit_calories(
    limit: int | None = None,
    fill_standard: bool = True,
    only_if_null_cpu: bool = False,
) -> tuple[int, int]:
    """
    人工补全 unit_name（及可选 standard_weight_*）后，按公式回填 calories_per_unit。
    不调用外部大模型，仅公式 + 规则推断标准量。

    返回 (已更新行数, 跳过行数)。
    """
    updated = 0
    skipped = 0
    with get_conn() as conn:
        cur = conn.cursor()
        require_check_tables(cur)
        q = """
          SELECT id, channel_food_name, unit_name, energy_basis, is_liquid,
                 calories_per_100g, calories_per_100ml,
                 standard_weight_value, standard_weight_unit,
                 calories_per_unit, inference_reason
          FROM check_food_staging
          WHERE unit_name IS NOT NULL AND TRIM(unit_name) <> ''
        """
        if only_if_null_cpu:
            q += " AND calories_per_unit IS NULL"
        q += " ORDER BY id"
        if limit is not None:
            q += " LIMIT %s"
            cur.execute(q, (limit,))
        else:
            cur.execute(q)
        for r in cur.fetchall():
            std_v = _to_dec(r.get("standard_weight_value"))
            std_u = r.get("standard_weight_unit")
            std_u = (std_u or "").strip() if std_u else None

            infer_note = ""
            if fill_standard and (std_v is None or not std_u):
                iv, iu, note = infer_standard_weight_for_manual_unit(
                    r.get("channel_food_name") or "",
                    r.get("unit_name"),
                    r.get("energy_basis"),
                    int(r.get("is_liquid") or 0),
                )
                infer_note = note
                if std_v is None:
                    std_v = iv
                if not std_u:
                    std_u = iu

            if std_v is None or not std_u:
                skipped += 1
                continue

            c100g = _to_dec(r.get("calories_per_100g"))
            c100ml = _to_dec(r.get("calories_per_100ml"))
            cpu = compute_calories_per_unit_from_row(
                r.get("energy_basis"),
                c100g,
                c100ml,
                std_v,
                std_u,
            )
            if cpu is None:
                skipped += 1
                continue

            reason = (r.get("inference_reason") or "").strip()
            if infer_note:
                add = f"recalc_units:{infer_note}"
                reason = f"{reason}; {add}" if reason else add
                reason = reason[:512]

            cur.execute(
                """
                UPDATE check_food_staging SET
                  standard_weight_value = %s,
                  standard_weight_unit = %s,
                  calories_per_unit = %s,
                  inference_reason = %s,
                  updated_at = CURRENT_TIMESTAMP
                WHERE id = %s
                """,
                (std_v, std_u, cpu, reason or None, r["id"]),
            )
            updated += 1
    return updated, skipped


def _formal_calories_per_100g(row: dict[str, Any]) -> Decimal | None:
    basis = (row.get("energy_basis") or "").strip()
    if basis == "100ml" and row.get("calories_per_100ml") is not None:
        return Decimal(str(row["calories_per_100ml"]))
    if row.get("calories_per_100g") is not None:
        return Decimal(str(row["calories_per_100g"]))
    if row.get("calories_per_100ml") is not None:
        return Decimal(str(row["calories_per_100ml"]))
    return None


def migrate_foods_to_formal(limit: int | None = None) -> int:
    migrated = 0
    with get_conn() as conn:
        cur = conn.cursor()
        require_check_tables(cur)
        q = """
          SELECT s.* FROM check_food_staging s
          WHERE s.manual_review_status IN ('approved','modified_approved')
            AND s.formal_migrate_status = 'not_migrated'
          ORDER BY s.id
        """
        if limit is not None:
            q += " LIMIT %s"
            cur.execute(q, (limit,))
        else:
            cur.execute(q)
        rows = cur.fetchall()

        for s in rows:
            sid = s["id"]
            ch = s["channel_name"]
            fid = s["channel_food_id"]

            cur.execute(
                "SELECT id FROM check_food_source_mapping WHERE channel_name=%s AND channel_food_id=%s",
                (ch, fid),
            )
            if cur.fetchone():
                cur.execute(
                    """
                    UPDATE check_food_staging SET formal_migrate_status='migrated',
                      target_food_id=(SELECT target_food_id FROM check_food_source_mapping
                        WHERE channel_name=%s AND channel_food_id=%s LIMIT 1),
                      updated_at=CURRENT_TIMESTAMP WHERE id=%s
                    """,
                    (ch, fid, sid),
                )
                continue

            cat_id = s.get("target_category_id")
            if cat_id is None:
                cur.execute(
                    """
                    SELECT target_category_id FROM check_food_category_source_mapping
                    WHERE channel_name=%s AND channel_category_id=%s LIMIT 1
                    """,
                    (ch, s["channel_category_id"]),
                )
                m = cur.fetchone()
                cat_id = m["target_category_id"] if m else None
            if cat_id is None:
                _fail_migrate(cur, sid, ch, fid, None, "缺少 target_category_id / 分类映射")
                continue

            cals = _formal_calories_per_100g(s)
            if cals is None:
                _fail_migrate(cur, sid, ch, fid, None, "缺少 calories_per_100g / calories_per_100ml（审核后仍为空）")
                continue

            name = re.sub(r"\s+", " ", (s["channel_food_name"] or "").strip())
            if not name:
                _fail_migrate(cur, sid, ch, fid, None, "名称为空")
                continue

            cur.execute("SELECT name FROM food_category WHERE id=%s", (cat_id,))
            cr = cur.fetchone()
            cat_name = cr["name"] if cr else None
            kw = build_keywords(name, (s.get("channel_food_name") or name), cat_name)

            std_g = s.get("standard_weight_value")
            img_path = s.get("local_image_path")
            if img_path and str(img_path).startswith("http"):
                img_path = None

            try:
                cur.execute(
                    """
                    INSERT INTO food (
                      creator_user_id, category_id, name, image, gi_level,
                      calories_per_100g, calories_per_unit, unit_name, standard_weight_g,
                      edible_portion_rate,
                      carb_per_100g, protein_per_100g, fat_per_100g,
                      keywords, is_custom, status
                    ) VALUES (
                      NULL, %s, %s, %s, %s,
                      %s, %s, %s, %s,
                      NULL,
                      %s, %s, %s,
                      %s, 0, 1
                    )
                    """,
                    (
                        cat_id,
                        name,
                        img_path,
                        s.get("gi_level"),
                        cals,
                        s.get("calories_per_unit"),
                        s.get("unit_name"),
                        std_g,
                        s.get("carb_per_100g"),
                        s.get("protein_per_100g"),
                        s.get("fat_per_100g"),
                        kw[:256] if kw else None,
                    ),
                )
                new_id = cur.lastrowid
                cur.execute(
                    """
                    INSERT INTO check_food_source_mapping (channel_name, channel_food_id, target_food_id)
                    VALUES (%s, %s, %s)
                    """,
                    (ch, fid, new_id),
                )
                cur.execute(
                    """
                    UPDATE check_food_staging SET
                      formal_migrate_status='migrated',
                      target_food_id=%s,
                      updated_at=CURRENT_TIMESTAMP
                    WHERE id=%s
                    """,
                    (new_id, sid),
                )
                cur.execute(
                    """
                    INSERT INTO check_food_migrate_log (
                      check_food_staging_id, channel_name, channel_food_id, target_food_id,
                      migrate_action, detail_msg
                    ) VALUES (%s,%s,%s,%s,'insert_food',%s)
                    """,
                    (sid, ch, fid, new_id, "ok"),
                )
                migrated += 1
            except IntegrityError as e:
                _fail_migrate(cur, sid, ch, fid, None, f"integrity:{e}")
            except Exception as e:
                _fail_migrate(cur, sid, ch, fid, None, str(e)[:500])
    return migrated


def _fail_migrate(cur: Any, sid: int, ch: str, fid: str, tid: int | None, msg: str) -> None:
    cur.execute(
        """
        UPDATE check_food_staging SET formal_migrate_status='failed', updated_at=CURRENT_TIMESTAMP
        WHERE id=%s
        """,
        (sid,),
    )
    cur.execute(
        """
        INSERT INTO check_food_migrate_log (
          check_food_staging_id, channel_name, channel_food_id, target_food_id,
          migrate_action, detail_msg
        ) VALUES (%s,%s,%s,%s,'insert_food_failed',%s)
        """,
        (sid, ch, fid, tid, msg[:512]),
    )
    logger.warning("迁移失败 staging_id=%s %s/%s: %s", sid, ch, fid, msg)


def stats() -> dict[str, int]:
    out: dict[str, int] = {}
    img_dir = Path(config.food_image_local_dir)
    with get_conn() as conn:
        cur = conn.cursor()
        require_check_tables(cur)
        cur.execute("SELECT COUNT(*) AS c FROM init_food_channel_category")
        out["init_categories"] = int(cur.fetchone()["c"])
        cur.execute("SELECT COUNT(*) AS c FROM food_category")
        out["formal_categories"] = int(cur.fetchone()["c"])
        cur.execute("SELECT COUNT(*) AS c FROM check_food_category_source_mapping")
        out["category_mappings"] = int(cur.fetchone()["c"])
        cur.execute("SELECT COUNT(*) AS c FROM init_food_channel_item")
        out["init_foods"] = int(cur.fetchone()["c"])
        cur.execute("SELECT COUNT(*) AS c FROM check_food_staging")
        out["staging_foods"] = int(cur.fetchone()["c"])
        cur.execute(
            "SELECT COUNT(*) AS c FROM check_food_staging WHERE manual_review_status='pending'"
        )
        out["staging_pending"] = int(cur.fetchone()["c"])
        cur.execute(
            """SELECT COUNT(*) AS c FROM check_food_staging
               WHERE manual_review_status IN ('approved','modified_approved')"""
        )
        out["staging_approved"] = int(cur.fetchone()["c"])
        cur.execute("SELECT COUNT(*) AS c FROM check_food_staging WHERE manual_review_status='rejected'")
        out["staging_rejected"] = int(cur.fetchone()["c"])
        cur.execute("SELECT COUNT(*) AS c FROM check_food_staging WHERE formal_migrate_status='migrated'")
        out["staging_migrated"] = int(cur.fetchone()["c"])
        cur.execute("SELECT COUNT(*) AS c FROM food")
        out["formal_foods"] = int(cur.fetchone()["c"])
        cur.execute("SELECT COUNT(*) AS c FROM check_food_source_mapping")
        out["food_source_mappings"] = int(cur.fetchone()["c"])
        cur.execute(
            "SELECT COUNT(*) AS c FROM check_food_staging WHERE image_download_status='failed'"
        )
        out["image_download_failed"] = int(cur.fetchone()["c"])

    n_files = 0
    if img_dir.is_dir():
        n_files = sum(1 for p in img_dir.iterdir() if p.is_file())
    out["local_image_files"] = n_files
    return out
