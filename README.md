# General Configurations

Install using ansible:
```command
ansible-playbook playbook.yml
```
If ansible is having troubles finding some packages, try specifying the interpreter.
```
ansible-playbook playbook.yml -K  -e 'ansible_python_interpreter=/usr/bin/python3.8'
```

Terminal utilities:

```
sudo apt install bat fzf
```

## Bear
(ʕ·ᴥ·ʔ Build EAR)[https://github.com/rizsotto/Bear]
Bear is a tool that generates a compilation database for clang tooling.

The JSON compilation database is used in the clang project to provide information on how a single compilation unit is processed. With this, it is easy to re-run the compilation with alternate programs.

Some build system natively supports the generation of JSON compilation database. For projects which does not use such build tool, Bear generates the JSON file during the build process.
```bash
sudo apt install bear

# usage
bear make
```
## zsh
```
$ cd zsh && ./install.sh
```

## nvim

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

1) Move or create a soft link to `nvim/`
```bash
$ mkdir -v  ~/.config
$ ln -v -r -s ./nvim ~/.config/nvim
```

2) Clone the required plugins using 'vim-plug'

```
:PlugInstall
```

3) Compile 'YouCompleteMe'
Optionally install c/cpp compilers and tools (llvm)
```
# apt install llvm-12 llvm-12-doc clang-12 clang-tidy-12 clang-format-12 clangd-12 lld-12 lldb-12
$ cd nvim/plugged/YouCompleteMe/
$ CC=clang-12 CXX=clang++-12 python ./install.py --clangd-completer --verbose
```

4) Install `clang-format` and set vim to use the correct binary
Debian/Ubuntu example
```
# apt install clang-format-12 -y
$ sed -i 's|let g:clang_format_path = "clang-format.*"|let g:clang_format_path = "clang-format-12"|g' ./nvim/init.vim
```

### how-to-use-the-windows-clipboard-from-wsl
 # https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
```
# sudo ln -s "$NEOVIM_WIN_DIR/bin/win32yank.exe" "/usr/local/bin/win32yank.exe"
sudo ln -v -s "$(whereis win32yank.exe |awk '{print $2 }')" "/usr/local/bin/win32yank.exe"
```
