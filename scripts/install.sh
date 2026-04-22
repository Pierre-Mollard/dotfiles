#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
DOTFILES_DIR="$PROJECT_DIR/stow"
TARGET_DIR="${HOME}"

stow --dir="$DOTFILES_DIR" --target="$TARGET_DIR" git tmux vim nvim

# NOTE: bash file are meant to be cherry-pick by hand based on local configuration

# clone tokyonight in the nvim-lite cache
mkdir -p ~/.local/share/nvim-lite/site/pack/colors/start/tokyonight.nvim
dir="$HOME/.local/share/nvim-lite/site/pack/colors/start/tokyonight.nvim/"
if [ -d $dir ] && [ -z "$(ls -A "$dir")" ]; then
  git clone https://github.com/folke/tokyonight.nvim "$dir"
fi
