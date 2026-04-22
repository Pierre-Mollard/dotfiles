return {
  -- add tmux navigator plugin to run within tmux with same key binds
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      -- Key maps
      { "<C-h>", "<cmd> TmuxNavigateLeft<CR>", desc = "Tmux Window Left" },
      { "<C-l>", "<cmd> TmuxNavigateRight<CR>", desc = "Tmux Window Right" },
      { "<C-j>", "<cmd> TmuxNavigateDown<CR>", desc = "Tmux Window Down" },
      { "<C-k>", "<cmd> TmuxNavigateUp<CR>", desc = "Tmux Window Up" },
    },
  },
}
