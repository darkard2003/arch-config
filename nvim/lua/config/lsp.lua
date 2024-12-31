local M = {}

M.setup = function()
  vim.keymap.set("n", "gk", vim.diagnostic.open_float)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end



M.on_attach = function(client, buffer)
  local lsp_method_map = {
    {
      name = 'textDocument/rename',
      keymap = '<leader>rn',
      action = vim.lsp.buf.rename,
    },
    {
      name = 'textDocument/implementation',
      keymap = 'gi',
      action = vim.lsp.buf.implementation,
    },
    {
      name = 'textDocument/codeAction',
      keymap = '<leader>ca',
      action = vim.lsp.buf.code_action,
    },
    {
      name = 'textDocument/formatting',
      keymap = '<leader>fm',
      action = vim.lsp.buf.format,
    },
    {
      name = 'textDocument/definition',
      keymap = 'gd',
      action = vim.lsp.buf.definition
    },
  }

  for _, v in ipairs(lsp_method_map) do
    -- if client.supports_method(v.name) then
    vim.keymap.set('n', v.keymap, v.action, { buffer = buffer })
    if v.name == 'textDocument/formatting' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = buffer,
        callback = function()
          vim.lsp.buf.format({ bufnr = buffer, id = client.id })
        end
      })
    end
    -- end
  end
end


M.capabilites = require('cmp_nvim_lsp').capabilites

M.handlers = {
  function(server_name)
    local opts = {
      capabilites = M.capabilites,
      on_attach = M.on_attach,
    }
    if server_name == "lua_ls" then
      local lua_opts = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      }
      opts = vim.tbl_deep_extend("force", lua_opts, opts)
    end
    require('lspconfig')[server_name].setup(opts)
  end
}

return M
