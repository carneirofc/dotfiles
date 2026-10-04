# AGENTS.md — linux/zsh

## Purpose

- zsh shell setup: `zshenv` (sets `ZDOTDIR`), the `zshrc.j2` /
  `zsh-config.j2` / `zsh-prompt.j2` jinja templates rendered by the ansible
  role, the powerlevel10k prompt (`p10k.zsh`), and `install.sh` for a manual
  install.

## Ownership

- Owns everything under `linux/zsh/`.

## Local Contracts

- `.j2` files are templates: the ansible role renders them
  (`zsh_template_settings`); `install.sh` expects already-rendered `.zshrc`,
  `zsh-config`, `zsh-prompt` beside it. Keep template variables in sync with
  the role's `vars/main.yml`.
- Destinations: `~/.zshenv` (sets `ZDOTDIR=~/.config/zsh`),
  `~/.config/zsh/.zshrc`, and `p10k.zsh` / `zsh-config` / `zsh-prompt` under
  `/usr/share/zsh/`; plugins (`zsh-syntax-highlighting`,
  `zsh-history-substring-search`, `zsh-autosuggestions`) are git-cloned into
  `/usr/share/zsh/plugins` and powerlevel10k into
  `/usr/share/zsh-theme-powerlevel10k` by `install.sh` (needs `sudo`).
- `install.sh` symlinks by default (`USE_LN`), `FORCE=1` overwrites.

## Work Guidance

- Prompt tweaks go in `p10k.zsh`; aliases/exports go in the matching
  template, not in `zshrc.j2` directly.

## Verification

- `zsh -i -c 'echo ok'` after install prints `ok` with no errors, and
  `p10k configure` is not re-prompted.

## Child Index

- None.
