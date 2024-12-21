#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

// 检查是否是全局卸载
const isGlobalUninstall = process.env.npm_config_global === 'true';

if (!isGlobalUninstall) {
  console.log('This package should be uninstalled globally. Please use: npm uninstall -g @cs-magic-open/zsh-git-relative-path');
  process.exit(1);
}

// 清理插件目录
const pluginName = 'zsh-git-relative-path';
const omzPath = path.join(os.homedir(), '.oh-my-zsh');
const pluginPath = path.join(omzPath, 'custom/plugins', pluginName);

if (fs.existsSync(pluginPath)) {
  fs.rmSync(pluginPath, { recursive: true, force: true });
  console.log(`Removed plugin directory: ${pluginPath}`);
}

// 从 .zshrc 中移除插件
const zshrcPath = path.join(os.homedir(), '.zshrc');
if (fs.existsSync(zshrcPath)) {
  let zshrcContent = fs.readFileSync(zshrcPath, 'utf8');
  
  // 处理插件行
  zshrcContent = zshrcContent.replace(
    new RegExp(`plugins=\\((.*?)${pluginName}(.*?)\\)`),
    (match, before, after) => {
      // 清理多余的空格
      const cleaned = (before + after).replace(/\s+/g, ' ').trim();
      return `plugins=(${cleaned})`;
    }
  );
  
  fs.writeFileSync(zshrcPath, zshrcContent);
  console.log('Removed plugin from .zshrc');
}

console.log(`
\x1b[32mUninstallation complete!\x1b[0m
Please run: \x1b[34msource ~/.zshrc\x1b[0m to apply changes.
`);
