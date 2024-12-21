# zsh-vscode-path.plugin.zsh

# 定义获取 vscode 相对路径的函数
function get_vscode_relative_path() {
  local workspace_root=$(git rev-parse --show-toplevel 2>/dev/null)
  local current_path=$(pwd)
  local path_format=${1:-%~} # 默认使用 %~，但允许传入其他格式
  
  if [[ -n "$workspace_root" && $current_path == $workspace_root* ]]; then
    echo ${current_path#$workspace_root/}
  else
    echo $path_format
  fi
}

# 保存原始的 prompt_subst 设置
if [[ -z $original_prompt_subst ]]; then
    original_prompt_subst=$prompt_subst
fi

# 启用命令替换
setopt prompt_subst

# 定义一个函数来包装任意主题的提示符
function wrap_prompt_with_vscode_path() {
    # 处理主题特定的变量
    case $ZSH_THEME in
        avit)
            _current_dir="%{$fg_bold[blue]%}$(get_vscode_relative_path %3~)%{$reset_color%} "
            ;;
        agnoster)
            # 为 agnoster 主题添加特殊处理
            prompt_dir() {
                prompt_segment blue $CURRENT_FG "$(get_vscode_relative_path)"
            }
            ;;
        *)
            # 默认替换
            PROMPT=${PROMPT//\%\~/'$(get_vscode_relative_path)'}
            PROMPT=${PROMPT//\%c/'$(get_vscode_relative_path %c)'}
            ;;
    esac
}

# 添加到主题加载后的钩子
add-zsh-hook precmd wrap_prompt_with_vscode_path
