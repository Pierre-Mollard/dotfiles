return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        replace_netrw = true,
      },
      picker = {
        sources = {
          explorer = {
            -- Keeps focus in your main window when the explorer opens
            enter = false,
          },
        },
      },
    },
    init = function()
      -- 1. FIX NVIM . FOCUS: Focus main window when opening a directory naturally
      if vim.fn.argc() == 1 and vim.fn.isdirectory(tostring(vim.fn.argv(0))) == 1 then
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            vim.schedule(function()
              -- Snacks replaces netrw and opens the explorer.
              -- We just ensure we cycle back to the right window.
              vim.cmd("wincmd p")
            end)
          end,
        })
      end

      -- 2. SESSION RESTORE
      -- Let the session manager load normally. If a directory buffer was restored,
      -- we clear it (buggy, not the real explorer).
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistenceLoadPost",
        callback = function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local buf_name = vim.api.nvim_buf_get_name(buf)
            local state = vim.uv.fs_stat(buf_name)

            if state and state.type == "directory" then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end,
      })

      -- 3. AUTO-QUIT IF EXPLORER IS THE LAST WINDOW
      -- Simplified logic: directly check if the only normal window left is the picker/explorer
      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          local snacks_windows = {}
          local floating_windows = {}
          local windows = vim.api.nvim_list_wins()

          for _, w in ipairs(windows) do
            local buf = vim.api.nvim_win_get_buf(w)
            local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
            local config = vim.api.nvim_win_get_config(w)

            if filetype and filetype:match("snacks_") then
              table.insert(snacks_windows, w)
            elseif config.relative ~= "" then
              table.insert(floating_windows, w)
            end
          end

          if 1 == #windows - #floating_windows - #snacks_windows then
            for _, w in ipairs(snacks_windows) do
              vim.api.nvim_win_close(w, true)
            end
          end
        end,
      })
    end,
  },
}
