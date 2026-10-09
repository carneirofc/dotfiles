# Zellij

Configuration for [Zellij](https://zellij.dev) (tested with 0.45.x), shared
by Linux and Windows.

## Layout

```
zellij/
├── config.kdl                    # Options, plugins, keybinds (single entry point)
└── themes/
    └── carneirofc-mocha.kdl      # Custom theme (Catppuccin Mocha palette)
```

Zellij reads exactly one config file (`config.kdl`) and has no include
mechanism, so options, plugins and keybinds must live there. Concerns that can
be split into separate files are auto-loaded from sibling directories of the
config file:

- `themes/` — one theme per file ([docs](https://zellij.dev/documentation/themes.html))
- `layouts/` — one layout per file ([docs](https://zellij.dev/documentation/layouts.html))

## Install

The config is copied into place, never symlinked (Zellij rewrites
`config.kdl` when settings change from inside it, which would land in the
repo through a link):

- **Linux** — `~/.config/zellij`, by the `setup-workstation` Ansible role.
- **Windows** — `%APPDATA%\Zellij\config`, by `windows/setup-windows.ps1`.

Verify with `zellij setup --check`.

## Theme

The active theme is selected in `config.kdl` (`theme "carneirofc-mocha"`) and
defined in `themes/carneirofc-mocha.kdl` using the
[theme styling spec](https://zellij.dev/documentation/themes.html). It is based
on the Catppuccin Mocha palette to match the Wezterm config
(`common/wezterm/wezterm.lua`).

On Linux with theming enabled, the Ansible role switches the line to
`theme "matugen"`, the palette matugen generates from the wallpaper into
`~/.config/zellij/themes/matugen.kdl` (see `linux/matugen`). Until matugen has
run once, Zellij falls back to its built-in theme.

Note: themes in `themes/` are picked up on session start. For rapid iteration,
temporarily paste the `themes { ... }` block into `config.kdl`, which is
live-reloaded.

## Keybinds

`config.kdl` uses `keybinds clear-defaults=true` with the full 0.45 default
binding set written out, so upstream default changes never silently alter
behavior. Deliberate departures: `Alt`+arrows/`hjkl` in scroll mode move focus
and return to normal mode, and resize mode's `hjkl` increase the pane size
(0.45 upstream decreases it). Tweak per-mode blocks directly; `zellij setup --dump-config` prints
the current upstream defaults for comparison.
