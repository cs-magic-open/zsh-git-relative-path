# zsh-git-relative-path.plugin.zsh

# Load required modules
autoload -Uz add-zsh-hook

# Debug function
function debug_log() {
    [[ -n "$ZSH_GIT_PATH_DEBUG" ]] && echo "\033[0;33m[DEBUG] $@\033[0m" >&2
}

# Load version from package.json
function get_plugin_version() {
  local json_file="${0:A:h}/package.json"
  if [[ -f "$json_file" ]]; then
    echo $(cat "$json_file" | grep -o '"version": "[^"]*"' | cut -d'"' -f4)
  else
    echo "unknown"
  fi
}

ZSH_GIT_RELATIVE_PATH_VERSION=$(get_plugin_version)
ZSH_GIT_RELATIVE_PATH_REPO="https://github.com/cs-magic-open/zsh-git-relative-path"

[[ -n "$ZSH_GIT_PATH_DEBUG" ]] && debug_log "Plugin loaded with version: $ZSH_GIT_RELATIVE_PATH_VERSION"

# 定义获取 git 相对路径的函数
function get_git_relative_path() {
  local workspace_root=$(git rev-parse --show-toplevel 2>/dev/null)
  local current_path=$(pwd)
  local path_format=${1:-%~}

  [[ -n "$ZSH_GIT_PATH_DEBUG" ]] && {
    debug_log "get_git_relative_path called with format: $path_format"
    debug_log "workspace_root: $workspace_root"
    debug_log "current_path: $current_path"
  }
  
  if [[ -n "$workspace_root" && $current_path == $workspace_root* ]]; then
    local relative_path=${current_path#$workspace_root/}
    [[ -z "$relative_path" ]] && relative_path="/"
    [[ -n "$ZSH_GIT_PATH_DEBUG" ]] && debug_log "Returning relative path: $relative_path"
    echo "$relative_path"
  else
    [[ -n "$ZSH_GIT_PATH_DEBUG" ]] && debug_log "Returning default format: $path_format"
    echo "$path_format"
  fi
}

# 检查更新函数
function check_git_relative_path_update() {
  if [[ -n "$ZSH_GIT_RELATIVE_PATH_REPO" ]]; then
    local latest_version=$(curl -s "$ZSH_GIT_RELATIVE_PATH_REPO/raw/main/package.json" | grep -o '"version": "[^"]*"' | cut -d'"' -f4)
    if [[ -n "$latest_version" && "$latest_version" != "$ZSH_GIT_RELATIVE_PATH_VERSION" ]]; then
      echo "\033[0;33mA new version ($latest_version) of zsh-git-relative-path is available!\033[0m"
      echo "Current version: $ZSH_GIT_RELATIVE_PATH_VERSION"
      echo "Update with: npm update -g @cs-magic-open/zsh-git-relative-path"
    fi
  fi
}

# 每天检查一次更新
if [[ ! -f "${ZSH_CACHE_DIR:-$ZSH/cache}/git_relative_path_update" || $(find "${ZSH_CACHE_DIR:-$ZSH/cache}/git_relative_path_update" -mtime +1) ]]; then
  check_git_relative_path_update &>/dev/null &!
  touch "${ZSH_CACHE_DIR:-$ZSH/cache}/git_relative_path_update"
fi

# 保存原始的 prompt_subst 设置
if [[ -z $original_prompt_subst ]]; then
    original_prompt_subst=$prompt_subst
fi

# 启用命令替换
setopt prompt_subst
[[ -n "$ZSH_GIT_PATH_DEBUG" ]] && debug_log "prompt_subst enabled"

# 定义一个函数来修改提示符
function wrap_prompt_with_git_path() {
    [[ -n "$ZSH_GIT_PATH_DEBUG" ]] && {
      debug_log "wrap_prompt_with_git_path called"
      debug_log "Current theme: $ZSH_THEME"
      debug_log "Original PROMPT: $PROMPT"
    }

    # 处理主题特定的变量
    case "$ZSH_THEME" in
        robbyrussell)
            [[ -n "$ZSH_GIT_PATH_DEBUG" ]] && debug_log "Handling robbyrussell theme"
            PROMPT='%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}$(get_git_relative_path)%{$reset_color%} $(git_prompt_info)'
            ;;
        avit)
            [[ -n "$ZSH_GIT_PATH_DEBUG" ]] && debug_log "Handling avit theme"
            _current_dir="%{$fg_bold[blue]%}$(get_git_relative_path %3~)%{$reset_color%} "
            ;;
        agnoster)
            [[ -n "$ZSH_GIT_PATH_DEBUG" ]] && debug_log "Handling agnoster theme"
            prompt_dir() {
                prompt_segment blue $CURRENT_FG "$(get_git_relative_path)"
            }
            ;;
        *)
            [[ -n "$ZSH_GIT_PATH_DEBUG" ]] && debug_log "Handling default theme"
            # 默认替换
            if [[ -n "$PROMPT" ]]; then
                PROMPT=${PROMPT//\%\~/'$(get_git_relative_path)'}
                PROMPT=${PROMPT//\%c/'$(get_git_relative_path %c)'}
                PROMPT=${PROMPT//\%C/'$(get_git_relative_path %C)'}
                [[ -n "$ZSH_GIT_PATH_DEBUG" ]] && debug_log "Modified PROMPT: $PROMPT"
            fi
            if [[ -n "$RPROMPT" ]]; then
                RPROMPT=${RPROMPT//\%\~/'$(get_git_relative_path)'}
                RPROMPT=${RPROMPT//\%c/'$(get_git_relative_path %c)'}
                RPROMPT=${RPROMPT//\%C/'$(get_git_relative_path %C)'}
                [[ -n "$ZSH_GIT_PATH_DEBUG" ]] && debug_log "Modified RPROMPT: $RPROMPT"
            fi
            ;;
    esac
}

# 添加到主题加载后的钩子
add-zsh-hook precmd wrap_prompt_with_git_path
[[ -n "$ZSH_GIT_PATH_DEBUG" ]] && debug_log "Added wrap_prompt_with_git_path to precmd hook"
