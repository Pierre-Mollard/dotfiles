local ai = require("config.ai")

-- pi coding agent (~/.local/bin/pi), for smaller tasks. There's no nvim plugin:
-- pi runs in a snacks terminal on the right, and context is pasted into its prompt.
-- Keys follow ai-claude.lua (ac toggle, as send selection, ...) so muscle memory carries over.

local opts = { win = { position = "right", width = 0.35 } }
local term ---@type snacks.win? the last pi terminal opened from here

local function running()
  return term ~= nil and term:buf_valid()
end

local function start(args)
  if running() then
    term:close()
  end
  term = Snacks.terminal.open(vim.list_extend({ "pi" }, args or {}), opts)
end

local function toggle()
  if running() then
    term:toggle()
  else
    start()
  end
end

-- Paste text into pi's prompt (bracketed paste keeps multi-line text in one message).
-- A pi that isn't running is started first, and the text waits for its TUI to be ready.
local function send(text, submit)
  local function paste()
    term:show()
    local chan = vim.bo[term.buf].channel
    vim.api.nvim_chan_send(chan, "\27[200~" .. text .. "\27[201~")
    if submit then
      vim.api.nvim_chan_send(chan, "\r")
    end
    term:focus()
    vim.cmd.startinsert()
  end
  if running() then
    paste()
  else
    start()
    vim.defer_fn(paste, 1000)
  end
end

local function send_selection()
  local mode = vim.fn.mode()
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  s, e = math.min(s, e), math.max(s, e)
  vim.api.nvim_feedkeys(vim.keycode("<esc>"), "nx", false)
  send(("@%s (lines %d-%d):\n```%s\n%s\n```\n"):format(vim.fn.expand("%:."), s, e, vim.bo.filetype, table.concat(lines, "\n")))
end

return {
  {
    "folke/snacks.nvim",
    optional = true,
    init = function()
      if ai.pi then
        vim.o.autoread = true -- reload buffers pi edited on disk
      end
    end,
    keys = ai.pi and {
      { "<leader>ac", toggle, desc = "Toggle pi" },
      { "<leader>af", function() if running() then term:focus() else start() end end, desc = "Focus pi" },
      { "<leader>aC", function() start({ "-c" }) end, desc = "Continue last pi session" },
      { "<leader>ar", function() start({ "-r" }) end, desc = "Resume pi session (picker)" },
      { "<leader>ab", function() send("@" .. vim.fn.expand("%:.") .. " ") end, desc = "Add buffer to pi" },
      { "<leader>as", send_selection, mode = "x", desc = "Send selection to pi" },
      {
        "<leader>ai",
        function()
          Snacks.input({ prompt = "pi" }, function(input)
            if input and input ~= "" then
              send(input, true)
            end
          end)
        end,
        desc = "Prompt pi",
      },
      { "<leader>aq", function() if running() then term:close() end end, desc = "Quit pi" },
    } or {},
  },
}
