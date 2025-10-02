return {
	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		opts = require "configs.conform",
	},

	-- These are some examples, uncomment them if you want to see them work!
	{
		"neovim/nvim-lspconfig",
		config = function()
			require "configs.lspconfig"
		end,
	},
	-- {
	-- 	"hardyrafael17/norminette42.nvim",
	-- 	keys = { { "<Leader>wf", desc = "activate norm"}},
	-- 	config = function()
	-- 	local norminette = require("norminette")
	-- 	norminette.setup({
	-- 			runOnSave = true,
	-- 			maxErrorsToShow = 5,
	-- 			active = true,
	-- 	})
	-- end,
	-- },

}
