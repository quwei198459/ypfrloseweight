#!/bin/bash
# 用法: proc_product.sh <序号NNN> <产品名(用于目录)> <列表页点击y(图像px)>
# 完整处理一个产品：点击进详情 → 校验 → 滚动采集全屏 → 返回列表 → 校验
set -uo pipefail
cd "$(dirname "$0")/.."
NDX="$1"; NAME="$2"; CLICKY="$3"
SAFE=$(echo "$NAME" | tr '/ ' '__' | tr -d '"')
DIR="product-knowledge-base/images/${NDX}-${SAFE}"

is_on_category() {
  # 截窗口顶部标题区做快速 OCR，判断是否在「产品分类」页
  POS=$(./tools/winpos.sh); WX=$(echo "$POS" | cut -d, -f1); WY=$(echo "$POS" | cut -d, -f2)
  screencapture -x -R"$((WX+130)),$((WY+22)),160,42" shots/title_check.png
  tesseract shots/title_check.png stdout -l chi_sim --psm 7 2>/dev/null | grep -q "产品分类"
}

# 1) 点击产品卡（x=450 避开右侧购物车按钮）
./tools/tap.sh 450 "$CLICKY" >/dev/null
sleep 1.6

# 2) 校验已离开分类页（最多重试一次点击）
if is_on_category; then
  ./tools/tap.sh 450 "$CLICKY" >/dev/null
  sleep 1.6
  if is_on_category; then
    echo "FAIL_ENTER ${NDX} ${NAME}"
    exit 2
  fi
fi

# 3) 采集详情全部屏幕
./tools/capdetail.sh "$DIR" >/dev/null
SCREENS=$(ls "$DIR" | grep -c screen || true)

# 4) 返回列表（最多重试 3 次；处理可能的多级页面）
for t in 1 2 3; do
  ./tools/tap.sh 70 82 >/dev/null
  sleep 1.3
  if is_on_category; then
    echo "OK ${NDX} ${NAME} screens=${SCREENS}"
    exit 0
  fi
done
echo "FAIL_BACK ${NDX} ${NAME} screens=${SCREENS}"
exit 3
