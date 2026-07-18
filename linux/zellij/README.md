# Zellij

Configuration for [Zellij](https://zellij.dev) (tested with 0.44.x).

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

Link (or copy) this directory to `$XDG_CONFIG_HOME/zellij`:

```sh
ln -s "$PWD" ~/.config/zellij
```

Verify with `zellij setup --check`.

## Theme

The active theme is selected in `config.kdl` (`theme "carneirofc-mocha"`) and
defined in `themes/carneirofc-mocha.kdl` using the
[theme styling spec](https://zellij.dev/documentation/themes.html). It is based
on the Catppuccin Mocha palette to match the Wezterm config
(`common/wezterm/wezterm.lua`).

Note: themes in `themes/` are picked up on session start. For rapid iteration,
temporarily paste the `themes { ... }` block into `config.kdl`, which is
live-reloaded.

## Keybinds

`config.kdl` uses `keybinds clear-defaults=true` with the full 0.44 default
binding set written out, so upstream default changes never silently alter
behavior. Tweak per-mode blocks directly; `zellij setup --dump-config` prints
the current upstream defaults for comparison.
