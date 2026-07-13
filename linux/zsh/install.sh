#!/bin/sh
set -ex

ZSH_DOTDIR=~/.config/zsh
ZSH_PATH=/usr/share/zsh
ZSH_PLUGINS=/usr/share/zsh/plugins

mkdir -p -v ${ZSH_PLUGINS}
mkdir -p -v ${ZSH_PATH}
mkdir -v -p ${ZSH_DOTDIR}

USE_LN=True

if [ ! -z ${USE_LN} ]; then
    [ ! -z "${FORCE}" ] && alias cp='ln -f -r -s' || alias cp='ln -r -s'
fi

cp .zshrc ${ZSH_DOTDIR}/.zshrc -v
cp zshenv ~/.zshenv -v

# https://github.com/ryanoasis/nerd-fonts
for f in p10k.zsh zsh-config zsh-prompt; do
    cp ${f} ${ZSH_PATH}/${f} -v
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
