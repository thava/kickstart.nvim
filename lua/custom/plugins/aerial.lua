return {
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("aerial").setup()

      -- Show outline of variables/functions in the file.
      -- Optional: Keymaps (you can change these)
      vim.keymap.set("n", "<leader>to", "<cmd>AerialToggle!<CR>", { desc = "Aerial (Symbols [T]oggle [O]utline)" })
    end,
  },
}
