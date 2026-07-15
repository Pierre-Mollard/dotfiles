-- Helper function to find Espressif clangd or fallback to system clangd
local function get_clangd_cmd()
  -- Use glob to find the esp-clangd binary, ignoring the version folder name
  local esp_pattern = vim.fn.expand("~/.espressif/tools/esp-clang/*/esp-clang/bin/clangd")
  local matches = vim.split(vim.fn.glob(esp_pattern), "\n")

  -- Default to system clangd (or Mason's clangd) if ESP-IDF is not found
  local clangd_bin = "clangd"

  -- If we found an esp-clangd binary, use the first one found
  if matches[1] and matches[1] ~= "" then
    clangd_bin = matches[1]
  end

  return {
    clangd_bin,
    "--query-driver="
      .. "**/*-elf-gcc," -- Any ESP32 compiler (Xtensa or RISC-V, anywhere on disk)
      .. "**/*-none-eabi-gcc," -- Any ARM embedded compiler (STM32, RP2040, etc.)
      .. "/usr/bin/gcc," -- Standard Linux C
      .. "/usr/bin/g++," -- Standard Linux C++
      .. "/usr/bin/cc,"
      .. "/usr/bin/c++",
    "--background-index",
    "--header-insertion=iwyu",
    "--enable-config",
  }
end

return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        clangd = {
          mason = false,
          cmd = get_clangd_cmd(),
        },
      },
    },
  },
}
