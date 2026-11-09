return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  branch = "main",
  config = function ()
    local ts = require("nvim-treesitter")
    ts.setup{}
    ts.install {
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "javascript",
      "html",
      "css",
      "cuda",
      "cpp",
      "python"
    }
  end
}
