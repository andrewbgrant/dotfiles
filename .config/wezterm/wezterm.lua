local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- config.color_scheme = "Tokyo Night"
config.colors = {
	-- background = "#121212",
	cursor_bg = "#F8F8F2",
}

config.window_padding = {
	left = 5,
	right = 5,
	top = 0,
	bottom = 0,
}
config.adjust_window_size_when_changing_font_size = false

config.default_cursor_style = "SteadyBlock"

config.enable_tab_bar = false

config.font = wezterm.font_with_fallback({ "Liga SFMono Nerd Font", "Fira Code" })

config.window_background_opacity = 0.70
config.macos_window_background_blur = 30

config.font_size = 14
config.max_fps = 240
config.animation_fps = 240

config.keys = {
	-- Disable Command+T (or Control+T on other systems)
	{ key = "t", mods = "CMD", action = wezterm.action.DisableDefaultAssignment },
	{ key = "t", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
}

return config
