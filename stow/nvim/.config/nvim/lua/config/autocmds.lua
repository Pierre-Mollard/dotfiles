-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Automatically clear the LSP log file when Neovim exits
vim.api.nvim_create_autocmd("VimLeavePre", {
  desc = "Clear LSP log file on exit to prevent it from growing indefinitely",
  callback = function()
    local log_path = vim.fn.stdpath("state") .. "/lsp.log"
    local f = io.open(log_path, "w")
    if f then
      -- Writing an empty string effectively clears the file
      f:write("")
      f:close()
    end
  end,
})

-- Automatically clear the 'select' visual when leaving select mode (the tab suggestions, like to fill function args)
local function stop_snippet_and_leave()
  if vim.snippet and vim.snippet.active() then
    vim.snippet.stop()
  end
  return "<Esc>"
end

vim.keymap.set(
  { "i", "s" },
  "<C-c>",
  stop_snippet_and_leave,
  { expr = true, silent = true, desc = "Stop snippet and return to Normal mode" }
)
vim.keymap.set(
  { "i", "s" },
  "<Esc>",
  stop_snippet_and_leave,
  { expr = true, silent = true, desc = "Stop snippet and return to Normal mode" }
)
