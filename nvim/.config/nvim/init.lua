-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

require('config.options')
require('pack.loader').setup()
require('config.autocmd')
require('config.remap')
