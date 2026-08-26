return {
	{
		"stevearc/conform.nvim",
		opts = require "configs.conform",
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require "configs.lspconfig"
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			git = {
				enable = true,
				ignore = false,
			},
			filters = {
				dotfiles = false,
				custom = { "*.o", "*.d", "^.git$" },
			},
		},
	},
}
