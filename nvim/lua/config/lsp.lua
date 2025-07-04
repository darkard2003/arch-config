local M = {}


M.setup = function()
  vim.keymap.set("n", "gk", vim.diagnostic.open_float)
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump {
      count = 1,
      float = true,
    }
  end)
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump {
      count = -1,
      float = true,
    }
  end)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  vim.diagnostic.config({
    virtual_text = {
      prefix = '',
      spacing = 4,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = signs.Error,
        [vim.diagnostic.severity.WARN] = signs.Warn,
        [vim.diagnostic.severity.HINT] = signs.Hint,
        [vim.diagnostic.severity.INFO] = signs.Info,
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = 'rounded',
      focusable = false,
      style = 'minimal',
      header = '',
      prefix = '',
    },
  })
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
    vim.keymap.set('n', v.keymap, v.action, { buffer = buffer })
    if v.name == 'textDocument/formatting' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = buffer,
        callback = function()
          vim.lsp.buf.format({ bufnr = buffer, id = client.id })
        end
      })
    end
  end
end


M.capabilites = require('cmp_nvim_lsp').capabilites

M.handler = function(server_name)
  local opts = {
    capabilites = M.capabilites,
    on_attach = M.on_attach,
  }
  if server_name == "lua_ls" then
    local lua_opts = {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = {
              'lua/?.lua',
              'lua/?/init.lua',
            },
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
            }
          },
        },
      },
    }
    opts = vim.tbl_deep_extend("force", opts, lua_opts)
  end
  require('lspconfig')[server_name].setup(opts)
end



return M
