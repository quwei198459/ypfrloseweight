# 电商首页 Figma 同步状态

- 创建时间：2026-04-16
- 目标风格：淘宝风格电商 App 首页
- Figma 文件名：`电商App首页-淘宝风格-20260416`
- Figma 文件 Key：`JhnWpT9ObKSBqnNcOkPxbG`
- Figma 文件链接：https://www.figma.com/design/JhnWpT9ObKSBqnNcOkPxbG

## 当前状态

- 已成功通过 MCP 创建 Figma 文件。
- **若在浏览器中打开该链接，左侧只有「Page 1」且图层面板为空**：说明云端画布上**尚未出现**我们期望的图层。常见原因如下（见下节「为何浏览器里是空白」）。
- 此前会话里 `use_figma` 曾回报执行成功，但**插件 API 实际写入的是「当前在 Figma 桌面端/MCP 所关联会话中的文件」**；若当时未在桌面端打开同一 `fileKey` 文件，或写入落在新建页面而未同步到你看到的视图，就会出现「链接打开是空稿」的现象。

## 为何浏览器里是空白

1. **`use_figma` 依赖 Figma 桌面端插件上下文**：建议在 **Figma Desktop** 中打开同一文件（同一链接），并保持 Cursor 与 Figma MCP 已连接，再执行写入。
2. **页面不一致**：若脚本新建了名为 `Home / 电商首页` 的页面，而你只盯着默认的 **Page 1**，请在左侧 **Pages** 展开查看是否还有其它页面；若始终只有 Page 1，则说明写入未落到该云端文件。
3. **本地 `.fig` 与云端文件不是同一个东西**：从菜单另存得到的 `test.fig` 是**本地副本**，改云端链接里的文件不会自动改你磁盘上的 `.fig`，反之亦然。

## 推荐操作（让画布上立刻有内容）

1. 安装并打开 **Figma Desktop**，用浏览器里同一账号打开：`https://www.figma.com/design/JhnWpT9ObKSBqnNcOkPxbG`
2. 在 Cursor 里**允许** Figma MCP 的 `use_figma` / `get_metadata` 执行（若弹出确认框请点允许）。
3. 让助手再次执行 `use_figma`，并**明确把画框建在默认的第一页（Page 1）上**，便于你在网页端也能立刻看到图层。

## 已准备好的参考资源（可直接用来快速补齐）

- `designs/ecommerce-home-taobao-style.md`（完整结构与视觉规范）
- `designs/ecommerce-home-taobao-style.html`（可直接预览的高保真静态原型）

## 本次已写入模块

1. 顶栏（定位 + 搜索 + 相机 + 购物车）
2. 金刚区（10 宫格）
3. 大促 Banner
4. 横向券卡
5. 推荐双列商品卡
6. 底部 TabBar

