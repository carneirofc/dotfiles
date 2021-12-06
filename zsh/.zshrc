# Enable Powerlevel10k instant prompt.
# Should stay close to the top of ~/.config/zsh//.zshrc.
# Initialization code that may require console input
# (password prompts, [y/n] confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"

# Source zsh-configuration
if [[ -e /usr/share/zsh/zsh-config ]]; then
  source /usr/share/zsh/zsh-config
fi

# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/zsh-prompt ]]; then
  source /usr/share/zsh/zsh-prompt
fi

export PATH=/opt/node/node-v16.13.0-linux-x64/bin/:${PATH}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/carneirofc/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/carneirofc/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/carneirofc/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/carneirofc/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

