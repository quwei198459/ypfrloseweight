#!/usr/bin/env python3
"""食物 init_* -> check_food_staging -> food 迁移 CLI。"""
from __future__ import annotations

import argparse
import logging
import sys
from pathlib import Path

_ROOT = Path(__file__).resolve().parent
if str(_ROOT) not in sys.path:
    sys.path.insert(0, str(_ROOT))

from config import config
from migrator import (
    CheckTablesNotInitializedError,
    generate_food_staging,
    migrate_categories,
    migrate_foods_to_formal,
    recalc_staging_unit_calories,
    refetch_images_from_init,
    repair_images,
    run_migration_tables_sql,
    stats,
)


def _setup_logging() -> None:
    logging.basicConfig(
        level=getattr(logging, config.log_level, logging.INFO),
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )


def main() -> int:
    _setup_logging()
    p = argparse.ArgumentParser(
        description="loseweight 食物迁移：check_food_staging / check_food_source_mapping 等（无后台）"
    )
    sub = p.add_subparsers(dest="cmd", required=True)

    sub.add_parser("init", help="执行 migration_tables.sql 创建 check_* 表")

    sub.add_parser("migrate-categories", help="init 分类 -> food_category + check_food_category_source_mapping")

    gs = sub.add_parser("generate-staging", help="生成 check_food_staging 并下载图片")
    gs.add_argument("--limit", type=int, default=None, help="最多处理条数")
    g = gs.add_mutually_exclusive_group()
    g.add_argument(
        "--only-new",
        dest="only_new",
        action="store_true",
        help="仅 channel_food_id 尚不在 check_food_staging 的条目（默认）",
    )
    g.add_argument(
        "--all",
        dest="only_new",
        action="store_false",
        help="扫描全部 init 条目（已存在 staging 会因唯一约束跳过）",
    )
    gs.set_defaults(only_new=True)

    ri = sub.add_parser("repair-images", help="对 staging 补下载或重试失败图片")
    ri.add_argument("--limit", type=int, default=None)

    rf = sub.add_parser(
        "refetch-init-images",
        help="用 init_food_channel_image.image_url 刷新 staging 并下载（无 URL 则用 item.cover）",
    )
    rf.add_argument("--limit", type=int, default=None)
    rf.add_argument(
        "--force",
        action="store_true",
        help="删除已有 mxnzp_{foodId}.* 后强制重新下载",
    )

    mf = sub.add_parser("migrate-formal", help="审核通过且未迁移 -> food + check_food_source_mapping")
    mf.add_argument("--limit", type=int, default=None)

    ru = sub.add_parser(
        "recalc-unit-calories",
        help="人工补 unit_name 后，按公式回填 calories_per_unit（可选补 standard_weight；不调用在线大模型）",
    )
    ru.add_argument("--limit", type=int, default=None)
    ru.add_argument(
        "--no-fill-standard",
        action="store_true",
        help="不自动推断 standard_weight_*（必须在库中已填好标准量）",
    )
    ru.add_argument(
        "--only-if-null-cpu",
        action="store_true",
        help="仅 calories_per_unit 为空的行才重算",
    )

    sub.add_parser(
        "init-unit-fields",
        help="仅初始化「有 unit_name 且 calories_per_unit 仍为空」的行（不覆盖已有每单位热量/不改编 unit_name）",
    )

    sub.add_parser("stats", help="统计 init / check_* / food / 本地图片等")

    args = p.parse_args()

    def _run_db_cmd(fn, *a, **kw):
        try:
            return fn(*a, **kw)
        except CheckTablesNotInitializedError as e:
            print(str(e), file=sys.stderr)
            return None

    if args.cmd == "init":
        run_migration_tables_sql()
        print("已执行 tools/food_migration/migration_tables.sql（check_* 表）。")
        return 0
    if args.cmd == "migrate-categories":
        r = _run_db_cmd(migrate_categories)
        if r is None:
            return 2
        print(f"新增分类映射行数: {r}")
        return 0
    if args.cmd == "generate-staging":
        r = _run_db_cmd(generate_food_staging, limit=args.limit, only_new=args.only_new)
        if r is None:
            return 2
        print(f"新插入 check_food_staging 行数: {r}")
        return 0
    if args.cmd == "repair-images":
        r = _run_db_cmd(repair_images, limit=args.limit)
        if r is None:
            return 2
        print(f"已尝试补图/更新状态行数: {r}")
        return 0
    if args.cmd == "refetch-init-images":
        r = _run_db_cmd(refetch_images_from_init, limit=args.limit, force=args.force)
        if r is None:
            return 2
        print(f"已按 init_food_channel_image 刷新并尝试下载行数: {r}")
        return 0
    if args.cmd == "migrate-formal":
        r = _run_db_cmd(migrate_foods_to_formal, limit=args.limit)
        if r is None:
            return 2
        print(f"成功迁移至 food 行数: {r}")
        return 0
    if args.cmd == "recalc-unit-calories":
        r = _run_db_cmd(
            recalc_staging_unit_calories,
            limit=args.limit,
            fill_standard=not args.no_fill_standard,
            only_if_null_cpu=args.only_if_null_cpu,
        )
        if r is None:
            return 2
        u, sk = r
        print(f"已更新行数: {u}，跳过（缺标准量或热量）: {sk}")
        return 0
    if args.cmd == "init-unit-fields":
        r = _run_db_cmd(
            recalc_staging_unit_calories,
            limit=None,
            fill_standard=True,
            only_if_null_cpu=True,
        )
        if r is None:
            return 2
        u, sk = r
        print(f"已初始化（仅 cpu 为空）: {u} 行；跳过: {sk} 行（已有 calories_per_unit 的未修改）")
        return 0
    if args.cmd == "stats":
        r = _run_db_cmd(stats)
        if r is None:
            return 2
        s = r
        keys = [
            ("init 分类数", "init_categories"),
            ("正式分类数", "formal_categories"),
            ("分类映射数 (check_food_category_source_mapping)", "category_mappings"),
            ("init 食物数", "init_foods"),
            ("check_food_staging 行数", "staging_foods"),
            ("staging 待审核 (pending)", "staging_pending"),
            ("staging 已通过 (approved/modified_approved)", "staging_approved"),
            ("staging 已拒绝", "staging_rejected"),
            ("staging 已迁移", "staging_migrated"),
            ("正式 food 数", "formal_foods"),
            ("check_food_source_mapping 数", "food_source_mappings"),
            ("本地图片文件数", "local_image_files"),
            ("图片下载失败数 (staging)", "image_download_failed"),
        ]
        for label, k in keys:
            print(f"{label}: {s.get(k, 0)}")
        return 0
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
