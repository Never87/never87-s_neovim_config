return {
    {
        "danymat/neogen",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
        -- Neogen 初始化配置
            require("neogen").setup({
                enabled = true,
                languages = {
                    lua = {
                        template = {
                        annotation_convention = "ldoc",     -- Lua 的 ldoc 风格
                        },
                    },
                    python = {
                        template = {
                        annotation_convention = "google",   -- Python 的 Google 风格
                        },
                    },
                    cpp = {
                        template = {
                        annotation_convention = "doxygen",  -- C++ 使用 doxygen 风格
                        },
                    },
                    c = {
                        template = {
                        annotation_convention = "doxygen",  -- C 也用 doxygen 风格（常用）
                        },
                    },
                    cs = {
                        template = {
                        annotation_convention = "xmldoc",   -- C# 使用 xmldoc 风格
                        },
                    },
                    java = {
                        template = {
                        annotation_convention = "javadoc",  -- Java 的 javadoc 风格
                        },
                    },
                },
            })

        -- 快捷键绑定：<leader>nd 生成注释
        vim.keymap.set("n", "<leader>nd", function()
            require("neogen").generate()
        end, { desc = "Generate annotation with Neogen" })
        end,
    },
}
