return {
  "lewis6991/gitsigns.nvim",
  keys = {
    {
      "<leader>gc",
      function()
        local gs = require("gitsigns")
        gs.toggle_deleted()
        gs.toggle_word_diff()
        gs.toggle_linehl()
      end,
      desc = "Git Inline Diff (Toggle)",
    },
  },
}
