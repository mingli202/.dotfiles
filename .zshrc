# alias
alias ..="cd .."
alias ls="eza --group-directories-first -F --icons auto"
alias ll="eza -l --group-directories-first -F --icons -h --git"
alias lt="eza --tree --git-ignore"
alias l="ls"

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

alias ct="TERM=screen-256color ~/dev/Codes/C/ncurses/tetris/bin/tetris"

alias pn="pnpm"
alias px="pnpx"

alias g="git"
alias gm="git add . && git commit -m"
alias gz="git add . && git cz"
alias gp="git push"

alias ttt="typing-test-tui"
alias tt="typing_test"

alias cc="codex --yolo"
alias oc="opencode"

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd <"$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

export VISUAL="nvim"
export EDITOR="nvim"

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

# env
# source ~/.env

# zsh plugins
# vim mode
ZVM_VI_INSERT_ESCAPE_BINDKEY="jk"
ZVM_INIT_MODE=sourcing
source "$HOME/.local/state/nix/profiles/profile/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# autosuggestions
source "$HOME/.local/state/nix/profiles/profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^y' autosuggest-accept

# syntax highlihting
source "$HOME/.local/state/nix/profiles/profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# evals
if command -v starship >/dev/null 2>&1; then
	eval "$(starship init zsh)"
fi
if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init --cmd cd zsh)"
fi
if command -v fzf >/dev/null 2>&1; then
	eval "$(fzf --zsh)"
fi

# custom paths
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/ncurses/bin:$PATH"
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

typeset -U path PATH
