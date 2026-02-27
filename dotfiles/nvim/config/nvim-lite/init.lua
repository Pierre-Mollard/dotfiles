-- This is neovim config entry point
require("lite")

-- Use NeoVim 0.12 vim.pack internal plugin manager
local plugins = require("plugins")
local specs = {}
for _, p in ipairs(plugins) do
	table.insert(specs, p.spec)
end

vim.pack.add(specs, { load = true, confirm = true })

for _, p in ipairs(plugins) do
	if type(p.config) == "function" then
		local ok, err = pcall(p.config)
		if not ok then
			vim.notify(err, vim.log.levels.ERROR)
		end
	end
end
