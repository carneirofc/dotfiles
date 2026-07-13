# Dotfiles

My public dotfiles, organized so a single repo can configure Windows, my Linux
laptop (CachyOS), and any cross-platform tooling that lives in between.

I'm slowly moving things to Ansible. Some config files are Jinja templates.

## Layout

```
.
├── common/            # cross-platform configs (symlinked the same way on any OS)
│   ├── nvim/          # Neovim configuration
│   └── git/           # Git configuration
├── linux/             # Linux-specific (CachyOS laptop)
│   ├── zsh/           # zsh config + p10k + jinja templates
│   ├── alacritty/     # alacritty terminal (the terminal I use)
│   ├── ripgrep/       # ripgrep install helper
│   ├── fonts/         # nerd-font install helper
│   ├── lua/           # luarocks notes
│   ├── install-tools.sh   # fetch prebuilt CLI tools (rg, jq, fd) into ~/.local/bin
│   └── ansible/       # ansible-based provisioning
│       ├── playbook.yml
│       └── roles/     # setup-workstation + ansible-role-neovim (submodule)
└── windows/           # Windows-specific
    ├── profile.ps1        # PowerShell profile
    ├── settings.json      # Windows Terminal settings
    └── setup-windows.ps1  # bootstrap: links nvim + installs the profile
```

Rule of thumb: if a config works unchanged on both OSes it lives in `common/`;
anything that only makes sense on one OS (or is installed differently) lives
under `linux/` or `windows/`.

## Neovim

Always install the latest version available — the project is extremely active and
some plugins rely on nightly features. The config itself is cross-platform and
lives in `common/nvim/`; only the symlink target differs per OS.

Linux:

```bash
mkdir -v ~/.config
ln -v -r -s ./common/nvim ~/.config/nvim
```

Windows (absolute paths required — the `setup-windows.ps1` script does this for you):

```powershell
$dest = (Get-Location).Path + "\common\nvim"
New-Item -Verbose -Value $dest -Path $env:USERPROFILE\AppData\Local\nvim -ItemType SymbolicLink
```

Then install external dependencies referenced by the `.lua` files (mdformat,
ansible-language-server, etc.) and, if using packer/vim-plug, run the plugin
install from inside Neovim.

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

The neovim role is a git submodule — initialize it after cloning:

```bash
git submodule update --init --recursive
```

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

## Some utilities and must-have programs

- [ripgrep](https://github.com/BurntSushi/ripgrep) — fast recursive search.
- [fzf](https://github.com/junegunn/fzf) — terminal fuzzy finder.
- [bat](https://github.com/sharkdp/bat) — `cat` replacement with syntax highlight.
- [Bear](https://github.com/rizsotto/Bear) — generates a JSON compilation database
  for LLVM-based tools (e.g. clangd). Usage: `bear make`.
- [mdformat-gfm](https://github.com/executablebooks/mdformat) — markdown formatter
  used by some nvim autocommands: `pip install --user -U mdformat mdformat-gfm`.
