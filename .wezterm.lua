local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("SauceCodePro Nerd Font", { weight = "Regular" })
config.font_size = 14

config.color_scheme = "GitHub Dark"
-- config.colors = {
-- 	background = "#0b0b0f",
-- }

config.window_background_opacity = 0.8
config.macos_window_background_blur = 30

config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"

return config
