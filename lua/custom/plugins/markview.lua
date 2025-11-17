-- lua/custom/plugins/markview.lua
-- plugins/markview.lua
return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- recommended
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown", "typst", "tex", "html", "yaml" },

  config = function()
    require("markview").setup({
      wrap = true, -- soft-wrap recommended for markdown
      -- preview = { icon_provider = "internal", -- or "devicons" },
      -- markdown = { checkboxes = true, callouts = true, },
    })

    -- Keymaps with descriptions
    local map = vim.keymap.set
    local function opts(desc)
      return { silent = true, noremap = true, desc = desc }
    end

    -- Toggle Markview for current buffer
    map("n", "<leader>tmv", "<cmd>Markview toggle<cr>", opts("Markview: Toggle preview"))

    -- See Also:
		-- Markview enable
		-- Markview disable
		-- Markview toggleAll (for all buffers)
  end,
}
