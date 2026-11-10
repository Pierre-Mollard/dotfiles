-- AI assistants switchboard: each lua/plugins/ai-*.lua spec reads its flag through `enabled`.
-- They all share the <leader>a prefix, so keep a single one enabled to avoid keymap overlaps.
-- Override per launch without editing this file (comma separated, "none" disables all):
--   NVIM_AI=pi nvim
--   NVIM_AI=claude,codecompanion nvim
local M = {
  claude = true, -- claudecode.nvim (Claude Code CLI bridge)
  opencode = false, -- opencode.nvim (opencode CLI in a side tmux pane)
  codecompanion = false, -- codecompanion.nvim (API chat, Gemini or a local model)
  pi = false, -- pi coding agent in a snacks terminal, for smaller tasks (same keys as claude)
}

local env = vim.env.NVIM_AI
if env and env ~= "" then
  local wanted = {}
  for name in env:gmatch("[^,%s]+") do
    wanted[name] = true
  end
  for name in pairs(M) do
    M[name] = wanted[name] == true -- exact names: "pi" must not match e.g. "copilot"
  end
end

return M
