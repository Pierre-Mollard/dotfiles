-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.filetype.add({ extension = { ptu = "ptuscript" } })

vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').ptuscript = {
      install_info = {
        path = '/home/pierre/projects/tree-sitter-ptuscript',
        -- optional entries
        location = 'parser',
        generate = true,
        generate_from_json = false,
        queries = 'queries/ptuscript',
      },
    }
  end
})

vim.treesitter.language.register('ptuscript', { 'ptu' })
