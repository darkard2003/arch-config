return {
  "cursortab/cursortab.nvim",
  keys = "<C-Tab>",
  build = "cd server && go build",
  config = function()
    require("cursortab").setup({
      provider = {
        type = "sweep",
        url = "http://darkmac:11434",
        model = "sweepai/sweep-next-edit",
        context_size = 1024,
        max_tokens = 64,
        top_k = 50,
        max_diff_history_tokens = 64,
      },
      keymaps = {
        accept = "<Tab>",
        partial_accept = "<S-Tab>",
        trigger = "<C-Tab>",
      },
    })
  end,
}
