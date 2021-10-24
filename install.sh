#!/usr/bin/env sh

# We wrap everything in parentheses to prevent the shell from executing only a prefix of the script
# if the download is interrupted.
(
  rm -rf /tmp/dotfiles && \
  git clone https://github.com/stepchowfun/dotfiles.git /tmp/dotfiles && \
  /tmp/dotfiles/install-local.sh && \
  rm -rf /tmp/dotfiles
)
