
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
│       └── nvim/            # → ~/.config/nvim/
└── tmux/
    └── dot-config/
        └── tmux/            # → ~/.config/tmux/

Using stow, all the package inside this directory will be symlink to HOME (~/).
All dot-name will be converted to .name by stow using the --dotefiles argument.
(not working so keeping .config)

## Ghostty on Arch Linux

From the root of this repo:

```bash
sudo pacman -S --needed ghostty xdg-terminal-exec ttf-jetbrains-mono-nerd stow
stow -d stow -t "$HOME" ghostty
```

This links `~/.config/ghostty/config` and makes Ghostty the preferred terminal
for XDG-aware launchers through `~/.config/xdg-terminals.list`. Verify the
selection with `xdg-terminal-exec --print-id`. Applications with their own
terminal preference may need to be configured separately.

For the full Arch setup (Ghostty, CLI utilities, C and Rust tooling, and
LazyVim dependencies), run `bash scripts/install_arch.sh` as your regular user.
The script installs `clangd` and `rust-analyzer` system-wide; LazyVim's Mason
installs the other configured language servers when you open Neovim. Cargo
installs `xcp` in `~/.cargo/bin` by default, so add that directory to your
shell's `PATH` if it isn't already there.

## Hyprland on Arch Linux

The optional `hyprland` Stow package uses the Lua config format in Hyprland
0.57. It auto-detects monitors and starts Waybar with workspaces, time,
network status, battery, and hostname. No launcher or file manager is required.
Install the bar and its font with `sudo pacman -S --needed waybar ttf-jetbrains-mono-nerd`
if you didn't run the Arch setup script. Back up and move any conflicting files under
`~/.config/hypr/` or `~/.config/waybar/`, then run from the repo root:

```bash
stow -d stow -t "$HOME" hyprland
```

`Super+Q` opens Ghostty, `Super+C` closes the active window, and `Super+M`
exits Hyprland. Use `Super+1` through `Super+0` to switch workspaces, or add
`Shift` to move the active window to that workspace. If you're already in
Hyprland, run `waybar` to preview the bar without logging out.

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

## Windows Terminal setup

Background color with tokyonight : #16161e
Configuration source: <https://github.com/jiyometrik/tokyonight-windows-terminal/tree/master>

## Docker

if running lazyvim through a container but not tmux, docker need access to the tmux socket:

```bash
docker run -it \
  -v /tmp/tmux-$(id -u):/tmp/tmux-$(id -u) \
  -e TMUX=$TMUX \
  -e TMUX_PANE=$TMUX_PANE \
  your-dev-image
```

TODO: sync the theme of all stuffs

- WEZTERM (theme)
- TMUX (theme)
- STARSHIP (theme)
- ZSH (LS_COLOR with vivid)
- NEOVIM (theme)
- VIM (theme)

TEST: in testing:  alternating starship prompt color (may be annoying long term, will see)
