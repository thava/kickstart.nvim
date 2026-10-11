return {
  {
    -- Pipe a motion / text object / Visual selection through a shell command.
    -- g!{motion}, g!! (line), {Visual}g!, :[range]Bang[!] {cmd}. See :help bang.nvim
    'Nagato-Yuzuru/bang.nvim',
    event = 'VeryLazy',
    opts = {
      on_error = 'keep', -- failing command leaves buffer untouched ("replace" = like built-in !)
      timeout = 30000, -- ms before the command is killed
      keymaps = true, -- g!{motion}, g!!, {Visual}g!
      expand_bang = false, -- don't expand "!" to the previous command
    },
  },
}
