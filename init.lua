
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