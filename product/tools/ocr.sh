#!/bin/bash
# 用法: ocr.sh <图片.png>  → 输出简体中文+英文 OCR 文本到 stdout
set -euo pipefail
IMG="$1"
tesseract "$IMG" stdout -l chi_sim+eng --psm 6 2>/dev/null
