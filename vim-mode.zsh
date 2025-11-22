# vi mode
CURSOR_BLOCK='\e[2 q'
CURSOR_LINE='\e[6 q'
KEYTIMEOUT=10
export VI_MODE_SET_CURSOR=true

bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins '^P' up-history
bindkey -M viins '^N' down-history
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^W' backward-kill-word

# Lightweight Vi-Mode Cursor Shape Logic
# Extracted/Adapted from zsh-vi-mode

# 1. Define Cursor Shapes
# \e[2 q  -> Block (Normal Mode)
# \e[6 q  -> Beam/Line (Insert Mode)
# \e[0 q  -> User Default (On finish)
_fix_cursor_shape() {
	local cursor_shape

	# Check the current keymap to determine mode
	if [[ ${KEYMAP} == 'vicmd' ]]; then
		# Normal Mode -> Block
		cursor_shape='\e[2 q'
		MODE_INDICATOR="❮N❯"
	else
		# Insert/Main Mode -> Beam (Line)
		cursor_shape='\e[6 q'
		MODE_INDICATOR="❮I❯"
	fi

	# Output the escape sequence to change the cursor
	print -n -- "$cursor_shape"
	zle reset-prompt
}

# 2. Ensure cursor is reset when the line finishes (executing a command)
_reset_cursor_shape() {
	print -n -- '\e[0 q'
}

# 3. The Hook Functions
# Called when the keymap changes (e.g. typing <ESC>)
function zle-keymap-select {
	_fix_cursor_shape
	zle redisplay
}

# Called when the line editor initializes (new prompt)
function zle-line-init {
	# Default to insert mode behavior on init
	zle -K viins
	_fix_cursor_shape
}

# Called just before Zsh redraws the line
# THIS IS THE CRITICAL PART FOR TMUX
function zle-line-pre-redraw {
	# Only run if inside TMUX to save cycles, though it's safe otherwise.
	if [[ -n $TMUX && $PENDING -eq 0 ]]; then
		_fix_cursor_shape
	fi
}

# 4. Register the Hooks
zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-pre-redraw
zle -N zle-line-finish _reset_cursor_shape

# 5. Enable Vi Mode (if not already done elsewhere in your config)
bindkey -v
