local config_path = vim.fn.stdpath('config') -- 返回 C:\Users\ckcol\AppData\Local\nvim

package.path = package.path .. ';' .. config_path .. '/lua/?.lua;' .. config_path .. '/lua/?/init.lua'

-- 加载lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "\\lazy\\lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    cwarn("no valiable lazyvim packer, prepare for downloading...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.tabstop = 4 
vim.opt.shiftwidth = 4 
vim.opt.expandtab = true 

-- 关闭默认的 netrw 文件浏览器
-- 以防与nvim-tree冲突
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

vim.g.mapleader = " "

require('lazy').setup("plugins")
require("Never87.window").setup()

require("Never87.SimplePatches").setup()

----------------------------------------------------------------------
----------------------------------------------------------------------

-- 强制设置常用高亮组为透明
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "MsgArea", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- 设置浮动窗口透明
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- 设置所有窗口默认透明
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

-- 窗口焦点变化时保持透明
vim.api.nvim_create_autocmd({"WinEnter", "WinLeave", "FocusGained", "FocusLost"}, {
    callback = function()
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#555555", bg = "none" })
    end
})

-- 禁用所有背景填充
vim.opt.fillchars = {
    vert = " ",
    fold = " ",
    eob = " ",  -- 隐藏 ~ 字符
    diff = " ",
    msgsep = " ",
}

-- 强制原生状态栏透明
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })

-- 强制顶部路径栏透明
vim.api.nvim_set_hl(0, "WinBar", { bg = "none" })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "none" })

-- 模式指示器透明
vim.api.nvim_set_hl(0, "ModeMsg", { bg = "none" })

-- 标签页透明
vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" })
vim.api.nvim_set_hl(0, "TabLineSel", { bg = "none" })

-- 添加焦点事件监听确保透明效果持久
vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
  callback = function()
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
    vim.api.nvim_set_hl(0, "WinBar", { bg = "none" })
  end
})


-- ===== 状态栏和标签栏透明修复 =====

-- 1. 确保标签栏可见
vim.opt.showtabline = 2  -- 总是显示标签栏

-- 2. 设置所有必要的高亮组
local transparent_groups = {
  -- 状态栏相关
  "StatusLine", "StatusLineNC", 
  "ModeNormal", "ModeInsert", "ModeVisual", "ModeReplace", "ModeCommand",
  
  -- 标签栏相关
  "TabLine", "TabLineSel", "TabLineFill",
  
  -- 顶部栏相关
  "WinBar", "WinBarNC",
  
  -- 其他
  "Normal", "NormalNC", "NormalFloat", "FloatBorder", "EndOfBuffer"
}

for _, group in ipairs(transparent_groups) do
  vim.api.nvim_set_hl(0, group, { bg = "none" })
end

-- 3. 设置模式特定的颜色
vim.api.nvim_set_hl(0, "ModeNormal", { bg = "none", fg = "#7aa2f7" })
vim.api.nvim_set_hl(0, "ModeInsert", { bg = "none", fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "ModeVisual", { bg = "none", fg = "#bb9af7" })
vim.api.nvim_set_hl(0, "ModeReplace", { bg = "none", fg = "#f7768e" })
vim.api.nvim_set_hl(0, "ModeCommand", { bg = "none", fg = "#e0af68" })

-- 4. 自定义状态栏
vim.opt.statusline = table.concat({
  -- 模式指示器
  "%{%v:lua.require'config.mode'.get_mode()%}",
  
  -- 文件名和修改状态
  " %f%m",
  
  -- 右对齐部分
  "%=",
  
  -- 文件编码和类型
  "%{&fileencoding?&fileencoding:&encoding} | ",
  "%{&filetype}",
  
  -- 位置信息
  " | %l:%c",
})

-- 5. 模式指示器模块 (创建 config/mode.lua 文件)
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
