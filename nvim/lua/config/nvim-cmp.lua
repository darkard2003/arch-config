local cmp = require 'cmp'
local lspkind = require 'lspkind'
local luasnip = require 'luasnip'

require("luasnip.loaders.from_vscode").lazy_load()

vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#6CC644" })

cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      symbol_map = {
        Copilot = "",
        Supermaven = "",
        Ollama = "󱚣",
      },
      before = function(entry, vim_item)
        if entry.source.name == "minuet" then
          vim_item.kind = "Ollama"
          vim_item.kind_hl_group = "CmpItemKindCopilot"
        end
        return vim_item
      end,
      maxwidth = {
        menu = 50,
        abbr = 50,
      },
      ellipsis_char = '...',
      show_labelDetails = true,
    })
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    before = function(entry, vim_item)
      -- Map the source 'minuet' to the symbol 'Minuet'
      if entry.source.name == "minuet" then
        vim_item.kind = "Minuet"
        vim_item.kind_hl_group = "CmpItemKindCopilot"
      end
      return vim_item
    end
  }),
  sources = cmp.config.sources({
    { name = 'minuet',     group_index = 1 },
    { name = "cmp-ai",     group_index = 1 },
    { name = "supermaven", group_index = 1 },
    { name = "copilot",    group_index = 2 },
    { name = 'nvim_lsp',   group_index = 2 },
    { name = 'luasnip',    group_index = 2 }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  }),
  performence = {
    fetching_timeout = 2000,
  },
  experimental = {
    ghost_text = true,
  }
})
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})
