-- Quick reference popup for my own key conventions. Bound to <leader>i.
local M = {}

local function show_key(k)
  if k == nil or k == '' then
    return '\\ (default)'
  end
  return (k:gsub(' ', '<Space>'))
end

-- Centered, read-only markdown float; q or <Esc> closes it.
function M.popup(lines, title)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = 'markdown'
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'

  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  width = math.min(width + 2, vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 4)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = title,
    title_pos = 'center',
  })
  vim.wo[win].conceallevel = 2

  for _, key in ipairs { 'q', '<Esc>' } do
    vim.keymap.set('n', key, function()
      vim.api.nvim_win_close(win, true)
    end, { buffer = buf, nowait = true })
  end
end

function M.show()
  local leader = show_key(vim.g.mapleader)
  local localleader = show_key(vim.g.maplocalleader)

  local lines = {
    '# Key conventions',
    '',
    '- Global leader: `' .. leader .. '`',
    '- Local leader:  `' .. localleader .. '`',
    '',
    '## Search',
    '- `' .. leader .. 's…` Telescope search (sf files, sg grep, sh help, sk keymaps, sb buffers)',
    '',
    '## Buffer transformation (bang.nvim)',
    '- `g!{motion}`  filter motion/text object through a shell cmd (e.g. `g!ip` sort)',
    '- `{Visual}g!`  filter selection (charwise, linewise, or block)',
    '- `g!!`         filter current line (`[count]g!!` for N lines)',
    '- `:Bang! cmd`  write output even if cmd fails (diff, grep)',
    '- `.`           repeat last g!',
    '',
    '## Claude Code (claudecode.nvim, Claude runs in your own terminal)',
    '- `' .. leader .. 'ac` show port + copy `claude-lite` connect command to clipboard',
    '- `' .. leader .. 'as` (Visual) send selection   `' .. leader .. 'ab` add buffer',
    '- `' .. leader .. 'aa` accept diff   `' .. leader .. 'ad` deny diff',
    '- In claude-lite: `/ide` lists running nvims; add `--resume`/`--continue` to reopen',
    '- One-shot: `g!` + `claude-lite -p "…"` replaces selection',
    '',
    'Press q or <Esc> to close',
  }

  M.popup(lines, ' Help ')
end

vim.keymap.set('n', '<leader>i', M.show, { desc = 'Show key conventions [I]nfo' })

return M
