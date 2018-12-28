# Path to the oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh

# The oh-my-zsh theme to load
ZSH_THEME="agnoster"

# oh-my-zsh plugins to load
plugins=(git)

# Load oh-my-zsh.
source $ZSH/oh-my-zsh.sh

# Preferred editor
export EDITOR='nvim'

# Don't display user@host in the prompt.
DEFAULT_USER="$(whoami)"

# Only show the last component of the path.
prompt_dir() {
  prompt_segment blue black '%1~'
}

# We use C-d to scroll in tmux and nvim, so turn this option off to prevent
# us from accidentally terminating the shell with it.
setopt ignoreeof

# Aliases
alias v="nvim"

# vim keybindings
bindkey -v

# Other keybindings
bindkey '^w' backward-kill-word

# base16-shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '"'!*.git/'"'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh || true

# Local configuration
[ -f ~/.zshrc-local ] && source ~/.zshrc-local || true
