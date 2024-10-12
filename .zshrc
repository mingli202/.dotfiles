# custom paths
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/opt/homebrew/opt/ncurses/bin:$PATH"

#postgresql
export PATH="/Library/PostgreSQL/16/bin:$PATH"
export PGDATA="/Library/PostgreSQL/16/data"

# cargo
source "$HOME/.cargo/env"

# alias
alias ls="eza --group-directories-first -F --icons"
alias ll="eza -l --group-directories-first -F --icons -h --git"
alias lt="eza --tree --git-ignore"

alias v="nvim"
alias nv="neovide --frame buttonless"
alias t="tmux"

alias fz="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
alias vf="nvim \$(fz)"
alias nvf="neovide --frame none \$(fz)"
alias cdf="cd \$(fd -H -t d | fzf)"

alias lg="lazygit"

alias cl="clear"
alias e="exit"

alias ns="nix-shell --command zsh"
alias ncg="nix-collect-garbage"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

# bun completions
[ -s "/Users/vincentliu/.bun/_bun" ] && source "/Users/vincentliu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# zsh plugins
source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vincentliu/dev/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vincentliu/dev/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vincentliu/dev/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vincentliu/dev/google-cloud-sdk/completion.zsh.inc'; fi
