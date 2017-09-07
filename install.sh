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
  mv ~/.oh-my-zsh ~/.oh-my-zsh.old
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

  echo 'Installing powerline-fonts...'
  git clone https://github.com/powerline/fonts.git
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts

  echo 'Installing tmux...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y tmux

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
  cp  "$DIR/.tmux.conf" ~/.tmux.conf
  cp  "$DIR/.zshrc" ~/.zshrc
  rm -rf ~/.config/base16-shell
  mkdir -p ~/.config/base16-shell
  cp -r "$DIR/.config/base16-shell" ~/.config
  rm -rf ~/.config/nvim
  mkdir -p ~/.config/nvim
  cp -r "$DIR/.config/nvim" ~/.config

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
  which git > /dev/null 2>&1 || brew install git

  echo 'Installing zsh...'
  which zsh > /dev/null 2>&1 || brew install zsh zsh-completions

  echo 'Setting the login shell to zsh...'
  sudo sh -c "grep -qi \"$(which zsh)\" /etc/shells || echo \"$(which zsh)\" >> /etc/shells"
  sudo chsh -s "$(which zsh)" "$(whoami)"

  echo 'Installing oh-my-zsh...'
  mv ~/.oh-my-zsh ~/.oh-my-zsh.old
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

  echo 'Installing powerline-fonts...'
  git clone https://github.com/powerline/fonts.git
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts

  echo 'Installing tmux...'
  which tmux > /dev/null 2>&1 || brew install tmux reattach-to-user-namespace

  echo 'Installing neovim...'
  which nvim > /dev/null 2>&1 || brew install neovim/neovim/neovim

  echo 'Installing vim-plug...'
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo 'Downloading submodules...'
  (cd $DIR && git submodule update --init)

  echo 'Installing dotfiles...'
  cp  "$DIR/.tmux.conf" ~/.tmux.conf
  cp  "$DIR/.zshrc" ~/.zshrc
  rm -rf ~/.config/base16-shell
  mkdir -p ~/.config/base16-shell
  cp -r "$DIR/.config/base16-shell" ~/.config
  rm -rf ~/.config/nvim
  mkdir -p ~/.config/nvim
  cp -r "$DIR/.config/nvim" ~/.config

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
  which rg > /dev/null 2>&1 || brew install ripgrep

  echo 'Done.'
  exit
fi

echo 'This operating system is not supported.'
