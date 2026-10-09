# AGENTS.md — linux

## Purpose

- Linux-only (Arch-based: CachyOS laptop + desktop) configs and installers:
  terminals (`alacritty/`, `kitty/`), shell (`zsh/`), system info
  (`fastfetch/`), theming (`matugen/`, `kde/`), compositor (`hypr/`),
  networking (`network/`), luarocks notes (`lua/`), and the ansible playbook
  that provisions most of it (`ansible/`, run via `bootstrap.sh`).
- `setup-linux.bash` is the one-command entry point: it chains
  `bootstrap.sh`, `claude/install-claude.bash`, `common/ssh/setup.bash` and
  the opt-in `network/setup.bash` / `setup-ai-tools.bash`. A new standalone
  setup script gets a step there too.
- Cross-platform configs (nvim, wezterm, zellij, ssh, git) live in `common/`.

## Ownership

- Owns every folder under `linux/` plus `bootstrap.sh` and `setup-linux.bash`, except where a child
  `AGENTS.md` exists (see Child Index).

## Local Contracts

- Arch-based only: every package installs with `pacman`, always with a full
  `-Syu`, never a partial `-Sy`. AUR-only packages are optional and skipped
  where no configured repo carries them.
- Scripts resolve paths from their own location so they work from any cwd,
  use `set -eu -o pipefail` (or stricter), and are idempotent.
- System-wide files (e.g. `network/wifi-powersave.conf` →
  `/etc/NetworkManager/conf.d/`) are installed by the folder's `setup.bash`
  with `sudo`, never by hand-written instructions only.
- The ansible role copies configs into `~/.config`; it does not symlink into
  the repo. A folder's standalone script, if it has one, must agree with the
  role on destination paths.

## Work Guidance

- Adding a tool: create `linux/<tool>/` with the config, add a
  `setup_<tool>` task to the ansible role (see `linux/ansible/AGENTS.md`), a
  README section under the Linux setup, and a CHANGELOG entry.

## Verification

- `./linux/bootstrap.sh --check` (ansible dry run) succeeds.
- A folder's `setup.bash` is safe to run twice in a row.

## Child Index

- `linux/ansible/AGENTS.md` — playbook, inventory and `setup-workstation` role.
- `linux/zsh/AGENTS.md` — zsh templates, zshenv and p10k.
