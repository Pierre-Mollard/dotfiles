local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

local TERMINAL_BG = "#1a1b26"
local FLAT_TAB_BAR_BG = TERMINAL_BG
local DARK_TAB_BAR_BG = "#12131c"
local TAB_BAR_HOVER_BG = "#1f2335"
local TAB_ACTIVE_FG = "#c0caf5"
local TAB_INACTIVE_FG = "#565f89"
local STATUS_FG = "#7aa2f7"

local FLAT_SCHEME = "Tokyo Night Flat Tab Bar"
local DARK_SCHEME = "Tokyo Night Dark Tab Bar"

-- WSL
config.wsl_domains = {
	{
		name = "WSL:Ubuntu",
		distribution = "Ubuntu",
		default_cwd = "~",
	},
}
config.default_domain = "WSL:Ubuntu"

-- Font
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"Symbols Nerd Font Mono",
	"Nerd Font Symbols",
})
config.font_size = 13.5

-- Two Tokyo Night variants. Only the WezTerm tab-bar colors differ.
-- Each call returns an independent mutable scheme table.
local flat_scheme = wezterm.color.get_builtin_schemes()["Tokyo Night"]
local dark_scheme = wezterm.color.get_builtin_schemes()["Tokyo Night"]

-- Flat mode: the tab bar uses the exact terminal background, so it visually
-- merges into Tokyo Night instead of looking like a separate header.
flat_scheme.tab_bar = {
	background = FLAT_TAB_BAR_BG,

	active_tab = {
		bg_color = FLAT_TAB_BAR_BG,
		fg_color = TAB_ACTIVE_FG,
		intensity = "Bold",
	},

	inactive_tab = {
		bg_color = FLAT_TAB_BAR_BG,
		fg_color = TAB_INACTIVE_FG,
	},

	inactive_tab_hover = {
		bg_color = TAB_BAR_HOVER_BG,
		fg_color = "#a9b1d6",
	},

	new_tab = {
		bg_color = FLAT_TAB_BAR_BG,
		fg_color = TAB_INACTIVE_FG,
	},

	new_tab_hover = {
		bg_color = TAB_BAR_HOVER_BG,
		fg_color = TAB_ACTIVE_FG,
	},
}

-- Dark mode: a separate, darker top strip.
dark_scheme.tab_bar = {
	background = DARK_TAB_BAR_BG,

	active_tab = {
		bg_color = DARK_TAB_BAR_BG,
		fg_color = TAB_ACTIVE_FG,
		intensity = "Bold",
	},

	inactive_tab = {
		bg_color = DARK_TAB_BAR_BG,
		fg_color = TAB_INACTIVE_FG,
	},

	inactive_tab_hover = {
		bg_color = TAB_BAR_HOVER_BG,
		fg_color = "#a9b1d6",
	},

	new_tab = {
		bg_color = DARK_TAB_BAR_BG,
		fg_color = TAB_INACTIVE_FG,
	},

	new_tab_hover = {
		bg_color = TAB_BAR_HOVER_BG,
		fg_color = TAB_ACTIVE_FG,
	},
}

config.color_schemes = {
	[FLAT_SCHEME] = flat_scheme,
	[DARK_SCHEME] = dark_scheme,
}

-- Default scheme for new WezTerm windows.
config.color_scheme = FLAT_SCHEME

-- Windows 10: Acrylic is the compatible blurred transparency effect.
-- This is the default appearance. Ctrl+Shift+T toggles the current window
-- between this mode and opaque mode.
config.window_background_opacity = 0.85
config.win32_system_backdrop = "Acrylic"
config.win32_acrylic_accent_color = TERMINAL_BG

-- Integrated Windows controls in the WezTerm tab bar.
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.integrated_title_button_style = "Windows"
config.integrated_title_button_alignment = "Right"
config.integrated_title_buttons = {
	"Hide",
	"Maximize",
	"Close",
}

-- Keep the bar visible so the integrated window controls remain available.
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false

config.window_padding = {
	left = 8,
	right = 8,
	top = 8,
	bottom = 8,
}

