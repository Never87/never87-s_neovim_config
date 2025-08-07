local function normalize(s)
  return s
    :gsub("\r\n", "\n")   -- Windows换行 -> Unix换行
    :gsub("\r", "\n")     -- 其他平台兼容
    :gsub(" +\n", "\n")   -- 行末多余空格
    :gsub("%s+$", "")     -- 整体末尾空白
end

local M = {}

local cph = require("Never87.cph")

M.config = {
    window_ratio = 0.45,
    window_margin = 1,
    window_split_radio = 0.4,
    window_split_margin = 2,
    max_show_cnt = 4,
    tests = "tests",
    main = "main.cpp",
    exe = "main.exe",
    compiler = "g++",
    compile_args = "-std=c++14 -O2 -static",
    cc_listener_name = "cc_listener.py",
    max_wait_ms = 5000,
    failed_stop = false,
}

vim.api.nvim_set_hl(0, "ACGreen", { fg = "#67c23a", bold = true })
vim.api.nvim_set_hl(0, "WARed", { fg = "#f56c6c", bold = true })
vim.api.nvim_set_hl(0, "REYellow", { fg = "#e6a23c", bold = true })
vim.api.nvim_set_hl(0, "CEBlue", { fg = "#409EFF", bold = true })
vim.api.nvim_set_hl(0, "NEGrey", { fg = "#909399", bold = true })
vim.api.nvim_set_hl(0, "UKEPink", { fg = "#c06c84", bold = true })
vim.api.nvim_set_hl(0, "TLEBlue", { fg = "#5965f2", bold = true })

local windows_vis = false
local tests_cnt = cph.count_tests()
local enable_test = true

local bufleft, bufright
local winleft, winright
local linesl = {}
local linesr = {}

local function close()
    if winleft and vim.api.nvim_win_is_valid(winleft) then
        vim.api.nvim_win_close(winleft, true)
    end
    if winright and vim.api.nvim_win_is_valid(winright) then
        vim.api.nvim_win_close(winright, true)
    end
    winleft, winright = nil, nil
    bufleft, bufright = nil, nil
    linesl, linesr = {}, {}
    windows_vis = false
end

local function map_close(buf)
    vim.keymap.set("n", "q", function()
        close()
    end, { buffer = buf, nowait = true, silent = true })
end

local function create_windows()
    local W, H = vim.o.columns, vim.o.lines
    local m = M.config.window_margin
    local r = M.config.window_ratio
    local m0 = M.config.window_split_margin
    local r0 = M.config.window_split_radio

    local w = math.floor((W - m * 2) * r)
    local h = math.floor((H - m * 2) * r)
    local cl = math.floor(W - m - w)
    local ll = math.floor(W - m - h)
    local wl = math.floor(w * r0 - m0 / 2)
    local wr = math.floor(w * (1 - r0) - m0 / 2)
    local cr = math.floor(cl + wl + m0)

    if not bufleft or not vim.api.nvim_buf_is_valid(bufleft) then
        bufleft = vim.api.nvim_create_buf(false, true)
    end
    if not bufright or not vim.api.nvim_buf_is_valid(bufright) then
        bufright = vim.api.nvim_create_buf(false, true)
    end

    if not winleft or not vim.api.nvim_win_is_valid(winleft) then
        winleft = vim.api.nvim_open_win(bufleft, true, {
            relative = "editor",
            width = wl,
            height = h,
            row = ll,
            col = cl,
            anchor = "NW",
            style = "minimal",
            border = "rounded",
            focusable = true,
        })
    end

    if not winright or not vim.api.nvim_win_is_valid(winright) then
        winright = vim.api.nvim_open_win(bufright, true, {
            relative = "editor",
            width = wr,
            height = h,
            row = ll,
            col = cr,
            anchor = "NW",
            style = "minimal",
            border = "rounded",
            focusable = true,
        })
    end

    vim.api.nvim_buf_set_option(bufleft, "modifiable", false)
    vim.api.nvim_buf_set_option(bufright, "modifiable", false)
end

local function update_buffers(linesl, linesr)
    vim.api.nvim_buf_set_option(bufleft, "modifiable", true)
    vim.api.nvim_buf_set_option(bufright, "modifiable", true)
    vim.api.nvim_buf_set_lines(bufleft, 0, -1, false, linesl)
    vim.api.nvim_buf_set_lines(bufright, 0, -1, false, linesr)
    vim.api.nvim_buf_set_option(bufleft, "modifiable", false)
    vim.api.nvim_buf_set_option(bufright, "modifiable", false)
end

