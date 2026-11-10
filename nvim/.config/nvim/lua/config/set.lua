-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- mode
vim.opt.showmode = false

-- line
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars:append("space:·")

-- indents
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'

-- search
vim.opt.hlsearch = true
vim.opt.incsearch = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

-- netrw
vim.g.netrw_liststyle = 1


-- clipboard
-- use builtin OSC 52 clipboard provider
vim.g.clipboard = "osc52"
-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  See `:help 'clipboard'`
vim.schedule(function() vim.opt.clipboard = 'unnamedplus' end)
