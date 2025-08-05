return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
        local builtin = require('telescope.builtin')
        -- 打开一个文件搜索窗口
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
        -- 全局文本搜索
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
        -- 列出当前打开的所有缓冲区（buffer），帮你快速切换已打开的文件。
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
        -- 搜索 Neovim/Vim 的帮助文档标签。
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help Tags' })
    end
}