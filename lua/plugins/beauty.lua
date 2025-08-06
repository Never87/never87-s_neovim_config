return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",

        config = function()
            require("config.treesitter")
        end,
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },

        config = function()
            require("config.lualine")
        end,

        vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' }),
        vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},

        -- 配置见：https://github.com/lukas-reineke/indent-blankline.nvim
    },
}