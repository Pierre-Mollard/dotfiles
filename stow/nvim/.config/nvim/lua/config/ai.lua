-- AI assistants switchboard: each lua/plugins/ai-*.lua spec reads its flag through `enabled`.
-- They all share the <leader>a prefix, so keep a single one enabled to avoid keymap overlaps.
-- Override per launch without editing this file (comma separated, "none" disables all):
--   NVIM_AI=opencode nvim
--   NVIM_AI=claude,codecompanion nvim
local M = {
  claude = true, -- claudecode.nvim (Claude Code CLI bridge)
  opencode = false, -- opencode.nvim (opencode CLI in a side tmux pane)
  codecompanion = false, -- codecompanion.nvim (API chat, Gemini or a local model)
}

local env = vim.env.NVIM_AI
if env and env ~= "" then
  for name in pairs(M) do
    M[name] = env:find(name, 1, true) ~= nil
  end
end

return M
