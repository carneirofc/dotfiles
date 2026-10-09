# Changelog

All notable changes to this repo are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Conventional Commits](https://www.conventionalcommits.org/).

## [Unreleased]

### Added
- **zellij**: binds the actions added in 0.45 — pane `;` (last pane) and
  `Shift f` (fullscreen without UI); scroll/search `[`/`]` (previous/next
  prompt) and `m` (select command); scroll `c` (copy last command output);
  session `[`/`]` (guest/host session) and `f` (host fullscreen).
- **ansible**: `setup_wezterm` installs WezTerm with pacman and copies the
  tracked files of `common/wezterm` to `~/.config/wezterm`, replacing an old
  symlink there.
- **ansible**: `setup_zellij` installs Zellij with pacman and copies the shared
  `common/zellij` config to `~/.config/zellij`, setting `theme "matugen"` when
  theming is on (`zellij_theme`). A new `copy-tree.yml` copies only the files
  git tracks, so generated and ignored files in the repo aren't deployed.
- **theming**: wallpaper-driven colors with matugen. `linux/matugen/` renders a
  KDE color scheme and Alacritty, Kitty, WezTerm and Zellij palettes from the
  wallpaper; `set-wallpaper.sh` sets the desktop/lock-screen wallpaper and
  regenerates everything. `linux/kde/apply.sh` applies the Plasma look (blur,
  decorations, icons, rounded corners) via `kwriteconfig6`. Deployed by the
  `setup-workstation` role (`setup_theming` toggle).
- **kde**: `linux/kde/sync-login.sh` copies the Plasma look (colors, icons,
  fonts) and wallpaper to the Plasma Login Manager greeter, so the login
  screen matches the lock screen. Run as root by the theming task.
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
  by the `setup-workstation` ansible role (`setup_fastfetch` toggle).
  Documented in the README.

- **linux**: `linux/bootstrap.sh` installs Ansible with pacman and runs the
  playbook against this machine. The playbook gains an `ansible.cfg` and a
  localhost inventory, and reads per-machine overrides (laptop vs desktop) from
  a gitignored `linux/ansible/local.yml`.
- **ansible**: `setup_packages` installs base CLI tools (`ripgrep`, `fd`, `jq`,
  `fzf`, `bat`, `git`) and `ttf-jetbrains-mono-nerd`; every feature installs
  its own packages. CachyOS-only packages (powerlevel10k, rounded corners) are
  optional and skipped where they'd need the AUR.

### Changed
- **zellij**: one config for Linux and Windows in `common/zellij/`, replacing
  the near-identical `linux/zellij/` and `windows/zellij/` copies (they differed
  only in the header and theme line). It replaces the header Zellij wrote into
  the repo through the old symlink.
- **linux**: no install runs against stale package lists. `bootstrap.sh`,
  `hypr/setup.bash` and the role (first task, every run) do a full
  `pacman -Syu`, never a partial `-Sy`, per the Arch wiki.
- **ansible**: configs are copied instead of symlinked into the repo. The
  Neovim and matugen config dirs are now copies; old symlinks there (and at
  the fastfetch config) are removed first.
- **ansible**: `theming_wallpaper` has no default path; set it per machine in
  `local.yml`. Theming checks the file exists before using it, and skips the
  wallpaper and greeter image with a message when it doesn't.
- **terminals**: Alacritty, Kitty, WezTerm and Zellij take their colors from
  the matugen-generated files. Alacritty drops its inline Nord palette; Kitty
  keeps Nord as a fallback, and WezTerm falls back to `colors/custom.lua`.
- **windows**: `setup-windows.ps1` installs Zellij to the native Windows config
  dir `%APPDATA%\Zellij\config` (config.kdl and `themes/`), instead of the
  never-read `%APPDATA%\zellij`. Verify with `zellij setup --check`.
- **windows**: `alacritty.toml` sets opacity to `1.0` and drops the
  JetBrainsMono Nerd Font family, falling back to Alacritty's built-in default.
- **windows**: `setup-windows.ps1` copies the Neovim config to
  `%LOCALAPPDATA%\nvim` instead of symlinking it, so the whole bootstrap runs on
  a restricted account with no elevation or Developer Mode.
- **claude**: capitalized the `explore` and `implementer` subagent names.
- **ansible**: Arch-based distros only — everything installs with pacman,
  and the playbook asserts the OS family up front. `setup_nvim` installs
  neovim and its tooling from pacman and copies `common/nvim`.
- **zsh**: config is rendered into `~/.config/zsh` as the user instead of
  `/usr/share/zsh`; plugins and powerlevel10k come from pacman. Changing the
  login shell is opt-in (`zsh_login_shell`).
- **ansible**: theming steps only run where they can — the wallpaper needs a
  Plasma session and the login sync needs Plasma Login Manager.
- **hypr**: `setup.bash` installs repo Hyprland with `sudo pacman --needed`;
  the AUR `-git` stack is behind `--git`.
- **ai-tools**: `setup-ai-tools.bash` checks for `uv`/`npx` first and finds
  `graphify` through `uv tool dir --bin` instead of assuming `~/.local/bin`.

### Removed
- **git**: the `.gitignore` entries for matugen output inside the repo; with
  WezTerm and Zellij copied instead of linked, matugen writes to `~/.config`.
- **ansible**: apt/yum code paths, the Nerd Font download task (dead v2
  URLs), the pinned nightly nvim AppImage and the system-wide pip installs.
- **linux**: `install-tools.sh`, `ripgrep/install.sh` and `zsh/install.sh`,
  replaced by pacman packages and the playbook.
- **fastfetch**: `linux/fastfetch/setup.bash`, which symlinked the config; the
  playbook copies it instead.

### Fixed
- **docs**: the Windows setup section said to run `setup-windows.ps1` elevated
  "for symlinks"; it copies files and needs neither. It now says to use a
  normal PowerShell 7 prompt, that git is required, and that Windows Terminal's
  `settings.json` is copied by hand.
- **windows**: `setup-windows.ps1` deleted each destination before copying, so
  every run wiped `~/.claude/skills` (the repo only tracks `.gitkeep`) and
  `~/.claude/agents`, plus WezTerm backdrop images and anything else local.
  It now copies the files git tracks over what's there and deletes nothing,
  which also stops untracked files in the checkout (`nvim/plugged`) from
  being deployed. Files removed from the repo now linger; delete them by hand.
- **windows**: `setup-windows.ps1` stops at the first error
  (`$ErrorActionPreference = 'Stop'`) instead of printing it and carrying on,
  which could leave a config half-copied behind a run that looked finished.
- **matugen**: `set-wallpaper.sh <image> -m light` failed because the script
  already passes `--mode dark`, and matugen rejects the flag twice. The mode
  now comes from `MATUGEN_MODE` (default `dark`).
- **ansible**: the playbook targeted `hosts: all` with no inventory, so it ran
  on nothing.
- **zsh**: templates and `p10k.zsh` resolved to missing paths, the setup wrote
  to `/usr/share/zsh` without root, and the prompt sourced Manjaro's
  `zsh-maia-prompt` and a hardcoded node v16 path.
- **ansible**: feature toggles accept `-e setup_x=true` (ansible-core 2.19+
  rejects string conditionals).
- **kde**: `sync-login.sh` explains a missing Plasma Login Manager instead of
  failing on `id`.
