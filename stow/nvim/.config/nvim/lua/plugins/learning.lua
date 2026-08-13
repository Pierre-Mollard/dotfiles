return {
  -- vim-be-good for motion training
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },

  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    config = function()
      require("precognition").setup({
        startVisible = false,
        showBlankVirtLine = false,
        onlyVisibleLines = true,
        maxLineLength = 200,

        -- All hints must be defined (use defaults or set prio = 0 to disable)
        hints = {
          w = { text = "w", prio = 10 },
          e = { text = "e", prio = 8 },
          b = { text = "b", prio = 9 },
          W = { text = "W", prio = 7 },
          E = { text = "E", prio = 5 },
          B = { text = "B", prio = 6 },
          Zero = { text = "0", prio = 1 },
          MatchingPair = { text = "%", prio = 5 },
          Caret = { text = "^", prio = 2 },
          Dollar = { text = "$", prio = 1 },
        },

        -- All gutter hints must be defined
        gutterHints = {
          G = { text = "G", prio = 10 },
          gg = { text = "gg", prio = 9 },
          PrevParagraph = { text = "{", prio = 8 },
          NextParagraph = { text = "}", prio = 8 },
        },
      })
    end,
    keys = {
      { "<leader>cp", "<cmd>Precognition toggle<cr>", desc = "Toggle Precognition" },
      { "<leader>cP", "<cmd>Precognition peek<cr>", desc = "Peek Precognition" },
    },
  },
}
