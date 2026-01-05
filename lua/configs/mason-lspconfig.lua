if vim.lsp == nil then
  vim.lsp = {}
end

if type(vim.lsp.enable) ~= "function" then
  -- No-op; masonry checks will call this but for 0.10 we don't need/expect real behavior.
  vim.lsp.enable = function() end
end

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "clangd" },
  automatic_installation = false,
  handlers = {},
})

