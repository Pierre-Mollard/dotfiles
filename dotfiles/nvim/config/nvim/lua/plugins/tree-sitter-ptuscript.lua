return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
      vim.filetype.add({ extension = { ptu = "ptuscript" } })
      vim.treesitter.language.add('ptuscript', { path = "/home/pierre/projects/tree-sitter-ptuscript/ptuscript.so" })
      vim.treesitter.language.register('ptuscript', { 'ptu' })
    end,
  }
}
