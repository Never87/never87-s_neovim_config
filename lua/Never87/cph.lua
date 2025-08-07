local function normalize_path(path)
  return path:gsub("\\", "/")
end

local function perr(s)
  vim.api.nvim_err_writeln("[Never87:cph] >" .. s)
end

local function p(s)
  print("[Never87:cph] >" .. s)
end

local M = {}

M.config = {
   tests = "tests",
   main = "main.cpp",
   exe = "main.exe",
   compiler = "g++",
   compile_args = "-std=c++14 -O2 -static",
   cc_listener_name = "cc_listener.py",
   max_wait_ms = 5000,
   failed_stop = false,
}

-- main文件所在目录
local file_dir = normalize_path(vim.fn.expand("%:p:h")) .. "/"
local tests_dir = file_dir .. M.config.tests .. "/"

local plugin_path = debug.getinfo(1, "S").source:sub(2)  -- 插件文件路径
local plugin_dir = vim.fn.fnamemodify(plugin_path, ":h")  -- 插件所在文件夹路径

local cc_listener_path = plugin_dir .. "/" .. M.config.cc_listener_name;

local function run_in_new_window(cmd)
  local command = string.format('start cmd /k "%s"', cmd)
  local res = os.execute(command)
  return res
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local content = f:read("*a")
  f:close()
  return content
end

function M.start_cc_listener()
  if vim.loop.os_uname().version:match("Windows") then
    if not M.config.cc_listener_name or M.config.cc_listener_name == "" then
      perr("cc_listener_name出错了，检查：" .. cc_listener_path .. "有没有叫cc_listener.py或：" .. M.config.cc_listener_name .. " 的文件")
      return
    end
    local cmd = string.format('python "%s"', cc_listener_path)
    local res = run_in_new_window(cmd)
    if res ~= 0 then
      perr("你需要自己安装下python用于执行cc_listener或" .. M.config.cc_listener_name .. "哦~")
      return
    end
    p("已启动" .. M.config.cc_listener_name .. " (独立窗口运行中...)")
  else
    perr("fw作者没写其他平台的适配哦~，可以手动执行这个：" .. cc_listener_path .. " 文件哦，或者在：" .. plugin_path .. " 这个文件中改下run_in_new_window()函数哦!")
  end
end

function M.compile_main()
  local src = M.config.main
  local exe = M.config.exe
  local cmd = string.format('%s %s -o %s "%s"', M.config.compiler, M.config.compile_args, M.config.exe, file_dir .. M.config.main)
  local output = vim.fn.system(cmd)
  local res = vim.v.shell_error
  if res ~= 0 then
    perr("编译失败:" .. output)
    return false
  end
  return true
end

function M.count_tests()
  if vim.fn.isdirectory(tests_dir) == 0 then
    p("未找到tests文件夹（用来存放数据点）：" .. tests_dir)
    return 0
  end

  local count = 0
  while true do
    local in_file = string.format("%sin%d", tests_dir, count + 1)
    local out_file = string.format("%sout%d", tests_dir, count + 1)
    if vim.fn.filereadable(in_file) == 1 and vim.fn.filereadable(out_file) == 1 then
      count = count + 1
    else
      break
    end
  end
  return count
end

local function normalize(s)
  return s
    :gsub("\r\n", "\n")   -- Windows换行 -> Unix换行
    :gsub("\r", "\n")     -- 其他平台兼容
    :gsub(" +\n", "\n")   -- 行末多余空格
    :gsub("%s+$", "")     -- 整体末尾空白
end

-- return result.pass, result, input
function M.run_test(test_num)
  local in_file = string.format("%sin%d", tests_dir, test_num)
  local out_file = string.format("%sout%d", tests_dir, test_num)

  local input = read_file(in_file)
  if not input then
    return false, "读取输入文件失败: " .. in_file
  end

  local expected = read_file(out_file)
  if not expected then
    return false, "读取输出文件失败: " .. out_file
  end

  local stdout_data = {}
  local stderr_data = {}

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local stdin = vim.loop.new_pipe(false)

  local finished = false
  local result = nil

  local function on_stdout(err, data)
    assert(not err, err)
    if data then
      table.insert(stdout_data, data)
    end
  end

  local function on_stderr(err, data)
    assert(not err, err)
    if data then
      table.insert(stderr_data, data)
    end
  end

  local function on_exit_cb(code, signal)
    finished = true

    local output = table.concat(stdout_data)
    local errput = table.concat(stderr_data)

    local pass = normalize(output) == normalize(expected)

    result = {
      pass = pass,
      code = code,
      signal = signal,
      output = output,
      expected = expected,
      error_output = errput,
      is_re = (tonumber(code or 0) ~= 0) or (tonumber(signal or 0) ~= 0),
      is_out_of_time_ = false
    }
  end

  local exe_path = file_dir .. M.config.exe

  local pid = vim.loop.spawn(exe_path, {
    stdio = {stdin, stdout, stderr},
    cwd = file_dir
  }, on_exit_cb)

  if not pid then
    return false, "程序运行失败，找不到可执行文件：" .. exe_path
  end

  stdout:read_start(on_stdout)
  stderr:read_start(on_stderr)

  stdin:write(input)
  stdin:close()

  vim.wait(M.config.max_wait_ms, function()
    return finished
  end, 100, true)

  if not finished then
    if not result then
      result = {
        pass = false,
        code = nil,
        signal = nil,
        output = "",
        expected = expected,
        error_output = "",
        is_re = false,
        is_out_of_time_ = true
      }
    else
      result.is_out_of_time_ = true
    end
    -- return false, "运行测试超时"
  end

  if result then
    return result.pass, result, input
  else
    return false, nil, input
  end
end

function M.run_all_tests()
  local total = M.count_tests()
  if total == 0 then
    perr("没有检测到测试用例...")
    return
  end

  local ok = M.compile_main()
  if not ok then return end

  p("开始测试 " .. total .. " 个样例!")

  local passed_count = 0

  for i = 1, total do
    local pass, input, _, result = M.run_test(i)
    if pass then
        p(string.format("[Test %d] Passed!✅✅✅", i))
        passed_count = passed_count + 1
    else
        p(string.format("[Test %d] Failed!❌❌❌", i))
        p("Expected Output: ")
        p(result.expected:gsub("\n", "\\n"))
        p("Received Output: ")
        p(result.output:gsub("\n", "\\n"))
        if result.error_output ~= "" then
            p("Standard Error: ")
            p(result.error_output)
        end

        if M.config.failed_stop then
          break
        end
    end
  end

  p(string.format("测试结束：%d / %d 通过", passed_count, total))
end

function M.setup_keymaps()
  local wk_avail, wk = pcall(require, "which-key")
  if wk_avail then
    wk.register({
      ["<leader>"] = {
        sl = {M.start_cc_listener, "启动" .. M.config.cc_listener_name .. "监听器"},
        st = {M.run_all_tests, "运行所有测试样例"},
      }
    })
  else 
    vim.api.nvim_set_keymap("n", "<leader>sl", "<cmd>lua require('Never87.cph').start_cc_listener()<CR>", { noremap=true, silent=true })
    vim.api.nvim_set_keymap("n", "<leader>st", "<cmd>lua require('Never87.cph').run_all_tests()<CR>", { noremap=true, silent=true })
  end
end

function M.setup(opts)
  if opts then
    for k,v in pairs(opts) do
      M.config[k] = v
    end
  end
  M.setup_keymaps()
  p("插件加载完毕！")
end

return M
