#!/usr/bin/env bash

# Make Bash log commands and not silently ignore errors.
set -euxo pipefail

# Install the VS Code configuration into the given user data directory (e.g., that of VS Code or
# Cursor).
install_vscode_config() {
  mkdir -p "$1/User"
  cp 'vscode-keybindings.json' "$1/User/keybindings.json"
  cp 'vscode-settings.json' "$1/User/settings.json"
}

# Check for Debian/Ubuntu.
if uname -a | grep -qi 'Debian\|Ubuntu'; then
  echo 'Debian or Ubuntu detected.'
  export DEBIAN_FRONTEND=noninteractive

  echo 'Updating package lists...'
  sudo apt-get -y update < '/dev/tty'

  echo 'Installing `add-apt-repository`...'
  sudo apt-get install -y software-properties-common < '/dev/tty'

  echo 'Installing cURL...'
  sudo apt-get install -y curl < '/dev/tty'

  echo 'Installing Git...'
  sudo apt-get install -y git < '/dev/tty'

  echo 'Installing ripgrep...'
  sudo apt-get install -y ripgrep < '/dev/tty'

  echo 'Installing Alacritty...'
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
  sudo apt-get install -y \
    cmake \
    pkg-config \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxcb-xfixes0-dev \
    libxkbcommon-dev \
    python3 \
    < '/dev/tty'
  cargo install alacritty

  echo 'Installing zsh...'
  sudo apt-get install -y zsh < '/dev/tty'

  echo 'Setting the login shell to zsh...'
  sudo chsh -s "$(which zsh)" "$(whoami)" < '/dev/tty'

  echo 'Installing oh-my-zsh...'
  rm -rf "$HOME/.oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" '' --unattended

  echo 'Installing tmux...'
  sudo apt-get install -y tmux < '/dev/tty'

  echo 'Installing neovim...'
  sudo apt-get install -y neovim < '/dev/tty'

  echo 'Installing vim-plug...'
  curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo 'Downloading submodules...'
  git submodule update --init

  echo 'Installing dotfiles...'
  if command -v code > '/dev/null' || [ -d "$HOME/.config/Code" ]; then
    install_vscode_config "$HOME/.config/Code"
  fi
  if command -v cursor > '/dev/null' || [ -d "$HOME/.config/Cursor" ]; then
    install_vscode_config "$HOME/.config/Cursor"
  fi
  cp  '.tmux.conf' "$HOME/.tmux.conf"
  cp  '.zshrc' "$HOME/.zshrc"
  rm -rf "$HOME/.config/base16-shell"
  mkdir -p "$HOME/.config/base16-shell"
  cp -r '.config/base16-shell' "$HOME/.config"
  rm -rf "$HOME/.config/nvim"
  mkdir -p "$HOME/.config/nvim"
  cp -r '.config/nvim' "$HOME/.config"
  rm -rf "$HOME/.config/alacritty"
  mkdir -p "$HOME/.config/alacritty"
  cp -r '.config/alacritty' "$HOME/.config"

  echo 'Installing vim plugins...'
  nvim -c PlugInstall -c PlugUpdate -c qa

  echo 'Patching the vim color scheme to not set the background color...'
  echo 'This allows vim to use the background set by tmux, which is configured'
  echo 'to use a lighter background for panes that are not in focus.'
  sed -E -i.bak 's/[ \t]*let[ \t]+s:cterm00[ \t]*=.*$/let s:cterm00 = "none"/' \
    "$HOME/.local/share/nvim/plugged/base16-vim/colors/base16-circus.vim"

  echo 'Setting base16-shell color scheme...'
  zsh -ic base16_circus

  echo 'Reloading tmux config...'
  tmux source-file "$HOME/.tmux.conf" || true # Only succeeds if tmux is running

  echo 'Done.'
  exit
fi

# Check for macOS.
if uname -a | grep -qi 'Darwin'; then
  echo 'macOS detected.'

  echo 'Installing Homebrew...'
  '/bin/bash' -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < '/dev/tty'
  eval "$('/opt/homebrew/bin/brew' shellenv)"

  echo 'Upgrading Homebrew packages...'
  brew update
  brew upgrade

  echo 'Installing cURL...'
  brew install curl

  echo 'Installing Git...'
  brew install git

  echo 'Installing ripgrep...'
  brew install ripgrep

  echo 'Installing Alacritty...'
  brew install alacritty

  echo 'Installing zsh...'
  brew install zsh
  brew install zsh-completions

  echo 'Setting the login shell to zsh...'
  sudo chsh -s "$(which zsh)" "$(whoami)" < '/dev/tty'

  echo 'Installing oh-my-zsh...'
  rm -rf "$HOME/.oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" '' --unattended

  echo 'Installing tmux...'
  brew install tmux
  brew install reattach-to-user-namespace

  # NOTE: Only the macOS version of this script installs tmuxinator.
  echo 'Installing tmuxinator...'
  brew install tmuxinator

  echo 'Installing neovim...'
  brew install neovim

  echo 'Installing vim-plug...'
  curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo 'Downloading submodules...'
  git submodule update --init

  echo 'Installing dotfiles...'
  if [ -d '/Applications/Visual Studio Code.app' ] || \
    [ -d "$HOME/Library/Application Support/Code" ]; then
    install_vscode_config "$HOME/Library/Application Support/Code"
  fi
  if [ -d '/Applications/Cursor.app' ] || [ -d "$HOME/Library/Application Support/Cursor" ]; then
    install_vscode_config "$HOME/Library/Application Support/Cursor"
  fi
  cp  '.tmux.conf' "$HOME/.tmux.conf"
  cp  '.zshrc' "$HOME/.zshrc"
  rm -rf "$HOME/.config/base16-shell"
  mkdir -p "$HOME/.config/base16-shell"
  cp -r '.config/base16-shell' "$HOME/.config"
  rm -rf "$HOME/.config/nvim"
  mkdir -p "$HOME/.config/nvim"
  cp -r '.config/nvim' "$HOME/.config"
  rm -rf "$HOME/.config/alacritty"
  mkdir -p "$HOME/.config/alacritty"
  cp -r '.config/alacritty' "$HOME/.config"

  echo 'Installing vim plugins...'
  nvim -c PlugInstall -c PlugUpdate -c qa

  echo 'Patching the vim color scheme to not set the background color...'
  echo 'This allows vim to use the background set by tmux, which is configured'
  echo 'to use a lighter background for panes that are not in focus.'
  sed -E -i.bak 's/[ \t]*let[ \t]+s:cterm00[ \t]*=.*$/let s:cterm00 = "none"/' \
    "$HOME/.local/share/nvim/plugged/base16-vim/colors/base16-circus.vim"

  echo 'Setting base16-shell color scheme...'
  zsh -ic base16_circus

  echo 'Reloading tmux config...'
  tmux source-file "$HOME/.tmux.conf" || true # Only succeeds if tmux is running

  echo 'Done.'
  exit
fi

echo 'This operating system is not supported.'
