return {
  src = 'https://github.com/catppuccin/nvim',
  name = 'catppuccin',
  priority = 10,
  config = function()
    require('catppuccin').setup {
      flavour = 'mocha',
      float = {
        transparent = true, -- removes dark mantle bg from NormalFloat & FloatBorder
        solid = false,
      },
      custom_highlights = function(colors)
        return {
          -- Autocomplete menu
          Pmenu = { bg = colors.base },
          PmenuBorder = { fg = colors.blue, bg = colors.base },
          -- Autocomplete popup
          NormalFloat = { bg = colors.mantle },
        }
      end,
    }
    vim.cmd.colorscheme('catppuccin')
  end
}

