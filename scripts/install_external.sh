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
