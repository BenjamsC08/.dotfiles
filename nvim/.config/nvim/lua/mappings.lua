require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader><Down>", "yyp", { desc = "Duplicate line below" })
map("n", "<A-Down>", ":m +1<CR>", { desc = "Move line down" })
map("n", "<A-Up>", ":m -2<CR>", { desc = "Move line up" })

-- map('n', )

-- map("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover doc (Lspsaga)" })
map("n", "gk", "<cmd>Lspsaga hover_doc ++keep<CR>", { desc = "Floating fun def" })
map("n", "ge", "<cmd>Lspsaga show_workspace_diagnostics<CR>", { desc = "Floating code error" })

map("n", "gd","<cmd>Lspsaga goto_definition<CR>", {desc ="Go to definition"})
    -- ["gD"] = { "<cmd>Lspsaga goto_declaration<CR>", "Go to declaration" }
    -- ["<leader>ca"] = { "<cmd>Lspsaga code_action<CR>", "Code action" }
    -- ["<leader>rn"] = { "<cmd>Lspsaga rename<CR>", "Rename" }
    -- ["<leader>fi"] = { "<cmd>Lspsaga finder<CR>", "Finder (references/declarations)" }


-- local on_attach = function(client, bufnr)
-- map('n', '<A-<LeftMouse>>', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to definition' })
--

map("n", "<leader>qf", function()
  local entry = string.format(
    "%s:%d: %s",
    vim.fn.expand("%:p"),
    vim.fn.line("."),   
    vim.fn.getline(".")
  )
  vim.cmd("caddexpr '" .. entry .. "'")
end, { desc = "Add current line to quickfix" })
