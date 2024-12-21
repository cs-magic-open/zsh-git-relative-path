#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

// 检查是否是全局安装
const isGlobalInstall = process.env.npm_config_global === 'true';

if (!isGlobalInstall) {
  console.log('This package should be installed globally. Please use: npm install -g @cs-magic-open/zsh-git-relative-path');
  process.exit(1);
}

// 检查是否安装了 oh-my-zsh
const omzPath = path.join(os.homedir(), '.oh-my-zsh');
if (!fs.existsSync(omzPath)) {
  console.error('Oh My Zsh is not installed. Please install it first.');
  process.exit(1);
}

// 设置插件目录
const pluginName = 'zsh-git-relative-path';
const customPluginsPath = path.join(omzPath, 'custom/plugins');
const pluginPath = path.join(customPluginsPath, pluginName);

// 创建插件目录
fs.mkdirSync(path.join(customPluginsPath, pluginName), { recursive: true });

// 复制插件文件
const packageRoot = path.join(__dirname, '..');
const filesToCopy = [
  'zsh-git-relative-path.plugin.zsh',
  'README.md',
  'LICENSE',
  'package.json'
];

filesToCopy.forEach(file => {
  fs.copyFileSync(
    path.join(packageRoot, file),
    path.join(pluginPath, file)
  );
});

// 修改 .zshrc
const zshrcPath = path.join(os.homedir(), '.zshrc');
let zshrcContent = fs.readFileSync(zshrcPath, 'utf8');

if (!zshrcContent.includes(`plugins=(${pluginName}`)) {
  // 找到 plugins 行
  const pluginsRegex = /plugins=\((.*?)\)/;
  if (pluginsRegex.test(zshrcContent)) {
    // 在现有的 plugins 中添加我们的插件
    zshrcContent = zshrcContent.replace(
      pluginsRegex,
      (match, plugins) => `plugins=(${pluginName} ${plugins})`
    );
  } else {
    // 如果没有 plugins 行，添加一个新的
    zshrcContent += `\nplugins=(${pluginName})\n`;
  }

  fs.writeFileSync(zshrcPath, zshrcContent);
}

console.log(`
\x1b[32mInstallation complete!\x1b[0m
Please run: \x1b[34msource ~/.zshrc\x1b[0m to activate the plugin

Now your prompt will show paths relative to git project root!
`);
