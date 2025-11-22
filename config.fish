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

alias ctetris="TERM=screen-256color ~/dev/Codes/C/ncurses/tetris/bin/tetris"

alias pn="pnpm"
alias px="pnpx"

alias mimi="kitten ssh -i ~/.ssh/mcgill_mimi_server 'mliu8@mimi.cs.mcgill.ca'"

alias g="git"
alias gm="git add . && git commit -m"
alias gz="git add . && git cz"
alias gp="git push"

# paths
fish_add_path "/opt/homebrew/bin"

# cli utils
starship init fish | source
zoxide init --cmd cd fish | source
fzf --fish | source
