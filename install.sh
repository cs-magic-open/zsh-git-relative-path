#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Installing zsh-git-relative-path...${NC}"

# 检查是否安装了 oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is not installed. Please install it first."
    exit 1
fi

# 设置插件目录
PLUGIN_NAME="zsh-git-relative-path"
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$PLUGIN_NAME"

# 如果插件目录已存在，先删除
if [ -d "$PLUGIN_DIR" ]; then
    echo "Removing existing plugin..."
    rm -rf "$PLUGIN_DIR"
fi

# 创建插件目录
mkdir -p "$PLUGIN_DIR"

# 复制插件文件
cp "$(dirname "$0")/zsh-git-relative-path.plugin.zsh" "$PLUGIN_DIR/"
cp "$(dirname "$0")/version.zsh" "$PLUGIN_DIR/"
cp "$(dirname "$0")/README.md" "$PLUGIN_DIR/"
cp "$(dirname "$0")/LICENSE" "$PLUGIN_DIR/"

# 检查 .zshrc 中是否已经有插件配置
if grep -q "plugins=.*$PLUGIN_NAME" "$HOME/.zshrc"; then
    echo "Plugin already in .zshrc"
else
    # 找到 plugins 行并添加我们的插件
    if grep -q "^plugins=(" "$HOME/.zshrc"; then
        # 在现有的 plugins 行中添加插件
        sed -i '' 's/^plugins=(/plugins=($PLUGIN_NAME /' "$HOME/.zshrc"
    else
        # 如果没有 plugins 行，添加一个新的
        echo "plugins=($PLUGIN_NAME)" >> "$HOME/.zshrc"
    fi
fi

# 显示版本信息
source "$(dirname "$0")/version.zsh"
echo -e "${GREEN}Installation complete! Version: $ZSH_GIT_RELATIVE_PATH_VERSION${NC}"
echo -e "Please run: ${BLUE}source ~/.zshrc${NC} to activate the plugin"
