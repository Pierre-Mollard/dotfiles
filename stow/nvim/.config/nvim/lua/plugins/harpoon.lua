return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    },
    keys = function()
      local keys = {
        { "<leader>h", group = "Harpoon", icon = { icon = "󱡅", color = "cyan" } },
        {
          "<leader>ha",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Add File",
        },
        {
          "<leader>hh",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Menu",
        },
        {
          "<leader>hr",
          function()
            require("harpoon"):list():remove()
          end,
          desc = "Remove File",
        },
      }

      for i = 1, 9 do
        table.insert(keys, {
          "<leader>h" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "File " .. i,
        })
      end

      return keys
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>h", group = "harpoon", icon = { icon = "󱡅", color = "cyan" } },
      },
    },
    opts_extend = { "spec" },
  },
}
