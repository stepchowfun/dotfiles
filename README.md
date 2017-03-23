# Stephan’s dotfiles

![Screenshot](https://raw.githubusercontent.com/stepchowfun/dotfiles/master/screenshot.png)

## Installation

### Automatic

1. Run this: `curl https://www.stephanboyer.com/dotfiles | sh`
2. Configure your terminal to use the `13pt Meslo LG S Regular for Powerline` font.

### Manual

1. Install [zsh](http://www.zsh.org/), [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), [powerline-fonts](https://github.com/powerline/fonts), [tmux](https://tmux.github.io/), [neovim](https://neovim.io/), [vim-plug](https://github.com/junegunn/vim-plug), and [ripgrep](https://github.com/BurntSushi/ripgrep).
2. Clone this repository.
3. Run `git submodule init` and `git submodule update` from the root of this repository to clone the submodules.
4. Copy `.config`, `.tmux.conf`, and `.zshrc` from this repository into your home directory.
5. In `nvim`, run `:PlugInstall`.
6. Configure your terminal to use the `13pt Meslo LG S Regular for Powerline` font.
