-- on startup
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('vim_startup', { clear = true }),
  callback = function()
    local cur_path = vim.fn.expand('%:p:h')
    vim.cmd('cd ' .. cur_path)
  end
})
