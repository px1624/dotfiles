return {
  src = 'https://github.com/mason-org/mason-lspconfig.nvim',
  priority = 20,
  version = 'v2.3.0',
  config = function ()
    require("mason-lspconfig").setup({
      ensure_installed = { 'lua_ls', 'clangd' }
    })
  end
}
