return {
  -- override nvim-lspconfig clangd only (keeps everything else)
  -- remove manually if project is not esp32
  -- no easier solution found...
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        clangd = {
          cmd = {
            "/home/pierre/.espressif/tools/esp-clang/esp-20.1.1_20250829/esp-clang/bin/clangd",
            "--compile-commands-dir=build",
            "--query-driver=/home/pierre/.espressif/tools/xtensa-esp-elf/esp-15.2.0_20251204/xtensa-esp-elf/bin/xtensa-esp32-elf-gcc",
            "--background-index",
            "--header-insertion=iwyu", -- used for code action
            "--clang-tidy", -- used for code action
            "--enable-config", -- used for code action
          },
        },
      },
    },
  },
}
