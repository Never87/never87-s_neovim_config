return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup {}

        -- 打开/关闭 nvim-tree
        vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

        -- 打开并聚焦 nvim-tree
        vim.keymap.set('n', '<leader>o', ':NvimTreeFocus<CR>', { noremap = true, silent = true })

        -- 定位当前文件
        vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

    end,
}