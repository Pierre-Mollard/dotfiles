local themes = {
  catppuccin = false,
  tokyonight = true,
  rose_pine = false,
  cyberdream = false,
  kanagawa = false,
  everforest = false,
  gruvbox = false,
  gruvbox_material = false,
  neosolarized = false,
}

vim.g.transparent_enabled = true -- Keep track of state globally so we can toggle

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

return {
  -- 1. Global Transparency Toggle
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    keys = {
      {
        "<leader>ut",
        function()
          vim.g.transparent_enabled = not vim.g.transparent_enabled
          local is_transparent = vim.g.transparent_enabled

          if is_transparent then
            vim.cmd("TransparentEnable")
          else
            vim.cmd("TransparentDisable")
          end

          local active_theme = vim.g.colors_name

          if active_theme and active_theme:match("catppuccin") then
            local cat = require("catppuccin")
            cat.options.transparent_background = is_transparent
            cat.compile()
          elseif active_theme and active_theme:match("tokyonight") then
            local theme_opts = require("tokyonight.config").options
            theme_opts.transparent = is_transparent
            require("tokyonight").setup(theme_opts)
          elseif active_theme and active_theme:match("cyberdream") then
            require("cyberdream").setup({ transparent = is_transparent })
          elseif active_theme and active_theme:match("kanagawa") then
            require("kanagawa").setup({ transparent = is_transparent })
          elseif active_theme and active_theme:match("everforest") then
            vim.g.everforest_transparent_background = is_transparent and 2 or 0
          elseif active_theme and active_theme:match("gruvbox") then
            require("gruvbox").setup({ transparent_mode = is_transparent })
          end

          vim.cmd("colorscheme " .. current_colorscheme())

          local has_lualine, lualine = pcall(require, "lualine")
          if has_lualine then
            lualine.setup({ options = { theme = "auto" } })
          end

          local has_bufferline, bufferline = pcall(require, "bufferline")
          if has_bufferline then
            vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "*" })
            if is_transparent then
              vim.cmd([[
                hi BufferLineFill guibg=NONE ctermbg=NONE
                hi BufferLineBackground guibg=NONE ctermbg=NONE
              ]])
            end
          end
        end,
        desc = "Toggle Transparency",
      },
    },
    opts = {
      extra_groups = {
        "NormalFloat",
        "FloatTitle",
        "TelescopeNormal",
        "TelescopePromptNormal",
        "TelescopeResultsNormal",
        "TelescopePreviewNormal",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NeoTreeFloatNormal",
        "NeoTreeFloatTitle",
        "NeoTreeFloatBorder",
        "NeoTreeFilter",
        "Pmenu",
        "BlinkCmpMenu",
        "BlinkCmpMenuBorder",
        "BlinkCmpDoc",
        "BlinkCmpDocBorder",
        "BlinkCmpSignatureHelpBorder",
        "SignColumn",
        "CursorLineNr",
        "LineNr",
        "FoldColumn",
        "WhichKeyFloat",
        "LspInfoBorder",
        "LazyNormal",
        "MasonNormal",
        "FloatBorder",
        "TelescopeBorder",
        "TelescopePromptBorder",
        "TelescopeResultsBorder",
        "TelescopePreviewBorder",
        "PmenuSel",
        "CursorLine",
        "SnacksPickerNormal",
        "SnacksPickerBorder",
        "SnacksPickerInput",
        "SnacksPickerInputBorder",
        "SnacksPickerList",
        "SnacksPickerListBorder",
        "SnacksPickerPreview",
        "SnacksPickerPreviewBorder",
        "NoiceCmdlinePopup",
        "NoiceCmdlinePopupBorder",
        "NoiceConfirm",
        "NoiceConfirmBorder",
        "NoiceMini",
        "WhichKey",
        "WhichKeyNormal",
        "WhichKeyBorder",
        "WhichKeyTitle",
      },
      exclude_groups = {},
    },
    config = function(_, opts)
      local transparent = require("transparent")
      transparent.setup(opts)
      transparent.clear_prefix("NeoTree")

      if vim.g.transparent_enabled then
        vim.cmd("TransparentEnable")
      else
        vim.cmd("TransparentDisable")
      end
    end,
  },

  -- 2. Set the LazyVim colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = current_colorscheme(),
    },
  },

  -- 3. Force Borders on UI Elements
  {
    "mason-org/mason.nvim",
    opts = { ui = { border = "rounded" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics = opts.diagnostics or {}
      opts.diagnostics.float = opts.diagnostics.float or {}
      opts.diagnostics.float.border = "rounded"
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = {
      defaults = {
        winblend = 0,
        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
    },
  },
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      presets = { lsp_doc_border = true, cmdline_output_to_split = false },
      views = {
        cmdline_popup = { border = { style = "rounded" } },
        hover = { border = { style = "rounded" } },
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      completion = {
        menu = { border = "rounded", winblend = 0 },
        documentation = { window = { border = "rounded", winblend = 0 } },
      },
      signature = { window = { border = "rounded", winblend = 0 } },
    },
  },

  -- 4. Themes
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = function()
      return {
        transparent_background = vim.g.transparent_enabled,
        term_colors = true,
        integrations = {
          aerial = true,
          alpha = true,
          blink_cmp = true,
          cmp = true,
          dashboard = true,
          flash = true,
          fzf = true,
          gitsigns = true,
          headlines = true,
          illuminate = true,
          indent_blankline = { enabled = true },
          leap = true,
          mason = true,
          mini = true,
          native_lsp = { enabled = true, underlines = { errors = { "undercurl" } } },
          navic = { enabled = true, custom_bg = "lualine" },
          neotree = true,
          noice = true,
          notify = true,
          snacks = true,
          telescope = true,
          treesitter = true,
          which_key = true,
        },
      }
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = function()
      return {
        transparent = vim.g.transparent_enabled,
        styles = { sidebars = "dark", floats = "dark" },
        on_colors = function(colors)
          if vim.g.transparent_enabled then
            colors.bg_statusline = colors.none
          end
        end,
        on_highlights = function(hl, c)
          if vim.g.transparent_enabled then
            -- 1. General Floats
            hl.NormalFloat = { bg = "NONE" }
            hl.FloatBorder = { fg = c.border_highlight, bg = "NONE" }
            hl.FloatTitle = { fg = c.orange, bg = "NONE" }
            hl.Pmenu = { bg = "NONE" }

            -- 2. Split Lines
            hl.WinSeparator = { fg = c.border_highlight, bg = "NONE" }
            hl.VertSplit = { fg = c.border_highlight, bg = "NONE" }

            -- 3. Telescope
            hl.TelescopeNormal = { bg = "NONE" }
            hl.TelescopeBorder = { fg = c.border_highlight, bg = "NONE" }
            hl.TelescopePromptBorder = { fg = c.orange, bg = "NONE" }
            hl.TelescopePromptTitle = { fg = c.orange, bg = "NONE" }

            -- 4. Snacks Picker (<space><space> window)
            hl.SnacksPickerNormal = { bg = "NONE" }
            hl.SnacksPickerBorder = { fg = c.border_highlight, bg = "NONE" }
            hl.SnacksPickerTitle = { fg = c.orange, bg = "NONE" }

            hl.SnacksPickerInput = { bg = "NONE" }
            hl.SnacksPickerInputBorder = { fg = c.orange, bg = "NONE" }
            hl.SnacksPickerInputTitle = { fg = c.orange, bg = "NONE" }

            hl.SnacksPickerList = { bg = "NONE" }
            hl.SnacksPickerListBorder = { fg = c.border_highlight, bg = "NONE" }

            hl.SnacksPickerPreview = { bg = "NONE" }
            hl.SnacksPickerPreviewBorder = { fg = c.border_highlight, bg = "NONE" }

            -- 5. NeoTree (Explorer)
            hl.NeoTreeFloatNormal = { bg = "NONE" }
            hl.NeoTreeFloatBorder = { fg = c.border_highlight, bg = "NONE" }
            hl.NeoTreeFloatTitle = { fg = c.orange, bg = "NONE" }

            hl.NeoTreeFilter = { bg = "NONE" }
            hl.NeoTreeFilterBorder = { fg = c.orange, bg = "NONE" }

            -- 6. Blink Dropdowns
            hl.BlinkCmpMenuBorder = { fg = c.border_highlight, bg = "NONE" }
            hl.BlinkCmpDocBorder = { fg = c.border_highlight, bg = "NONE" }
            hl.BlinkCmpSignatureHelpBorder = { fg = c.border_highlight, bg = "NONE" }

            -- 7. Noice (Command Line & Messages)
            hl.NoiceCmdlinePopup = { bg = "NONE" }
            hl.NoiceCmdlinePopupBorder = { fg = c.border_highlight, bg = "NONE" }
            hl.NoiceCmdlinePopupTitle = { fg = c.orange, bg = "NONE" }
            hl.NoiceConfirm = { bg = "NONE" }
            hl.NoiceConfirmBorder = { fg = c.border_highlight, bg = "NONE" }
            -- Noice 'mini' messages (bottom right corners) [web:956]
            hl.NoiceMini = { bg = "NONE" }

            -- 8. WhichKey (Bottom keybind popup)
            hl.WhichKeyFloat = { bg = "NONE" }
            hl.WhichKeyBorder = { fg = c.border_highlight, bg = "NONE" }
            hl.WhichKeyTitle = { fg = c.orange, bg = "NONE" }
          end
        end,
      }
    end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = function()
      return { styles = { transparency = vim.g.transparent_enabled } }
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    opts = function()
      return { transparent = vim.g.transparent_enabled, hide_fillchars = true }
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = function()
      return { transparent = vim.g.transparent_enabled }
    end,
  },
  {
    "neanias/everforest-nvim",
    lazy = true,
    opts = function()
      return { background = "hard", transparent_background_level = vim.g.transparent_enabled and 2 or 0 }
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = function()
      return { transparent_mode = vim.g.transparent_enabled }
    end,
  },
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    init = function()
      vim.g.gruvbox_material_transparent_background = vim.g.transparent_enabled and 2 or 0
    end,
  },
  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = true,
    opts = function()
      return { transparent = vim.g.transparent_enabled }
    end,
  },
}
