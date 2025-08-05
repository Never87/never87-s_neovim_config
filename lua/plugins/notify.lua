return {
  "rcarriga/nvim-notify",
  config = function()
    -- 设置 nvim-notify 作为默认通知插件
    vim.notify = require("notify")

    -- 你可以配置 notify 的样式，比如持续时间、动画等
    require("notify").setup({
      stages = "fade_in_slide_out",  -- 动画效果
      timeout = 3000,                -- 通知显示时间，单位毫秒
      -- 更多配置可以查文档
    })
  end,
}