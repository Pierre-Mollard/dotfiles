local ai = require("config.ai")

return {
  -- OpenCode Neovim Bridge (Assistant via side tmux pane)
  {
    "nickjvandyke/opencode.nvim",
    enabled = ai.opencode,
    version = "*",
    event = "VeryLazy",
    dependencies = {
      -- Snacks enhances the input prompts and fuzzy picker if you use LazyVim defaults
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...)
                return require("opencode").snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      vim.o.autoread = true -- Automatically reload buffers when OpenCode writes to disk

      -- OpenCode Keymaps mapped directly under <leader>a
      vim.keymap.set({ "n", "x" }, "<leader>aa", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask OpenCode (@this)" })

      vim.keymap.set({ "n", "x" }, "<leader>as", function()
        require("opencode").select()
      end, { desc = "Select OpenCode Action" })

      vim.keymap.set({ "n", "t" }, "<leader>at", function()
        require("opencode").toggle()
      end, { desc = "Toggle / Focus OpenCode" })

      vim.keymap.set({ "n", "x" }, "<leader>ao", function()
        return require("opencode").operator("@this ")
      end, { desc = "Add Range to OpenCode", expr = true })
    end,
  },
}
