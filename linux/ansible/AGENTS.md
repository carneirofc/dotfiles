# AGENTS.md — linux/ansible

## Purpose

- `playbook.yml` + the single `setup-workstation` role that deploys the
  Linux configs (zsh, fonts, nvim, alacritty, kitty, fastfetch) to localhost.

## Ownership

- Owns `playbook.yml` and `roles/setup-workstation/**`.

## Local Contracts

- Each tool is one task file `roles/setup-workstation/tasks/setup-<tool>.yml`,
  included from `tasks/main.yml` behind a `setup_<tool>` boolean. The toggles
  live only in `playbook.yml` `vars`; `roles/setup-workstation/defaults/main.yml`
  holds paths and the per-tool file lists (`<tool>_settings`,
  `zsh_template_settings`, `zsh_plugins_repos`, …), which default to empty.
- Tasks copy or render (jinja) the files that live in the sibling
  `linux/<tool>/` or `common/<tool>/` folder; they do not carry their own
  copies of configs.
- Tasks that need root use `become: true` per task, not at play level.
- Package-manager steps target Debian (`apt`) and RedHat (`yum`) only; on
  CachyOS/Arch install packages by hand (or via the folder's `setup.bash`)
  and run the role for file deployment.
- `tasks/setup-nvim.yml` is legacy (downloads a pinned nvim binary, apt
  packages, pip LSP tooling) and is off by default (`setup_nvim: false`); the
  nvim config now manages its servers through mason (see
  `common/nvim/AGENTS.md`).

## Work Guidance

- When a `linux/<tool>/setup.bash` changes its destination, update the
  matching task so both paths agree.

## Verification

- `ansible-playbook -i localhost, -c local linux/ansible/playbook.yml --check`
  must succeed with the default toggles.

## Child Index

- None.
