return {
  src = 'https://github.com/nvim-telescope/telescope.nvim',
  priority = 20,
  version = 'v0.2.2',
  config = function()
    local telescope = require('telescope')
    telescope.setup {
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
    }
    telescope.load_extension('fzf')
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

    -- disable autocomplete on telescope prompt
    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Turn off autocomplete on telescope prompt',
      pattern = 'TelescopePrompt',
      group = vim.api.nvim_create_augroup('plugin: telescope no autocomplete', { clear = true }),
      callback = function()
        vim.bo.autocomplete = false
      end,
    })
  end
}
