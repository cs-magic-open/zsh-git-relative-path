# Zsh Git 相对路径插件

一个简单但实用的 Zsh 插件，它可以在你的命令提示符中显示相对于 Git 项目根目录的当前路径。这个插件是在 AI 的协助下在短短 10 分钟内完成的，展示了 AI 辅助开发的强大能力。

## 主要特性

- 自动将完整路径转换为相对于 Git 项目根目录的路径
- 支持多种常用的 Zsh 主题
- 提供调试模式方便排查问题
- 支持自动检查更新

## 为什么需要这个插件？

在使用像 Windsurf 这样的 AI 编程助手时，我们经常需要复制终端中的命令和输出来让 AI 理解上下文。传统的完整路径会包含大量冗余信息，这不仅增加了 AI 的处理负担，还可能导致 AI 在定位问题时需要更多时间。

通过显示相对路径，我们可以：
1. 提供更清晰的上下文信息
2. 减少 AI 处理路径信息的复杂度
3. 提高 AI 辅助编程的效率

## 安装

### 通过 npm 安装（推荐）

```bash
npm install -g @cs-magic-open/zsh-git-relative-path
```

### 手动安装

1. 克隆仓库到 Oh My Zsh 的自定义插件目录：
```bash
git clone https://github.com/cs-magic-open/zsh-git-relative-path ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-git-relative-path
```

2. 在 `~/.zshrc` 中启用插件：
```bash
plugins=(... zsh-git-relative-path)
```

3. 重新加载配置：
```bash
source ~/.zshrc
```

## 配置

### 调试模式

如果插件不能正常工作，你可以启用调试模式来查看详细信息：

```bash
export ZSH_GIT_PATH_DEBUG=1
source ~/.zshrc
```

## 工作原理

1. 插件会检测当前目录是否在 Git 仓库中
2. 如果是，则获取 Git 项目根目录
3. 将当前完整路径转换为相对于项目根目录的路径
4. 根据使用的 Zsh 主题，适配并更新提示符显示

## 支持的主题

目前已经测试并支持以下主题：
- robbyrussell（默认主题）
- agnoster
- 其他常用主题（持续添加中）

## 贡献

欢迎提交 Issue 和 Pull Request！如果你发现了 bug 或者有新的想法，请随时与我们分享。

## 开源协议

MIT

## 致谢

特别感谢 AI 助手在开发过程中提供的帮助，这个项目展示了人机协作的美好未来。
