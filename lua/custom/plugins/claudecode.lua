-- Show how to connect an externally started claude-lite to this nvim.
-- The plugin never launches Claude itself (terminal.provider = "none").
local function show_connect_info()
  local cc = require 'claudecode'
  if not cc.state.port then
    cc.start(false)
  end
  local port = cc.state.port
  local cwd = vim.fn.getcwd()
  local cmd = string.format('cd %s && CLAUDE_CODE_SSE_PORT=%d ENABLE_IDE_INTEGRATION=true claude-lite', vim.fn.shellescape(cwd), port)
  vim.fn.setreg('+', cmd)

  require('custom.keyhelp').popup({
    cc.is_claude_connected() and '**Claude is already connected to this nvim.**' or 'Claude: not connected yet',
    '',
    '- nvim port: `' .. port .. '`',
    '- cwd:       `' .. cwd .. '`',
    '',
    '**Copied to clipboard** (paste in iTerm; add `--resume`/`--continue` if wanted):',
    '`' .. cmd .. '`',
    '',
    'Or run `claude-lite` in ' .. cwd,
    'and type `/ide`, then pick Neovim with that folder.',
  }, ' Claude connect ')
end

return {
  {
    "coder/claudecode.nvim",
    -- Nothing starts until a <leader>a* key or :ClaudeCode* command is used:
    -- no WebSocket server, no ~/.claude/ide lock file, no claude process.
    opts = {
      -- Claude runs in my own terminal (iTerm), started with ~/bin/claude-lite:
      -- Pro login (unsets ANTHROPIC_API_KEY), global CLAUDE.md only, and
      -- "focus on the buffer, don't explore". <leader>ac shows how to connect.
      terminal = { provider = "none" },
    },
    -- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
    -- so `:ClaudeCode` and friends work on a fresh start. Without it, a keys-only
    -- spec defers loading until a <leader>a* mapping is pressed and the commands
    -- would not exist yet.
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", show_connect_info, desc = "Claude connect info (copies cmd)" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
