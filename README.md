# Dotfiles

My public dotfiles, organized so a single repo can configure Windows, my Linux
laptop (CachyOS), and any cross-platform tooling that lives in between.

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
├── linux/             # Linux-specific (CachyOS laptop)
│   ├── zsh/           # zsh config + p10k + jinja templates
│   ├── alacritty/     # alacritty terminal (the terminal I use)
│   ├── kitty/         # kitty terminal (same look/keymaps as alacritty)
│   ├── fastfetch/     # fastfetch system-info screen (Nord icon rows)
│   ├── ripgrep/       # ripgrep install helper
│   ├── fonts/         # nerd-font install helper
│   ├── lua/           # luarocks notes
│   ├── install-tools.sh   # fetch prebuilt CLI tools (rg, jq, fd) into ~/.local/bin
│   └── ansible/       # ansible-based provisioning
│       ├── playbook.yml
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

## Linux setup (CachyOS)

### Ansible

Install Ansible:

```bash
pip install ansible==5.2.0 ansible-core==2.12.1 ansible-lint==5.3.2
```

Run the playbook (from the `linux/ansible/` directory so roles resolve):

```bash
cd linux/ansible
ansible-playbook playbook.yml
```

If Ansible can't find some packages, specify the interpreter:

```bash
ansible-playbook playbook.yml -K -e 'ansible_python_interpreter=/usr/bin/python3.8'
```

This playbook uses the local `setup-workstation` role in this repo. Toggle the
features you want in `linux/ansible/playbook.yml`.

### Alacritty

[Alacritty](https://github.com/alacritty/alacritty) is the terminal I use. The
config is `linux/alacritty/alacritty.toml` (modern TOML format — the old YAML
format is gone since Alacritty 0.14). It's deployed by the `setup-workstation`
role (`setup_alacritty: true`), or link it manually:

```bash
mkdir -pv ~/.config/alacritty
ln -v -r -s ./linux/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
```

The font is `JetBrainsMono Nerd Font` — install it first (see the fonts helper).

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

### Fastfetch

[Fastfetch](https://github.com/fastfetch-cli/fastfetch) draws the system-info
screen at shell startup. The config is `linux/fastfetch/config.jsonc` — a modern
JSONC layout with clean Nerd Font icon rows, the same Nord palette as the
terminals, and percentage bars for memory/disk (root only). It's deployed by the
`setup-workstation` role (`setup_fastfetch: true`), or symlink it with the helper
script (works from any directory):

```bash
./linux/fastfetch/setup.bash
```

which just does the equivalent of:

```bash
mkdir -pv ~/.config/fastfetch
ln -v -r -s ./linux/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
```

The icons need a Nerd Font (this setup uses `JetBrainsMono Nerd Font`). The logo
uses the builtin `cachyos` art — switch `logo.source` to `arch` in the config if
you're on a different distro.

### CLI tools

`linux/install-tools.sh` fetches prebuilt binaries (ripgrep, jq, fd) into
`~/.local/bin`:

```bash
./linux/install-tools.sh
```

### zsh

zsh is set up via the `setup-workstation` role in the [playbook](./linux/ansible/playbook.yml).
Enable it by setting the corresponding variable to `true`:

```yaml
---
- connection: local
  become: false
  hosts: localhost

  vars:
    setup_zsh: true

  roles:
    - setup-workstation
```

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
