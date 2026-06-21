local themes = {
  catppuccin = true,
  tokyonight = false,
  rose_pine = false,
  cyberdream = false,
  kanagawa = false,
  everforest = false,
  gruvbox = false,
  gruvbox_material = false,
  neosolarized = false,
}

vim.g.transparent_enabled = true

local function current_colorscheme()
  return themes.catppuccin and "catppuccin-frappe"
    or themes.tokyonight and "tokyonight-night"
    or themes.rose_pine and "rose-pine"
    or themes.cyberdream and "cyberdream"
    or themes.kanagawa and "kanagawa-wave"
    or themes.everforest and "everforest"
    or themes.gruvbox and "gruvbox"
    or themes.gruvbox_material and "gruvbox-material"
    or themes.neosolarized and "NeoSolarized"
    or "tokyonight-night"
end

local function bg_none_if_transparent()
  return vim.g.transparent_enabled and "NONE" or nil
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      transparent_background = vim.g.transparent_enabled,
      term_colors = true,
      no_italic = false,
      no_bold = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        aerial = true,
        alpha = true,
        blink_cmp = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        gitsigns = true,
        grug_far = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      custom_highlights = function(colors)
        local transparent = vim.g.transparent_enabled
        return {
          Normal = { bg = transparent and "NONE" or colors.base },
          NormalNC = { bg = transparent and "NONE" or colors.base },
          SignColumn = { bg = transparent and "NONE" or colors.base },
          EndOfBuffer = { bg = transparent and "NONE" or colors.base },
          LineNr = { bg = transparent and "NONE" or colors.base },
          CursorLineNr = { bg = transparent and "NONE" or colors.base },
          NormalFloat = { bg = transparent and "NONE" or colors.mantle },
          FloatBorder = { bg = transparent and "NONE" or colors.mantle },
          FloatTitle = { bg = transparent and "NONE" or colors.mantle },
          CursorLine = { bg = transparent and "NONE" or colors.surface0 },
          Pmenu = { bg = transparent and "NONE" or colors.mantle },
          PmenuSel = { bg = colors.surface1, fg = colors.text },
          StatusLine = { bg = transparent and "NONE" or colors.mantle },
          StatusLineNC = { bg = transparent and "NONE" or colors.mantle },
          WinSeparator = { bg = "NONE" },
          VertSplit = { bg = "NONE" },
          FoldColumn = { bg = transparent and "NONE" or colors.base },
          LazyNormal = { bg = transparent and "NONE" or colors.base },
          MasonNormal = { bg = transparent and "NONE" or colors.base },
          TelescopeNormal = { bg = transparent and "NONE" or colors.base },
          TelescopeBorder = { bg = transparent and "NONE" or colors.base },
          TelescopePromptNormal = { bg = transparent and "NONE" or colors.mantle },
          TelescopePromptBorder = { bg = transparent and "NONE" or colors.mantle },
          TelescopeResultsNormal = { bg = transparent and "NONE" or colors.base },
          TelescopeResultsBorder = { bg = transparent and "NONE" or colors.base },
          TelescopePreviewNormal = { bg = transparent and "NONE" or colors.base },
          TelescopePreviewBorder = { bg = transparent and "NONE" or colors.base },
        }
      end,
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent = vim.g.transparent_enabled,
        styles = {
          sidebars = vim.g.transparent_enabled and "transparent" or "dark",
          floats = vim.g.transparent_enabled and "transparent" or "dark",
        },
        on_highlights = function(hl, c)
          local transparent = vim.g.transparent_enabled
          hl.Normal = { bg = transparent and "NONE" or c.bg }
          hl.NormalNC = { bg = transparent and "NONE" or c.bg }
          hl.SignColumn = { bg = transparent and "NONE" or c.bg }
          hl.EndOfBuffer = { bg = transparent and "NONE" or c.bg }
          hl.LineNr = { bg = transparent and "NONE" or c.bg }
          hl.CursorLineNr = { bg = transparent and "NONE" or c.bg }
          hl.NormalFloat = { bg = transparent and "NONE" or c.bg_dark }
          hl.FloatBorder = { bg = transparent and "NONE" or c.bg_dark }
          hl.FloatTitle = { bg = transparent and "NONE" or c.bg_dark }
          hl.CursorLine = { bg = transparent and "NONE" or c.bg_highlight }
          hl.Pmenu = { bg = transparent and "NONE" or c.bg_dark }
          hl.PmenuSel = { bg = c.bg_highlight, fg = c.fg }
          hl.StatusLine = { bg = transparent and "NONE" or c.bg_statusline }
          hl.StatusLineNC = { bg = transparent and "NONE" or c.bg_statusline }
          hl.WinSeparator = { bg = "NONE" }
          hl.VertSplit = { bg = "NONE" }
          hl.FoldColumn = { bg = transparent and "NONE" or c.bg }
          hl.LazyNormal = { bg = transparent and "NONE" or c.bg }
          hl.MasonNormal = { bg = transparent and "NONE" or c.bg }
          hl.TelescopeNormal = { bg = transparent and "NONE" or c.bg_dark }
          hl.TelescopeBorder = { bg = transparent and "NONE" or c.bg_dark }
        end,
      }
    end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
    opts = function()
      local transparent = vim.g.transparent_enabled
      return {
        styles = {
          transparency = transparent,
        },
        highlight_groups = {
          Normal = { bg = transparent and "NONE" or "base" },
          NormalNC = { bg = transparent and "NONE" or "base" },
          SignColumn = { bg = transparent and "NONE" or "base" },
          EndOfBuffer = { bg = transparent and "NONE" or "base" },
          LineNr = { bg = transparent and "NONE" or "base" },
          CursorLineNr = { bg = transparent and "NONE" or "base" },
          NormalFloat = { bg = transparent and "NONE" or "surface" },
          FloatBorder = { bg = transparent and "NONE" or "surface" },
          FloatTitle = { bg = transparent and "NONE" or "surface" },
          CursorLine = { bg = transparent and "NONE" or "highlight_med" },
          Pmenu = { bg = transparent and "NONE" or "surface" },
          StatusLine = { bg = transparent and "NONE" or "surface" },
          StatusLineNC = { bg = transparent and "NONE" or "surface" },
          WinSeparator = { bg = "NONE" },
          VertSplit = { bg = "NONE" },
          FoldColumn = { bg = transparent and "NONE" or "base" },
          TelescopeNormal = { bg = transparent and "NONE" or "base" },
          TelescopeBorder = { bg = transparent and "NONE" or "base" },
        },
      }
    end,
  },

  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      local transparent = vim.g.transparent_enabled
      return {
        transparent = transparent,
        italic_comments = true,
        hide_fillchars = true,
        borderless_pickers = false,
        terminal_colors = true,
        highlights = {
          Normal = { bg = transparent and "NONE" or nil },
          NormalNC = { bg = transparent and "NONE" or nil },
          SignColumn = { bg = transparent and "NONE" or nil },
          EndOfBuffer = { bg = transparent and "NONE" or nil },
          LineNr = { bg = transparent and "NONE" or nil },
          CursorLineNr = { bg = transparent and "NONE" or nil },
          NormalFloat = { bg = transparent and "NONE" or nil },
          FloatBorder = { bg = transparent and "NONE" or nil },
          FloatTitle = { bg = transparent and "NONE" or nil },
          CursorLine = { bg = transparent and "NONE" or nil },
          Pmenu = { bg = transparent and "NONE" or nil },
          StatusLine = { bg = transparent and "NONE" or nil },
          StatusLineNC = { bg = transparent and "NONE" or nil },
          WinSeparator = { bg = "NONE" },
          VertSplit = { bg = "NONE" },
          FoldColumn = { bg = transparent and "NONE" or nil },
          TelescopeNormal = { bg = transparent and "NONE" or nil },
          TelescopeBorder = { bg = transparent and "NONE" or nil },
        },
      }
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      local transparent = vim.g.transparent_enabled
      return {
        transparent = transparent,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = transparent and "none" or nil,
                float = { bg = transparent and "none" or nil },
              },
            },
          },
        },
        overrides = function()
          return {
            Normal = { bg = transparent and "NONE" or nil },
            NormalNC = { bg = transparent and "NONE" or nil },
            SignColumn = { bg = transparent and "NONE" or nil },
            EndOfBuffer = { bg = transparent and "NONE" or nil },
            LineNr = { bg = transparent and "NONE" or nil },
            CursorLineNr = { bg = transparent and "NONE" or nil },
            NormalFloat = { bg = transparent and "NONE" or nil },
            FloatBorder = { bg = transparent and "NONE" or nil },
            FloatTitle = { bg = transparent and "NONE" or nil },
            CursorLine = { bg = transparent and "NONE" or nil },
            Pmenu = { bg = transparent and "NONE" or nil },
            StatusLine = { bg = transparent and "NONE" or nil },
            StatusLineNC = { bg = transparent and "NONE" or nil },
            WinSeparator = { bg = "NONE" },
            VertSplit = { bg = "NONE" },
            FoldColumn = { bg = transparent and "NONE" or nil },
            TelescopeNormal = { bg = transparent and "NONE" or nil },
            TelescopeBorder = { bg = transparent and "NONE" or nil },
          }
        end,
      }
    end,
  },

  {
    "neanias/everforest-nvim",
    version = false,
    lazy = true,
    priority = 1000,
    opts = function()
      local transparent = vim.g.transparent_enabled
      return {
        background = "hard",
        transparent_background_level = transparent and 2 or 0,
        ui_contrast = "high",
        float_style = transparent and "dim" or "bright",
        on_highlights = function(hl, palette)
          hl.Normal = { bg = transparent and "NONE" or palette.bg0 }
          hl.NormalNC = { bg = transparent and "NONE" or palette.bg0 }
          hl.SignColumn = { bg = transparent and "NONE" or palette.bg0 }
          hl.EndOfBuffer = { bg = transparent and "NONE" or palette.bg0 }
          hl.LineNr = { bg = transparent and "NONE" or palette.bg0 }
          hl.CursorLineNr = { bg = transparent and "NONE" or palette.bg0 }
          hl.NormalFloat = { bg = transparent and "NONE" or palette.bg_dim }
          hl.FloatBorder = { bg = transparent and "NONE" or palette.bg_dim }
          hl.FloatTitle = { bg = transparent and "NONE" or palette.bg_dim }
          hl.CursorLine = { bg = transparent and "NONE" or palette.bg3 }
          hl.Pmenu = { bg = transparent and "NONE" or palette.bg_dim }
          hl.PmenuSel = { bg = palette.bg3 }
          hl.StatusLine = { bg = transparent and "NONE" or palette.bg_dim }
          hl.StatusLineNC = { bg = transparent and "NONE" or palette.bg_dim }
          hl.WinSeparator = { bg = "NONE" }
          hl.VertSplit = { bg = "NONE" }
          hl.FoldColumn = { bg = transparent and "NONE" or palette.bg0 }
          hl.TelescopeNormal = { bg = transparent and "NONE" or palette.bg_dim }
          hl.TelescopeBorder = { bg = transparent and "NONE" or palette.bg_dim }
        end,
      }
    end,
  },

  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      local transparent = vim.g.transparent_enabled
      return {
        transparent_mode = transparent,
        terminal_colors = true,
        overrides = {
          Normal = { bg = transparent and "NONE" or nil },
          NormalNC = { bg = transparent and "NONE" or nil },
          SignColumn = { bg = transparent and "NONE" or nil },
          EndOfBuffer = { bg = transparent and "NONE" or nil },
          LineNr = { bg = transparent and "NONE" or nil },
          CursorLineNr = { bg = transparent and "NONE" or nil },
          NormalFloat = { bg = transparent and "NONE" or nil },
          FloatBorder = { bg = transparent and "NONE" or nil },
          FloatTitle = { bg = transparent and "NONE" or nil },
          CursorLine = { bg = transparent and "NONE" or nil },
          Pmenu = { bg = transparent and "NONE" or nil },
          StatusLine = { bg = transparent and "NONE" or nil },
          StatusLineNC = { bg = transparent and "NONE" or nil },
          WinSeparator = { bg = "NONE" },
          VertSplit = { bg = "NONE" },
          FoldColumn = { bg = transparent and "NONE" or nil },
          TelescopeNormal = { bg = transparent and "NONE" or nil },
          TelescopeBorder = { bg = transparent and "NONE" or nil },
        },
      }
    end,
  },

  {
    "sainnhe/gruvbox-material",
    lazy = true,
    priority = 1000,
    init = function()
      vim.g.gruvbox_material_transparent_background = vim.g.transparent_enabled and 2 or 0
      vim.g.gruvbox_material_float_style = vim.g.transparent_enabled and "dim" or "bright"
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_better_performance = 1
    end,
  },

  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = vim.g.transparent_enabled,
      enable_italics = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { bold = false },
        variables = {},
      },
    },
  },

  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {
      extra_groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "FloatTitle",
        "CursorLine",
        "CursorLineNr",
        "SignColumn",
        "EndOfBuffer",
        "LineNr",
        "StatusLine",
        "StatusLineNC",
        "WinSeparator",
        "VertSplit",
        "FoldColumn",
        "Pmenu",
        "TelescopeNormal",
        "TelescopeBorder",
        "TelescopePromptNormal",
        "TelescopePromptBorder",
        "TelescopeResultsNormal",
        "TelescopeResultsBorder",
        "TelescopePreviewNormal",
        "TelescopePreviewBorder",
        "LazyNormal",
        "MasonNormal",
      },
      exclude_groups = {
        "PmenuSel",
      },
    },
    config = function(_, opts)
      require("transparent").setup(opts)
      if vim.g.transparent_enabled then
        vim.cmd("TransparentEnable")
      end

      vim.keymap.set("n", "<leader>ut", function()
        vim.g.transparent_enabled = not vim.g.transparent_enabled

        if vim.g.transparent_enabled then
          vim.cmd("TransparentEnable")
        else
          vim.cmd("TransparentDisable")
        end

        vim.cmd.colorscheme(current_colorscheme())
      end, { desc = "Toggle Transparency" })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = current_colorscheme(),
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = {
      defaults = {
        winblend = 10,
      },
    },
  },

  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      opts.window = opts.window or {}
      opts.window.completion = opts.window.completion or {}
      opts.window.documentation = opts.window.documentation or {}
      opts.window.completion.winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None"
      opts.window.documentation.winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Search:None"
      return opts
    end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      completion = {
        menu = {
          winblend = 10,
        },
        documentation = {
          window = {
            winblend = 10,
          },
        },
      },
    },
  },
}
