-- leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- don't show mode, status bar already does that
vim.o.showmode = false

-- relative line number
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
-- show invisible chars
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', space = '·', nbsp = '␣' }

-- column width display for tab
vim.o.tabstop = 4
-- spaces to advance per tab/backspace
vim.o.softtabstop = 4
-- columns to shift for >>, <<, = operations, matches tabstop
vim.o.shiftwidth = 4
-- expand tabs to spaces
vim.o.expandtab = true
-- syntax aware indent
vim.o.smartindent = true

-- auto complete on tab
vim.o.wildmenu = true
-- longest matching subsequence on first press, cycle through on subsequence presses
vim.o.wildmode = 'longest:full,full'

-- highlght search
vim.o.hlsearch = true
-- show partial search results while typing
vim.o.incsearch = true
-- case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- enables 24-bit true color
vim.o.termguicolors = true
-- dark mode
vim.o.background = 'dark'

-- lines to keep visible above and below while scrolling
vim.o.scrolloff = 8

-- time (ms) to wait for CursorHold event and swap file writes
vim.o.updatetime = 50

-- vertical line guide
vim.o.colorcolumn = "100"

-- netrw one file per line with size and timestamp
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
