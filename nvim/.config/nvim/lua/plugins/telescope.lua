return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  },
  opts = {
    defaults = {
      file_ignore_patterns = {
        '.git',
        'node_modeules'
      }
    },
    pickers = {
      git_files = { recurse_submodules = true },
    }
  },
  config = function(_, opts)
    require('telescope').setup(opts)
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>fw', function()
      local word = vim.fn.expand('<cword>')
      builtin.grep_string{ search = word }
    end)
    vim.keymap.set('n', '<leader>fW', function()
      local word = vim.fn.expand('<cWORD>')
      builtin.grep_string{ search = word }
    end)
    vim.keymap.set('n', '<leader>fs', function()
      builtin.grep_string{ search = vim.fn.input("Grep > ") }
    end)
    vim.keymap.set('n', '<leader>ne', function()
      builtin.find_files{ cwd = vim.fn.stdpath("config") }
    end)
    vim.keymap.set('n', '<leader>fh', function()
      builtin.find_files{ hidden = true }
    end)
    vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
  end
}
