if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.zsh_func ]] && source ~/.zsh_func


export ZSH="$HOME/.oh-my-zsh"

export PATH=$PATH:/usr/local/bin
export PATH="$PATH:/$HOME/Bin/jdk-21/bin"
export PATH="$PATH:/$HOME/Bin/ExifTool"


ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git history copypath encode64 zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
HISTFILE=~/.zsh_history

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh



# opencode
export PATH=/home/moa/.opencode/bin:$PATH

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<
