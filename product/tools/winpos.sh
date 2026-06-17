#!/bin/bash
# 用法: winpos.sh [窗口名包含, 默认 宝护健康]
# 输出: X,Y,W,H（逻辑坐标，配合 2x Retina 截图换算：屏幕点 = X + 图像px/2）
set -euo pipefail
NAME="${1:-宝护健康}"
osascript -l JavaScript -e '
ObjC.import("CoreGraphics");
function run(argv) {
  const target = argv[0];
  const ref = $.CGWindowListCopyWindowInfo($.kCGWindowListOptionOnScreenOnly | $.kCGWindowListExcludeDesktopElements, $.kCGNullWindowID);
  const nsarr = ObjC.castRefToObject(ref);
  for (let i = 0; i < nsarr.count; i++) {
    const w = ObjC.deepUnwrap(nsarr.objectAtIndex(i));
    if (w.kCGWindowOwnerName === "微信" && (w.kCGWindowName || "").indexOf(target) >= 0) {
      const b = w.kCGWindowBounds;
      return Math.round(b.X) + "," + Math.round(b.Y) + "," + Math.round(b.Width) + "," + Math.round(b.Height);
    }
  }
  return "NOT_FOUND";
}' "$NAME"
