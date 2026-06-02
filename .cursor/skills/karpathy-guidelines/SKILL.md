---
name: karpathy-guidelines
description: Apply careful, minimal, goal-driven engineering discipline before and during code changes.
---

# Karpathy Guidelines Skill

这个 skill 用于在复杂任务、模糊需求、跨文件改动、代码修复、重构评估时，强制执行“先思考、后动手”的工程纪律。

## When to use

在以下场景中优先启用本 skill：

- 需求存在歧义
- 改动可能影响多个模块
- 用户要求“稳健”“最小改动”“不要改样式”“不要动结构”
- 要做 bug 修复、联调、排查、兼容性处理
- 要评估是否应该重构
- 要在已有系统上新增能力，但需严格控制范围

---

## Core Principles

### 1. Think Before Coding
先理解目标、假设、边界，再修改代码。

### 2. Simplicity First
优先最简单、最直接、最少改动的实现方式。

### 3. Surgical Changes
只改必要代码，不顺手改无关内容。

### 4. Goal-Driven Execution
围绕成功标准执行，每一步都可验证。

---

## Required Workflow

执行任务时，按以下流程输出：

### Step 1. Restate the task
先用简洁语言复述任务目标。

格式示例：

- 目标：
- 成功标准：
- 本次不应改动的范围：

---

### Step 2. Identify assumptions and ambiguity
列出当前假设与不确定点。

格式示例：

- 已知：
- 假设：
- 风险点：
- 若假设不成立的影响：

---

### Step 3. Choose the simplest viable plan
给出最小可行方案，而不是最大方案。

格式示例：

- 最小改动方案：
- 需要修改的文件：
- 不需要修改的文件：
- 为什么这是最稳妥的方案：

---

### Step 4. Make surgical changes
改动时遵守：

- 只改与任务直接相关内容
- 不扩大影响面
- 不做顺手优化
- 不改无关命名/结构/格式

---

### Step 5. Verify explicitly
完成后必须给验证方案。

格式示例：

- 验证步骤 1：
- 验证步骤 2：
- 预期结果：
- 回归检查点：

---

### Step 6. Report scope clearly
最后明确说明改动范围。

格式示例：

- 已修改：
- 未修改：
- 潜在风险：
- 后续如要继续，建议下一步是什么：

---

## Response Style

输出风格要求：

- 先分析，后执行
- 先计划，后改动
- 简洁清晰，不说空话
- 不夸大完成度
- 不隐藏风险
- 不把猜测说成事实

---

## Hard Constraints

默认禁止：

- 无关重构
- 擅自扩大需求
- 擅自修改页面结构
- 擅自改数据库
- 擅自改接口协议
- 擅自引入新依赖
- 擅自抽象通用层

---

## Success Definition

一个任务只有在满足以下条件时才算完成：

1. 目标被正确理解
2. 改动范围最小
3. 修改内容与需求直接对应
4. 验证路径明确
5. 风险已说明
6. 不影响无关功能

---

## Short Operating Prompt

当需要快速调用本 skill 时，可使用下面这段指令：

“使用 karpathy-guidelines：先复述目标，再列出假设与风险，选择最小可行方案，只做必要改动，并给出明确验证步骤与影响范围说明。”