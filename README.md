# Stephan’s dotfiles

![Screenshot](https://raw.githubusercontent.com/stepchowfun/dotfiles/master/screenshot.png)

## Installation

1. Run this: `curl https://www.stephanboyer.com/dotfiles -LSfs | sh`
2. Do one of the following to set up a terminal:
   - Install [iTerm2](https://www.iterm2.com) and configure it to use the `Input` font at size 14. The installation script does not install iTerm2, but it does install the font.
   - Install [Alacritty](https://github.com/jwilm/alacritty). The installation script does not install Alacritty, but it does install an Alacritty configuration file.

**NOTE:** The installer script will overwrite existing dotfiles and other configuration. Use at your own risk!

**NOTE:** The installer script uses [base16-shell](https://github.com/chriskempson/base16-shell) to set the terminal colors, and base16-shell is [not supported](https://github.com/chriskempson/base16-shell/issues/139) for macOS's Terminal app. To ensure the color scheme works correctly, use a terminal emulator which supports setting colors 0-21 via escape sequences, such as [iTerm2](https://www.iterm2.com/) or [Alacritty](https://github.com/jwilm/alacritty).
