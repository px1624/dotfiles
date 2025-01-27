local adapters = {
  gdb = {
    type = 'executable',
    command = 'gdb',
    args = { '--interpreter=dap', '--eval-command', 'set print pretty on' }
  }
}

local dap_config = {
  c = {
    {
      name = 'Launch',
      type = 'gdb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopAtBeginningOfMainSubprogram = false,
    },
  }
}
dap_config.cpp = dap_config.c
dap_config.cuda = dap_config.cpp

return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')
      dap.adapters = adapters
      dap.configurations = dap_config
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio'
    },
    config = function(_, opts)
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup(opts)
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end
  }
}
