local M = {}

M.setup = function()
  vim.keymap.set("n", "gk", vim.diagnostic.open_float)

  -- Fixed direction: [ is usually 'previous', ] is 'next'
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump { count = -1, float = true }
  end)
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump { count = 1, float = true }
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
    { name = 'textDocument/rename',         keymap = '<leader>rn', action = vim.lsp.buf.rename },
    { name = 'textDocument/implementation', keymap = 'gi',         action = vim.lsp.buf.implementation },
    { name = 'textDocument/codeAction',     keymap = '<leader>ca', action = vim.lsp.buf.code_action },
    { name = 'textDocument/definition',     keymap = 'gd',         action = vim.lsp.buf.definition },
    -- Formatting is handled separately below to support the "filter" option
  }

  for _, v in ipairs(lsp_method_map) do
    vim.keymap.set('n', v.keymap, v.action, { buffer = buffer })
  end

  -- Manual format keymap
  if client.supports_method('textDocument/formatting') then
    vim.keymap.set('n', '<leader>fm', function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = buffer })

    -- Format on Save (BufWritePre)
    -- We use a specific group to avoid duplicating the autocommand
    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = buffer })

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = buffer,
      callback = function()
        vim.lsp.buf.format({
          bufnr = buffer,
          id = client.id,
          -- IMPORTANT: Prioritize Ruff for formatting, ignore Basedpyright formatting
          filter = function(c)
            return c.name == "ruff" or c.name ~= "basedpyright"
          end
        })
      end
    })
  end
end

-- Typo fixed here (capabilites -> capabilities)
M.capabilities = require('cmp_nvim_lsp').default_capabilities()

M.handler = function(server_name)
  local opts = {
    capabilities = M.capabilities, -- Updated to use the fixed variable
    on_attach = M.on_attach,
  }

  -- 1. Lua Configuration
  if server_name == "lua_ls" then
    opts.settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
      },
    }
  end

  -- 2. Python: Basedpyright (IntelliSense)
  if server_name == "basedpyright" then
    opts.settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = "standard",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "openFilesOnly",
        },
      },
    }
  end

  -- 3. Python: Ruff (Linting & Formatting)
  if server_name == "ruff" then
    -- We wrap on_attach specifically for Ruff to disable hover
    opts.on_attach = function(client, bufnr)
      client.server_capabilities.hoverProvider = false
      M.on_attach(client, bufnr)
    end
  end

  -- 4. Emmet: Templ support
  if server_name == "emmet_language_server" then
    opts.filetypes = {
      "html", "css", "scss", "javascriptreact", "typescriptreact", "haml", "xml", "templ"
    }
  end

  -- 5. gopls dev tag
  if server_name == "gopls" then
    opts.settings = {
      gopls = {
        buildFlags = { "-tags=dev" },
      },
    }
  end


  -- Using your requested syntax
  vim.lsp.config(server_name, opts)
  vim.lsp.enable(server_name)
end

return M
