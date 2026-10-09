# AGENTS.md — linux/ansible

## Purpose

- `playbook.yml` + the single `setup-workstation` role that provisions an
  Arch-based localhost: base packages, zsh, nvim, alacritty, kitty, wezterm,
  zellij, fastfetch and matugen/KDE theming. Run through
  `linux/bootstrap.sh`, which installs ansible with pacman first.

## Ownership

- Owns `playbook.yml`, `ansible.cfg`, `inventory.yml` (localhost only),
  `local.example.yml` and `roles/setup-workstation/**`.

## Local Contracts

- The playbook asserts `os_family == 'Archlinux'`; every package installs with
  `community.general.pacman`. `tasks/main.yml` runs one `pacman -Syu` up
  front; tasks never refresh the package lists on their own.
- Each tool is one task file `roles/setup-workstation/tasks/setup-<tool>.yml`,
  included from `tasks/main.yml` behind a `setup_<tool>` toggle. Toggles live
  in `playbook.yml` `vars` and are read with `| default(false) | bool` so
  `-e setup_x=true` works (ansible-core 2.19+ rejects string conditionals).
- Per-machine overrides (laptop vs desktop, `theming_wallpaper`) go in the
  git-ignored `local.yml`; `local.example.yml` documents them.
- `defaults/main.yml` holds paths, package lists and empty file lists;
  `vars/main.yml` fills the file lists (`<tool>_settings`,
  `zsh_template_settings`) from the sibling `linux/<tool>/` or
  `common/<tool>/` folder. Tasks never carry their own copies of configs.
- Configs are copied, not symlinked. Directory trees go through
  `copy-tree.yml` (git-tracked files only); old symlinks at a destination are
  removed first by `remove-links.yml`. Optional packages go through
  `install-optional.yml`.
- Tasks that need root use `become: true` per task, not at play level.

## Work Guidance

- When a config's destination changes, update the role so the copy lands in
  the new place, and the README section that documents it.

## Verification

- `./linux/bootstrap.sh --check` must succeed with the default toggles.

## Child Index

- None.
