# Changelog

All notable changes to this repo are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Conventional Commits](https://www.conventionalcommits.org/).

## [Unreleased]

### Added
- **windows**: `setup-windows.ps1` now copies the wezterm, alacritty, and zellij
  configs and the Claude agent/skill files into their Windows locations
  (`~/.config/wezterm`, `%APPDATA%\alacritty`, `%APPDATA%\zellij`, `~/.claude`),
  idempotently. Adds Windows-tuned `windows/alacritty/` and `windows/zellij/`
  variants and a `claude/skills/` directory.
- **docs**: Xbox controller Bluetooth setup section in the README —
  `UserspaceHID=false` and disabling ERTM via `/etc/modprobe.d/bluetooth.conf`
  to fix pairing/connection drops.
- **fastfetch**: modern `linux/fastfetch/config.jsonc` with clean Nerd Font
  icon rows, the repo's Nord palette, and memory/disk bars (root only). Deployed
  by the `setup-workstation` ansible role (`setup_fastfetch` toggle) or via the
  cwd-independent `linux/fastfetch/setup.bash`, which symlinks it into
  `~/.config/fastfetch`. Documented in the README.

### Changed
- **windows**: `setup-windows.ps1` copies the Neovim config to
  `%LOCALAPPDATA%\nvim` instead of symlinking it, so the whole bootstrap runs on
  a restricted account with no elevation or Developer Mode.
- **claude**: capitalized the `explore` and `implementer` subagent names.
