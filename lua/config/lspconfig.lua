local lspconfig = require("lspconfig")

-- 通用能力
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- clangd (C, C++)
lspconfig.clangd.setup({
    capabilities = capabilities,
})

-- Python
lspconfig.pyright.setup({
  capabilities = capabilities,
})

-- Lua
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})

-- Java（建议配合 nvim-jdtls 使用更完整功能）
lspconfig.jdtls.setup({
  capabilities = capabilities,
})

-- C#
lspconfig.omnisharp.setup({
  capabilities = capabilities,
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
})
