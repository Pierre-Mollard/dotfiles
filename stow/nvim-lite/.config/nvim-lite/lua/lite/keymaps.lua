local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<cr>", { silent = true })
map("n", "<leader>q", "<cmd>quit<cr>", { silent = true })

-- quick edit + run current lua file (useful while iterating)
map("n", "<leader>x", "<cmd>luafile %<cr>", { silent = true })
