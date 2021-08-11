#!/bin/sh
set -eu

ZSH_DOTDIR=~/.config/zsh/
ZSH_PATH=/usr/share/zsh
ZSH_PLUGINS=/usr/share/zsh/plugins

mkdir -p -v ${ZSH_PLUGINS}
mkdir -p -v ${ZSH_PATH}
mkdir -v -p ${ZSH_DOTDIR}

cp -v zshrc ${ZSH_DOTDIR}/.zshrc
cp -v zshenv ~/.zshenv

# https://github.com/ryanoasis/nerd-fonts
for f in p10k.zsh zsh-config zsh-prompt; do
    sudo cp -v ${f} ${ZSH_PATH}/${f}
done

set +e
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_PLUGINS}/zsh-syntax-highlighting 2>/dev/null \
    || cd ${ZSH_PLUGINS}/zsh-syntax-highlighting && sudo git pull && cd -

sudo git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_PLUGINS}/zsh-history-substring-search 2>/dev/null \
    || cd ${ZSH_PLUGINS}/zsh-history-substring-search && sudo git pull && cd -

sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_PLUGINS}/zsh-autosuggestions 2>/dev/null \
    || cd ${ZSH_PLUGINS}/zsh-autosuggestions && sudo git pull && cd -

sudo git clone https://github.com/romkatv/powerlevel10k /usr/share/zsh-theme-powerlevel10k 2>/dev/null \
    || cd /usr/share/zsh-theme-powerlevel10k && sudo git pull && cd -

set -e
