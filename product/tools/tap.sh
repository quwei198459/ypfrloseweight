#!/bin/bash
# 用法: tap.sh <图像px_x> <图像px_y>          —— 在小程序窗口内点击（自动置顶+换算坐标, @2x）
#       tap.sh scroll <图像px_x> <图像px_y> <dy_pt> <times>  —— 在窗口内滚动
set -euo pipefail
cd "$(dirname "$0")/.."
osascript -l JavaScript tools/ui.js raise 微信 宝护健康 >/dev/null
sleep 0.35
POS=$(./tools/winpos.sh)
if [ "$POS" = "NOT_FOUND" ]; then echo "ERROR: window lost" >&2; exit 1; fi
WX=$(echo "$POS" | cut -d, -f1)
WY=$(echo "$POS" | cut -d, -f2)
if [ "$1" = "scroll" ]; then
  SX=$((WX + $2 / 2)); SY=$((WY + $3 / 2))
  osascript -l JavaScript tools/ui.js scroll "$SX" "$SY" "$4" "$5"
else
  SX=$((WX + $1 / 2)); SY=$((WY + $2 / 2))
  osascript -l JavaScript tools/ui.js click "$SX" "$SY"
fi
