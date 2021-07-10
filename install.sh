#!/usr/bin/env sh

DIR="$(cd "$(dirname "$0")" && pwd)"

if uname -a | grep -qi 'Ubuntu'; then
  echo 'Ubuntu detected.'

  echo 'Updating package lists...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get -y update < /dev/tty

  echo 'Installing Alacritty...'
  DEBIAN_FRONTEND=noninteractive sudo add-apt-repository ppa:mmstick76/alacritty
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y alacritty < /dev/tty

  echo 'Installing Git...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y git < /dev/tty

  echo 'Installing ripgrep...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y ripgrep < /dev/tty

  echo 'Installing zsh...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y zsh < /dev/tty

  echo 'Setting the login shell to zsh...'
  sudo chsh -s "$(which zsh)" "$(whoami)" < /dev/tty

  echo 'Installing oh-my-zsh...'
  rm -rf ~/.oh-my-zsh
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

  echo 'Installing the `Input` font...'
  mkdir -p ~/.local/share/fonts
  cp "$DIR/input-font/Input_Fonts/Input/"* ~/.local/share/fonts

  if which fc-cache >/dev/null 2>&1; then
    echo "Resetting font cache..."
    fc-cache -f ~/.local/share/fonts
  fi

  echo 'Installing tmux...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y tmux < /dev/tty

  echo 'Installing neovim...'
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y neovim python3-neovim < /dev/tty

  echo 'Installing vim-plug...'
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo 'Downloading submodules...'
  (cd "$DIR" && git submodule update --init)

  echo 'Installing dotfiles...'
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
  nvim -c PlugInstall -c PlugUpdate -c qa

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
  tmux source-file ~/.tmux.conf || true # Only succeeds if tmux is running

  echo 'Done.'
  exit
fi

if uname -a | grep -qi 'Darwin'; then
  echo 'macOS detected.'

  echo 'Installing Homebrew...'
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  echo 'Upgrading Homebrew packages...'
  brew update
  brew upgrade

  echo 'Installing Alacritty...'
  brew install alacritty

  echo 'Installing Git...'
  brew install git

  echo 'Installing ripgrep...'
  brew install ripgrep

  echo 'Installing zsh...'
  brew install zsh
  brew install zsh-completions

  echo 'Setting the login shell to zsh...'
  sudo chsh -s "$(which zsh)" "$(whoami)" < /dev/tty

  echo 'Installing oh-my-zsh...'
  rm -rf ~/.oh-my-zsh
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

  echo 'Installing the `Input` font...'
  cp "$DIR/input-font/Input_Fonts/Input/"* ~/Library/Fonts

  echo 'Installing tmux...'
  brew install tmux
  brew install reattach-to-user-namespace

  # NOTE: Only the macOS version of this script installs tmuxinator.
  echo 'Installing tmuxinator...'
  brew install tmuxinator

  echo 'Installing Python3...'
  brew install python

  echo 'Installing Python3 support for neovim...'
  pip3 install --user neovim

  echo 'Installing neovim...'
  brew install neovim

  echo 'Installing vim-plug...'
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo 'Downloading submodules...'
  (cd "$DIR" && git submodule update --init)

  echo 'Installing dotfiles...'
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
  tmux source-file ~/.tmux.conf || true # Only succeeds if tmux is running

  echo 'Done.'
  exit
fi

echo 'This operating system is not supported.'
