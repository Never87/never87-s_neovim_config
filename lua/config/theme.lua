return {
    -- Set light or dark variant
    variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`

    -- Enable transparent background
    transparent = true,

    -- Reduce the overall saturation of colours for a more muted look
    saturation = 1, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)

    -- Enable italics comments
    italic_comments = false,

    -- Replace all fillchars with ' ' for the ultimate clean look
    hide_fillchars = true,

    -- Apply a modern borderless look to pickers like Telescope, Snacks Picker & Fzf-Lua
    borderless_pickers = true,

    -- Set terminal colors used in `:terminal`
    terminal_colors = true,

    -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
    cache = false,

    -- Override highlight groups with your own colour values
    -- highlights = {
        -- Highlight groups to override, adding new groups is also possible
        -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

        -- Example:
        -- Comment = { fg = "#696969", bg = "#ffffff", italic = true },

        -- More examples can be found in `lua/cyberdream/extensions/*.lua`
    -- },

    overrides = function(c)
        return {
            Normal = { bg = "none" },
            NormalFloat = { bg = "none" },
            CursorLine = { bg = "none" },
            Visual = { bg = "none" },
            SignColumn = { bg = "none" },
            MsgArea = { bg = "none" },
            TelescopeNormal = { bg = "none" },
            TelescopeBorder = { bg = "none" },
            NvimTreeNormal = { bg = "none" },
            NvimTreeEndOfBuffer = { bg = "none" },
            NormalNC = { bg = "none" },  -- 非活动窗口背景
            WinSeparator = { fg = "#555555" },  -- 更柔和的窗口分隔线
            FloatBorder = { bg = "none" },
            EndOfBuffer = { bg = "none" },  

            -- 状态栏透明
            StatusLine = { bg = "none" },
            StatusLineNC = { bg = "none" },

            -- 顶部路径栏透明
            WinBar = { bg = "none" },
            WinBarNC = { bg = "none" },

            -- 模式指示器透明
            ModeMsg = { bg = "none" },
            MsgArea = { bg = "none" },

            -- 标签页透明
            TabLine = { bg = "none" },
            TabLineFill = { bg = "none" },
            TabLineSel = { bg = "none" },

            ModeNormal = { bg = "none", fg = "#7aa2f7" },
            ModeInsert = { bg = "none", fg = "#9ece6a" },
            ModeVisual = { bg = "none", fg = "#bb9af7" },
            ModeReplace = { bg = "none", fg = "#f7768e" },
            ModeCommand = { bg = "none", fg = "#e0af68" },

            -- Lualine 模式高亮组
            lualine_a_normal = { bg = 'none', fg = c.blue },    
            lualine_a_insert = { bg = 'none', fg = c.green },
            lualine_a_visual = { bg = 'none', fg = c.purple },
        }
    end,

    -- Override a highlight group entirely using the built-in colour palette
    -- overrides = function(c) -- NOTE: This function nullifies the `highlights` option
    --     -- Example:
    --     return {
    --         Normal = { bg = c.bg },
    --         CursorLine = { bg = c.bg_highlight },
    --         Visual = { bg = c.magenta, fg = c.bg, bold = true },
    --         StatusLine = { fg = c.cyan, bg = c.bg_alt, bold = true },
    --         WinSeparator = { fg = c.fg },
    --         Comment = { fg = c.comment, italic = true },
    --         ["@function"] = { fg = c.cyan, bold = true },
    --         ["@property"] = { fg = c.magenta, bold = true },
    --         NormalFloat = { bg = c.bg_alt },
    --     }
    -- end,

    -- Override colors
    -- colors = {
    --     -- For a list of colors see `lua/cyberdream/colours.lua`

    --     -- Override colors for both light and dark variants
    --     bg = "#000000",
    --     green = "#00ff00",

    --     -- If you want to override colors for light or dark variants only, use the following format:
    --     dark = {
    --         magenta = "#ff00ff",
    --         fg = "#eeeeee",
    --     },
    --     light = {
    --         red = "#ff5c57",
    --         cyan = "#5ef1ff",
    --     },
    -- },

    -- Disable or enable colorscheme extensions
    extensions = {
        telescope = true,
        notify = true,
        mini = true,
        cmp = true,
        lsp = true,
        nvim_tree = true,
    },

    -- highlights = {
    --     -- cmp 补全项函数高亮
    --     CmpItemKindFunction = { fg = "#FF79C6", bold = true },
    --     CmpItemKindVariable = { fg = "#8BE9FD" },

    --     -- LSP Diagnostics 错误提示颜色
    --     DiagnosticError = { fg = "#FF5555", bold = true },
    --     DiagnosticWarn = { fg = "#F1FA8C" },
    --     DiagnosticInfo = { fg = "#6272A4" },
    --     DiagnosticHint = { fg = "#8BE9FD" },

    --     -- Telescope 弹窗提示
    --     TelescopeBorder = { fg = "#6272A4" },
    --     TelescopePromptNormal = { bg = "#282A36" },
    --     TelescopePromptPrefix = { fg = "#FF79C6" },
    -- },
}