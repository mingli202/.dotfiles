# custom paths
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/opt/homebrew/opt/ncurses/bin:$PATH"

# llvm
export PATH="/opt/homebrew/Cellar/llvm/17.0.6_1/bin:$PATH"

# dotnet
export PATH="/usr/local/share/dotnet:$PATH"
export DOTNET_ROOT="/usr/local/share/dotnet"

alias ls="eza"
alias lt="eza --tree"

alias pip="pip3"
alias v="nvim"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vincentliu/dev/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vincentliu/dev/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vincentliu/dev/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vincentliu/dev/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
