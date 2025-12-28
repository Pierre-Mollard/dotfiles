# Tutorial to link Github to workspace

## Keys Handling

To generate keys for Github :

`ssh-keygen -t ed25519 -C "pierre.mollard19@orange.fr"`

Choose a name (prompted with ssh)
Move the keys in home/.ssh
Use the script `scripts/git_add_user.sh` to add the command that fill the ssh-agent with the private keys

Important: add the public key to github profile

Source the bashrc
Done

## Help update this repo

If you clone this repo with HTTPS, use the script `scripts/git_repo_ssh.sh` to reset the remote to SSH so you can use the SSH keys.

# List of all deps recommended for a WSL or any Linux env

gperf python3 python3-pip python3-venv cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0
