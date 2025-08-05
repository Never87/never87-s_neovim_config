return {
  "echasnovski/mini.nvim",
  version = false, -- 使用最新提交版本
  config = function()
    -- 功能：快捷注释代码行或块，支持多种语言注释格式。
    require("mini.comment").setup({
        mappings = {
            -- Toggle comment (like `gcip` - comment inner paragraph) for both
            -- Normal and Visual modes
            -- 作用：这是在普通模式（Normal）和视觉模式（Visual）下，切换注释的主快捷键。
            -- 在普通模式下，gc 加上一个动作，比如 gcip 就是注释（或取消注释）“inner paragraph”（当前段落）。
            -- 在视觉模式下选中一段文本，按 gc 可以注释/取消注释选中的内容。

            comment = 'gc',

            -- Toggle comment on current line
            -- 作用：切换当前行注释的快捷键，通常用于快速注释/取消注释光标所在的整行。
            comment_line = 'gcc',

            -- Toggle comment on visual selection
            -- 作用：视觉模式下的切换注释快捷键，专门处理视觉模式。
            comment_visual = 'gc',

            -- Define 'comment' textobject (like `dgc` - delete whole comment block)
            -- Works also in Visual mode if mapping differs from `comment_visual`
            -- 作用：定义了一个“注释文本对象”的快捷键。
            textobject = 'gc',
        },
    })
    -- 功能：显示当前代码缩进范围的辅助线，帮助理解代码层级结构。
    require("mini.indentscope").setup()
    -- 功能：自动补全括号、引号等成对符号。
    require("mini.pairs").setup()
    -- 功能：快速添加、修改、删除文本的包围符号（如括号、引号等）。
    require("mini.surround").setup()
    -- 快速浏览、打开和操作文件，方便管理项目文件。
    require("mini.files").setup()
    -- 定制和美化状态栏，显示更多有用信息。
    require("mini.statusline").setup()
    -- 快速跳转到文本中的字符或单词，提升导航效率。
    require("mini.jump").setup()
    -- 替代 Neovim 默认通知，提供漂亮的弹窗通知。
    require("mini.notify").setup()

    -- 全部配置看 https://github.com/echasnovski/mini.nvim
  end,
}
