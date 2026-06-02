---
name: bugfix-minimal-change
description: Fix bugs with the smallest possible scope, preserving existing structure, behavior, and compatibility.
---

# Bugfix Minimal Change Skill

用于 bug 修复、联调修复、回归修复、线上问题排查等场景。

## When to use

在以下任务中使用：

- 某个页面有 bug
- 某个接口异常
- 某个字段不对
- 某个交互失效
- 真机调试与开发工具行为不一致
- 图片、登录、请求、路由、弹层等局部问题修复

---

## Core Rule

修 bug 的目标不是“顺便优化代码”，而是：

**精准定位问题，用最小范围修复问题，并确保不破坏原有行为。**

---

## Workflow

### Step 1. Define the symptom
先明确用户看到的现象，而不是先猜原因。

输出格式：
- 现象：
- 复现方式：
- 实际结果：
- 预期结果：

---

### Step 2. Narrow the cause
先缩小范围，再定位根因。

输出格式：
- 可能原因 1：
- 可能原因 2：
- 最可能根因：
- 依据：

---

### Step 3. Pick the smallest fix
只选择足够修复问题的最小改动方案。

输出格式：
- 最小修复方案：
- 需要修改的文件：
- 不需要修改的文件：
- 为什么不扩大改动：

---

### Step 4. Preserve compatibility
修复时必须默认保持：

- 页面结构不变
- 接口协议不变
- 数据模型不变
- 现有交互不变
- 现有样式不变

除非用户明确要求，否则不得突破这些边界。

---

### Step 5. Verify and regression check
修完必须给：

- 本问题验证步骤
- 相关回归检查点
- 风险点

---

## Hard Constraints

默认禁止：

- 借修 bug 重构模块
- 借修 bug 优化架构
- 借修 bug 改 UI 风格
- 借修 bug 改接口协议
- 借修 bug 改数据库结构

---

## Quick Prompt

“使用 bugfix-minimal-change：先定义现象和预期，缩小原因范围，选择最小修复方案，不扩大改动，并给出验证步骤和回归检查点。”