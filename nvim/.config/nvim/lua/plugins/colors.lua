return {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    init = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_enable_italic = true
    end
  },
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 }
}
