return {
  src = 'https://github.com/nvim-treesitter/nvim-treesitter',
  priority = 10,
  version = 'main',
  config = function()
    local ts = require('nvim-treesitter')
    ts.setup { install_dir = vim.fn.stdpath('data') .. '/site' }
    ts.install { 
      'lua',
      'c',
      'cpp',
      'cuda',
      'vim',
      'vimdoc',
      'query',
      'javascript',
      'html',
      'css',
      'python',
      'bash'
    }

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Enable treesitter highlighting on filetype change, install parser if missing',
      group = vim.api.nvim_create_augroup('plugin: treesitter hightlight', { clear = true }),
      callback = function(args)
        if args.match == 'netrw' then
          return
        end
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang and vim.tbl_contains(ts.get_available(), lang) then
          ts.install({ lang }):await(function() vim.treesitter.start(args.buf) end)
        end
      end,
    })
  end
}
