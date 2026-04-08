---
name: "init-frontend-project"
description: "Bootstraps this repo's uni-app frontend and verifies setup. Invoke when setting up a new machine, fixing env issues, or re-initializing the frontend workflow."
---

# 初始化前端项目（uni-app / mp-weixin）

本技能用于把“初始化前端项目”的文档步骤固化为可重复执行的操作序列，并在执行前后做关键校验，避免误覆盖、误路径、环境不一致。

## 何时调用

- 新电脑首次拉取仓库，需要把前端跑起来
- `frontend/node_modules` 缺失或依赖异常，需要修复
- `npm run dev:mp-weixin` / `npm run type-check` 无法运行，需要排障
- 想确认 appid、目录结构、脚本入口是否一致

## 执行步骤（按顺序）

### 1）仓库与目录校验

- 确认仓库根目录包含 `scripts/init-project.js` 与 `frontend/`（若 `frontend/` 不存在，则需要初始化；若存在则进入“修复/补全依赖”模式）
- 识别 `frontend/package.json` 是否存在
  - 存在：视为“已有前端项目”，严禁执行会覆盖文件的模板克隆
  - 不存在：允许使用模板初始化（会生成全套前端结构）

### 2）Node / npm 环境校验

- 读取 `frontend/package.json` 的 `engines.node`，确保 Node 版本满足要求
- 在 Windows 环境下，优先使用项目内的 `.nvmrc`（若存在）提示使用者对齐版本

### 3）初始化或修复（统一入口）

- 在仓库根目录执行：
  - `node scripts/init-project.js`
- 预期行为（由脚本保证）：
  - 使用仓库根目录下的 `frontend/` 作为目标目录
  - 若检测到现有项目则跳过 `degit` 克隆，仅做依赖安装与模板清理

### 4）关键配置一致性校验（P0）

- 校验 `frontend/src/manifest.json` 中 `mp-weixin.appid` 是否已配置（避免把 dist 产物当作配置源头）
- 若存在 `frontend/dist/dev/mp-weixin/project.config.json`：
  - 仅用于微信开发者工具导入
  - 不作为 appid 的权威来源

### 5）类型校验（必须）

- 在 `frontend/` 下执行：
  - `npm run type-check`
- 若失败：
  - 优先修复缺失导入/类型声明问题
  - 再继续后续开发，避免把类型债务滚入业务迭代

### 6）启动开发（按需）

- 在 `frontend/` 下执行：
  - `npm run dev:mp-weixin`
- 微信开发者工具导入目录：
  - `frontend/dist/dev/mp-weixin`

## 常见保护策略（必须遵守）

- 任何会“覆盖现有 frontend 源码”的操作都必须先判定 `frontend/package.json` 是否存在
- 依赖安装默认使用 `npm install`；若项目未来切换到 `npm ci`，需同步更新脚本与本技能
- dist 是构建产物：可以存在，但不应成为配置权威来源
