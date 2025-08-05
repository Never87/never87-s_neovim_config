return {
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,

        config = function()
            require("config.theme")
            vim.cmd.colorscheme("cyberdream")
        end,
    },
}