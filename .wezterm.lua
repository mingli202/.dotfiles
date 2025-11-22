local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("VictorMono Nerd Font", { weight = "DemiBold" })

config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.font_rules = {
	{
		italic = true,
		font = wezterm.font("VictorMono Nerd Font", { weight = "DemiBold", style = "Oblique" }),
	},
}

config.font_size = 14

config.line_height = 1
config.cell_width = 1
config.enable_tab_bar = false

config.window_background_opacity = 0.9
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"

config.color_scheme = "GruvboxDark"

config.use_ime = false -- macOS only
config.enable_kitty_keyboard = true

return config
