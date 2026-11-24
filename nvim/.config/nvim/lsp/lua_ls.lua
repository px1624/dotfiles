-- Library paths are set here, in the initial settings, so lua_ls scans them
-- before its first workspace preload.
local library = {
  vim.env.VIMRUNTIME .. '/lua',
  '${3rd}/luv/library',
}
for _, pack in ipairs(vim.pack.get()) do
  library[#library + 1] = pack.path .. '/lua'
end

return {
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = 'Disable' },
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = library,
      },
    },
  },
}
