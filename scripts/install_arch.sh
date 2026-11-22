#!/usr/bin/env bash

set -e

sudo pacman -S --needed \
  ghostty stow lsd vivid fzf \
  base-devel cmake ninja gdb \
  clang rust rust-analyzer \
  neovim git ripgrep fd tree-sitter-cli \
  curl unzip nodejs npm

# base-devel includes GCC, Make and pkgconf; rust includes Cargo and rustfmt.
# clang provides clangd. LazyVim's Mason installs the Lua, Bash, CMake,
# JSON and Markdown servers when Neovim starts.

# xcp is not in the official Arch repos. Install it for the current user.
cargo install --locked xcp
