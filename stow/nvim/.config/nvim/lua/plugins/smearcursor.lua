return {
  "sphamba/smear-cursor.nvim",
  opts = {
    -- Tokyonight accent colors:
    -- You can use "#7aa2f7" (Blue - default cursor color in tokyonight)
    -- Or "#bb9af7" (Purple), or "#c0caf5" (Main text color)
    cursor_color = "#c0caf5",

    -- Make the smear feel snappy and fluid, not sluggish
    stiffness = 0.3,
    trailing_stiffness = 0.2,
    damping = 0.8,

    -- Control how the trail looks
    distance_stop_animating = 0.05,

    -- Keep particles disabled for a cleaner transparent look
    particles_enabled = false,

    smear_between_neighbor_lines = true,

    -- The core hacks to make it look right over text
    never_draw_over_target = true,
    hide_target_hack = true,
  },
}
