# Dotfiles

My public dotfiles, organized so a single repo can configure Windows, my Linux
machines (CachyOS laptop and desktop; any Arch-based distro works), and any
cross-platform tooling that lives in between.

I'm slowly moving things to Ansible. Some config files are Jinja templates.

## Layout

```
.
├── claude/            # Claude Code user-level config
│   ├── agents/        # custom subagents (symlinked to ~/.claude/agents)
│   └── skills/        # custom skills (copied to ~/.claude/skills on Windows)
├── common/            # cross-platform configs (symlinked the same way on any OS)
│   ├── nvim/          # Neovim configuration
│   └── git/           # Git configuration
├── linux/             # Linux-specific (Arch-based: CachyOS laptop + desktop)
│   ├── zsh/           # zsh config + p10k + jinja templates
│   ├── alacritty/     # alacritty terminal (the terminal I use)
│   ├── kitty/         # kitty terminal (same look/keymaps as alacritty)
│   ├── fastfetch/     # fastfetch system-info screen (Nord icon rows)
│   ├── matugen/       # wallpaper-driven color palette for KDE + terminals
│   ├── kde/           # KDE Plasma look (blur, icons, decorations)
│   ├── hypr/          # Hyprland install helper
│   ├── lua/           # luarocks notes
│   ├── bootstrap.sh   # install ansible with pacman and run the playbook
│   └── ansible/       # ansible-based provisioning
│       ├── playbook.yml
│       ├── inventory.yml  # localhost only
│       └── roles/     # local workstation role for linux tooling
└── windows/           # Windows-specific
    ├── alacritty/         # alacritty terminal (Windows-tuned variant)
    ├── zellij/            # zellij config + theme (used under WSL)
    ├── profile.ps1        # PowerShell profile
    ├── settings.json      # Windows Terminal settings
    └── setup-windows.ps1  # bootstrap: profile, nvim, wezterm/alacritty/zellij, claude
```

Rule of thumb: if a config works unchanged on both OSes it lives in `common/`;
anything that only makes sense on one OS (or is installed differently) lives
under `linux/` or `windows/`.

On Windows, `setup-windows.ps1` installs the PowerShell profile and **copies**
every config into place — no symlinks, so it runs on a locked-down account with
no elevation or Developer Mode: nvim (from `common/`) to `%LOCALAPPDATA%\nvim`,
wezterm (from `common/`) to `~/.config/wezterm`, alacritty to
`%APPDATA%\alacritty`, zellij to `%APPDATA%\zellij` (applies under WSL — zellij
has no native Windows build), and the Claude agents/skills to `~/.claude`. It is
idempotent; re-run it to refresh every destination.

```powershell
pwsh -File .\windows\setup-windows.ps1
```

## Claude Code

`claude/agents/` holds user-level [Claude Code subagents](https://code.claude.com/docs/en/sub-agents)
that route mechanical work (codebase search, doc lookups, test runs, git
history) to Haiku and mid-tier work (deep code reading, scoped edits) to
Sonnet, keeping the expensive main model for the work that needs it. Link it
into place:

```bash
ln -v -r -s ./claude/agents ~/.claude/agents
```

Run `/agents` inside Claude Code to confirm they're picked up.

## Neovim

Neovim is kept as a regular cross-platform config under `common/nvim/`. It's
optional in this repo: the main focus is overall workstation tooling, and nvim
can be linked independently without requiring any extra role or submodule.

Linux:

```bash
mkdir -v ~/.config
ln -v -r -s ./common/nvim ~/.config/nvim
```

Windows (the `setup-windows.ps1` script does this for you; it **copies** rather
than symlinks so no elevation or Developer Mode is needed):

```powershell
Copy-Item -Recurse -Force .\common\nvim (Join-Path $env:LOCALAPPDATA 'nvim')
```

Then install any external dependencies referenced by the `.lua` files
(`mdformat`, `ansible-language-server`, etc.) and install plugins from inside
Neovim if you use this setup.

### FAQ

#### Neovim on Windows: graphical bug on line wrap
Before starting nvim, set `TERM` to empty:

```bash
TERM= nvim
```

or add an alias to your shell rc:

```bash
alias nvim='TERM= nvim'
```

#### [Use the Windows clipboard from WSL](https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl)

```bash
sudo ln -v -s "$(whereis win32yank.exe | awk '{print $2 }')" "/usr/local/bin/win32yank.exe"
```

## Windows setup

`windows/` contains a PowerShell profile and Windows Terminal `settings.json`.
Install the `JetBrains Mono NF` font first, then run the bootstrap from an
elevated PowerShell (needed for symlinks):

```powershell
./windows/setup-windows.ps1
```

## Linux setup (Arch-based)

Linux machines (the CachyOS laptop and desktop) are provisioned by Ansible.
Everything is installed with **pacman**, so only Arch-based distros are
supported; the playbook stops early on anything else.

### Ansible

`linux/bootstrap.sh` upgrades the system and installs Ansible with pacman (the
`ansible` package bundles `community.general`, which provides the pacman
module), then runs the playbook against this machine, asking once for your sudo
password:

```bash
./linux/bootstrap.sh            # provision
./linux/bootstrap.sh --check    # dry run; extra args go to ansible-playbook
```

To run it by hand instead, from `linux/ansible/` (its `ansible.cfg` points at
the localhost inventory):

```bash
sudo pacman -Syu --needed ansible
cd linux/ansible
ansible-playbook playbook.yml --ask-become-pass
```

Toggle features in `linux/ansible/playbook.yml` (`setup_packages`, `setup_zsh`,
`setup_nvim`, `setup_alacritty`, `setup_kitty`, `setup_fastfetch`,
`setup_theming`). Per-machine differences — say, nvim only on the desktop —
go in `linux/ansible/local.yml` (gitignored; copy `local.example.yml`), or pass
them once with `-e setup_nvim=true`. The wallpaper path (`theming_wallpaper`)
differs between machines, so it lives only there; theming skips it with a
message when the file isn't found.

Every run starts with a full system upgrade (`pacman -Syu`). Arch doesn't
support partial upgrades, so packages are never installed against package
lists that are stale or synced without upgrading.

Configs are **copied** (or rendered from templates) into `~/.config`, never
symlinked into the repo: edit them here and re-run the playbook to deploy.
Symlinks left by older setups are removed and replaced by the copies. Copies
don't delete files removed from the repo; clean those up by hand.

`setup_packages` installs the base CLI tools and the font: `git`, `ripgrep`,
`fd`, `jq`, `fzf`, `bat` and `ttf-jetbrains-mono-nerd` (`base_packages` in the
role defaults). Each feature installs its own packages too. Packages that only
CachyOS's repos carry (`zsh-theme-powerlevel10k`,
`kwin-effect-rounded-corners`) are optional: they're skipped with a note on
distros where they'd need the AUR.

