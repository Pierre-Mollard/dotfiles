hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

hl.config({
    general = {
        layout = "dwindle",
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
        col = {
            -- Match the cyan accent and muted inactive border in tmux.
            active_border = "rgb(2ac3de)",
            inactive_border = "rgb(565f89)",
        },
    },
    decoration = {
        rounding = 0,
    },
    input = {
        natural_scroll = true,
        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
end)

local terminal = "ghostty"
hl.env("TERMINAL", terminal)

local mod = "SUPER"

hl.bind(mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exit())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))

for _, direction in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(mod .. " + " .. direction, hl.dsp.focus({ direction = direction }))
end

for workspace = 1, 10 do
    local key = workspace % 10 -- Use 0 for workspace 10.
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -c backlight set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -c backlight -n 1 set 5%-"), { locked = true, repeating = true })
