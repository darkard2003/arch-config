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
        -- local buftype = vim.bo[bufnr].buftype
        --
        -- if buftype ~= '' and buftype ~= 'help' then
        --   return
        -- end

        local ft = vim.bo[bufnr].filetype
        local lang = vim.treesitter.language.get_lang(ft)

        if not lang then
          return
        end

        local has_parser = vim.tbl_contains(langs, lang)

        if has_parser then
          vim.treesitter.start(bufnr, lang)
        end
      end,
    })
  end,
}
