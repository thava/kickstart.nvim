-- ~/.config/nvim/lua/custom/plugins/codecompanion.lua
return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = {
          adapter = "gemini",
          model = "gemini-2.5-flash-lite",
          use_selection = true,  -- For inline fixes
          shortcircuit_diagnostics = true,
        },
        inline = {
          adapter = "gemini",
          model = "gemini-2.5-flash-lite",
          use_selection = true,
        },
        cmd = {
          adapter = "gemini",
          model = "gemini-2.5-flash-lite"
        },
      },
      -- NOTE: The log_level is in `opts.opts`
      -- :checkhealth codecompanion to know log path
      opts = {
        log_level = "DEBUG",
      },
      context = {
        -- make LSP diagnostics available as chat evidence
        lsp = {
          diagnostics = true,  -- turns pyright messages into context
          references = true,
        },
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)

      -- Command Aliases
      vim.api.nvim_create_user_command("CCC", function()
        vim.cmd("CodeCompanionChat")
      end, { desc = "Alias: CodeCompanionChat" })

      vim.api.nvim_create_user_command("CC", function()
        vim.cmd("CodeCompanion")
      end, { desc = "Alias: CodeCompanion" })

      vim.api.nvim_create_user_command("CCA", function()
        vim.cmd("CodeCompanionActions")
      end, { desc = "Alias: CodeCompanionActions" })
      -- See Also:
      --  CodeCompanionChat Add  // Adds highlighted code
      --  CodeCompanionChat <inline-prompt>

      vim.api.nvim_create_user_command("CCDiagYank", function()
        local diags = vim.diagnostic.get(0)
        if not diags or #diags == 0 then
          vim.notify("No diagnostics in this buffer", vim.log.levels.INFO)
          return
        end

        local msg = { "### Pyright Diagnostics", "" }
        for _, d in ipairs(diags) do
          local pos = ("%d:%d"):format(d.lnum + 1, d.col + 1)
          table.insert(msg, ("- (%s) %s"):format(pos, d.message))
        end
        local text = table.concat(msg, "\n")

        vim.fn.setreg("+", text)   -- system clipboard
        vim.fn.setreg("\"", text)  -- unnamed register

        vim.notify("Diagnostics copied to clipboard + and register double-quote", vim.log.levels.INFO)
      end, { desc = "Copy Pyright diagnostics to clipboard" })

      vim.api.nvim_create_user_command("CCY", function()
        vim.cmd("CCDiagYank")
      end, { desc = "Alias: CCDiagYank" })
    end,
  },
}
