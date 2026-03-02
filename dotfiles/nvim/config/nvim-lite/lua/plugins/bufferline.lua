local M = {}

M.spec = {
	src = "https://github.com/akinsho/bufferline.nvim",
	name = "bufferline.nvim",
}

function M.config()
	local Snacks = require("snacks")
	local Bufferline = require("bufferline")
	Bufferline.setup({
		options = {
    -- stylua: ignore
    close_command = function(n) Snacks.bufdelete(n) end,
    -- stylua: ignore
    right_mouse_command = function(n) Snacks.bufdelete(n) end,
			diagnostics = "nvim_lsp",
			always_show_bufferline = false,
			offsets = {
				{
					filetype = "neo-tree",
					text = "Neo-tree",
					highlight = "Directory",
					text_align = "left",
				},
				{
					filetype = "snacks_layout_box",
				},
			},
		},
	})
end

M.keys = {}

return M
