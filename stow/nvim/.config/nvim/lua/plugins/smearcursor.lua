return {
  "sphamba/smear-cursor.nvim",
  opts = {
    -- Helper Tokyonight accent colors:
    -- #7aa2f7 : Default cursor color in tokyonight
    -- #c0caf5 : Main text color
    -- #bb9af7 : Purple
    -- #3b4261 : Background
    -- because with wezterm the actual color is the content
    -- it is pointing at, so this will only be used for the trailing animation
    cursor_color = "#c0caf5",

    -- Make the smear feel snappy and fluid, not sluggish
    stiffness = 0.3,
    trailing_stiffness = 0.2,
    damping = 0.8,
    distance_stop_animating = 0.05,

    -- Keep particles disabled for a cleaner transparent look
    particles_enabled = false,
    smear_between_neighbor_lines = true,

    -- The core hacks to make it look right over text
    never_draw_over_target = true,
    hide_target_hack = true,
    legacy_computing_symbols_support = true,
  },
}
