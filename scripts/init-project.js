#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const colors = {
  reset: '\x1b[0m',
  cyan: '\x1b[36m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
};

function log(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function logSection(title) {
  log('\n========================================', 'cyan');
  log(title, 'cyan');
  log('========================================\n', 'cyan');
}

function executeCommand(command, description) {
  try {
    log(`${description}...`, 'yellow');
    execSync(command, { stdio: 'inherit', shell: true });
    log(`✓ ${description}成功`, 'green');
    return true;
  } catch (error) {
    log(`✗ ${description}失败`, 'red');
    return false;
  }
}

function isDirEmpty(dirPath) {
  try {
    const entries = fs.readdirSync(dirPath);
    return entries.length === 0;
  } catch {
    return true;
  }
}

async function initProject() {
  logSection('开始初始化减肥小程序前端项目');

  const repoRootDir = path.resolve(__dirname, '..');
  const projectDir = path.join(repoRootDir, 'frontend');
  const packageJsonPath = path.join(projectDir, 'package.json');

  // Step 1: 创建项目目录
  log('[1/5] 创建项目目录...', 'yellow');
  if (!fs.existsSync(projectDir)) {
    fs.mkdirSync(projectDir, { recursive: true });
    log(`✓ 项目目录创建成功: ${projectDir}`, 'green');
  } else {
    log(`✓ 项目目录已存在: ${projectDir}`, 'green');
  }

  // Step 2: 初始化 uni-app 项目
  log('\n[2/5] 初始化 uni-app 项目...', 'yellow');
  process.chdir(projectDir);

  if (fs.existsSync(packageJsonPath) && !isDirEmpty(projectDir)) {
    log('✓ 检测到现有前端项目，跳过模板克隆', 'green');
  } else {
    if (!executeCommand('npx degit dcloudio/uni-preset-vue#vite-ts .', 'degit 克隆')) {
      process.exit(1);
    }
  }

  // Step 3: 安装依赖
  log('\n[3/5] 安装依赖...', 'yellow');
  if (!executeCommand('npm install', 'npm install')) {
    process.exit(1);
  }

  // Step 4: 删除样例页面和模板文件
  log('\n[4/5] 清理模板文件...', 'yellow');

  const indexPageDir = path.join(projectDir, 'src', 'pages', 'index');
  try {
    if (fs.existsSync(indexPageDir)) {
      fs.rmSync(indexPageDir, { recursive: true, force: true });
      log(`✓ 删除样例页面成功: ${indexPageDir}`, 'green');
    } else {
      log(`✓ 样例页面不存在，跳过删除`, 'green');
    }
  } catch (error) {
    log(`✗ 删除样例页面失败: ${error.message}`, 'red');
  }

  // Step 5: 删除 H5 入口文件
  log('\n[5/5] 删除 H5 入口文件...', 'yellow');
  const indexHtmlFile = path.join(projectDir, 'index.html');
  try {
    if (fs.existsSync(indexHtmlFile)) {
      fs.unlinkSync(indexHtmlFile);
      log(`✓ 删除 index.html 成功: ${indexHtmlFile}`, 'green');
    } else {
      log(`✓ index.html 不存在，跳过删除`, 'green');
    }
  } catch (error) {
    log(`✗ 删除 index.html 失败: ${error.message}`, 'red');
  }

  logSection('✓ 项目初始化完成！');

  log('后续步骤:', 'yellow');
  log('1. 进入项目目录: cd frontend', 'reset');
  log('2. 启动微信小程序开发: npm run dev:mp-weixin', 'reset');
  log('3. 在微信开发者工具中打开 dist/dev/mp-weixin 目录', 'reset');
  log('', 'reset');
}

initProject().catch((error) => {
  log(`\n✗ 初始化失败: ${error.message}`, 'red');
  process.exit(1);
});
