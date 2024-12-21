# zsh-git-relative-path

A ZSH plugin that shows your current path relative to the git project root in your prompt.

## Features

- Works with any oh-my-zsh theme
- Shows path relative to git project root when in a git repository
- Falls back to normal path display when not in a git repository
- Special support for popular themes (robbyrussell, agnoster, avit)
- Zero configuration needed!

## Installation

### One-line Installation

```bash
curl -fsSL https://raw.githubusercontent.com/cs-magic-open/zsh-git-relative-path/main/install.sh | bash && source ~/.zshrc
```

That's it! No additional steps needed.

### Alternative: Local Installation

If you prefer to inspect the code first:

```bash
# 1. Clone the repository
git clone https://github.com/cs-magic-open/zsh-git-relative-path
cd zsh-git-relative-path

# 2. Run the installer
bash install.sh && source ~/.zshrc
```

## Usage

Once installed, the plugin will automatically modify your prompt to show paths relative to the git project root. No additional configuration is needed!

Example:
```
# Before (in /Users/username/projects/my-project/src/components)
username ~/projects/my-project/src/components $

# After (same directory)
username src/components $
```

## Uninstallation

```bash
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-git-relative-path
```
Then manually remove the plugin from the plugins list in your .zshrc.

## License

MIT

## Author

cs-magic-open
