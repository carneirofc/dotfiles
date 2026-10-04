# AGENTS.md — dotfiles (root rail)

## Purpose

- Personal dotfiles for a CachyOS (Arch) laptop and a locked-down Windows
  account. Configs are either symlinked (Linux) or copied (Windows) into place.
- `README.md` is the human-facing install guide; keep it in sync when a
  setup step changes.

## Ownership

- Root owns: `README.md`, `CHANGELOG.md`, `.gitignore`, `.gitattributes`,
  `setup-ai-tools.bash`, and the placement rule below.
- Everything under a folder with its own `AGENTS.md` is owned by that doc.

## Local Contracts

- Placement rule: a config that works unchanged on both OSes lives in
  `common/`; anything OS-specific or installed differently lives in `linux/`
  or `windows/`.
- Every change gets an entry under `## [Unreleased]` in `CHANGELOG.md`
  (Keep a Changelog sections: Added / Changed / Fixed / Removed), prefixed with
  the area in bold, e.g. `- **nvim**: …`.
- Commits use Conventional Commits with the area as scope, e.g.
  `fix(nvim): …`, `docs(readme): …`. No co-author trailers.
- Never commit or push to `master`. Work on a `fix/…`, `feat/…`, `docs/…`
  branch and open a pull request (`gh pr create`).
- Line endings: `.gitattributes` forces LF except `.cmd`/`.bat`.
- Generated or machine-specific files are git-ignored, never committed
  (e.g. `common/nvim/plugin/packer_compiled.lua`).

## Work Guidance

- Prefer editing the existing per-tool `setup.bash` / `install.sh` over
  adding new install paths; each script must work from any cwd.
- When a setup step is added or changed, update the matching README section
  and the ansible role if it covers that tool.

## Verification

- No repo-wide test suite. Each child doc lists its own check.
- `git status` must show no generated files staged.

## Child Index

- `claude/AGENTS.md` — Claude Code user-level config (`agents/`, `skills/`,
  `CLAUDE.md`, installers). This file is also the global template: it is
  symlinked to `~/.claude/AGENTS.md`, so its "not yet indexed" Child Index
  placeholder is intentional and must stay.
- `common/nvim/AGENTS.md` — Neovim config (packer, LSP via mason, plugins).
- `common/wezterm/AGENTS.md` — WezTerm config modules.
- `linux/AGENTS.md` — Linux-only tool configs, setup scripts, ansible role.
  Children: `linux/ansible/AGENTS.md`, `linux/zsh/AGENTS.md`.
- `windows/AGENTS.md` — Windows bootstrap (copy-based) and Windows-tuned
  terminal variants.
- Folders without a child doc (`common/git`, `common/ssh`) follow this root
  doc directly.
