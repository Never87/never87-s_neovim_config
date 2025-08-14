return {
    "sphamba/smear-cursor.nvim",
    opts = {
        -- 拖尾持续时间（秒），越小越快
        smear_length = 0.25,
        -- 刷新间隔（秒），改小能提高帧率
        smear_interval = 0.003,
        -- 拖尾点的数量，越多越平滑
        smear_size = 64,
    },
}