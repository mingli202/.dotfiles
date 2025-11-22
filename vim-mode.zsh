# vi mode
CURSOR_BLOCK='\e[2 q'
CURSOR_LINE='\e[6 q'
export VI_MODE_SET_CURSOR=true

bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins '^P' up-history
bindkey -M viins '^N' down-history
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^W' backward-kill-word

function _set_cursor_shape() {
	local shape="$1"
	if [[ -n "$TMUX" ]]; then
		# tmux requires special wrapping of escape sequences
		echo -ne "\ePtmux;\e${shape}\e\\"
	else
		echo -ne "${shape}"
	fi
}

# Change cursor shape when vi mode changes
function zle-keymap-select() {
	case $KEYMAP in
	vicmd)
		# Normal mode: block cursor
		_set_cursor_shape "$CURSOR_BLOCK"
		MODE_INDICATOR="❮N❯"
		;;
	viins | main)
		# Insert mode: line/bar cursor
		_set_cursor_shape "$CURSOR_LINE"
		MODE_INDICATOR="❮I❯"
		;;
	esac
	zle && zle reset-prompt

}

function zle-line-init() {
	# Start in insert mode with line cursor
	zle -K viins
	_set_cursor_shape "$CURSOR_LINE"
}

function zle-line-finish() {
	_set_cursor_shape "$CURSOR_BLOCK"
}

# Reset cursor before each new prompt
function precmd() {
	# Force cursor refresh based on current mode
	_set_cursor_shape "$CURSOR_LINE"
}

# Create zle widgets
zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

bindkey '^[[I' zle-keymap-select
bindkey -M vicmd '^[[I' zle-keymap-select
bindkey -M viins '^[[I' zle-keymap-select

_set_cursor_shape "$CURSOR_LINE"
