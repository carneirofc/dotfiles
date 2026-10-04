# AGENTS.md — windows

## Purpose

- Windows bootstrap for a locked-down account: `setup-windows.ps1` (single
  entry point), the PowerShell profile (`profile.ps1`), Windows Terminal
  `settings.json`, and Windows-tuned variants of `alacritty/` and `zellij/`.

## Ownership

- Owns everything under `windows/`.

## Local Contracts

- Everything is a plain copy, never a symlink: no elevation, no Developer
  Mode. `setup-windows.ps1` resolves paths relative to itself and must stay
  idempotent (re-run refreshes every destination).
- Cross-platform configs are copied from `common/` (nvim →
  `%LOCALAPPDATA%\nvim`, wezterm → `~/.config/wezterm`); only configs that
  need Windows-specific values get a variant here (`windows/alacritty/`,
  `windows/zellij/`), and those override the Linux ones for this OS only.
- Zellij installs to `%APPDATA%\Zellij\config` (capital Z; the lower-case dir
  is never read).
- The copied nvim tree must not include generated Linux artifacts
  (`plugin/packer_compiled.lua` is git-ignored for this reason).

## Work Guidance

- Adding a config to the bootstrap: add an `Install-File` / directory copy
  block in `setup-windows.ps1`, document the destination in the README
  "Windows setup" section, and add a CHANGELOG entry.

## Verification

- `pwsh -File .\windows\setup-windows.ps1` twice in a row: second run reports
  no errors and leaves destinations unchanged. `zellij setup --check` for the
  zellij copy.

## Child Index

- None.
