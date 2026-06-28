-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.guicursor = {
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "a:blinkwait800-blinkoff400-blinkon250",
}

vim.api.nvim_set_hl(0, "Cursor", { fg = "#1A1B2C", bg = "#C0CAF5" })
vim.api.nvim_set_hl(0, "lCursor", { fg = "#1A1B2C", bg = "#C0CAF5" })
