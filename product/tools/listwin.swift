import CoreGraphics
import Foundation

// 列出屏幕上所有窗口：windowNumber | ownerName | windowName | bounds
let options: CGWindowListOption = [.optionOnScreenOnly, .excludeDesktopElements]
guard let infoList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
    print("ERROR: cannot list windows")
    exit(1)
}
for info in infoList {
    let owner = info[kCGWindowOwnerName as String] as? String ?? ""
    let name = info[kCGWindowName as String] as? String ?? ""
    let num = info[kCGWindowNumber as String] as? Int ?? 0
    let layer = info[kCGWindowLayer as String] as? Int ?? 0
    var x = 0.0, y = 0.0, w = 0.0, h = 0.0
    if let b = info[kCGWindowBounds as String] as? [String: Double] {
        x = b["X"] ?? 0; y = b["Y"] ?? 0; w = b["Width"] ?? 0; h = b["Height"] ?? 0
    }
    if layer == 0 && w > 50 && h > 50 {
        print("\(num)|\(owner)|\(name)|\(Int(x)),\(Int(y)),\(Int(w)),\(Int(h))")
    }
}
