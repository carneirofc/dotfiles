# General Configurations

These are my dotfiles.

I'm slowly moving things to ansible. Some config files are jinja templates.

## [Neovim](https://github.com/neovim/neovim)
Always install the latest version available, the project is extremely active and some plugins will use nightly features. Check the releases section and go from there.

1. Clone the repository and create a link to the corresponding folder according to the OS.

```bash
# Linux based
mkdir -v  ~/.config
ln -v -r -s ./nvim ~/.config/nvim
```
or
```powershell
$dest = (Get-Location).Path + "\nvim" # We need absolute paths here!
New-Item -Verbose -Value $dest  -Path $env:USERPROFILE\AppData\Local\nvim -ItemType SymbolicLink 
```


2. Check the `.vim` and `.lua` files and install external dependencies e.g.: mdformat, ansible-language-server, etc.

3. Clone the required plugins using 'vim-plug'

```
:PlugInstall
```

### FAQ
#### [how-to-use-the-windows-clipboard-from-wsl](https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl)

```
# sudo ln -s "$NEOVIM_WIN_DIR/bin/win32yank.exe" "/usr/local/bin/win32yank.exe"
sudo ln -v -s "$(whereis win32yank.exe |awk '{print $2 }')" "/usr/local/bin/win32yank.exe"
```
## Windows setup

The folder `./windows/` contains a PowerShell profile and a Windows terminal settings `profile.json` file.
It is important to download and install the specified font `JetBraing Mono NF`.


## Linux setup and Ansible
Install ansible.

```command
pip install ansible==5.2.0 ansible-core==2.12.1 ansible-lint==5.3.2
```

Install using ansible:

```command
ansible-playbook playbook.yml
```

If ansible is having troubles finding some packages, try specifying the interpreter.

```
ansible-playbook playbook.yml -K  -e 'ansible_python_interpreter=/usr/bin/python3.8'
```

There are several utilities required, specially related to neovim and the development setup.

## Some utilities and must have programs

- ripgrep https://github.com/BurntSushi/ripgrep

```
# https://github.com/BurntSushi/ripgrep
wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb
```


- fzf *A really useful terminal fuzzyfinder https://github.com/junegunn/fzf.*

- bat *Unix `cat` replacement with syntax highlight https://github.com/sharkdp/bat.*


- [ʕ·ᴥ·ʔ BEAR](https://github.com/rizsotto/Bear) is compilation database generator, works great with llvm based tools (aka: clangd).

The JSON compilation database is used in the clang project to provide information on how a single compilation unit is processed. With this, it is easy to re-run the compilation with alternate programs.
Some build system natively supports the generation of JSON compilation database. For projects which does not use such build tool, Bear generates the JSON file during the build process.

```bash
# usage
bear make
```

- [mdformat-gfm](https://github.com/executablebooks/mdformat) is a markdown format utility, some nvim autocommands will use it.

```bash
pip install --user -U mdformat mdformat-gfm
```

### zsh

zsh should be installed using Ansible using this [playbook](./playbook.yml). Enable the role settings the corresponding variable to `true`.

```yml
---
- connection: local
  become: false
  hosts: localhost

  vars:
    setup_zsh: true

  roles:
    - setup-workstation

```
