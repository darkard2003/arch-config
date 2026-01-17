local has_vectorcode, vectorcode_plugin = pcall(require, 'vectorcode')
local vectorcode_available = has_vectorcode

local RAG_CONTEXT_SIZE = 8000
local TOTAL_CTX_SIZE = 16000

local cacher = nil

if vectorcode_available then
  vectorcode_plugin.setup({
    cli_cmds = {
      vectorcode = "vectorcode",
    },

    async_opts = {
      n_query = 1,
      debounce = 10,
      notify = false,
      run_on_register = true,
    },
  })

  local has_vc_conf, vc_config = pcall(require, 'vectorcode.config')
  if has_vc_conf then
    local status, backend = pcall(vc_config.get_cacher_backend)
    if status then
      cacher = backend
    else
      print("VectorCode: Could not retrieve backend")
    end
  end
else
  print("VectorCode plugin not found!")
end

local function template_function(pref, suff, _)
  local prompt_message = ''

  if cacher then
    local status, results = pcall(cacher.query_from_cache, 0) -- 0 = Current Buffer

    if status and results and #results > 0 then
      print("VC: SUCCESS - Found " .. #results .. " snippets")
      for _, file in ipairs(results) do
        if file.path and file.document then
          prompt_message = prompt_message ..
              '<|file_sep|>' .. file.path .. '\n' .. file.document .. '\n'
        end
      end
    end
  end

  prompt_message = vim.fn.strcharpart(prompt_message, 0, RAG_CONTEXT_SIZE)

  local current_file = vim.fn.expand('%')

  return prompt_message ..
      '<|file_sep|>' .. current_file .. '\n' ..
      '<|fim_prefix|>' .. pref ..
      '<|fim_suffix|>' .. suff ..
      '<|fim_middle|>'
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
      model = 'qwen2.5-fast-complete-mini',
      stream = true,

      optional = {
        stop = { "<|file_sep|>", "<|fim_prefix|>", "<|fim_suffix|>", "<|fim_middle|>", "<|endoftext|>" },
        max_tokens = 128,
      },


      template = {
        prompt = template_function,
        suffix = false,
      },
    },
  },
  throttle = 100,
  debounce = 200,
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    if cacher then
      local has_vc_cacher, vc_cacher_mod = pcall(require, "vectorcode.cacher")

      if has_vc_cacher and vc_cacher_mod.utils and vc_cacher_mod.utils.async_check then
        vc_cacher_mod.utils.async_check("config", function()
          cacher.register_buffer(bufnr, { n_query = 1 })
        end, nil)
      elseif cacher.async_check then
        cacher.async_check("config", function()
          cacher.register_buffer(bufnr, { n_query = 1 })
        end, nil)
      end
    end
  end,
  desc = "Auto-register buffer for VectorCode context",
})
