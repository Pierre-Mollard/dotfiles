-- Shared AI setup. Each assistant lives in its own lua/plugins/ai-*.lua file,
-- enabled/disabled from lua/config/ai.lua.
return {
  -- WhichKey group for <leader>a, whichever assistant is active
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai", icon = { icon = "󰚩", color = "white" }, mode = { "n", "v" } },
      },
    },
    opts_extend = { "spec" },
  },
}
