local M = {}

M.spec = {
	src = "https://github.com/folke/snacks.nvim",
	name = "snacks.nvim",
}

function M.config()
	local Snacks = require("snacks")
	-- opts
	Snacks.setup({
		bigfile = { enabled = true },
		dashboard = { enabled = false },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		picker = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		styles = {
			notification = {
				wo = { wrap = true },
			},
		},
	})

	-- Toggle mappings (Snacks creates these mappings)
	Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
	Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
	Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
	Snacks.toggle.diagnostics():map("<leader>ud")
	Snacks.toggle.line_number():map("<leader>ul")
	Snacks.toggle
		.option("conceallevel", {
			off = 0,
			on = (vim.o.conceallevel > 0 and vim.o.conceallevel or 2),
		})
		:map("<leader>uc")
	Snacks.toggle.treesitter():map("<leader>uT")
	Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")

	-- only if your Neovim has inlay hint API available
	if vim.lsp.inlay_hint then
		Snacks.toggle.inlay_hints():map("<leader>uh")
	end

	Snacks.toggle.indent():map("<leader>ug")
	Snacks.toggle.dim():map("<leader>uD")
end

M.keys = {
	-- Top Pickers & Explorer
	{
		"<leader><space>",
		function()
			require("snacks").picker.smart()
		end,
		desc = "Smart Find Files",
	},
	{
		"<leader>,",
		function()
			require("snacks").picker.buffers()
		end,
		desc = "buffers",
	},
	{
		"<leader>/",
		function()
			require("snacks").picker.grep()
		end,
		desc = "grep",
	},
	{
		"<leader>:",
		function()
			require("snacks").picker.command_history()
		end,
		desc = "command history",
	},
	{
		"<leader>n",
		function()
			require("snacks").picker.notifications()
		end,
		desc = "notification history",
	},
	{
		"<leader>e",
		function()
			require("snacks").explorer()
		end,
		desc = "file explorer",
	},
	-- find
	{
		"<leader>fb",
		function()
			require("snacks").picker.buffers()
		end,
		desc = "buffers",
	},
	{
		"<leader>fc",
		function()
			require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
		end,
		desc = "find config file",
	},
	{
		"<leader>ff",
		function()
			require("snacks").picker.files()
		end,
		desc = "find files",
	},
	{
		"<leader>fg",
		function()
			require("snacks").picker.git_files()
		end,
		desc = "find git files",
	},
	{
		"<leader>fp",
		function()
			require("snacks").picker.projects()
		end,
		desc = "projects",
	},
	{
		"<leader>fr",
		function()
			require("snacks").picker.recent()
		end,
		desc = "recent",
	},
	-- git
	{
		"<leader>gb",
		function()
			require("snacks").picker.git_branches()
		end,
		desc = "git branches",
	},
	{
		"<leader>gl",
		function()
			require("snacks").picker.git_log()
		end,
		desc = "git log",
	},
	{
		"<leader>gl",
		function()
			require("snacks").picker.git_log_line()
		end,
		desc = "git log line",
	},
	{
		"<leader>gs",
		function()
			require("snacks").picker.git_status()
		end,
		desc = "git status",
	},
	{
		"<leader>gs",
		function()
			require("snacks").picker.git_stash()
		end,
		desc = "git stash",
	},
	{
		"<leader>gd",
		function()
			require("snacks").picker.git_diff()
		end,
		desc = "git diff (hunks)",
	},
	{
		"<leader>gf",
		function()
			require("snacks").picker.git_log_file()
		end,
		desc = "git log file",
	},
	-- gh
	{
		"<leader>gi",
		function()
			require("snacks").picker.gh_issue()
		end,
		desc = "github issues (open)",
	},
	{
		"<leader>gi",
		function()
			require("snacks").picker.gh_issue({ state = "all" })
		end,
		desc = "github issues (all)",
	},
	{
		"<leader>gp",
		function()
			require("snacks").picker.gh_pr()
		end,
		desc = "github pull requests (open)",
	},
	{
		"<leader>gp",
		function()
			require("snacks").picker.gh_pr({ state = "all" })
		end,
		desc = "github pull requests (all)",
	},
	-- grep
	{
		"<leader>sb",
		function()
			require("snacks").picker.lines()
		end,
		desc = "buffer lines",
	},
	{
		"<leader>sb",
		function()
			require("snacks").picker.grep_buffers()
		end,
		desc = "grep open buffers",
	},
	{
		"<leader>sg",
		function()
			require("snacks").picker.grep()
		end,
		desc = "grep",
	},
	{
		"<leader>sw",
		function()
			require("snacks").picker.grep_word()
		end,
		desc = "visual selection or word",
		mode = { "n", "x" },
	},
	-- search
	{
		'<leader>s"',
		function()
			require("snacks").picker.registers()
		end,
		desc = "registers",
	},
	{
		"<leader>s/",
		function()
			require("snacks").picker.search_history()
		end,
		desc = "search history",
	},
	{
		"<leader>sa",
		function()
			require("snacks").picker.autocmds()
		end,
		desc = "autocmds",
	},
	{
		"<leader>sb",
		function()
			require("snacks").picker.lines()
		end,
		desc = "buffer lines",
	},
	{
		"<leader>sc",
		function()
			require("snacks").picker.command_history()
		end,
		desc = "command history",
	},
	{
		"<leader>sc",
		function()
			require("snacks").picker.commands()
		end,
		desc = "commands",
	},
	{
		"<leader>sd",
		function()
			require("snacks").picker.diagnostics()
		end,
		desc = "diagnostics",
	},
	{
		"<leader>sd",
		function()
			require("snacks").picker.diagnostics_buffer()
		end,
		desc = "buffer diagnostics",
	},
	{
		"<leader>sh",
		function()
			require("snacks").picker.help()
		end,
		desc = "help pages",
	},
	{
		"<leader>sh",
		function()
			require("snacks").picker.highlights()
		end,
		desc = "highlights",
	},
	{
		"<leader>si",
		function()
			require("snacks").picker.icons()
		end,
		desc = "icons",
	},
	{
		"<leader>sj",
		function()
			require("snacks").picker.jumps()
		end,
		desc = "jumps",
	},
	{
		"<leader>sk",
		function()
			require("snacks").picker.keymaps()
		end,
		desc = "keymaps",
	},
	{
		"<leader>sl",
		function()
			require("snacks").picker.loclist()
		end,
		desc = "location list",
	},
	{
		"<leader>sm",
		function()
			require("snacks").picker.marks()
		end,
		desc = "marks",
	},
	{
		"<leader>sm",
		function()
			require("snacks").picker.man()
		end,
		desc = "man pages",
	},
	{
		"<leader>sp",
		function()
			require("snacks").picker.lazy()
		end,
		desc = "search for plugin spec",
	},
	{
		"<leader>sq",
		function()
			require("snacks").picker.qflist()
		end,
		desc = "quickfix list",
	},
	{
		"<leader>sr",
		function()
			require("snacks").picker.resume()
		end,
		desc = "resume",
	},
	{
		"<leader>su",
		function()
			require("snacks").picker.undo()
		end,
		desc = "undo history",
	},
	{
		"<leader>uc",
		function()
			require("snacks").picker.colorschemes()
		end,
		desc = "colorschemes",
	},
	-- lsp
	{
		"gd",
		function()
			require("snacks").picker.lsp_definitions()
		end,
		desc = "goto definition",
	},
	{
		"gd",
		function()
			require("snacks").picker.lsp_declarations()
		end,
		desc = "goto declaration",
	},
	{
		"gr",
		function()
			require("snacks").picker.lsp_references()
		end,
		nowait = true,
		desc = "references",
	},
	{
		"gi",
		function()
			require("snacks").picker.lsp_implementations()
		end,
		desc = "goto implementation",
	},
	{
		"gy",
		function()
			require("snacks").picker.lsp_type_definitions()
		end,
		desc = "goto t[y]pe definition",
	},
	{
		"gai",
		function()
			require("snacks").picker.lsp_incoming_calls()
		end,
		desc = "c[a]lls incoming",
	},
	{
		"gao",
		function()
			require("snacks").picker.lsp_outgoing_calls()
		end,
		desc = "c[a]lls outgoing",
	},
	{
		"<leader>ss",
		function()
			require("snacks").picker.lsp_symbols()
		end,
		desc = "lsp symbols",
	},
	{
		"<leader>ss",
		function()
			require("snacks").picker.lsp_workspace_symbols()
		end,
		desc = "lsp workspace symbols",
	},
	-- other
	{
		"<leader>z",
		function()
			require("snacks").zen()
		end,
		desc = "toggle zen mode",
	},
	{
		"<leader>z",
		function()
			require("snacks").zen.zoom()
		end,
		desc = "toggle zoom",
	},
	{
		"<leader>.",
		function()
			require("snacks").scratch()
		end,
		desc = "toggle scratch buffer",
	},
	{
		"<leader>s",
		function()
			require("snacks").scratch.select()
		end,
		desc = "select scratch buffer",
	},
	{
		"<leader>n",
		function()
			require("snacks").notifier.show_history()
		end,
		desc = "notification history",
	},
	{
		"<leader>bd",
		function()
			require("snacks").bufdelete()
		end,
		desc = "delete buffer",
	},
	{
		"<leader>cr",
		function()
			require("snacks").rename.rename_file()
		end,
		desc = "rename file",
	},
	{
		"<leader>gb",
		function()
			require("snacks").gitbrowse()
		end,
		desc = "git browse",
		mode = { "n", "v" },
	},
	{
		"<leader>gg",
		function()
			require("snacks").lazygit()
		end,
		desc = "lazygit",
	},
	{
		"<leader>un",
		function()
			require("snacks").notifier.hide()
		end,
		desc = "dismiss all notifications",
	},
	{
		"<c-/>",
		function()
			require("snacks").terminal()
		end,
		desc = "toggle terminal",
	},
	{
		"<c-_>",
		function()
			require("snacks").terminal()
		end,
		desc = "which_key_ignore",
	},
	{
		"]]",
		function()
			require("snacks").words.jump(vim.v.count1)
		end,
		desc = "next reference",
		mode = { "n", "t" },
	},
	{
		"[[",
		function()
			require("snacks").words.jump(-vim.v.count1)
		end,
		desc = "prev reference",
		mode = { "n", "t" },
	},
}

return M
