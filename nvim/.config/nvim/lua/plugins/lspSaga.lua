return {
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",  -- lazy-load propre
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- requis pour le rendu Markdown
			"nvim-tree/nvim-web-devicons",     -- optionnel (icônes)
		},
		config = function()
			require("lspsaga").setup({
				ui = {
					border = "rounded",          -- bordures nettes
					devicon = true,              -- icônes si dispo
					title = true,
				},
				hover = {
					max_width = 0.9,
					max_height = 0.8,
					open_link = "gx",            -- ouvrir les liens depuis la doc
					-- open_cmd auto: xdg-open (Linux), open (macOS)…
				},
				lightbulb = {
					enable = false,              -- évite le “bulb” si tu n’en veux pas
					sign = false,
					virtual_text = false,
				},
				symbol_in_winbar = {
					enable = false,              -- évite d’altérer la winbar de NVChad
				},
				definition = {
					edit = "<C-c>o",
					vsplit = "<C-c>v",
					split = "<C-c>i",
					tabe = "<C-c>t",
					quit = "q",
				},
				finder = {
					keys = {
						jump_to = "p",
						edit = "<CR>",
						vsplit = "s",
						split = "i",
						tabe = "t",
						quit = "q",
					},
				},
				-- Les autres modules restent disponibles via :Lspsaga … sans config
			})
		end,
	},

}
