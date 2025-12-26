return {
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require('minuet').setup {
      provider = 'openai_fim_compatible',
      n_completions = 1,     -- Best for 1.5B to stay near-instant
      context_window = 2048, -- Increased from 512 for better logic/imports awareness

      provider_options = {
        openai_fim_compatible = {
          api_key = 'TERM', -- Required placeholder for local servers
          name = 'Ollama',
          end_point = 'http://darkmac.local:11434/v1/completions',
          model = 'qwen2.5-fast-complete',
          optional = {
            max_tokens = 64,   -- Slightly more than 56 to allow for full function signatures
            temperature = 0.0, -- Force deterministic code
            top_p = 0.9,
            num_ctx = 2048,
            keep_alive = -1,
          },
        },
      },
      throttle = 100, -- milliseconds between requests while typing
      debounce = 200, -- wait until typing stops for 200ms
    }
  end,
}
