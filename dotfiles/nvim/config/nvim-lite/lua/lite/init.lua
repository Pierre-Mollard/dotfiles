-- LITE entry point

-- leader and localleader (special to buffer/filetype) must be loaded here
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- load lite modules
require("lite.options")
require("lite.keymaps")
require("lite.autocmds")
require("lite.commands")
require("lite.reload")
