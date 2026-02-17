# Path to the oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh

# The oh-my-zsh theme to load
ZSH_THEME="agnoster"

# Load oh-my-zsh.
source "$ZSH/oh-my-zsh.sh"

# Preferred editor
export EDITOR='nvim'

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

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"

# fzf
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '"'!*.git/'"'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh || true

# Functions
function v {
  nvim "$@"
}

function replace {
  SEPARATOR=''
  for CANDIDATE in '`' '~' '!' '@' '#' '$' '%' '^' '&' '*' '(' ')' '-' '_' '=' '+'; do
    if ! echo "$1" | rg --fixed-strings --quiet "$CANDIDATE"; then
      SEPARATOR="$CANDIDATE"
      break
    fi
  done
  if test -z "$SEPARATOR"; then
    echo 'Unable to find separator for sed.' 1>&2
    return 1
  fi

  # Linux version:
  #   rg ... | xargs --null -I % sed --regexp-extended --in-place "s${SEPARATOR}${1}${SEPARATOR}${2}${SEPARATOR}g" %

  # macOS version:
  rg --null --hidden --glob '!.git/' --files-with-matches -- "$1" | xargs -0 -I % sed -E -I '' "s${SEPARATOR}${1}${SEPARATOR}${2}${SEPARATOR}g" %
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

function gra {
  update-repo "$(default-branch)"
  git for-each-ref --format='%(refname:short)' refs/heads | while read line; do
    git checkout "$line"
    git rebase "$(default-branch)"
  done
  git checkout "$(default-branch)"
  git status
}

function close {
  BRANCH="$(current-branch)"
  git checkout "$(default-branch)"
  git pull
  git branch -D "$BRANCH"
}

function rg {
  $(which -a rg | grep '^/' | tail -n 1) --hidden --glob '!.git' "$@"
}

# Homebrew
! test -f /opt/homebrew/bin/brew || eval "$(/opt/homebrew/bin/brew shellenv)"

# OPAM
[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Local configuration
if [ -f "$HOME/.zshrc-local" ]; then
  source "$HOME/.zshrc-local"
fi
