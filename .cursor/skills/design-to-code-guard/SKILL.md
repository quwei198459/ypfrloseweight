---
name: design-to-code-guard
description: Guard the design-to-code process to preserve fidelity, structure, and maintainability.
---

# Design to Code Guard Skill

用于设计稿转代码、截图复刻、页面静态生成、设计修复、前端页面补齐等场景。

## When to use

在以下场景中启用：

- 根据设计稿生成页面
- 根据截图修复页面
- 根据 .pen / 设计说明生成静态页面
- 补齐缺失页面
- 做高保真还原
- 检查设计稿与代码是否一致

---

## Core Rule

设计到代码的目标不是“做出一个差不多的页面”，而是：

**在结构、视觉、交互上尽可能贴近目标设计，并保持代码可维护。**

---

## Workflow

### Step 1. Identify the source of truth
先明确当前以什么为准：

- 设计稿
- 原截图
- 已有前端页面
- PRD
- 页面流程说明

如果多个来源冲突，要先说明优先级。

---

### Step 2. Extract page structure
先拆页面区块，再写代码。

输出格式：
- 页面区块：
- 每个区块的作用：
- 固定元素：
- 动态元素：
- 交互元素：

---

### Step 3. Preserve layout and hierarchy
实现时必须尽量保持：

- 模块顺序
- 容器层级
- 关键间距关系
- 对齐关系
- 固定定位 / 滚动关系
- 点击热区分布

---

### Step 4. Avoid fake fidelity
禁止使用以下方式伪造效果：

- 过量绝对定位
- 大量魔法数字堆砌
- 与设计稿结构不一致的硬编码
- 无语义命名
- 牺牲后续维护性的临时拼接

---

### Step 5. Report gap explicitly
如果设计稿有问题或信息不足，必须说明：

- 缺少哪些信息
- 当前做了什么合理假设
- 哪些地方需要后续确认

---

### Step 6. Verify against design
完成后至少给出：

- 与设计稿对比维度
- 与截图对比维度
- 交互验证步骤
- 样式验证重点

---

## Hard Constraints

默认禁止：

- 擅自美化
- 擅自改版
- 擅自删减页面区块
- 擅自添加设计稿里没有的重要元素
- 擅自改变交互路径

---

## Quick Prompt

“使用 design-to-code-guard：先明确设计依据，拆页面结构，按高保真方式实现，不要擅自改版，并给出与设计稿/截图的验证清单。”