
M = {}

function M.setup()
        
    vim.api.nvim_create_user_command("Q", function()
        vim.cmd("q!")
    end, {})
end 

return M
