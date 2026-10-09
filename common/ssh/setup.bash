#!/bin/bash
set -eu -o pipefail

# Symlink the SSH client config into ~/.ssh/config and create the ControlPath
# socket directory. Works regardless of the current working directory.
#
# Private per-host config belongs in ~/.ssh/config.local, which the shipped
# config Includes ahead of its own defaults.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ssh_dir="$HOME/.ssh"

mkdir -pv "$ssh_dir"
chmod 700 "$ssh_dir"

# Never clobber an existing real config; back it up so its host entries can be
# moved into ~/.ssh/config.local by hand.
if [[ -e "$ssh_dir/config" && ! -L "$ssh_dir/config" ]]; then
    backup="$ssh_dir/config.bak"
    echo "Existing ~/.ssh/config found, backing it up to $backup"
    echo "Move any per-host entries from it into ~/.ssh/config.local"
    mv -v "$ssh_dir/config" "$backup"
fi

ln -v -f -r -s "$script_dir/config" "$ssh_dir/config"

# ControlPath sockets live here; ssh will not create the directory itself.
mkdir -pv "$ssh_dir/sockets"
chmod 700 "$ssh_dir/sockets"

echo "Verify the effective config with: ssh -G <somehost>"
