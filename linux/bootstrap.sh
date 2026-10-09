#!/bin/bash
# Provision this machine: install Ansible with pacman, then run the
# setup-workstation playbook against localhost. Extra args go to
# ansible-playbook (e.g. --check, --tags, -e setup_nvim=true).
set -euo pipefail

command -v pacman >/dev/null || { echo "pacman not found; Arch-based distros only" >&2; exit 1; }

# The 'ansible' package bundles community.general (for the pacman module).
sudo pacman -S --needed ansible git

cd "$(dirname "$(realpath "$0")")/ansible"
exec ansible-playbook playbook.yml --ask-become-pass "$@"
