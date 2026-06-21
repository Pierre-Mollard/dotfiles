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

local function pick(default_name, fallback)
  return themes[default_name] and default_name or fallback
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      transparent_background = true,
      term_colors = true,
      no_italic = false,
      no_bold = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
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
        return {
          Normal = { bg = "NONE" },
          NormalNC = { bg = "NONE" },
          SignColumn = { bg = "NONE" },
          EndOfBuffer = { bg = "NONE" },
          LineNr = { bg = "NONE" },
          CursorLineNr = { bg = "NONE" },
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          FloatTitle = { bg = "NONE" },
          CursorLine = { bg = "NONE" },
          Pmenu = { bg = "NONE" },
          PmenuSel = { bg = colors.surface1, fg = colors.text },
          StatusLine = { bg = "NONE" },
          StatusLineNC = { bg = "NONE" },
          WinSeparator = { bg = "NONE" },
          VertSplit = { bg = "NONE" },
          FoldColumn = { bg = "NONE" },
          LazyNormal = { bg = "NONE" },
          MasonNormal = { bg = "NONE" },
          TelescopeNormal = { bg = "NONE" },
          TelescopeBorder = { bg = "NONE" },
          TelescopePromptNormal = { bg = "NONE" },
          TelescopePromptBorder = { bg = "NONE" },
          TelescopeResultsNormal = { bg = "NONE" },
          TelescopeResultsBorder = { bg = "NONE" },
          TelescopePreviewNormal = { bg = "NONE" },
          TelescopePreviewBorder = { bg = "NONE" },
        }
      end,
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, c)
        hl.Normal = { bg = "NONE" }
        hl.NormalNC = { bg = "NONE" }
        hl.SignColumn = { bg = "NONE" }
        hl.EndOfBuffer = { bg = "NONE" }
        hl.LineNr = { bg = "NONE" }
        hl.CursorLineNr = { bg = "NONE" }
        hl.NormalFloat = { bg = "NONE" }
        hl.FloatBorder = { bg = "NONE" }
        hl.FloatTitle = { bg = "NONE" }
        hl.CursorLine = { bg = "NONE" }
        hl.Pmenu = { bg = "NONE" }
        hl.PmenuSel = { bg = c.bg_highlight, fg = c.fg }
        hl.StatusLine = { bg = "NONE" }
        hl.StatusLineNC = { bg = "NONE" }
        hl.WinSeparator = { bg = "NONE" }
        hl.VertSplit = { bg = "NONE" }
        hl.FoldColumn = { bg = "NONE" }
        hl.LazyNormal = { bg = "NONE" }
        hl.MasonNormal = { bg = "NONE" }
        hl.TelescopeNormal = { bg = "NONE" }
        hl.TelescopeBorder = { bg = "NONE" }
      end,
    },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
    opts = {
      styles = {
        transparency = true,
      },
      highlight_groups = {
        Normal = { bg = "NONE" },
        NormalNC = { bg = "NONE" },
        SignColumn = { bg = "NONE" },
        EndOfBuffer = { bg = "NONE" },
        LineNr = { bg = "NONE" },
        CursorLineNr = { bg = "NONE" },
        NormalFloat = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        FloatTitle = { bg = "NONE" },
        CursorLine = { bg = "NONE" },
        Pmenu = { bg = "NONE" },
        StatusLine = { bg = "NONE" },
        StatusLineNC = { bg = "NONE" },
        WinSeparator = { bg = "NONE" },
        VertSplit = { bg = "NONE" },
        FoldColumn = { bg = "NONE" },
        TelescopeNormal = { bg = "NONE" },
        TelescopeBorder = { bg = "NONE" },
      },
    },
  },

  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      hide_fillchars = true,
      borderless_pickers = false,
      terminal_colors = true,
      highlights = {
        Normal = { bg = "NONE" },
        NormalNC = { bg = "NONE" },
        SignColumn = { bg = "NONE" },
        EndOfBuffer = { bg = "NONE" },
        LineNr = { bg = "NONE" },
        CursorLineNr = { bg = "NONE" },
        NormalFloat = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        FloatTitle = { bg = "NONE" },
        CursorLine = { bg = "NONE" },
        Pmenu = { bg = "NONE" },
        StatusLine = { bg = "NONE" },
        StatusLineNC = { bg = "NONE" },
        WinSeparator = { bg = "NONE" },
        VertSplit = { bg = "NONE" },
        FoldColumn = { bg = "NONE" },
        TelescopeNormal = { bg = "NONE" },
        TelescopeBorder = { bg = "NONE" },
      },
    },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
              float = { bg = "none" },
            },
          },
        },
      },
      overrides = function(colors)
        return {
          Normal = { bg = "NONE" },
          NormalNC = { bg = "NONE" },
          SignColumn = { bg = "NONE" },
          EndOfBuffer = { bg = "NONE" },
          LineNr = { bg = "NONE" },
          CursorLineNr = { bg = "NONE" },
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          FloatTitle = { bg = "NONE" },
          CursorLine = { bg = "NONE" },
          Pmenu = { bg = "NONE" },
          StatusLine = { bg = "NONE" },
          StatusLineNC = { bg = "NONE" },
          WinSeparator = { bg = "NONE" },
          VertSplit = { bg = "NONE" },
          FoldColumn = { bg = "NONE" },
          TelescopeNormal = { bg = "NONE" },
          TelescopeBorder = { bg = "NONE" },
        }
      end,
    },
  },

  {
    "neanias/everforest-nvim",
    version = false,
    lazy = true,
    priority = 1000,
    opts = {
      background = "hard",
      transparent_background_level = 2,
      ui_contrast = "high",
      float_style = "dim",
      on_highlights = function(hl, palette)
        hl.Normal = { bg = "NONE" }
        hl.NormalNC = { bg = "NONE" }
        hl.SignColumn = { bg = "NONE" }
        hl.EndOfBuffer = { bg = "NONE" }
        hl.LineNr = { bg = "NONE" }
        hl.CursorLineNr = { bg = "NONE" }
        hl.NormalFloat = { bg = "NONE" }
        hl.FloatBorder = { bg = "NONE" }
        hl.FloatTitle = { bg = "NONE" }
        hl.CursorLine = { bg = "NONE" }
        hl.Pmenu = { bg = "NONE" }
        hl.PmenuSel = { bg = palette.bg3 }
        hl.StatusLine = { bg = "NONE" }
        hl.StatusLineNC = { bg = "NONE" }
        hl.WinSeparator = { bg = "NONE" }
        hl.VertSplit = { bg = "NONE" }
        hl.FoldColumn = { bg = "NONE" }
        hl.TelescopeNormal = { bg = "NONE" }
        hl.TelescopeBorder = { bg = "NONE" }
      end,
    },
  },

  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent_mode = true,
      terminal_colors = true,
      overrides = {
        Normal = { bg = "NONE" },
        NormalNC = { bg = "NONE" },
        SignColumn = { bg = "NONE" },
        EndOfBuffer = { bg = "NONE" },
        LineNr = { bg = "NONE" },
        CursorLineNr = { bg = "NONE" },
        NormalFloat = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        FloatTitle = { bg = "NONE" },
        CursorLine = { bg = "NONE" },
        Pmenu = { bg = "NONE" },
        StatusLine = { bg = "NONE" },
        StatusLineNC = { bg = "NONE" },
        WinSeparator = { bg = "NONE" },
        VertSplit = { bg = "NONE" },
        FoldColumn = { bg = "NONE" },
        TelescopeNormal = { bg = "NONE" },
        TelescopeBorder = { bg = "NONE" },
      },
    },
  },

  {
    "sainnhe/gruvbox-material",
    lazy = true,
    priority = 1000,
    init = function()
      vim.g.gruvbox_material_transparent_background = 2
      vim.g.gruvbox_material_float_style = "dim"
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_better_performance = 1
    end,
  },

  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true,
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
        "NormalFloat",
        "FloatBorder",
        "FloatTitle",
        "CursorLine",
        "CursorLineNr",
        "SignColumn",
        "EndOfBuffer",
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
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = themes.catppuccin and "catppuccin-frappe"
        or themes.tokyonight and "tokyonight-night"
        or themes.rose_pine and "rose-pine"
        or themes.cyberdream and "cyberdream"
        or themes.kanagawa and "kanagawa-wave"
        or themes.everforest and "everforest"
        or themes.gruvbox and "gruvbox"
        or themes.gruvbox_material and "gruvbox-material"
        or themes.neosolarized and "NeoSolarized"
        or "tokyonight-night",
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