### Alacritty

[Alacritty](https://github.com/alacritty/alacritty) is the terminal I use. The
config is `linux/alacritty/alacritty.toml` (modern TOML format — the old YAML
format is gone since Alacritty 0.14). It's deployed by the `setup-workstation`
role (`setup_alacritty: true`), or link it manually:

```bash
mkdir -pv ~/.config/alacritty
ln -v -r -s ./linux/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
```

The font is `JetBrainsMono Nerd Font` (`ttf-jetbrains-mono-nerd`, installed by
`setup_packages`).

### Kitty

[Kitty](https://sw.kovidgoyal.net/kitty/) is configured in
`linux/kitty/kitty.conf` and deliberately mirrors the Alacritty setup: same Nord
palette, same JetBrainsMono Nerd Font at 12pt, 0.9 background opacity, and the
same keymaps. Ligatures are enabled everywhere (`disable_ligatures never`),
including under the cursor. It's deployed by the `setup-workstation` role
(`setup_kitty: true`), or link it manually:

```bash
mkdir -pv ~/.config/kitty
ln -v -r -s ./linux/kitty/kitty.conf ~/.config/kitty/kitty.conf
```

Two things don't map one-to-one from Alacritty: kitty has no in-terminal search
(`ctrl+shift+f` opens the scrollback pager instead), and `TERM` is pinned to
`xterm-256color` to match Alacritty — switch it to `xterm-kitty` if you want
kitty's extra terminfo features and don't mind installing its terminfo on
remote hosts.

### Theming (KDE Plasma + matugen)

The desktop and terminal colors are generated from the wallpaper by
[matugen](https://github.com/InioX/matugen) (Material You palette).
`linux/matugen/` holds the config and one template per app:

| Template | Output | Reload |
|---|---|---|
| `kde.colors` | `~/.local/share/color-schemes/Matugen.colors` | applied via `plasma-apply-colorscheme` |
| `alacritty.toml` | `~/.config/alacritty/colors.toml` | live (imported by `alacritty.toml`) |
| `kitty.conf` | `~/.config/kitty/colors.conf` | live (`SIGUSR1`) |
| `wezterm.lua` | `~/.config/wezterm/colors/matugen.lua` | live (falls back to `colors/custom.lua`) |
| `zellij.kdl` | `~/.config/zellij/themes/matugen.kdl` | new sessions |

The terminal ANSI colors are fixed hues (`[config.custom_colors]`) harmonized
toward the wallpaper, so red still reads as red. The WezTerm and Zellij outputs
land inside this repo through the config symlinks and are gitignored.

```bash
sudo pacman -S matugen
cp -rT linux/matugen ~/.config/matugen
~/.config/matugen/set-wallpaper.sh ~/Pictures/Wallpaper/<image>.png
```

`set-wallpaper.sh` sets the desktop and lock-screen wallpaper, then runs
matugen; extra args are forwarded (e.g. `-t scheme-content` for colors closer
to the image). The mode defaults to dark; set `MATUGEN_MODE=light` for a light
palette (matugen rejects a second `--mode`, so it can't go in the extra args).

`linux/kde/apply.sh` applies the rest of the look with `kwriteconfig6`, one key
at a time, so the rc files Plasma rewrites at runtime aren't tracked whole:
Breeze Dark, blur, borderless centered-title decorations, the scheme's accent,
Papirus-Dark icons and rounded corners when installed
(`papirus-icon-theme`, `kwin-effect-rounded-corners`). Panels and widgets live
in `plasma-org.kde.plasma.desktop-appletsrc`, which is machine-specific, so
they stay manual.

The login screen (Plasma Login Manager) runs as the `plasmalogin` user and
keeps its own copy of `kdeglobals` and friends, so it doesn't follow these
changes the way the lock screen does. `linux/kde/sync-login.sh` copies them
(colors, icons, fonts, keyboard, monitors) and the wallpaper over, same as
System Settings > Login Screen > *Apply Plasma Settings*:

```bash
sudo linux/kde/sync-login.sh ~ ~/Pictures/Wallpaper/<image>.png
```

All three run from the `setup-workstation` role (`setup_theming: true`,
wallpaper in `theming_wallpaper`), the login sync last and with `become`. Each
step only runs where it can: the KDE look needs Plasma installed, the wallpaper
needs a running Plasma session (run `set-wallpaper.sh` yourself after logging
in otherwise), and the login sync needs Plasma Login Manager (a `plasmalogin`
user), so SDDM machines skip it.

### Fastfetch

[Fastfetch](https://github.com/fastfetch-cli/fastfetch) draws the system-info
screen at shell startup. The config is `linux/fastfetch/config.jsonc` — a modern
JSONC layout with clean Nerd Font icon rows, the same Nord palette as the
terminals, and percentage bars for memory/disk (root only). It's deployed by the
`setup-workstation` role (`setup_fastfetch: true`), which copies it to
`~/.config/fastfetch/config.jsonc`.

The icons need a Nerd Font (this setup uses `JetBrainsMono Nerd Font`). The logo
uses the builtin `cachyos` art — switch `logo.source` to `arch` in the config if
you're on a different distro.

### zsh

zsh is set up by the `setup-workstation` role (`setup_zsh: true`). It installs
zsh and its plugins with pacman, then renders the config into `~/.config/zsh`
(`ZDOTDIR`, set by `~/.zshenv`) — nothing is written under `/usr/share`. The
prompt is powerlevel10k when `zsh-theme-powerlevel10k` is installed, and a
plain prompt otherwise (and on the TTY).

Your login shell is left alone; set `zsh_login_shell: true` to `chsh` to zsh.

### Xbox controller Bluetooth

Getting an Xbox controller to pair reliably over Bluetooth needs a few tweaks —
BlueZ changed the `UserspaceHID` default to `true` in March 2024, which breaks
Xbox controllers, and ERTM (Enhanced Re-Transmission Mode) conflicts with the
controller's Bluetooth implementation and causes most connection drops. These
are system-level config files, so they're the same regardless of distro.
Adapted from [this guide](https://www.simon-neutert.de/posts/2025/09/07/aurora-xbox-nuc11/).

In `/etc/bluetooth/main.conf`, add to the `[General]` section:

```ini
ControllerMode = dual
Privacy = device
FastConnectable = true
JustWorksRepairing = confirm
```

and add a new `[LE]` section:

```ini
[LE]
MinConnectionInterval=7
MaxConnectionInterval=9
ConnectionLatency=0
```

In `/etc/bluetooth/input.conf`, set in the `[General]` section:

```ini
UserspaceHID=false
ClassicBondedOnly=false
```

Create `/etc/modprobe.d/bluetooth.conf` to disable ERTM:

```ini
options bluetooth disable_ertm=1
```

The `disable_ertm` option is read when the `bluetooth` kernel module loads, so a
reboot is required for it to take effect:

```bash
sudo reboot
```

(A `sudo systemctl restart bluetooth` picks up the `main.conf`/`input.conf`
changes but not the module option.)

## Some utilities and must-have programs

- [ripgrep](https://github.com/BurntSushi/ripgrep) — fast recursive search.
- [fzf](https://github.com/junegunn/fzf) — terminal fuzzy finder.
- [bat](https://github.com/sharkdp/bat) — `cat` replacement with syntax highlight.
- [Bear](https://github.com/rizsotto/Bear) — generates a JSON compilation database
  for LLVM-based tools (e.g. clangd). Usage: `bear make`.
- [mdformat-gfm](https://github.com/executablebooks/mdformat) — markdown formatter
  used by some nvim autocommands: `pip install --user -U mdformat mdformat-gfm`.
