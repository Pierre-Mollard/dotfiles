return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          -- Intercept the LSP initialization for clangd
          on_new_config = function(new_config, new_root_dir)
            -- Detect if the current workspace is an ESP-IDF project.
            -- We do this by checking for the existence of "sdkconfig" or a main component folder.
            local is_esp_project = vim.fn.filereadable(new_root_dir .. "/sdkconfig") == 1
              or vim.fn.filereadable(new_root_dir .. "/sdkconfig.defaults") == 1

            if is_esp_project then
              -- Override with the custom ESP-IDF clangd and cross-compiler
              new_config.cmd = {
                "/home/pierre/.espressif/tools/xtensa-esp-elf/esp-15.2.0_20251204/xtensa-esp-elf/bin/xtensa-esp32-elf-gcc",
                "--compile-commands-dir=" .. new_root_dir .. "/build",
                "--query-driver=/home/pierre/.espressif/tools/xtensa-esp-elf/esp-15.2.0_20251204/xtensa-esp-elf/bin/xtensa-esp32-elf-gcc",
                "--background-index",
                "--header-insertion=iwyu",
                "--clang-tidy",
                "--enable-config",
              }
            end

            -- If it's NOT an ESP project, the `cmd` is left untouched,
            -- and LazyVim will fall back to your system's default `clangd`
          end,
        },
      },
    },
  },
}
