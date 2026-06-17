#!/bin/bash
# 用法: boxes.sh <图片.png> [min_conf=40]
# 输出: 置信度|文本|left,top,width,height （图像像素坐标）
set -euo pipefail
IMG="$1"
MINCONF="${2:-40}"
tesseract "$IMG" stdout -l chi_sim+eng --psm 11 tsv 2>/dev/null | awk -F'\t' -v mc="$MINCONF" '
NR > 1 && $11 != "-1" && $11 + 0 >= mc && $12 != "" && $12 != " " {
  printf "%s|%s|%s,%s,%s,%s\n", $11, $12, $7, $8, $9, $10
}'
