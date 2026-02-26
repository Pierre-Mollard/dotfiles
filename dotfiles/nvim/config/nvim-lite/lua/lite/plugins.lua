-- plugins

vim.pack.add({
	"https://www.github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/folke/tokyonight.nvim",
})

local function packadd(name)
	vim.cmd("packadd " .. name)
end

packadd("nvim-tree.lua")
packadd("tokyonight.nvim")

require("nvim-tree").setup({
	view = {
		width = 35,
	},
	filters = {
		dotfiles = false,
	},
	renderer = {
		group_empty = true,
	},
})
vim.keymap.set("n", "<leader>e", function()
	require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })
