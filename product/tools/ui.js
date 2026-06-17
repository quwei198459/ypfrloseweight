#!/usr/bin/env osascript -l JavaScript
// 小程序窗口自动化助手（CGEvent 注入，需「辅助功能」权限）
// 用法:
//   ui.js raise <进程名> <窗口名包含>     置顶指定窗口
//   ui.js click <x> <y>                  在屏幕坐标点击（左键单击）
//   ui.js move <x> <y>                   移动鼠标
//   ui.js scroll <x> <y> <dy> [次数]     在坐标处滚动，dy 负数向下滚内容
//   ui.js drag <x1> <y1> <x2> <y2>       按下拖拽到目标点（模拟触摸滑动）
ObjC.import("CoreGraphics");
ObjC.import("Foundation");

function sleep(s) { $.NSThread.sleepForTimeInterval(s); }

function post(ev) {
  $.CGEventPost($.kCGHIDEventTap, ev);
}

function mouseEvent(type, x, y) {
  const pt = { x: x, y: y };
  const ev = $.CGEventCreateMouseEvent($(), type, pt, $.kCGMouseButtonLeft);
  post(ev);
}

function click(x, y) {
  mouseEvent($.kCGEventMouseMoved, x, y);
  sleep(0.08);
  mouseEvent($.kCGEventLeftMouseDown, x, y);
  sleep(0.06);
  mouseEvent($.kCGEventLeftMouseUp, x, y);
}

function scroll(x, y, dy, times) {
  mouseEvent($.kCGEventMouseMoved, x, y);
  sleep(0.1);
  for (let i = 0; i < times; i++) {
    const ev = $.CGEventCreateScrollWheelEvent($(), $.kCGScrollEventUnitPixel, 1, dy);
    post(ev);
    sleep(0.03);
  }
}

function drag(x1, y1, x2, y2) {
  mouseEvent($.kCGEventMouseMoved, x1, y1);
  sleep(0.1);
  mouseEvent($.kCGEventLeftMouseDown, x1, y1);
  sleep(0.15);
  const steps = 20;
  for (let i = 1; i <= steps; i++) {
    const nx = x1 + ((x2 - x1) * i) / steps;
    const ny = y1 + ((y2 - y1) * i) / steps;
    const ev = $.CGEventCreateMouseEvent($(), $.kCGEventLeftMouseDragged, { x: nx, y: ny }, $.kCGMouseButtonLeft);
    post(ev);
    sleep(0.015);
  }
  sleep(0.1);
  mouseEvent($.kCGEventLeftMouseUp, x2, y2);
}

function raise(procName, winNameContains) {
  const se = Application("System Events");
  const proc = se.processes.byName(procName);
  const wins = proc.windows();
  for (const w of wins) {
    const name = w.name();
    if (name && name.indexOf(winNameContains) >= 0) {
      w.actions.byName("AXRaise").perform();
      proc.frontmost = true;
      return "raised: " + name;
    }
  }
  return "NOT FOUND: " + winNameContains;
}

function run(argv) {
  const cmd = argv[0];
  if (cmd === "raise") return raise(argv[1], argv[2]);
  if (cmd === "click") { click(Number(argv[1]), Number(argv[2])); return "clicked"; }
  if (cmd === "move") { mouseEvent($.kCGEventMouseMoved, Number(argv[1]), Number(argv[2])); return "moved"; }
  if (cmd === "scroll") { scroll(Number(argv[1]), Number(argv[2]), Number(argv[3]), Number(argv[4] || 1)); return "scrolled"; }
  if (cmd === "drag") { drag(Number(argv[1]), Number(argv[2]), Number(argv[3]), Number(argv[4])); return "dragged"; }
  return "unknown cmd";
}
