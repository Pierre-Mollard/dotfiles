#!/bin/sh
sudo apt install zsh zsh-autosuggestions zsh-syntax-highlighting
chsh -s $(which zsh)

# Git special key name for ssh
#
# To reload one time
## eval "$(ssh-agent -s)"
## ssh-add ~/.ssh/github
#
# To setup ssh for a new key name
# In ~/.ssh/config
## Host github.com
## HostName github.com
## User git
## IdentityFile ~/.ssh/github
## IdentitiesOnly yes
## AddKeysToAgent yes

set -euo pipefail

echo "==> Detecting distribution package manager..."

if command -v apt-get >/dev/null 2>&1; then
  echo "==> Detected Debian/Ubuntu. Installing packages via APT..."
  sudo apt-get update -y
  sudo apt-get install -y zsh-autosuggestions zsh-syntax-highlighting

elif command -v pacman >/dev/null 2>&1; then
  echo "==> Detected Arch Linux. Installing packages via pacman..."
  sudo pacman -Sy --noconfirm zsh-autosuggestions zsh-syntax-highlighting

elif command -v dnf >/dev/null 2>&1; then
  echo "==> Detected Fedora/RHEL. Installing packages via dnf..."
  sudo dnf install -y zsh-autosuggestions zsh-syntax-highlighting

else
  echo "==> No supported system package manager found. Falling back to Git clone..."
  ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.local/share/zsh/plugins}"
  mkdir -p "$ZSH_CUSTOM_DIR"

  if [ ! -d "$ZSH_CUSTOM_DIR/zsh-autosuggestions" ]; then
    echo "==> Cloning zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM_DIR/zsh-autosuggestions"
  else
    echo "==> zsh-autosuggestions already cloned. Pulling latest..."
    git -C "$ZSH_CUSTOM_DIR/zsh-autosuggestions" pull
  fi

  if [ ! -d "$ZSH_CUSTOM_DIR/zsh-syntax-highlighting" ]; then
    echo "==> Cloning zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_DIR/zsh-syntax-highlighting"
  else
    echo "==> zsh-syntax-highlighting already cloned. Pulling latest..."
    git -C "$ZSH_CUSTOM_DIR/zsh-syntax-highlighting" pull
  fi
fi

## Rust components
rustup component add rust-analyzer rust-src rustfmt clippy

echo "==> Installation complete!"
