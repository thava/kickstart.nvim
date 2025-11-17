
return {
  "ahmedkhalf/project.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("project_nvim").setup({
      --- Manual mode: Neovim will NOT auto change cwd
      --- You trigger root changes manually (Telescope projects or commands)
      manual_mode = true,

      --- Project root detection methods (order matters!)
      detection_methods = { "lsp", "pattern" },

      --- Patterns used when `pattern` detection is applied
      patterns = {
        "!^packages/.*",           -- ignore pattern.
        "!^node_modules/.*",  
        "!workspaces/.*",    
        ".git",
        "Makefile",
        "package.json",
        "pyproject.toml",
        "Cargo.toml",
        "go.mod",
        "requirements.txt",
      },

      exclude_dirs = {},

      --- Show hidden files in Telescope project picker
      show_hidden = true,

      --- Optional: silent directory changes
      silent_chdir = false,
    })

    -- Load Telescope extension
    pcall(require("telescope").load_extension, "projects")

    -- Keymaps (you can change these later)
    local map = vim.keymap.set

    -- Launch Telescope project selector
    map("n", "<leader>sp", "<cmd>Telescope projects<CR>", {
      desc = "[S]earch [P]rojects"
    })

    -- Manually set project root based on project.nvim logic
    map("n", "<leader>Cr", function()
      local project = require("project_nvim.project")
      local root = project.get_project_root()

      if root and root ~= "" then
        -- project.set_pwd()
        vim.fn.chdir(root)
        print("Project Root → " .. root)
      else
        print("No project root detected")
      end
    end, { desc = "[C]hange Project [R]oot", })
  end,
}
