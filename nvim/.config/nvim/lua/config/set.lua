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
-- case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

-- netrw
vim.g.netrw_liststyle = 1

-- diagnostics
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  jump = {
    on_jump = function (_, bufnr)
      vim.diagnostic.open_float {
        bufnt = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end
  }
}

-- clipboard
local function paste_from_unnamed_reg()
  return function (_)
    local content = vim.fn.getreg('"')
    return vim.split(content, '\n')
  end
end
-- sync clipboard between OS and Neovim.
-- schedule the setting after `UiEnter` because it can increase startup-time.
-- see `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard:append("unnamedplus")
  if (os.getenv('SSH_TTY') ~= nil) then
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
      },
      paste = {
        ['+'] = paste_from_unnamed_reg(),
        ['*'] = paste_from_unnamed_reg(),
      },
    }
  end
end)
