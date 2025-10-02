source ~/powerlevel10k/powerlevel10k.zsh-theme
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.zsh_func ]] && source ~/.zsh_func


# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/usr/local/bin
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git history copypath encode64 zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
HISTFILE=~/.zsh_history
