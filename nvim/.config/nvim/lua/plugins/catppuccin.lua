return { 
  src = 'https://github.com/catppuccin/nvim',
  name = 'catppuccin',
  priority = 10,
  config = function()
    require('catppuccin').setup { flavour = 'mocha' }
    vim.cmd.colorscheme('catppuccin')
  end
}

