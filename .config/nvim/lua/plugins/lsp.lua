
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})


return {
  {
    "williamboman/mason.nvim",
    opts = {}
  },
  {
   "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "eslint",
        "ts_ls"
      },
      automatic_install = true
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.eslint.setup({})
      lspconfig.ts_ls.setup({})
    end

  }
}
