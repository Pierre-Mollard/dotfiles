return {
  -- 1. OpenCode Neovim Bridge (Primary Assistant via side tmux pane)
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      -- Snacks enhances the input prompts and fuzzy picker if you use LazyVim defaults
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...)
                return require("opencode").snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      vim.o.autoread = true -- Automatically reload buffers when OpenCode writes to disk

      -- OpenCode Keymaps mapped directly under <leader>a
      vim.keymap.set({ "n", "x" }, "<leader>aa", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask OpenCode (@this)" })

      vim.keymap.set({ "n", "x" }, "<leader>as", function()
        require("opencode").select()
      end, { desc = "Select OpenCode Action" })

      vim.keymap.set({ "n", "t" }, "<leader>at", function()
        require("opencode").toggle()
      end, { desc = "Toggle / Focus OpenCode" })

      vim.keymap.set({ "n", "x" }, "<leader>ao", function()
        return require("opencode").operator("@this ")
      end, { desc = "Add Range to OpenCode", expr = true })
    end,
  },

  -- 2. CodeCompanion Plugin (Fallback under <leader>ac*)
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      local progress_handle = nil

      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequest*",
        callback = function(request)
          if request.match == "CodeCompanionRequestStarted" then
            local success, progress = pcall(require, "fidget.progress")
            if success then
              progress_handle = progress.handle.create({
                title = "CodeCompanion",
                lsp_client = { name = "Gemini" },
                message = "Thinking...",
              })
            end
          elseif request.match == "CodeCompanionRequestFinished" then
            if progress_handle then
              progress_handle:finish()
              progress_handle = nil
            end
          end
        end,
      })
    end,
    opts = {
      strategies = {
        chat = {
          adapter = "gemini",
          roles = {
            llm = "Gemini",
            user = "Me",
          },
          tools = {
            ["files"] = {
              callback = "strategies.chat.tools.files",
              description = "Inspect workspace files",
            },
          },
          keymaps = {
            close = {
              modes = { n = "q", i = "<C-x>" },
              index = 3,
              callback = "keymaps.close",
              description = "Close Chat",
            },
            stop = {
              modes = { n = "<C-c>" },
              index = 4,
              callback = "keymaps.stop",
              description = "Stop Request",
            },
          },
        },
        inline = {
          adapter = "gemini",
          layout = "vertical", -- View diffs vertically next to original buffer
        },
        agent = { adapter = "gemini" },
      },
      adapters = {
        http = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = "cmd:echo $GEMINI_API_KEY",
              },
              schema = {
                model = {
                  default = "gemini-3.8-flash",
                  choices = {
                    ["gemini-2.5-flash"] = { opts = { can_reason = true } },
                    ["gemini-1.5-flash"] = { opts = { can_reason = false } },
                  },
                },
              },
            })
          end,
        },
      },
      display = {
        diff = {
          enabled = true,
          close_chat_at = 240, -- Auto-format diff presentation
          layout = "vertical",
        },
        chat = {
          window = {
            layout = "vertical",
            width = 0.35,
          },
          show_settings = false,
        },
      },
      prompt_library = {
        ["Explain Code (Verbose)"] = {
          strategy = "chat",
          description = "Explain the highlighted code in extreme detail",
          opts = {
            short_name = "explain",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = "You are a senior systems engineer. Explain the code clearly with performance and memory considerations.",
            },
            {
              role = "user",
              content = function(context)
                -- Fallback to an empty string if there is no selection
                local text = context.selection or ""
                return "Explain this code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```"
              end,
            },
          },
        },
        ["Fix LSP Diagnostic"] = {
          strategy = "inline",
          description = "Fix compile or linter issues at the cursor",
          opts = {
            short_name = "fix",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = "You are an expert compiler engineer. Correct the code to eliminate the reported diagnostics without altering logic.",
            },
            {
              role = "user",
              content = function(context)
                return "Fix the diagnostic errors in this code selection:\n\n"
                  .. "```"
                  .. context.filetype
                  .. "\n"
                  .. context.selection
                  .. "\n```\n\n"
                  .. "Diagnostics:\n"
                  .. vim.inspect(context.diagnostics)
              end,
            },
          },
        },
        ["Generate Conventional Commit"] = {
          strategy = "chat",
          description = "Draft a conventional commit message from staged git diff",
          opts = {
            short_name = "commit",
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = function()
                return "Write a conventional commit message for the following git diff:\n\n```diff\n"
                  .. vim.fn.system("git diff --staged")
                  .. "\n```"
              end,
            },
          },
        },
      },
    },
    keys = {
      -- Nested under <leader>ac to keep top-level bindings for OpenCode
      { "<leader>acc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat (CodeCompanion)" },
      { "<leader>aca", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to Chat (CodeCompanion)" },
      { "<leader>aci", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline Prompt (CodeCompanion)" },
      { "<leader>acx", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Actions Palette (CodeCompanion)" },
    },
  },

  -- 3. WhichKey Integration for <leader>a
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai", icon = { icon = "󰚩", color = "white" }, mode = { "n", "v" } },
        { "<leader>ac", group = "codecompanion", icon = { icon = "󰘦", color = "cyan" }, mode = { "n", "v" } },
      },
    },
    opts_extend = { "spec" },
  },

  -- 4. Fidget to show loading notification
  {
    "j-hui/fidget.nvim",
    opts = {
      progress = {
        display = {
          done_icon = "✓", -- Icon shown when the AI finishes
        },
      },
      notification = {
        window = {
          winblend = 0, -- Respects transparent themes
        },
      },
    },
  },
}
