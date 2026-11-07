-- Extra todo-comments keywords (merged with LazyVim's defaults TODO/FIX/WARN/NOTE/...)
-- REVIEW / ASK are notes addressed to Claude (see ~/.claude/CLAUDE.md)
return {
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        REVIEW = { icon = " ", color = "review" },
        ASK = { icon = " ", color = "ask" },
      },
      colors = {
        review = { "#FFFFFF" },
        ask = { "#D97757" }, -- Claude orange
      },
    },
  },
}