-- OpenGL avoids the incorrect color rendering seen with WebGPU on this system.
config.front_end = "OpenGL"
config.animation_fps = 120
config.max_fps = 120

-- New tabs remain in the active WSL domain.
config.prefer_to_spawn_tabs = true

-- Battery state does not need frequent polling.
config.status_update_interval = 10000

-- Toggle transparency for only the active WezTerm window.
wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local effective = window:effective_config()
	local opacity = effective.window_background_opacity or 1.0

	if opacity < 1.0 then
		overrides.window_background_opacity = 1.0
		overrides.win32_system_backdrop = "Disable"
		overrides.win32_acrylic_accent_color = nil
	else
		overrides.window_background_opacity = 0.85
		overrides.win32_system_backdrop = "Acrylic"
		overrides.win32_acrylic_accent_color = TERMINAL_BG
	end

	window:set_config_overrides(overrides)
end)

-- Toggle the tab-bar style for only the active WezTerm window.
wezterm.on("toggle-tab-bar-theme", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local current_scheme = overrides.color_scheme or window:effective_config().color_scheme

	if current_scheme == DARK_SCHEME then
		overrides.color_scheme = FLAT_SCHEME
	else
		overrides.color_scheme = DARK_SCHEME
	end

	window:set_config_overrides(overrides)
end)

config.keys = {
	-- WezTerm UI/window actions
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentTab({ confirm = false }),
	},
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = act.EmitEvent("toggle-opacity"),
	},
	{
		key = "b",
		mods = "CTRL|SHIFT",
		action = act.EmitEvent("toggle-tab-bar-theme"),
	},
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = act.ReloadConfiguration,
	},

	-- Native font zoom: faster than managing font-size config overrides.
	{
		key = "+",
		mods = "CTRL",
		action = act.IncreaseFontSize,
	},
	{
		key = "=",
		mods = "CTRL",
		action = act.IncreaseFontSize,
	},
	{
		key = "-",
		mods = "CTRL",
		action = act.DecreaseFontSize,
	},
	{
		key = "0",
		mods = "CTRL",
		action = act.ResetFontSize,
	},

	-- Clipboard: plain Ctrl+C remains SIGINT for tmux, the shell, and Neovim.
	{
		key = "v",
		mods = "CTRL",
		action = act.PasteFrom("Clipboard"),
	},
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = act.CopyTo("Clipboard"),
	},
}

-- With one tab, leave the bar visually empty but retain integrated controls.
-- With multiple tabs, show compact numbered titles.
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	if #tabs == 1 then
		return ""
	end

	local title = tab.active_pane.title
	local prefix = string.format(" %d: ", tab.tab_index + 1)
	local available = math.max(1, max_width - #prefix - 1)

	title = wezterm.truncate_right(title, available)
	return prefix .. title .. " "
end)

-- Keep only GUI/window-level information here; tmux owns pane/session status.
wezterm.on("update-status", function(window, pane)
	local effective = window:effective_config()
	local active_scheme = effective.color_scheme
	local tab_bar_bg = active_scheme == DARK_SCHEME and DARK_TAB_BAR_BG or FLAT_TAB_BAR_BG
	local cells = {}

	for _, battery in ipairs(wezterm.battery_info()) do
		local icon = "󰁹"

		if battery.state == "Charging" then
			icon = "󰂄"
		elseif battery.state_of_charge <= 0.15 then
			icon = "󰂃"
		elseif battery.state_of_charge <= 0.35 then
			icon = "󰁺"
		elseif battery.state_of_charge <= 0.60 then
			icon = "󰁽"
		elseif battery.state_of_charge <= 0.85 then
			icon = "󰁿"
		end

		table.insert(cells, string.format("%s %d%%", icon, math.floor(battery.state_of_charge * 100)))
	end

	window:set_right_status(wezterm.format({
		{ Background = { Color = tab_bar_bg } },
		{ Foreground = { Color = STATUS_FG } },
		{ Text = "  " .. table.concat(cells, "   ") .. "  " },
	}))
end)

return config
