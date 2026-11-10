-- on startup
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('vim-startup', { clear = true }),
  callback = function()
    local cur_path = vim.fn.expand('%:p:h')
    vim.cmd('cd ' .. cur_path)
  end
})

-- highlight when yanking (copying) text
-- see `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank{ higroup = 'Visual', timeout = 300} end,
})
