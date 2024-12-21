#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

const DEBUG = process.env.ZSH_GIT_PATH_DEBUG === '1';

function log(message, type = 'info') {
  if (type === 'debug' && !DEBUG) return;
  
  let prefix = '';
  let color = '\x1b[0m'; // default
  
  switch (type) {
    case 'debug':
      prefix = '[DEBUG]';
      color = '\x1b[36m'; // cyan
      break;
    case 'error':
      prefix = '[ERROR]';
      color = '\x1b[31m'; // red
      break;
    case 'success':
      prefix = '[SUCCESS]';
      color = '\x1b[32m'; // green
      break;
  }

  if (prefix) {
    console.log(`${color}${prefix}\x1b[0m %s`, message);
  } else {
    console.log(message);
  }
}

try {
  // 检查是否是全局安装
  const isGlobalInstall = process.env.npm_config_global === 'true';
  log('Checking installation type...', 'debug');

  if (!isGlobalInstall) {
    log('This package must be installed globally.', 'error');
    log('Run: npm install -g @cs-magic-open/zsh-git-relative-path');
    process.exit(1);
  }

  // 检查是否安装了 oh-my-zsh
  const omzPath = path.join(os.homedir(), '.oh-my-zsh');
  log('Checking Oh My Zsh installation...', 'debug');
  
  if (!fs.existsSync(omzPath)) {
    log('Oh My Zsh is not installed.', 'error');
    log('Visit https://ohmyz.sh/ to install');
    process.exit(1);
  }

  // 设置插件目录
  const pluginName = 'zsh-git-relative-path';
  const customPluginsPath = path.join(omzPath, 'custom/plugins');
  const pluginPath = path.join(customPluginsPath, pluginName);

  // 创建插件目录
  log(`Creating plugin directory: ${pluginPath}`, 'debug');
  fs.mkdirSync(pluginPath, { recursive: true });

  // 复制插件文件
  const packageRoot = path.join(__dirname, '..');
  const filesToCopy = [
    'zsh-git-relative-path.plugin.zsh',
    'README.md',
    'LICENSE',
    'package.json'
  ];

  log('Copying plugin files...', 'debug');
  filesToCopy.forEach(file => {
    const src = path.join(packageRoot, file);
    const dest = path.join(pluginPath, file);
    if (!fs.existsSync(src)) {
      log(`Source file not found: ${src}`, 'error');
      return;
    }
    fs.copyFileSync(src, path.join(pluginPath, file));
    log(`Copied ${file}`, 'debug');
  });

  // 修改 .zshrc
  const zshrcPath = path.join(os.homedir(), '.zshrc');
  log('Updating .zshrc configuration...', 'debug');
  
  if (!fs.existsSync(zshrcPath)) {
    log('Creating new .zshrc file', 'debug');
    fs.writeFileSync(zshrcPath, '');
  }

  let zshrcContent = fs.readFileSync(zshrcPath, 'utf8');

  // 更智能地处理 plugins 行
  const pluginsRegex = /plugins=\((.*?)\)/;
  if (pluginsRegex.test(zshrcContent)) {
    const match = zshrcContent.match(pluginsRegex);
    const currentPlugins = match[1].split(/\s+/).filter(p => p);
    
    if (!currentPlugins.includes(pluginName)) {
      log('Adding plugin to existing plugins list', 'debug');
      currentPlugins.push(pluginName);
      zshrcContent = zshrcContent.replace(
        pluginsRegex,
        `plugins=(${currentPlugins.join(' ')})`
      );
      fs.writeFileSync(zshrcPath, zshrcContent);
    } else {
      log('Plugin already configured in .zshrc', 'debug');
    }
  } else {
    log('Adding new plugins configuration', 'debug');
    zshrcContent += `\nplugins=(${pluginName})\n`;
    fs.writeFileSync(zshrcPath, zshrcContent);
  }

  // 设置文件权限
  log('Setting file permissions', 'debug');
  execSync(`chmod -R 755 ${pluginPath}`);

  // 成功信息
  log('✨ Installation complete!', 'success');
  log(`
To activate the plugin, run:
  \x1b[34msource ~/.zshrc\x1b[0m

Your prompt will now show paths relative to git project root.
For debugging, set ZSH_GIT_PATH_DEBUG=1 before sourcing .zshrc
`);

} catch (err) {
  log('Installation failed', 'error');
  log(err.message, 'error');
  process.exit(1);
}
