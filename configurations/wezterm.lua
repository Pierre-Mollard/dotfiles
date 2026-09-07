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
local schemes = wezterm.color.get_builtin_schemes()
local tokyo_night = schemes["Tokyo Night"]
tokyo_night.tab_bar = {
	background = "#12131c",

	active_tab = {
		bg_color = "#1a1b26",
		fg_color = "#c0caf5",
		intensity = "Bold",
	},

	inactive_tab = {
		bg_color = "#12131c",
		fg_color = "#565f89",
	},

	inactive_tab_hover = {
		bg_color = "#1f2335",
		fg_color = "#a9b1d6",
	},

	new_tab = {
		bg_color = "#12131c",
		fg_color = "#565f89",
	},

	new_tab_hover = {
		bg_color = "#1f2335",
		fg_color = "#c0caf5",
	},
}

config.color_schemes = {
	["Tokyo Night Dark Tab Bar"] = tokyo_night,
}

config.color_scheme = "Tokyo Night Dark Tab Bar"

-- more transparent, but keep blur
--config.window_background_opacity = 0
--config.win32_system_backdrop = "Mica"
config.window_background_opacity = 1.0
config.win32_system_backdrop = "Disable"

config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.integrated_title_button_style = "Windows"
config.integrated_title_button_alignment = "Right"
config.integrated_title_buttons = {
	"Hide",
	"Maximize",
	"Close",
}

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
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

config.front_end = "OpenGL"
config.animation_fps = 120
config.max_fps = 120
config.prefer_to_spawn_tabs = true

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local index = tab.tab_index + 1

	-- A single tab: leave the left area visually empty.
	if #tabs == 1 then
		return ""
	end

	-- Multiple tabs: show compact numbered titles.
	local title = tab.active_pane.title

	if #title > max_width - 6 then
		title = wezterm.truncate_right(title, max_width - 6)
	end

	return string.format(" %d: %s ", index, title)
end)

return config

-- TODO: make the theme switch?
--
-- TODO: keybinding toggle transparent
-- TODO: keybinding toggle text size
-- TODO: adust paddings
-- TODO: test the tabbar bg and maybe remove/change it
