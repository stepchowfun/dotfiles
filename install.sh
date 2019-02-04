#!/usr/bin/env bash
set -eu -o pipefail

DIR="$(cd "$(dirname "$0")"; pwd)"

if uname -a | grep -qi 'Ubuntu'; then
  echo 'Ubuntu detected.'

  echo 'Updating package lists...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get -y update

  echo 'Installing git...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y git

  echo 'Installing zsh...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y zsh

  echo 'Setting the login shell to zsh...'
  sudo chsh -s "$(which zsh)" "$(whoami)"

  echo 'Installing oh-my-zsh...'
  rm -rf ~/.oh-my-zsh
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

  echo 'Installing powerline-fonts...'
  git clone https://github.com/powerline/fonts.git
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts

  echo 'Installing tmux...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y tmux

  echo 'Installing Python3...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y python3-pip

  echo 'Installing Python3 support for neovim...'
  pip3 install --user neovim

  echo 'Installing neovim...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y software-properties-common
  DEBIAN_FRONTEND=noninteractive sudo add-apt-repository -y ppa:neovim-ppa/unstable
  DEBIAN_FRONTEND=noninteractive sudo apt-get update -y
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y neovim

  echo 'Installing vim-plug...'
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo 'Downloading submodules...'
  (cd $DIR && git submodule update --init)

  echo 'Installing dotfiles...'
  cp  "$DIR/.chunkwmrc" ~/.chunkwmrc
  cp  "$DIR/.skhdrc" ~/.skhdrc
  cp  "$DIR/.tmux.conf" ~/.tmux.conf
  cp  "$DIR/.zshrc" ~/.zshrc
  rm -rf ~/.config/base16-shell
  mkdir -p ~/.config/base16-shell
  cp -r "$DIR/.config/base16-shell" ~/.config
  rm -rf ~/.config/nvim
  mkdir -p ~/.config/nvim
  cp -r "$DIR/.config/nvim" ~/.config
  rm -rf ~/.config/alacritty
  mkdir -p ~/.config/alacritty
  cp -r "$DIR/.config/alacritty" ~/.config

  echo 'Installing vim plugins...'
  nvim -c PlugInstall -c qa

  echo 'Installing color scheme...'
  cp "$DIR/base16-circus-scheme/circus/scripts/base16-circus.sh" ~/.config/base16-shell/scripts
  cp "$DIR/base16-circus-scheme/circus/colors/base16-circus.vim" ~/.local/share/nvim/plugged/base16-vim/colors

  echo 'Patching the vim color scheme to not set the background color...'
  echo 'This allows vim to use the background set by tmux, which is configured'
  echo 'to use a lighter background for panes that are not in focus.'
  sed -E -i.bak 's/[ \t]*let[ \t]+s:cterm00[ \t]*=.*$/let s:cterm00 = "none"/' ~/.local/share/nvim/plugged/base16-vim/colors/base16-circus.vim

  echo 'Setting base16-shell color scheme...'
  zsh -ic base16_circus

  echo 'Reloading tmux config...'
  tmux source-file ~/.tmux.conf || true

  echo 'Installing ripgrep...'
  curl -L -o ripgrep.tar.gz https://github.com/BurntSushi/ripgrep/releases/download/0.5.1/ripgrep-0.5.1-x86_64-unknown-linux-musl.tar.gz
  mkdir ripgrep
  tar -xzf ripgrep.tar.gz -C ripgrep --strip-components=1
  sudo cp ripgrep/rg /usr/local/bin
  rm -rf ripgrep ripgrep.tar.gz

  echo 'Done.'
  exit
fi

if uname -a | grep -qi 'Darwin'; then
  echo 'macOS detected.'

  echo 'Updating homebrew...'
  brew update

  echo 'Installing git...'
  brew ls --versions git || brew install git

  echo 'Installing zsh...'
  brew ls --versions zsh || brew install zsh
  brew ls --versions zsh-completions || brew install zsh-completions

  echo 'Setting the login shell to zsh...'
  sudo sh -c "grep -qi \"$(which zsh)\" /etc/shells || echo \"$(which zsh)\" >> /etc/shells"
  sudo chsh -s "$(which zsh)" "$(whoami)"

  echo 'Installing oh-my-zsh...'
  rm -rf ~/.oh-my-zsh
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

  echo 'Installing powerline-fonts...'
  git clone https://github.com/powerline/fonts.git
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts

  echo 'Installing tmux...'
  brew ls --versions tmux || brew install tmux
  brew ls --versions reattach-to-user-namespace || brew install reattach-to-user-namespace

  echo 'Installing Python3...'
  brew ls --versions python || brew install python

  echo 'Installing Python3 support for neovim...'
  pip3 install --user neovim

  echo 'Installing neovim...'
  brew ls --versions neovim || brew install neovim

  echo 'Installing vim-plug...'
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo 'Downloading submodules...'
  (cd $DIR && git submodule update --init)

  echo 'Installing dotfiles...'
  cp  "$DIR/.chunkwmrc" ~/.chunkwmrc
  cp  "$DIR/.skhdrc" ~/.skhdrc
  cp  "$DIR/.tmux.conf" ~/.tmux.conf
  cp  "$DIR/.zshrc" ~/.zshrc
  rm -rf ~/.config/base16-shell
  mkdir -p ~/.config/base16-shell
  cp -r "$DIR/.config/base16-shell" ~/.config
  rm -rf ~/.config/nvim
  mkdir -p ~/.config/nvim
  cp -r "$DIR/.config/nvim" ~/.config
  rm -rf ~/.config/alacritty
  mkdir -p ~/.config/alacritty
  cp -r "$DIR/.config/alacritty" ~/.config

  echo 'Installing vim plugins...'
  nvim -c PlugInstall -c qa

  echo 'Installing color scheme...'
  cp "$DIR/base16-circus-scheme/circus/scripts/base16-circus.sh" ~/.config/base16-shell/scripts
  cp "$DIR/base16-circus-scheme/circus/colors/base16-circus.vim" ~/.local/share/nvim/plugged/base16-vim/colors

  echo 'Patching the vim color scheme to not set the background color...'
  echo 'This allows vim to use the background set by tmux, which is configured'
  echo 'to use a lighter background for panes that are not in focus.'
  sed -E -i.bak 's/[ \t]*let[ \t]+s:cterm00[ \t]*=.*$/let s:cterm00 = "none"/' ~/.local/share/nvim/plugged/base16-vim/colors/base16-circus.vim

  echo 'Setting base16-shell color scheme...'
  zsh -ic base16_circus

  echo 'Reloading tmux config...'
  tmux source-file ~/.tmux.conf || true

  echo 'Installing ripgrep...'
  brew ls --versions ripgrep || brew install ripgrep

  echo 'Done.'
  exit
fi

echo 'This operating system is not supported.'
