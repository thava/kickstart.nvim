-- lua/custom/plugins/render-markdown.lua
--
return {
  'MeanderingProgrammer/render-markdown.nvim',
  enabled = true,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    -- Choose one of the following for icons:
    -- 'echasnovski/mini.nvim', -- if you use the mini.nvim suite
    -- 'echasnovski/mini.icons', -- if you use standalone mini plugins
    'nvim-tree/nvim-web-devicons', -- if you prefer nvim-web-devicons
  },
  ft = { 'markdown' }, -- Only load for markdown files
  opts = {
    -- Your custom configuration options here
    enabled = false, -- Render markdown by default
    -- For example, customize heading icons:
    heading = {
      icons = { '   ', '   ', '   ', '  /span>  ', '   ', '   ' },
    },
    -- Customize checkbox icons:
    checkbox = {
      unchecked = { icon = '   ' },
      checked = { icon = '   ' },
    },
    -- ... and so on for other components
  },
}
