local default = require("nvchad.configs.lspconfig")

local function get_root()
  return vim.fs.dirname(vim.fs.find({ ".git", "compile_commands.json", "Makefile" }, { upward = true })[1])
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "c", "h", "hpp" },
  callback = function()
    vim.lsp.start({
      name = "clangd",
      cmd = { "clangd" },
      root_dir = get_root(),
      on_attach = default.on_attach,
      on_init = default.on_init,
      capabilities = default.capabilities,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.lsp.start({
      name = "html",
      cmd = { "vscode-html-language-server", "--stdio" },
      root_dir = get_root(),
      on_attach = default.on_attach,
      on_init = default.on_init,
      capabilities = default.capabilities,
    })
  end,
})
