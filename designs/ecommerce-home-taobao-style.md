# 电商 App 首页（淘宝风格参考）

> **说明**：当前 Cursor 会话内 Figma MCP 工具不可用，无法在云端自动写入 `.figma` 文件。本目录提供 **可导入 Figma 的规格 + 本地 HTML 原型**；你在本机启用 Figma 插件后，可将 `ecommerce-home-taobao-style.html` 用本地服务打开，再通过 Figma 的「网页/截图导入」类能力对齐画布（若你使用 `generate_figma_design` 一类流程，需按插件文档选择 `localhost` 地址）。

---

## 画板与栅格

| 项目 | 值 |
|------|-----|
| 画板名 | `Home / 电商首页` |
| 尺寸 | **375 × 812**（iPhone 逻辑宽；安全区顶部 +34、底部 +34 可按需） |
| 背景 | `#F4F4F4` |

---

## 设计令牌（Design Tokens）

| Token | 色值 | 用途 |
|-------|------|------|
| `brand.primary` | `#FF5000` | 主按钮、强调价、搜索框描边/高亮 |
| `brand.primary-dark` | `#E64500` | 按下态 |
| `text.primary` | `#111111` | 标题、主文案 |
| `text.secondary` | `#666666` | 副标题、说明 |
| `text.tertiary` | `#999999` | 弱提示 |
| `surface.page` | `#F4F4F4` | 页面底 |
| `surface.card` | `#FFFFFF` | 卡片、搜索条背景 |
| `line.divider` | `#EEEEEE` | 分割线 |

**字体**：系统字体栈 `PingFang SC`, `Helvetica Neue`, `Arial`, sans-serif；标题 **15–17px** 粗体，正文 **12–13px**，辅助 **11px**。

**圆角**：搜索条 **18px**，小标签 **4px**，大促 Banner **8px**，商品卡 **8px**。

---

## 信息架构（自上而下）

1. **顶栏 `TopBar`**
   - 左：城市/定位文案「杭州 ▾」`text.secondary` 13px
   - 中：**搜索框** 占宽 ~62%，白底、浅灰边 `#E5E5E5`，内左放大镜图标位 + 占位「搜索宝贝、店铺」`text.tertiary`
   - 右：图标区「相机」「购物车」（线框图标即可，24×24 触控区）

2. **金刚区 `QuickNav`**
   - 白底圆角卡片（可选整体底或贴顶无卡片），**两行 × 5 列** 或 **单行 5 个 + 横向滚动**
   - 每项：圆形占位 48×48（或图标）+ 文案 11px 一行截断
   - 示例文案：天猫、聚划算、充值、飞猪、外卖、分类…

3. **大促 Banner `PromoBanner`**
   - 高度约 **140–160**，圆角 8，渐变或纯色占位（`#FF5000` → `#FF7A45`）
   - 左大标题「年货节」、右小字「领券」，模拟层次即可

4. **横向运营区 `HorizontalRow`**
   - 高度 **88–100**，**横向滚动** 3–4 张券/小 Banner 卡片（宽 120，间距 8）

5. **Tab + 瀑布推荐 `Feed`**
   - Tab：「猜你喜欢」「精选」等，下划线选中色 `brand.primary`
   - **双列瀑布**：列宽 `(375 - 12*3) / 2`，卡片白底、图区比例约 **1:1** 占位，标题 2 行截断，价格 `brand.primary` 粗体 + 「券后价」小标签

6. **底部 Tab Bar（可选）**
   - 高 **56 + safe bottom**，五项：首页、逛逛、消息、购物车、我的；选中色 `brand.primary`

---

## Figma 图层命名建议

```
Home / 电商首页
├── TopBar
│   ├── Location
│   ├── SearchField
│   └── Actions
├── QuickNav
│   └── Item × 10
├── PromoBanner
├── HorizontalRow
│   └── PromoCard × n
├── FeedHeader
└── FeedGrid
    └── ProductCard × 6
```

---

## 验收 Checklist

- [ ] 375 宽下无横向溢出（除刻意横向滚动区）
- [ ] 主色与淘宝红橙区分明显但不侵权描摹官方 Logo
- [ ] 搜索框与金刚区层级清晰，可扫读
- [ ] 商品卡价格与标题对比足够

---

## 关联文件

| 文件 | 说明 |
|------|------|
| `ecommerce-home-taobao-style.html` | 浏览器打开即可预览结构；可作导入参考 |
