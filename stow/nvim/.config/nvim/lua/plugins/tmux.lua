return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window/Pane Left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window/Pane Down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window/Pane Up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window/Pane Right" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Window/Pane Previous" },
    },
  },
}
