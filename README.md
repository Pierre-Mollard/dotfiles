
## Dotfiles

Select the bash init rc files from the different files in `Dotfiles` (avoid duplication with current bashrc you the new env). 

If copied then sourced in the main bashrc, then add a dot '.' before the filename for consistency. 

Careful, some bashrc like omarchy source the main configuration themselves. 

## File tree

This is how the dotfiles are mapped from this repo to the new environmemt: 

stow/
├── bash/
│   └── dot-bashrc           # → ~/.bashrc
├── git/
│   └── dot-gitconfig        # → ~/.gitconfig
├── vim/
│   └── dot-vimrc            # → ~/.vimrc
├── nvim/
│   └── dot-config/
│       └── nvim/        # → ~/.config/nvim/
└── tmux/
    └── dot-config/
        └── tmux/        # → ~/.config/tmux/

Using stow, all the package inside this directory will be symlink to HOME (~/). 
All dot-name will be converted to .name by stow using the --dotefiles argument.
(not working so keeping .config)

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
stow

## Offlines

- [ ] add all deps for offline components like lazyvim with C/C++ LSP servers.
- [ ] conf tmux more effecient
- [ ] cleanup and add tmux plugin files (manual for now: https://github.com/catppuccin/tmux)

TODO: 2
- [ ] setup colortheme for all rust utils? (check if possible)
- [ ] setup zellij conf like tmux

## Windows Terminal setup

Background color with tokyonight : #16161e
Configuration source: https://github.com/jiyometrik/tokyonight-windows-terminal/tree/master 
