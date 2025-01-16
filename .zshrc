# custom paths
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/opt/homebrew/opt/ncurses/bin:$PATH"

#postgresql
export PATH="/Library/PostgreSQL/16/bin:$PATH"
export PGDATA="/Library/PostgreSQL/16/data"

# cargo
source "$HOME/.cargo/env"

# llvm
# export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

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

# java
alias ns_java="ns -p zulu maven git"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# bun completions
[ -s "/Users/vincentliu/.bun/_bun" ] && source "/Users/vincentliu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# qt stuff
# Add the Qt directory to the PATH and CMAKE_PREFIX_PATH
export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH:/opt/homebrew/opt/qt@5"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/qt@5/lib/pkgconfig"

# flutter
export PATH="/Users/vincentliu/dev/flutter/bin:$PATH"
export PATH="/Users/vincentliu/.pub-cache/bin:$PATH"

# zsh plugins
# vim mode
ZVM_VI_INSERT_ESCAPE_BINDKEY="jk"
ZVM_INIT_MODE=sourcing
source "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

eval "$(fzf --zsh)"

# syntax highlihting
source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# autosuggestions
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# bindkey '^y' autosuggest-accept

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vincentliu/dev/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vincentliu/dev/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vincentliu/dev/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vincentliu/dev/google-cloud-sdk/completion.zsh.inc'; fi

# some options
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000
setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY            # Don't execute immediately upon history expansion.
setopt HIST_BEEP              # Beep when accessing nonexistent history.

export VISUAL=nvim
export EDITOR="$VISUAL"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
