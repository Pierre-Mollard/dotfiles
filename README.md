# Tutorial to setup configurations to workspace

## Dotfiles

Select the bash init rc files from the different files in `Dotfiles` (avoid duplication with current bashrc you the new env). 

If copied then sourced in the main bashrc, then add a dot '.' before the filename for consistency. 

Careful, some bashrc like omarchy source the main configuration themselves. 

## File tree

This is how the dotfiles are mapped from this repo to the new environmemt: 

dotfiles/
├── bash/
│   └── bashrc           # → ~/.bashrc
├── git/
│   └── gitconfig        # → ~/.gitconfig
├── vim/
│   └── vimrc            # → ~/.vimrc
├── nvim/
│   └── config/
│       └── nvim/        # → ~/.config/nvim/
└── tmux/
    └── config/
        └── tmux/        # → ~/.config/tmux/

## Keys Handling

To generate keys for Github :

```bash 
ssh-keygen -t ed25519 -C "pierre.mollard19@orange.fr"
```

- Choose a name (prompted with ssh)
- Move the keys in home/.ssh
- Use the script `scripts/git_add_user.sh` to add credentials to .gitconfig (or copy the config first from `dotfiles`)
- Important: add the public key to github profile
- source the `bashrc_perso` that load the private key into the ssh agent

## Help update this repo

If you clone this repo with HTTPS, use the script `scripts/git_repo_ssh.sh` to reset the remote to SSH so you can use the SSH keys.

## List of all deps recommended for a WSL or any Linux env

gperf python3 python3-pip python3-venv cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0

## Offlines

TODO: add all deps for offline components like lazyvim with C/C++ LSP servers.
TODO: conf tmux more effecient
TODO: cleanup and add tmux plugin files (manual for now: https://github.com/catppuccin/tmux)

## Windows Terminal setup

Background color with tokyonight : #16161e

