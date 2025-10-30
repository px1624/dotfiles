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
      },
      path_display = {
        truncate = 3,
        filename_first = {
          reverse_directories = false
        }
      },
    },
    pickers = {
      git_files = { recurse_submodules = true },
      colorscheme = { enable_preview = true },
    },
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                         -- the default case_mode is "smart_case"
      }
    }
  },
  config = function(_, opts)
    require('telescope').setup(opts)
    require('telescope').load_extension('fzf')
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>sch', builtin.colorscheme, {})
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
      builtin.live_grep{ max_results = 5000 }
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
