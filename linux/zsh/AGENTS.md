# AGENTS.md — linux/zsh

## Purpose

- zsh shell setup: `zshenv` (sets `ZDOTDIR`), the `zshrc.j2` /
  `zsh-config.j2` / `zsh-prompt.j2` jinja templates, and the powerlevel10k
  prompt config (`p10k.zsh`). Deployed by the ansible role's `setup-zsh.yml`;
  there is no standalone installer.

## Ownership

- Owns everything under `linux/zsh/`.

## Local Contracts

- The role renders, as the user, `zshenv` → `~/.zshenv`, the templates →
  `~/.config/zsh/{.zshrc,zsh-config,zsh-prompt}`, and copies `p10k.zsh` →
  `~/.config/zsh/p10k.zsh`. Nothing is written to `/usr/share/zsh`.
- Plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`,
  `zsh-history-substring-search`) and `zsh-theme-powerlevel10k` (optional)
  come from pacman; templates source them from the system paths in the role's
  `defaults/main.yml` (`zsh_path`, `zsh_p10k_theme`).
- Keep template variables in sync with the role's `defaults/main.yml` and
  `vars/main.yml`. Changing the login shell is opt-in (`zsh_login_shell`).

## Work Guidance

- Prompt tweaks go in `p10k.zsh`; aliases/exports go in the matching
  template, not in `zshrc.j2` directly.

## Verification

- `zsh -i -c 'echo ok'` after a playbook run prints `ok` with no errors, and
  `p10k configure` is not re-prompted.

## Child Index

- None.
