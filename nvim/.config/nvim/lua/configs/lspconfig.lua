local default = require "nvchad.configs.lspconfig"

local function get_root(buf)
	local found = vim.fs.find({ ".git", "compile_commands.json", "Makefile" }, {
		upward = true,
		path = vim.api.nvim_buf_get_name(buf or 0),
	})[1]
	if found then
		return vim.fs.dirname(found)
	end
	return vim.uv.cwd()
end

local function start_lsp(name, cmd)
	if vim.fn.executable(cmd[1]) == 0 then
		return
	end
	vim.lsp.start {
		name = name,
		cmd = cmd,
		root_dir = get_root(0),
		on_attach = default.on_attach,
		on_init = default.on_init,
		capabilities = default.capabilities,
	}
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		start_lsp("clangd", { "clangd" })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "html",
	callback = function()
		start_lsp("html", { "vscode-html-language-server", "--stdio" })
	end,
})
