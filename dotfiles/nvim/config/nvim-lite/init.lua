-- This is neovim config entry point
require("lite") -- Load "lite" namespace (lua/lite/init.lua)

-- Use NeoVim 0.12 vim.pack internal plugin manager
local specs = require("plugins")
vim.pack.add(specs, { load = true, confirm = true })
