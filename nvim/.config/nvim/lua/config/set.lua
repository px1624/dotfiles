-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

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
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

-- netrw
vim.g.netrw_liststyle = 1

-- clipboard
vim.opt.clipboard = "unnamedplus"
