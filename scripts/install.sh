#!/bin/sh
SCRIPT_PATH="$0"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
DOTFILES="$SCRIPT_DIR/../dotfiles"

# Create inital .config file
mkdir -p ~/.config
mkdir -p ~/.config/tmux
mkdir -p ~/.config/tmux/plugins
mkdir -p ~/.config/tmux/plugins/pmo
mkdir -p ~/.config/tmux/plugins/pmo/themes
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim-lite
mkdir -p ~/.config/nvim-lite/lua
mkdir -p ~/.config/nvim-lite/lua/lite
mkdir -p ~/.config/nvim-lite/lua/lite/plugins
mkdir -p ~/.config/nvim-lite/after/plugin/
mkdir -p ~/.tmux
mkdir -p ~/.vim
mkdir -p ~/.vim/colors
mkdir -p ~/.local/share/nvim-lite/site/pack/colors/start/tokyonight.nvim

ln -sf $DOTFILES/vim/vimrc ~/.vimrc
ln -sf $DOTFILES/vim/vim/colors/catppuccin_frappe.vim ~/.vim/colors/catppuccin_frappe.vim
ln -sf $DOTFILES/tmux/tmux.conf ~/.tmux.conf
ln -sf $DOTFILES/git/gitconfig ~/.gitconfig

ln -sf $DOTFILES/tmux/config/tmux/plugins/pmo/README.md ~/.config/tmux/plugins/pmo/README.md
ln -sf $DOTFILES/tmux/config/tmux/plugins/pmo/pmo.tmux ~/.config/tmux/plugins/pmo/pmo.tmux
ln -sf $DOTFILES/tmux/config/tmux/plugins/pmo/pmo_options_tmux.conf ~/.config/tmux/plugins/pmo/pmo_options_tmux.conf
ln -sf $DOTFILES/tmux/config/tmux/plugins/pmo/pmo_tmux.conf ~/.config/tmux/plugins/pmo/pmo_tmux.conf
ln -sf $DOTFILES/tmux/config/tmux/plugins/pmo/themes/catppuccin_frappe_tmux.conf ~/.config/tmux/plugins/pmo/themes/catppuccin_frappe_tmux.conf
ln -sf $DOTFILES/tmux/config/tmux/plugins/pmo/themes/catppuccin_latte_tmux.conf ~/.config/tmux/plugins/pmo/themes/catppuccin_latte_tmux.conf
ln -sf $DOTFILES/tmux/config/tmux/plugins/pmo/themes/catppuccin_macchiato_tmux.conf ~/.config/tmux/plugins/pmo/themes/catppuccin_macchiato_tmux.conf
ln -sf $DOTFILES/tmux/config/tmux/plugins/pmo/themes/catppuccin_mocha_tmux.conf ~/.config/tmux/plugins/pmo/themes/catppuccin_mocha_tmux.conf
ln -sf $DOTFILES/tmux/config/tmux/plugins/pmo/themes/tokyonight-night_tmux.conf ~/.config/tmux/plugins/pmo/themes/tokyonight-night_tmux.conf

cp -rf $DOTFILES/nvim/config/nvim ~/.config/nvim/

ln -sf $DOTFILES/nvim/config/nvim-lite/init.lua ~/.config/nvim-lite/init.lua
ln -sf $DOTFILES/nvim/config/nvim-lite/lua/lite/plugins.lua ~/.config/nvim-lite/lua/lite/plugins.lua
ln -sf $DOTFILES/nvim/config/nvim-lite/lua/lite/reload.lua ~/.config/nvim-lite/lua/lite/reload.lua
ln -sf $DOTFILES/nvim/config/nvim-lite/lua/lite/autocmds.lua ~/.config/nvim-lite/lua/lite/autocmds.lua
ln -sf $DOTFILES/nvim/config/nvim-lite/lua/lite/commands.lua ~/.config/nvim-lite/lua/lite/commands.lua
ln -sf $DOTFILES/nvim/config/nvim-lite/lua/lite/keymaps.lua ~/.config/nvim-lite/lua/lite/keymaps.lua
ln -sf $DOTFILES/nvim/config/nvim-lite/lua/lite/options.lua ~/.config/nvim-lite/lua/lite/options.lua
ln -sf $DOTFILES/nvim/config/nvim-lite/lua/lite/init.lua ~/.config/nvim-lite/lua/lite/init.lua
ln -sf $DOTFILES/nvim/config/nvim-lite/lua/lite/plugins/init.lua ~/.config/nvim-lite/lua/lite/plugins/init.lua
ln -sf $DOTFILES/nvim/config/nvim-lite/after/plugin/tokyonight.lua ~/.config/nvim-lite/after/plugin/tokyonight.lua

dir="$HOME/.local/share/nvim-lite/site/pack/colors/start/tokyonight.nvim/"
if [ -d $dir ] && [ -z "$(ls -A "$dir")" ]; then
  git clone https://github.com/folke/tokyonight.nvim "$dir"
fi

#TODO: automate with loop, make bash distro aware, handle the clangd special conf for esp idf.
#TODO: maybe remove the double software name in this repo /dotfiles?
#TODO: maybe make this whole repo an hidden folder with dot?
