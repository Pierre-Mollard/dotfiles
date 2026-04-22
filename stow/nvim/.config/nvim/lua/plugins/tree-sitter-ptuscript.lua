return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "typescript",
        "ptuscript"
      })
      vim.filetype.add({ extension = { ptu = "ptuscript" } })
      vim.treesitter.language.add('ptuscript', { path = "/home/pierre/projects/tree-sitter-ptuscript/ptuscript.so" })
      vim.treesitter.language.register('ptuscript', { 'ptu' })
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt_local.foldlevel = 99
      vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indent.get_indent()"
      end,
    }
 }
