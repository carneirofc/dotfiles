# AGENTS.md — linux

## Purpose

- Linux-only (CachyOS / Arch, Hyprland on Wayland) configs and installers:
  terminals (`alacritty/`, `kitty/`, `zellij/`), shell (`zsh/`), system
  info (`fastfetch/`), compositor (`hypr/`), networking (`network/`), CLI
  tool fetchers (`install-tools.sh`, `ripgrep/`), fonts, luarocks notes
  (`lua/`), and the ansible role that automates most of it (`ansible/`).

## Ownership

- Owns every folder under `linux/` except where a child `AGENTS.md` exists
  (see Child Index).

## Local Contracts

- One folder per tool. A folder that installs something ships its own
  `setup.bash` (or `install.sh`) that resolves paths from its own location
  (`script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)`), uses
  `set -exu -o pipefail`, symlinks into `${XDG_CONFIG_HOME:-$HOME/.config}`,
  and is idempotent.
- Package installs use `pacman` / `yay`; Debian-era `apt` steps are legacy and
  not maintained.
- System-wide files (e.g. `network/wifi-powersave.conf` →
  `/etc/NetworkManager/conf.d/`) are installed by the folder's `setup.bash`
  with `sudo`, never by hand-written instructions only.
- Anything the ansible role deploys must also be installable by the folder's
  standalone script; the two must agree on destination paths.

## Work Guidance

- Adding a tool: create `linux/<tool>/` with the config + `setup.bash`, add a
  README section under "Linux setup (CachyOS)", add a CHANGELOG entry, and
  optionally a `setup_<tool>` toggle in the ansible role.

## Verification

- Run the folder's `setup.bash` on a clean `~/.config` target; it must create
  the symlink(s) and be safe to re-run.

## Child Index

- `linux/ansible/AGENTS.md` — `setup-workstation` role and playbook.
- `linux/zsh/AGENTS.md` — zsh config, jinja templates, p10k, installer.
