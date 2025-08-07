-- my_floating_input.lua
local M = {}

local function perr(s)
  vim.api.nvim_err_writeln("[Never87:cph] >" .. s)
end

local function p(s)
  print("[Never87:cph] >" .. s)
end

local cph = require("Never87.cph")

M.config = {
    window_ratio = 0.45,
    window_margin = 1,
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

local tests_cnt = cph.count_tests()

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
        M.open_window()
    end, {})
    vim.api.nvim_create_user_command("CPHComplie", function()
        local res = cph.compile_main()
        if res then
            p("编译成功") 
        end
    end, {})
    vim.api.nvim_create_user_command("CPHCountTests", function()
        p("测试点数量：" .. cph.count_tests())
    end, {})
    vim.api.nvim_create_user_command("CPHTest", function(opts)
        local num = tonumber(opts.args)
        if num <= 0 then
            perr("测试点编号不能小于等于0")
            return
        end
        if num > tests_cnt then
            perr("没那么多测试点，调用:CPHCountTests查看当前测试点数量")
            return
        end

        local pass, result, input = cph.run_test(num)
        
        if pass then
            p(string.format("[Test %d] Passed!✅✅✅", num))
        else
            p(string.format("[Test %d] Failed!❌❌❌", num))
            p("Expected Output: ")
            p(result.expected:gsub("\n", "\\n"))
            p("Received Output: ")
            p(result.output:gsub("\n", "\\n"))
            if result.error_output ~= "" then
                p("Standard Error: ")
                p(result.error_output)
            end
        end

    end, {
        nargs = 1,  -- 需要一个参数
        desc = "index of the tests"
    })
end

return M
