#!/bin/bash
# 用法: capdetail.sh <输出目录>
# 详情页长图采集：截图→下滚→截图，直到连续两屏 md5 相同（到底）或达 18 屏上限
set -euo pipefail
cd "$(dirname "$0")/.."
OUT="$1"
mkdir -p "$OUT"
chmod +x tools/*.sh 2>/dev/null || true
PREV_MD5=""
for i in $(seq 1 18); do
  F=$(printf "%s/screen-%02d.png" "$OUT" "$i")
  ./tools/cap.sh "$F" >/dev/null
  MD5=$(md5 -q "$F")
  if [ "$MD5" = "$PREV_MD5" ]; then
    rm -f "$F"
    echo "BOTTOM at screen $((i-1))"
    exit 0
  fi
  PREV_MD5="$MD5"
  # 在内容区中部下滚约 550pt
  ./tools/tap.sh scroll 414 700 -10 55 >/dev/null
  sleep 0.9
done
echo "MAX screens reached"
