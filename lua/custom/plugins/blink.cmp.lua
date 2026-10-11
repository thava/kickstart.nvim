-- lua/custom/plugins/blink.cmp.lua
-- Autocompletion
-- Also configures windsurf / Codeium for autocompletion
-- Note: replaced windsurf.nvim with codeium.nvim temporarily. Revert back later.
-- 
return {
  {
    'saghen/blink.cmp',
    enabled = true,
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
      --  'Exafunction/codeium.nvim', -- codeium to be used for virtual text only elsewhere.
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        -- removed codeium from the default list.
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          -- codeium = { name = 'Codeium', module = 'codeium.blink', async = true },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    }
  },
  {
    "Exafunction/codeium.nvim",
    enabled = true,    -- Enable this for AI Auto completion!!!
    branch = "main",    -- Recommended: Use main branch for latest protocol fixes
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codeium").setup({
        -- Disable cmp (i.e. nvim-cmp) since we use blink.cmp
        enable_cmp_source = false,   -- we strictly use this for virtual text
        virtual_text = {
            enabled = true,

            -- These are the defaults

            -- Set to true if you never want completions to be shown automatically.
            manual = false,
            -- A mapping of filetype to true or false, to enable virtual text.
            filetypes = {
              markdown = false,
            },
            -- Whether to enable virtual text of not for filetypes not specifically listed above.
            default_filetype_enabled = true,
            -- How long to wait (in ms) before requesting completions after typing stops.
            idle_delay = 75,
            -- Priority of the virtual text. This usually ensures that the completions appear on top of
            -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
            -- desired.
            virtual_text_priority = 65535,
            -- Set to false to disable all key bindings for managing completions.
            map_keys = true,
            -- The key to press when hitting the accept keybinding but no completion is showing.
            -- Defaults to \t normally or <c-n> when a popup is showing.
            accept_fallback = nil,
            -- Key bindings for managing completions in virtual text mode.
            key_bindings = {
                -- Accept the current completion.
                accept = "<Tab>",
                -- Accept the next word.
                accept_word = false,
                -- Accept the next line.
                accept_line = false,
                -- Clear the virtual text.
                clear = false,
                -- Cycle to the next completion.
                next = "<M-]>",
                -- Cycle to the previous completion.
                prev = "<M-[>",
            }
        }
      })
      vim.api.nvim_create_user_command("Cm", function()
        vim.cmd("Codeium")
      end, { desc = "Alias: Codeium" })
    end
  },
}

-- windsurf Notes:
-- https://raw.githubusercontent.com/Exafunction/windsurf.vim/refs/heads/main/README.md

-- :Codeium Chat
-- :Cm Chat
--
