return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = true,
  ft = 'dart',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim', -- optional for vim.ui.select
    'mfussenegger/nvim-dap',
  },
  config = function()
    local lsp = require "config.lsp"
    require("flutter-tools").setup {
      fvm = true,
      debugger = {
        enabled = true,
      },
      widget_guides = {
        enabled = true,
      },
      lsp = {
        color = { -- show the derived colours for dart variables
          enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
          background = true, -- highlight the background
          -- background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
          foreground = false, -- highlight the foreground
          virtual_text = true, -- show the highlight using virtual text
          virtual_text_str = "■", -- the virtual text character to highlight
        },
        capabilities = lsp.capabilities,
        on_attach = lsp.on_attach,
      },
      dev_log = {
        enabled = false,
      },
    }
    vim.keymap.set('n', '<leader>fn', require('telescope').extensions.flutter.commands, { desc = "Load flutter tools" })
  end
}
