return {
  "cursortab/cursortab.nvim",
  build = "cd server && go build",
  keys = {
    { "<C-Tab>", "Trigger" }
  },
  config = function()
    require("cursortab").setup({
      provider = {
        type = "sweep",
        url = "http://darkmac:11434",
        model = "sweepai/sweep-next-edit",
      },
      keymaps = {
        accept = "<Tab>",
        partial_accept = "<S-Tab>",
        trigger = "<C-Tab>",
      },
    })
  end,
}
