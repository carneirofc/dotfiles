# General Configurations

These are my dotfiles, always WIP.
I'm slowly moving things to ansible in a way that it is not tight coupled with it. For now, some config files are jinja templates.

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

- A really useful terminal fuzzyfinder https://github.com/junegunn/fzf.

- Unix `cat` replacement with syntax highlight https://github.com/sharkdp/bat.

```
sudo apt install bat fzf
```

- [ʕ·ᴥ·ʔ BEAR](https://github.com/rizsotto/Bear) is compilation database generator, works great with llvm based tools (aka: clangd).

The JSON compilation database is used in the clang project to provide information on how a single compilation unit is processed. With this, it is easy to re-run the compilation with alternate programs.
Some build system natively supports the generation of JSON compilation database. For projects which does not use such build tool, Bear generates the JSON file during the build process.

```bash
sudo apt install bear

# usage
bear make
```

- [mdformat-gfm](https://github.com/executablebooks/mdformat) is a markdown format utility, some nvim autocommands will use it.

```bash
pip install --user -U mdformat mdformat-gfm
```

## zsh

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

## nvim

Ansible WIP.

### build from source

Requirements

```bash
sudo apt install libtool libtool-bin
mkdir /opt/neovim
cd /opt/neovim
git clone https://github.com/neovim/neovim neovim-src
```

### download build

Install steps:

1. Move or create a soft link to `nvim/`

```bash
$ mkdir -v  ~/.config
$ ln -v -r -s ./nvim ~/.config/nvim
```

2. Check the `.vim` and `.lua` files and install external dependencies e.g.: mdformat, ansible-language-server, etc.

1. Clone the required plugins using 'vim-plug'

```
:PlugInstall
```

4. Install `clang-format` and set vim to use the correct binary
   Debian/Ubuntu example

### how-to-use-the-windows-clipboard-from-wsl

# https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl

```
# sudo ln -s "$NEOVIM_WIN_DIR/bin/win32yank.exe" "/usr/local/bin/win32yank.exe"
sudo ln -v -s "$(whereis win32yank.exe |awk '{print $2 }')" "/usr/local/bin/win32yank.exe"
```