-- 异步执行测试并刷新显示
local function run_tests_async()
    linesl = { "正在加载测试，请稍候……" }
    linesr = {}
    update_buffers(linesl, linesr)

    vim.defer_fn(function()
        local not_ce = cph.compile_main()
        local tests_state = {}
        local tests_color = {}

        local tests_inp = {}
        local tests_exo = {}
        local tests_reo = {}
        local tests_ero = {}

        local function conf(n, inp0, exo0, reo0, ero0) 
            tests_inp[n] = inp0
            tests_exo[n] = exo0
            tests_reo[n] = reo0
            tests_ero[n] = ero0
        end

        for i = 1, tests_cnt do
            if not enable_test then
                tests_state[i] = "Not Evaluated."
                tests_color[i] = "NEGrey"
                conf(i, nil, nil, nil, nil)
            else
                if not_ce then
                    local pss, res, inp = cph.run_test(i)
                    if not res then
                        tests_state[i] = "UKE"
                        tests_color[i] = "UKEPink"
                        conf(i, nil, nil, nil, nil)
                    else
                        if res.is_re then
                            tests_state[i] = "RE"
                            tests_color[i] = "REYellow"
                            conf(i, inp, res.expected, nil, res.error_output)
                        elseif pss then
                            tests_state[i] = "AC"
                            tests_color[i] = "ACGreen"
                            conf(i, inp, res.expected, res.output, res.error_output)
                        elseif res.is_out_of_time_ then
                            tests_state[i] = "TLE"
                            tests_color[i] = "TLEBlue"
                            conf(i, inp, res.expected, nil, nil)
                        else
                            tests_state[i] = "WA"
                            tests_color[i] = "WARed"
                            conf(i, inp, res.expected, res.output, res.error_output)
                        end
                    end
                else
                    tests_state[i] = "CE"
                    tests_color[i] = "REYellow"
                    conf(i, nil, nil, nil, nil)
                end
            end
        end

        linesl = { string.format("测试点数: %d", tests_cnt) }
        for i = 1, tests_cnt do
            table.insert(linesl, string.format("[Test %d]: %s", i, tests_state[i]))
        end


        local function f(buf, i, src)
            if src[i] ~= nil then
                for tmp in string.gmatch(tostring(src[i]), "([^\n]*)\n?") do
                    table.insert(buf, tostring(tmp))
                end
            end
        end

        for i = 1, tests_cnt do
            table.insert(linesr, string.format("测试点 %d:", i))
            table.insert(linesr, string.format("Input:"))
            f(linesr, i, tests_inp)
            table.insert(linesr, string.format("Expected Output:"))
            f(linesr, i, tests_exo)
            table.insert(linesr, string.format("Recieved Output:"))
            if tests_reo[i] ~= nil then
                f(linesr, i, tests_reo)
            end
            if tests_ero[i] ~= nil and tests_ero[i] ~= "" and tests_ero[i] ~= "\n" then
                table.insert(linesr, string.format("Standard Error:"))
                f(linesr, i, tests_ero)
            end
        end

        -- 这

        update_buffers(linesl, linesr)

        local ns = vim.api.nvim_create_namespace("cph_highlight")
        vim.api.nvim_buf_clear_namespace(bufleft, ns, 0, -1)
        for i = 1, tests_cnt do
            vim.api.nvim_buf_add_highlight(bufleft, ns, tests_color[i], i, 0, -1)
        end

    end, 50)
end

function M.setwin()
    if windows_vis then
        return
    end
    create_windows()
    map_close(bufleft)
    map_close(bufright)
    windows_vis = true
    run_tests_async()
end

function M.togglewin()
    if windows_vis then
        close()
    else
        M.setwin()
    end
end

function M.setup()
    cph.setup({
        tests = "tests",
        main = "main.cpp",
        exe = "main.exe",
        compiler = "g++",
        compile_args = "-std=c++14 -O2 -static",
        cc_listener_name = "cc_listener.py",
        max_wait_ms = 5000,
        failed_stop = false,
    })

    vim.api.nvim_create_user_command("CPH", function()
        M.togglewin()
    end, {})

    vim.api.nvim_create_user_command("CPHComplie", function()
        local res = cph.compile_main()
        if res then
            print("编译成功")
        end
    end, {})

    vim.api.nvim_create_user_command("CPHCountTests", function()
        print("测试点数量：" .. cph.count_tests())
    end, {})

    vim.api.nvim_create_user_command("CPHTest", function(opts)
        local num = tonumber(opts.args)
        if not num or num <= 0 then
            vim.api.nvim_err_writeln("测试点编号不能小于等于0")
            return
        end
        if num > tests_cnt then
            vim.api.nvim_err_writeln("没那么多测试点，调用:CPHCountTests查看当前测试点数量")
            return
        end

        local pass, result, input = cph.run_test(num)
        if pass then
            print(string.format("[Test %d] Passed!✅✅✅", num))
        else
            print(string.format("[Test %d] Failed!❌❌❌", num))
            print("Expected Output: ")
            print(result.expected:gsub("\n", "\\n"))
            print("Received Output: ")
            print(result.output:gsub("\n", "\\n"))
            if result.error_output ~= "" then
                print("Standard Error: ")
                print(result.error_output)
            end
        end
    end, {
        nargs = 1,
        desc = "index of the tests"
    })

    vim.keymap.set("n", "<leader>cs", M.togglewin, { noremap = true, silent = true })
end

return M