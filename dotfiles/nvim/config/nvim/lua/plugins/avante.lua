return {
  "yetone/avante.nvim",
  opts = {
    provider = "ollama",
    providers = {
      ollama = {
        endpoint = "http://127.0.0.1:11434",
        model = "qwen2.5-coder:14b",
        -- Required: checks that Ollama is actually running
        is_env_set = require("avante.providers.ollama").check_endpoint_alive,
        timeout = 60000, -- local models can be slow
        extra_request_body = {
          options = {
            temperature = 0.7,
            num_ctx = 16384, -- adjust based on your RAM
            keep_alive = "5m",
          },
        },
      },
    },
  },
}
