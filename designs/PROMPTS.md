## 说明

这里用于保存所有用 Pencil（`.pen`）生成/调整页面时使用的提示词（Prompt），便于：

- 复用：后续页面直接套用同一套约束与风格
- 对齐：团队成员使用同一语言描述需求，减少“口口相传”的偏差
- 追溯：每次改动为什么这么做可被回放

建议每个页面至少保存 3 类内容：

- **Base Prompt（页面基础约束）**：布局栅格、尺寸、字体、色板、圆角、间距、组件命名规范
- **Delta Prompt（本次变更点）**：只描述“相对上一次”改了什么
- **Acceptance（验收要点）**：用于自检/走查的 checklist（1:1、可编辑、可复用、适配 375 宽等）

---

## 全局约束（推荐模板）

复制下面模板到每个页面条目里使用：

```text
目标：生成高保真微信小程序页面设计稿（375 宽逻辑），图层必须可编辑（text/rectangle/ellipse/frame），禁止贴图。

约束：
- 画板：375x812（或注明实际目标尺寸），layout: none（绝对布局）
- 所有组件必须命名清晰（例如：Button/Login、Agreement、Popup/Agreement）
- 颜色：主色/辅助色/背景色写清楚；同名色保持一致
- 圆角：按钮/卡片/输入框分别给定（例如：按钮 28、输入框 14、弹窗 20）
- 间距：主要区块的 y 坐标或间距要稳定可复用
- 弹窗/加载态做成 reusable component（reusable=true）

验收：
- 不存在 image fill
- 页面结构与命名符合约定
- 组件可复用：popup/loader 能作为 ref 实例插入到其它画板
```

---

## 页面：Login（login.pen）

### login_01（ck2Xe）

```text
基于 login_01 参考风格，重建为可编辑设计稿：
- 顶部：App Icon + 标题 + 副标题
- 主按钮：账号登录（微信一键登录）
- 协议勾选区域：文本分段可编辑
```

### login_02_status（p9onl）

```text
在 login_01 基础上增加 loading 状态：
- 按钮呈现 loading/禁用表现（降低 opacity）
- 居中加载弹层：深色容器 + “登录中” + spinner
```

### login_03_popup（TvfiA）

```text
底层保持 login_01，并增加可复用弹窗组件：
- Component/Popup/Agreement（reusable=true）
  - Mask（半透明遮罩）
  - Popup Container + Popup BG
  - Popup Text
  - Popup Actions：Cancel / Confirm
页面插入实例：Popup/Agreement
```

