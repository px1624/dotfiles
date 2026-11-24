-- highlight when yanking (copying) text
-- see `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('user: highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank{ higroup = 'Visual', timeout = 150} end,
})

