return {
  -- 1. CodeCompanion Plugin
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
            -- Safely create a new progress notification in Fidget
            local success, progress = pcall(require, "fidget.progress")
            if success then
              progress_handle = progress.handle.create({
                title = "CodeCompanion",
                lsp_client = { name = "Ollama" },
                message = "Thinking...",
              })
            end
          elseif request.match == "CodeCompanionRequestFinished" then
            -- Close the notification when the AI finishes
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
          adapter = "ollama",
          keymaps = {
            close = {
              modes = {
                n = "q",
                i = "<C-x>",
              },
              index = 3,
              callback = "keymaps.close",
              description = "Close Chat",
            },
            stop = {
              modes = {
                n = "<C-c>",
              },
              index = 4,
              callback = "keymaps.stop",
              description = "Stop Request",
            },
          },
        },
        inline = { adapter = "ollama" },
        agent = { adapter = "ollama" },
      },
      adapters = {
        ollama = function()
          local ollama_url = vim.env.OLLAMA_HOST or "http://127.0.0.1:11434"

          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = ollama_url,
            },
            schema = {
              model = {
                default = "qwen2.5-coder:7b",
              },
            },
          })
        end,
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
          },
        },
      },
      prompt_library = {
        ["Explain Code (Verbose)"] = {
          strategy = "chat",
          description = "Explain the highlighted code in extreme detail",
          opts = {
            index = 1,
            is_default = true,
            is_slash_cmd = false,
            short_name = "explain",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = "You are a senior developer. Explain the following code to a junior developer. Be extremely verbose.",
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
      },
    },
    keys = {
      -- Chat operations
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat" },
      { "<leader>aa", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to Chat" },

      -- Inline & Actions
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline Prompt" },
      { "<leader>ax", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Action Palette" },
    },
  },

  -- 2. WhichKey Integration for <leader>a
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        {
          "<leader>a",
          group = "ai",
          icon = { icon = "󰚩", color = "white" },
          mode = { "n", "v" },
        },
      },
    },
    opts_extend = { "spec" },
  },

  -- 3. Fidget to show loading notification
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
          winblend = 0, -- Set to 0 to respect your transparent Tokyo Night theme
        },
      },
    },
  },
}
