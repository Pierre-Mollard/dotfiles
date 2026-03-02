-- This is neovim config entry point
require("lite")

-- Use NeoVim 0.12 vim.pack internal plugin manager
local plugins = require("plugins")
local specs = {}
for _, p in ipairs(plugins) do
	table.insert(specs, p.spec)
end
vim.pack.add(specs, { load = true, confirm = true })

-- Apply keybinds from configurations
local function apply_keys(keys)
	for _, k in ipairs(keys or {}) do
		local lhs, rhs = k[1], k[2]
		local mode = k.mode or "n"
		local opts = {
			desc = k.desc,
			silent = (k.silent ~= false),
			nowait = k.nowait,
			remap = k.remap,
			expr = k.expr,
		}
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end
for _, p in ipairs(plugins) do
	if type(p.config) == "function" then
		local ok, err = pcall(p.config)
		if not ok then
			vim.notify(err, vim.log.levels.ERROR)
		end
		apply_keys(p.keys)
	end
end
