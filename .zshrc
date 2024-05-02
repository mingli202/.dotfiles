# custom paths
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/opt/homebrew/opt/ncurses/bin:$PATH"

# cargo
source "$HOME/.cargo/env"
# export PATH="/Users/vincentliu/.cargo/bin:$PATH"

# llvm
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# dotnet
export PATH="/usr/local/share/dotnet:$PATH"
export DOTNET_ROOT="/usr/local/share/dotnet"

# alias
alias ls="eza -l"
alias lt="eza --tree"

alias v="nvim"

alias fz="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
alias vf="nvim \$(fz)"
alias cdf="cd \$(fd -H -t d | fzf)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vincentliu/dev/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vincentliu/dev/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vincentliu/dev/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vincentliu/dev/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

# bun completions
[ -s "/Users/vincentliu/.bun/_bun" ] && source "/Users/vincentliu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
