-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

require('config.set')
require('config.autocmd')
require('config.lazy')
require('config.remap')
