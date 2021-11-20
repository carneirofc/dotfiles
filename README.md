# General Configurations

## nvim
Install steps:

1) Move or create a soft link to `nvim/`
2) Clone the required plugins using 'vim-plug'

```
:PlugInstall
```
3) Compile 'YouCompleteMe'
```bash
cd nvim/plugged/YouCompleteMe/
CC=clang-12 CXX=clang++-12 python ./install.py --clangd-completer --verbose
```
4) Install `clang-format` and set vim to use the correct binary
Debian/Ubuntu example
```
# apt install clang-format-12 -y
$ sed -i 's|let g:clang_format_path = "clang-format.*"|let g:clang_format_path = "clang-format-12"|g' ./nvim/init.vim
```
