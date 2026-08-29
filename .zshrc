# alias
alias ..="cd .."
alias cdf="cd \$(fd -H -t d | fzf)"
alias e="exit"

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd <"$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# env
# source ~/.env

# custom paths
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/opt/homebrew/opt/ncurses/bin:$PATH"

export ERG_PATH="~/.erg"

#postgresql
export PATH="/Library/PostgreSQL/16/bin:$PATH"
export PGDATA="/Library/PostgreSQL/16/data"

# csharp
export PATH="$PATH:/Users/vincentliu/.dotnet/tools"

# bun
export PATH="/opt/homebrew/sbin:$PATH"

# dotnet
export DOTNET_ROOT="/usr/local/share/dotnet"

# other

# java

# zsh plugins
# vim mode
ZVM_VI_INSERT_ESCAPE_BINDKEY="jk"
ZVM_INIT_MODE=sourcing
source "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# syntax highlihting

# autosuggestions
# source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^y' autosuggest-accept

# evals
if command -v starship >/dev/null 2>1; then
	eval "$(starship init zsh)"
fi
if command -v zoxide >/dev/null 2>1; then
	eval "$(zoxide init --cmd cd zsh)"
fi
if command -v fzf >/dev/null 2>1; then
	eval "$(fzf --zsh)"
fi
# eval "$(thefuck --alias)"

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
