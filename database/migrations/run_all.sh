#!/usr/bin/env bash
# 按顺序执行 V001～V013（跳过 V014 可选脚本）
# 用法:
#   cd database/migrations
#   export MYSQL_PWD='你的密码'   # 可选
#   ./run_all.sh root 127.0.0.1 3306 loseweight

set -euo pipefail
USER="${1:-root}"
HOST="${2:-127.0.0.1}"
PORT="${3:-3306}"
DB="${4:-loseweight}"
HERE="$(cd "$(dirname "$0")" && pwd)"

while IFS= read -r f; do
  [ -n "$f" ] || continue
  base="$(basename "$f")"
  case "$base" in
    V014__*) continue ;;
  esac
  echo ">>> $base"
  mysql -h "$HOST" -P "$PORT" -u "$USER" --default-character-set=utf8mb4 "$DB" < "$f"
done < <(find "$HERE" -maxdepth 1 -name 'V*.sql' | sort)

echo "Done. (V014 optional_drop_legacy_tables.sql 未执行)"
