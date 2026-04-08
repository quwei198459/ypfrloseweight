# 初始化前端项目代理

## 概述

这个代理用于快速初始化减肥小程序的前端项目。它会自动执行以下操作：

1. **创建项目目录** - 在项目根目录下创建 `frontend` 文件夹
2. **克隆项目模板** - 当 `frontend` 目录为空或不存在现有项目时，使用 `npx degit dcloudio/uni-preset-vue#vite-ts` 克隆官方 uni-app TypeScript 模板
3. **安装依赖** - 自动执行 `npm install` 安装所有项目依赖
4. **清理模板文件** - 删除模板中的样例页面和 H5 入口文件
5. **配置微信小程序** - 项目已预配置为支持微信小程序开发

## 快速开始

### 第一步：初始化项目

在项目根目录执行以下命令：

```bash
node scripts/init-project.js
```

脚本会自动完成项目创建和依赖安装，整个过程可能需要 5-10 分钟。

### 第二步：清理模板文件

初始化完成后，删除模板中的样例页面和不需要的文件：

```bash
# 1. 进入项目目录
cd frontend

# 2. 删除样例页面目录
# Windows
rmdir /s /q src\pages\index

# macOS/Linux
rm -rf src/pages/index

# 3. 删除 H5 入口文件（仅开发微信小程序时）
# Windows
del index.html

# macOS/Linux
rm index.html
```

或者手动删除以下文件和目录：
- `frontend/src/pages/index` 目录及其所有文件
- `frontend/index.html` 文件

### 第三步：启动开发

按照以下步骤启动开发：

```bash
# 1. 确保在 frontend 目录下
cd frontend

# 2. 启动微信小程序开发模式
npm run dev:mp-weixin
```

### 第四步：在微信开发者工具中预览

1. 打开微信开发者工具
2. 选择"导入项目"
3. 项目路径选择：`frontend/dist/dev/mp-weixin`
4. 开始开发调试

## 项目结构

初始化后的项目结构如下：

```
ypfrloseweight/
├── screenshots/          # 页面截图目录（按页面分类）
│   ├── home/            # 首页截图
│   ├── profile/         # 个人资料页截图
│   ├── weight-log/      # 体重记录页截图
│   ├── progress/        # 进度统计页截图
│   ├── settings/        # 设置页截图
│   └── other/           # 其他页面截图
├── frontend/             # 前端项目目录
│   ├── src/
│   │   ├── pages/       # 页面文件（样例页面已删除）
│   │   ├── components/  # 组件文件
│   │   ├── App.vue      # 应用入口
│   │   └── main.ts      # 应用主文件
│   ├── dist/            # 编译输出目录
│   ├── package.json
│   ├── vite.config.ts
│   └── tsconfig.json
├── scripts/              # 脚本文件目录
│   ├── init-project.js  # Node.js 初始化脚本
├── .cursor/
│   └── agents/          # 代理文件目录
└── README.md            # 项目文档
```

## 技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| uni-app3 | 最新 | 跨平台应用框架 |
| TypeScript | 5.x | 类型安全的 JavaScript |
| Vite | 5.x | 现代化构建工具 |
| Vue | 3.x | 前端框架 |
| 目标平台 | mp-weixin | 微信小程序 |

## 系统要求

- **Node.js** >= 14.0.0
- **npm** >= 6.0.0
- **微信开发者工具** - 用于预览和调试小程序

## 常见问题

### Q: 初始化失败怎么办？

A: 按照以下步骤排查：

1. 确保已安装 Node.js 和 npm
2. 检查网络连接（需要下载依赖包）
3. 清除 npm 缓存：`npm cache clean --force`
4. 重新运行初始化脚本

### Q: 如何修改项目配置？

A: 编辑以下文件：

- `frontend/vite.config.ts` - Vite 构建配置
- `frontend/src/manifest.json` - 小程序配置
- `frontend/pages.json` - 页面路由配置

### Q: 如何添加新页面？

A: 

1. 在 `frontend/src/pages` 目录下创建新的 `.vue` 文件
2. 在 `frontend/pages.json` 中配置路由
3. 重新启动开发服务器

### Q: 如何调试小程序？

A: 

1. 在微信开发者工具中打开项目
2. 使用开发者工具的调试面板
3. 查看控制台输出和网络请求

### Q: 删除样例页面和 index.html 后项目无法运行怎么办？

A: 

1. 确保已删除 `src/pages/index` 目录和 `index.html` 文件
2. 在 `pages.json` 中配置你自己的首页路由
3. 在 `src/pages` 下创建新的页面文件
4. 重新启动开发服务器

## 开发工作流

1. **初始化项目** - 运行初始化脚本创建项目
2. **清理模板文件** - 删除样例页面和 index.html
3. **启动开发服务器** - 执行 `npm run dev:mp-weixin`
4. **打开微信开发者工具** - 导入 `dist/dev/mp-weixin` 目录
5. **编辑源代码** - 修改 `src` 目录下的文件
6. **实时预览** - 开发服务器会自动编译，微信开发者工具会自动刷新
7. **根据截图复刻** - 参考 `screenshots` 目录下的页面截图进行 UI 复刻

## 相关文件

- `scripts/init-project.js` - Node.js 初始化脚本（推荐使用）
- `README.md` - 项目主文档
- `.cursor/agents/init-frontend-project.md` - 本代理文件
- `.trae/skills/init-frontend-project/SKILL.md` - Trae 下的可执行初始化技能说明

## 更多帮助

如需更多帮助，请参考：

- [uni-app 官方文档](https://uniapp.dcloud.net.cn/)
- [Vite 官方文档](https://vitejs.dev/)
- [TypeScript 官方文档](https://www.typescriptlang.org/)
- [微信小程序开发文档](https://developers.weixin.qq.com/miniprogram/dev/framework/)
