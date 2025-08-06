local M = {}

function M.get_mode()
  local mode_map = {
    ['n'] = {'%#ModeNormal#', 'NORMAL'},
    ['i'] = {'%#ModeInsert#', 'INSERT'},
    ['v'] = {'%#ModeVisual#', 'VISUAL'},
    ['V'] = {'%#ModeVisual#', 'V-LINE'},
    [''] = {'%#ModeVisual#', 'V-BLOCK'},
    ['R'] = {'%#ModeReplace#', 'REPLACE'},
    ['c'] = {'%#ModeCommand#', 'COMMAND'},
    ['t'] = {'%#ModeInsert#', 'TERM'},
  }
  
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_data = mode_map[current_mode:sub(1, 1)] or {'%#StatusLine#', current_mode}
  
  return mode_data[1] .. "  " .. mode_data[2] .. "  %*"
end

return M