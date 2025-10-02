return {
  "nvim-telescope/telescope.nvim",
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        mappings = {
          i = { -- Mode insert
            ["<C-s>"] = actions.select_default, -- Ouvre le fichier sous le curseur
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_next, -- Ajoute à la sélection et passe au suivant
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous, -- Ajoute à la sélection et passe au précédent
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- Envoie les sélections à la quickfix list
            ["<C-a>"] = function(prompt_bufnr) -- Nouvelle action pour ouvrir toutes les sélections
              local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              local selections = picker:get_multi_selection()
              if vim.tbl_isempty(selections) then
                actions.select_default(prompt_bufnr) -- Ouvre le fichier sous le curseur si aucune sélection multiple
              else
                actions.close(prompt_bufnr) -- Ferme Telescope
                for _, entry in ipairs(selections) do
                  vim.cmd("edit " .. entry[1]) -- Ouvre chaque fichier sélectionné dans un buffer
                end
              end
            end,
          },
          n = { -- Mode normal
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-a>"] = function(prompt_bufnr)
              local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              local selections = picker:get_multi_selection()
              if vim.tbl_isempty(selections) then
                actions.select_default(prompt_bufnr)
              else
                actions.close(prompt_bufnr)
                for _, entry in ipairs(selections) do
                  vim.cmd("edit " .. entry[1])
                end
              end
            end,
          },
        },
      },
    })
  end,
}
