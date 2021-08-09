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
    cp -v ${f} ${ZSH_PATH}/${f}
done

set +e
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_PLUGINS}/zsh-syntax-highlighting \
    || cd ${ZSH_PLUGINS}/zsh-syntax-highlighting && git pull && cd -

git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_PLUGINS}/zsh-history-substring-search \
    || cd ${ZSH_PLUGINS}/zsh-history-substring-search && git pull && cd -

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_PLUGINS}/zsh-autosuggestions \
    || cd ${ZSH_PLUGINS}/zsh-autosuggestions && git pull && cd -

git clone https://github.com/romkatv/powerlevel10k /usr/share/zsh-theme-powerlevel10k \
    || cd /usr/share/zsh-theme-powerlevel10k && git pull && cd -

set -e
