local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("SauceCodePro Nerd Font")
config.font_size = 14
config.enable_tab_bar = false

config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
config.window_decorations = "RESIZE"

config.color_scheme = "GruvboxDark"

return config
