-- lua/custom/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function current_colorscheme()
      return vim.g.colors_name or "no-scheme"
    end
    local lualine = require("lualine")
    lualine.setup( {

      sections = {
        lualine_a = {},
        lualine_b = {"branch", "diff"},
        lualine_c = {{"filename", path = 1}},
        lualine_x = {
          -- no encoding e.g. utf-8
          -- no fileformat e.g. unix, dos
          { "filetype", icon_only = false }
        },
        -- lualine_y = { 'progress', current_colorscheme },
        lualine_y = { 'progress' },
        lualine_z = { '%l/%L:%c' } -- line/total-lines:column
      },
    })
    vim.api.nvim_create_autocmd("ColorScheme", {
                                  callback = function()
                                    require("lualine").refresh()
                                  end,
    })
    lualine.refresh()
  end,
}

