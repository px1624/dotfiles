local function set_colorscheme(colorscheme)
  local default = 'catppuccin'
  local ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
  if not ok then
    vim.cmd.colorscheme(default)
  end
end

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
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000, config = set_colorscheme },
}
