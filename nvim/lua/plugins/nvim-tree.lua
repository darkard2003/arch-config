return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup {
			disable_netrw = true,
			hijack_netrw = true,
			view = {
				side = "right",
			},
		}
		local api = require("nvim-tree.api")
		vim.keymap.set("n", "<leader>e", function() api.tree.toggle() end, { desc = "Toggle nvim-tree" })
	end,
}
