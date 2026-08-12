return {
  -- vim-be-good for motion training
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },

  -- Precognition for motion hints
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    config = function()
      require("precognition").setup({
        hints = {
          show = true,
          show_on_startup = false,
        },
      })
    end,
  },
}
