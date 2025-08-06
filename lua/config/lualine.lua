require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = {
      -- 完全自定义透明主题
      normal = {
        a = { bg = 'none', fg = '#7aa2f7' },
        b = { bg = 'none', fg = '#c0caf5' },
        c = { bg = 'none', fg = '#a9b1d6' }
      },
      insert = {
        a = { bg = 'none', fg = '#9ece6a' },
        b = { bg = 'none', fg = '#c0caf5' },
        c = { bg = 'none', fg = '#a9b1d6' }
      },
      visual = {
        a = { bg = 'none', fg = '#bb9af7' },
        b = { bg = 'none', fg = '#c0caf5' },
        c = { bg = 'none', fg = '#a9b1d6' }
      },
      replace = {
        a = { bg = 'none', fg = '#f7768e' },
        b = { bg = 'none', fg = '#c0caf5' },
        c = { bg = 'none', fg = '#a9b1d6' }
      },
      command = {
        a = { bg = 'none', fg = '#e0af68' },
        b = { bg = 'none', fg = '#c0caf5' },
        c = { bg = 'none', fg = '#a9b1d6' }
      },
      inactive = {
        a = { bg = 'none', fg = '#565f89' },
        b = { bg = 'none', fg = '#565f89' },
        c = { bg = 'none', fg = '#565f89' }
      }
    },
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true, -- 重要：使用全局状态栏
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'filename'},
    lualine_x = {'diagnostics'},
    lualine_y = {'filetype'},
    lualine_z = {'progress', 'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- 确保基础状态栏透明
vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })