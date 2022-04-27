# Path to the oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh

# The oh-my-zsh theme to load
ZSH_THEME="agnoster"

# Load oh-my-zsh.
source "$ZSH/oh-my-zsh.sh"

# Preferred editor
export EDITOR='nvim'

# Disable the fancy Powerline segment separator since it doesn't render nicely
# in some fonts.
SEGMENT_SEPARATOR=''

# Show whether we are in normal mode or insert mode.
prompt_mode() {
  if [ "$KEYMAP" = 'vicmd' ]; then
    prompt_segment magenta black "\u2714"
  else
    prompt_segment green black "\u270e"
  fi
}

# Only show the last component of the path.
prompt_dir() {
  prompt_segment blue black '%1~'
}

# Override the Agnoster theme's built-in prompt.
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_mode
  prompt_dir

  # If this is too slow for a given repo, run
  #   git config oh-my-zsh.hide-status 1
  # in that repo to disable this segment.
  prompt_git

  prompt_end
}

# We use C-d to scroll in tmux and nvim, so turn this option off to prevent
# us from accidentally terminating the shell with it.
setopt ignoreeof

# vim keybindings
bindkey -v
bindkey "^?" backward-delete-char # See https://superuser.com/questions/476532/how-can-i-make-zshs-vi-mode-behave-more-like-bashs-vi-mode

# Reset the prompt when changing vi editing modes (normal vs. insert mode).
zle-keymap-select() {
  zle reset-prompt
}

zle -N zle-keymap-select

# base16-shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '"'!*.git/'"'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh || true

# Local configuration
if [ -f "$HOME/.zshrc-local" ]; then
  source "$HOME/.zshrc-local"
fi

# Functions
function v {
  nvim "$@"
}

function replace {
  # Linux version:
  #   rg --null --files-with-matches "$1" | xargs --null -I % sed --regexp-extended --in-place "s/$1/$2/g" %

  # macOS version:
  rg --null --files-with-matches "$1" | xargs -0 -I % sed -E -I '' "s/$1/$2/g" %
}

function die {
  killall nvim
  rm -f ~/.local/share/nvim/swap/*
  tmux kill-server
}

function dock {
  if docker ps --format='{{.ID}}' | grep > /dev/null "$1"; then
    docker exec --interactive --tty "$1" /bin/bash
  else
    docker run --rm --interactive --tty "$1" /bin/bash
  fi
}

function dockroot {
  if docker ps --format='{{.ID}}' | grep > /dev/null "$1"; then
    docker exec --interactive --tty --user root "$1" /bin/bash
  else
    docker run --rm --interactive --tty --user root "$1" /bin/bash
  fi
}

function ga {
  git commit --all --amend --no-edit
  git status
}

function gap {
  git commit --all --amend --no-edit
  git push --force
  git status
}

function gfp {
  git push --force
}

function current-branch {
  git rev-parse --abbrev-ref HEAD 2> /dev/null
}

function default-branch {
  echo main
}

function update-repo {
  if [ "$(current-branch)" = "$1" ]; then
    git pull
  else
    git fetch origin "$1:$1"
  fi

  git fetch --prune
}

function gr {
  update-repo "$(default-branch)"
  git rebase "$(default-branch)"
  git status
}

function close {
  BRANCH="$(current-branch)"
  git checkout "$(default-branch)"
  git pull
  git branch -D "$BRANCH"
}

# Coq
export PATH="$PATH:/Applications/Coq-Platform-8.15~beta1.app/Contents/Resources/bin"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
