return {
  src = 'https://github.com/nvim-lualine/lualine.nvim',
  priority = 20,
  config = function()
    local ll = require('lualine')
    ll.setup {
      options = {
        theme = 'catppuccin-mocha',
      },
      sections = {
        lualine_c = {
          {
            'filename',
            path = 1,
          }
        }
      }
    }
  end
}
