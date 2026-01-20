-- disabled (using tokyo-night)
if true then
  return {
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "tokyonight-night",
      },
    },
  }
end

return {
  -- Configure catppuccin to be transparent
  {
    "catppuccin",
    priority = 1000,
    opts = {
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      transparent_background = true,
      -- Some popups (like Lazy) need explicit override
      custom_highlights = function(colors)
        return {
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          FloatTitle = { bg = "NONE" },
          -- Lazy.nvim specific
          LazyNormal = { bg = "NONE" },
          MasonNormal = { bg = "NONE" },
          Pmenu = { bg = "NONE" }, -- Autocomplete menu
          PmenuSel = { bg = colors.surface1, fg = "NONE" },
          TelescopeNormal = { bg = "NONE" },
          TelescopeBorder = { bg = "NONE" },
        }
      end,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        snacks = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  -- Configure LazyVim to load catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
}
