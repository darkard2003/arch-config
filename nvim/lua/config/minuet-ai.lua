local vectorcode_available = vim.fn.executable("vectorcode") == 1

local RAG_CONTEXT_SIZE = 8000
local TOTAL_CTX_SIZE = 16000

local cacher = nil
local vc_config = nil
local has_vc_conf = false

if vectorcode_available then
  require('vectorcode').setup({
    async_opts = {
      debounce = 300, -- Wait 300ms after typing before searching
      events = { "BufWritePost", "InsertEnter", "CursorHold" },
      n_query = 1,
      notify = false, -- Disable noisy notifications
    },

    on_setup = {
      update = true, -- Equivalent to 'auto_index'
    },
    timeout_ms = 5000,
  })

  has_vc_conf, vc_config = pcall(require, 'vectorcode.config')
  if has_vc_conf then
    cacher = vc_config.get_cacher_backend()
  end
end

require('minuet').setup {
  provider = 'openai_fim_compatible',
  n_completions = 1,
  context_window = TOTAL_CTX_SIZE,

  provider_options = {
    openai_fim_compatible = {
      api_key = 'TERM',
      name = 'Ollama',
      end_point = 'http://darkmac:11434/v1/completions',
      model = 'qwen2.5-fast-complete',
      stream = true,

      optional = { max_tokens = 128 },

      template = {
        prompt = function(pref, suff, _)
          local prompt_message = ''


          if has_vc_conf then
            if cacher and cacher.query_from_cache then
              local results = cacher.query_from_cache(0) -- 0 = Current Buffer
              for _, file in ipairs(results) do
                prompt_message = prompt_message ..
                    '<|file_sep|>' .. file.path .. '\n' .. file.document .. '\n'
              end
            end
          end

          prompt_message = vim.fn.strcharpart(prompt_message, 0, RAG_CONTEXT_SIZE)

          return prompt_message ..
              '<|file_sep|>\n' ..
              '<|fim_prefix|>' .. pref ..
              '<|fim_suffix|>' .. suff ..
              '<|fim_middle|>'
        end,
        suffix = false,
      },
    },
  },
  throttle = 100,
  debounce = 200,
}
