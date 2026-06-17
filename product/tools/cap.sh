#!/bin/bash
# 用法: cap.sh <输出文件.png> [窗口名包含, 默认 宝护健康]
# 按窗口名实时解析 windowNumber 后截图（窗口 id 会变化，不能写死）
set -euo pipefail
OUT="$1"
NAME="${2:-宝护健康}"
WIN_ID=$(osascript -l JavaScript -e '
ObjC.import("CoreGraphics");
function run(argv) {
  const target = argv[0];
  const ref = $.CGWindowListCopyWindowInfo($.kCGWindowListOptionOnScreenOnly | $.kCGWindowListExcludeDesktopElements, $.kCGNullWindowID);
  const nsarr = ObjC.castRefToObject(ref);
  for (let i = 0; i < nsarr.count; i++) {
    const w = ObjC.deepUnwrap(nsarr.objectAtIndex(i));
    if (w.kCGWindowOwnerName === "微信" && (w.kCGWindowName || "").indexOf(target) >= 0) {
      return String(w.kCGWindowNumber);
    }
  }
  return "";
}' "$NAME")
if [ -z "$WIN_ID" ]; then
  echo "ERROR: window not found: $NAME" >&2
  exit 1
fi
screencapture -l"$WIN_ID" -x -o -t png "$OUT"
echo "$OUT"
