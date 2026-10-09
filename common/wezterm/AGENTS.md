# AGENTS.md — common/wezterm

## Purpose

- WezTerm configuration shared by Linux and Windows (`~/.config/wezterm` on
  both; Windows copies it via `windows/setup-windows.ps1`).

## Ownership

- Owns everything under `common/wezterm/`.

## Local Contracts

- `wezterm.lua` is the entry point and must never raise: every module load
  and side effect is wrapped through `utils/safe.lua`, with an inline
  dependency-free `FALLBACK` config. Keep `wezterm.lua` free of logic beyond
  wiring.
- `config/` holds one module per concern (`general`, `appearance`, `fonts`,
  `platform`), composed by `config/init.lua`.
- `utils/` holds helpers only (`backdrops`, `gpu-adapter`, `math`,
  `platform`, `safe`, `str`); no config values.
- `colors/` and `backdrops/` are assets referenced by `config/appearance.lua`
  and `utils/backdrops.lua`.
- Platform differences are branched in `config/platform.lua` /
  `utils/platform.lua`, not scattered across modules.

## Work Guidance

- Add a new setting to the matching `config/*.lua` module; add a helper to
  `utils/`. New requires go through `safe.require` so a broken module
  degrades to the fallback instead of killing the terminal.

## Verification

- Start WezTerm and open the debug overlay (`CTRL+SHIFT+L`): no errors
  logged. A fallback-coloured window means the real config failed to build.

## Child Index

- None.
