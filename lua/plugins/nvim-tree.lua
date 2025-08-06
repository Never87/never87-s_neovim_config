return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup {
            renderer = {
                highlight_opened_files = "none",
                highlight_git = false,
                indent_markers = {
                    enable = false,
                },
                icons = {
                    show = {
                        file = false,
                        folder = false,
                        folder_arrow = false,
                        git = false,
                    },
                },
                -- 禁用所有额外背景高亮
                root_folder_label = false,
                add_trailing = false,
                group_empty = false,
                full_name = false,
            },
            view = {
                -- 防止窗口聚焦时改变背景
                preserve_window_proportions = true,
                centralize_selection = false,
            },
            update_focused_file = {
                enable = false,  -- 关闭聚焦文件时的高亮更新
            },
            -- 禁用所有可能导致背景变化的选项
            git = { enable = false },
            diagnostics = { enable = false },
            filters = { dotfiles = false },
            actions = {
                change_dir = { enable = false },
                open_file = { resize_window = false },
            },
        }

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "NvimTree",
            callback = function()
                vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
                vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })
                vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#555555", bg = "none" })
            end
        })

        -- 打开/关闭 nvim-tree
        vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

        -- 打开并聚焦 nvim-tree
        vim.keymap.set('n', '<leader>o', ':NvimTreeFocus<CR>', { noremap = true, silent = true })

        -- 定位当前文件
        vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

    end,
}