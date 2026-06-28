local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config.wsl_domains = {
	{
		name = "WSL:Ubuntu",
		distribution = "Ubuntu",
		default_cwd = "~",
	},
}

config.default_domain = "WSL:Ubuntu"

config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"Symbols Nerd Font Mono",
	"Nerd Font Symbols",
})

config.font_size = 13.5

config.color_scheme = "Tokyo Night"

-- more transparent, but keep blur
config.window_background_opacity = 0
config.win32_system_backdrop = "Mica"

config.window_decorations = "TITLE | RESIZE"
config.window_close_confirmation = "NeverPrompt"

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- a bit more breathing room inside the terminal
config.window_padding = {
	left = 8,
	right = 8,
	top = 6,
	bottom = 6,
}

config.keys = {
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentTab({ confirm = false }),
	},
}

return config
