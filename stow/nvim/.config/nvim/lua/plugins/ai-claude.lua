local ai = require("config.ai")

-- Claude Code bridge. Extends the LazyVim extra "ai.claudecode" (lazyvim.json),
-- whose keymaps are kept: ac toggle, af focus, ar resume, aC continue, ab add buffer,
-- as send selection / add file from tree, aa accept diff, ad deny diff.
--
-- The plugin runs a websocket server on startup: a `claude` started outside nvim
-- (e.g. the AI tmux window from `gg`) can attach to it with the `/ide` command.
return {
  {
    "coder/claudecode.nvim",
    enabled = ai.claude,
    dependencies = { "folke/snacks.nvim" },
    init = function()
      vim.o.autoread = true -- Automatically reload buffers when Claude writes to disk
    end,
    opts = {
      auto_start = true, -- start the IDE server with nvim so /ide works from any terminal
      log_level = "warn",
      track_selection = true, -- Claude sees the current selection / cursor file as context
      focus_after_send = true, -- jump to the Claude terminal after sending a selection
      terminal = {
        provider = "snacks",
        split_side = "right",
        split_width_percentage = 0.35,
        auto_close = true,
      },
      diff_opts = {
        layout = "vertical", -- proposed edits shown side by side with the original
        open_in_new_tab = false,
        keep_terminal_focus = false, -- focus the diff so it can be reviewed right away
      },
    },
    keys = {
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ax", "<cmd>ClaudeCodeCloseAllDiffs<cr>", desc = "Close all Claude diffs" },
      { "<leader>aS", "<cmd>ClaudeCodeStatus<cr>", desc = "Claude connection status" },
      { "<leader>aq", "<cmd>ClaudeCodeClose<cr>", desc = "Close Claude terminal" },
      { "<leader>ap", "<cmd>ClaudeCodeOpen --permission-mode plan<cr>", desc = "Claude in plan mode" },
      -- new port, for when an external claude lost the /ide connection
      { "<leader>aR", "<cmd>ClaudeCodeStop<cr><cmd>ClaudeCodeStart<cr>", desc = "Restart Claude IDE server" },
      -- SendText only reaches a claude running in the nvim split, not one attached via /ide
      { "<leader>al", "<cmd>ClaudeCodeSendText /clear<cr>", desc = "Claude /clear" },
      { "<leader>ak", "<cmd>ClaudeCodeSendText /compact<cr>", desc = "Claude /compact" },
      { "<leader>ai", ":ClaudeCodeSendText ", desc = "Prompt Claude" },
      { "<leader>aI", ":ClaudeCodeSendText! ", desc = "Type into Claude (no submit)" },
      {
        "<leader>aL",
        function()
          local l = vim.fn.line(".")
          vim.cmd(("ClaudeCodeAdd %s %d %d"):format(vim.fn.expand("%:p"), l, l))
        end,
        desc = "Add current line to Claude",
      },
    },
  },
}
