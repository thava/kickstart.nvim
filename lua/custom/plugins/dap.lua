-- lua/custom/plugins/dap.lua
-- Configure for Debugging: DAP - Debug Adapter Protocol
-- Extracted from kickstart init.lua

return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  enabled = false, -- disabled by default
  dependencies = {
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Auto open/close UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    local auto_close = true
    if auto_close then
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end

    -- Python debugger
    require("dap-python").setup("python3")

    -- Keymaps only when filetype matches
    local function set_dap_keymaps(bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "<F5>", function() dap.continue() end, opts)
      vim.keymap.set("n", "<F10>", function() dap.step_over() end, opts)
      vim.keymap.set("n", "<F11>", function() dap.step_into() end, opts)
      vim.keymap.set("n", "<F12>", function() dap.step_out() end, opts)
      vim.keymap.set("n", ",b", function() dap.toggle_breakpoint() end, opts)
      vim.keymap.set("n", ",B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, opts)
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "python", "javascript", "typescript" },
      callback = function(args)
        set_dap_keymaps(args.buf)
      end,
    })
  end,
}

