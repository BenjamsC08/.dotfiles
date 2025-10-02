require "nvchad.options"

-- add yours here!

-- Dans un fichier options.lua ou dans votre fichier config.lua
vim.opt.expandtab = false
vim.opt.cindent = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.relativenumber = true


vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = '1'

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
