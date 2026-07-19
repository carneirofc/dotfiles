#!/bin/bash
set -exu -o pipefail

# Symlink the fastfetch config into ~/.config/fastfetch.
# Works regardless of the current working directory.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch"

mkdir -pv "$config_dir"
ln -v -f -r -s "$script_dir/config.jsonc" "$config_dir/config.jsonc"
