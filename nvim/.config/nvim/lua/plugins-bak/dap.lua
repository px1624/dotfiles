return {
  { -- Install and config debugger adapter
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'mfussenegger/nvim-dap',
      'williamboman/mason.nvim',
    },
    opts = {
      ensure_installed = {
        'cppdbg'
      },
      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
        cppdbg = function(config)
          config.filetypes = { 'cuda' }
          require('mason-nvim-dap').default_setup(config)
        end
      }
    },
  },
  { -- Debugger UI
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio'
    },
    opts = {},
    config = function(_, opts)
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup(opts)
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ap [C]ontinue'})
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ap toggle [B]reakpoint'})
      vim.keymap.set('n', '<leader>dt', function()
        dap.terminate()
        dapui.close()
      end, { desc = '[D]ap [T]erminate'})
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
    end
  }
}
