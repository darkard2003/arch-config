return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local langs = {
      "go",
      "zig",
      "c",
    }
    ts.install(langs)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*", -- Trigger on ALL filetypes
      callback = function(args)
        local bufnr = args.buf
        local ft = vim.bo[bufnr].filetype
        local ignore_fts = {
          "TelescopePrompt",
          "TelescopeResults",
          "cmp_menu",
          "cmp_docs",
          "lazy",
          "mason",
          "NvimTree",
          "neo-tree",
          "notify",
          "prompt",
        }

        if vim.tbl_contains(ignore_fts, ft) then
          return
        end

        local lang = vim.treesitter.language.get_lang(ft)

        if not lang then
          return
        end

        local has_parser = pcall(vim.treesitter.language.add, lang)

        if has_parser then
          vim.treesitter.start(bufnr, lang)
        end
      end,
    })
  end,
}
