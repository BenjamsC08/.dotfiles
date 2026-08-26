if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/bin"

[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.zsh_func ]] && source ~/.zsh_func

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git history copypath encode64 zsh-autosuggestions)

source "$ZSH/oh-my-zsh.sh"

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Per-machine overrides (PATH, extra aliases). Not tracked.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
