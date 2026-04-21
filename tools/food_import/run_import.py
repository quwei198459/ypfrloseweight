#!/usr/bin/env python3
"""MXNZP 食物渠道原始层采集 CLI。"""
from __future__ import annotations

import argparse
import logging
import sys
from pathlib import Path

_ROOT = Path(__file__).resolve().parent
if str(_ROOT) not in sys.path:
    sys.path.insert(0, str(_ROOT))

from config import config
from importer import FoodImporter


def _setup_logging() -> None:
    logging.basicConfig(
        level=getattr(logging, config.log_level, logging.INFO),
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )


def main() -> int:
    _setup_logging()
    p = argparse.ArgumentParser(description="MXNZP 食物数据 -> loseweight init_ 表")
    sub = p.add_subparsers(dest="cmd", required=True)

    sub.add_parser("init-tables", help="执行 init_tables.sql 建表")
    sub.add_parser("categories", help="导入分类")
    sub.add_parser("stats", help="统计")

    pf = sub.add_parser("foods", help="食物列表")
    g = pf.add_mutually_exclusive_group(required=True)
    g.add_argument("--category-id", type=str, help="分类 id")
    g.add_argument("--all", action="store_true", help="全部已有分类")
    pf.add_argument("--limit-per-category", type=int, default=None)

    pd = sub.add_parser("detail", help="食物详情")
    g2 = pd.add_mutually_exclusive_group(required=True)
    g2.add_argument("--food-id", type=str)
    g2.add_argument("--batch", action="store_true")
    pd.add_argument("--limit", type=int, default=500)
    dg = pd.add_mutually_exclusive_group()
    dg.add_argument("--only-missing", action="store_true", help="批量时仅补缺详情（默认）")
    dg.add_argument(
        "--include-existing", action="store_true", help="批量时重拉已有成功详情的 foodId"
    )

    pi = sub.add_parser("images", help="食物图片")
    g3 = pi.add_mutually_exclusive_group(required=True)
    g3.add_argument("--food-ids", type=str, help="逗号分隔，最多 10 个")
    g3.add_argument("--batch", action="store_true")
    pi.add_argument("--limit", type=int, default=500)
    ig = pi.add_mutually_exclusive_group()
    ig.add_argument("--only-missing", action="store_true", help="批量时仅补缺图片行（默认）")
    ig.add_argument("--include-existing", action="store_true", help="批量时重拉已有图片记录")
    pi.add_argument(
        "--batch-size",
        type=int,
        default=10,
        help="已废弃：images/list 固定每 HTTP 请求 10 个 id（接口上限）",
    )
    pi.add_argument(
        "--from-detail",
        action="store_true",
        help="批量时从 init_food_channel_detail（detail_status=success）取 foodId，而非 item 表",
    )

    ps = sub.add_parser("search", help="搜索补采")
    ps.add_argument("--keyword", type=str, required=True)
    ps.add_argument("--max-pages", type=int, default=1)

    args = p.parse_args()
    imp = FoodImporter()

    if args.cmd == "init-tables":
        imp.init_tables()
        print("init_tables 已执行。")
        return 0
    if args.cmd == "categories":
        n = imp.import_categories()
        print(f"分类写入 {n} 条。")
        return 0
    if args.cmd == "stats":
        s = imp.stats()
        print(
            "categories={categories}, items={items}, details(success)={details}, "
            "images(success)={images}, no_image={images_no_image}, invalid_id={images_invalid_id}, "
            "images(api_error)={images_api_error}".format(**s)
        )
        return 0
    if args.cmd == "foods":
        lim = args.limit_per_category
        if args.all:
            n = imp.import_foods_all(limit_per_category=lim)
        else:
            n = imp.import_foods_by_category(args.category_id, limit_per_category=lim)
        print(f"食物列表分页累计 {n} 条。")
        return 0
    if args.cmd == "detail":
        if args.food_id:
            ok = imp.import_food_detail(args.food_id)
            print("成功" if ok else "失败或未返回有效数据")
            return 0 if ok else 1
        only_missing = not args.include_existing
        okc, errc = imp.import_food_detail_batch(limit=args.limit, only_missing=only_missing)
        print(f"批量详情：成功 {okc}，失败/无数据 {errc}。")
        return 0
    if args.cmd == "images":
        if args.food_ids:
            ids = [x.strip() for x in args.food_ids.split(",") if x.strip()]
            if len(ids) > 10:
                print("单次 --food-ids 最多 10 个。", file=sys.stderr)
                return 2
            n = imp.import_food_images(ids)
            print(f"图片行 {n} 条。")
            return 0
        only_missing = not args.include_existing
        src = "detail" if args.from_detail else "item"
        n = imp.import_food_images_batch(
            limit=args.limit,
            only_missing=only_missing,
            batch_size=10,
            id_source=src,
        )
        print(f"批量图片累计 {n} 条（id 来源: {src}）。")
        return 0
    if args.cmd == "search":
        n = imp.search_and_import(args.keyword, max_pages=args.max_pages)
        print(f"搜索补采 item {n} 条。")
        return 0

    return 2


if __name__ == "__main__":
    raise SystemExit(main())
