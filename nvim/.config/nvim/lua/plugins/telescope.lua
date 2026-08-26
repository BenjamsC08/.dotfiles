return {
	{
		"nvim-telescope/telescope.nvim",
		opts = function(_, opts)
			local actions = require "telescope.actions"
			local action_state = require "telescope.actions.state"

			local open_selections = function(prompt_bufnr)
				local picker = action_state.get_current_picker(prompt_bufnr)
				local selections = picker:get_multi_selection()
				if vim.tbl_isempty(selections) then
					actions.select_default(prompt_bufnr)
					return
				end
				actions.close(prompt_bufnr)
				for _, entry in ipairs(selections) do
					local path = entry.path or entry.filename or entry.value or entry[1]
					if path then
						vim.cmd.edit(vim.fn.fnameescape(path))
					end
				end
			end

			opts.defaults = opts.defaults or {}
			opts.defaults.prompt_prefix = "   "
			opts.defaults.sorting_strategy = "ascending"
			opts.defaults.layout_config = {
				horizontal = {
					prompt_position = "top",
					preview_width = 0.55,
				},
				width = 0.87,
				height = 0.80,
			}
			opts.defaults.vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--glob",
				"!*.o",
				"--glob",
				"!*.d",
			}
			opts.defaults.file_ignore_patterns = { "%.o$", "%.d$" }
			opts.defaults.mappings = vim.tbl_deep_extend("force", opts.defaults.mappings or {}, {
				i = {
					["<C-s>"] = actions.select_default,
					["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					["<C-a>"] = open_selections,
				},
				n = {
					["q"] = actions.close,
					["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					["<C-a>"] = open_selections,
				},
			})

			opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
				find_files = {
					hidden = true,
				},
				live_grep = {
					additional_args = function()
						return { "--glob", "!*.o", "--glob", "!*.d" }
					end,
				},
			})

			return opts
		end,
	},
}
