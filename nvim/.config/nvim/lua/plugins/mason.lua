return {

  src = 'https://github.com/mason-org/mason.nvim',
  priority = 10,
  version = 'v2.3.1',
  config = function()
    require('mason').setup { }
  end
}
