---@type LazySpec
return {
  {
    -- Shows available keys after pressing <leader> etc.
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    -- One session per working directory; restored automatically when
    -- nvim is started without file arguments (as nvim-dev does)
    "folke/persistence.nvim",
    lazy = false,
    opts = {},
    init = function()
      vim.api.nvim_create_autocmd("StdinReadPre", {
        callback = function() vim.g.started_with_stdin = true end,
      })
      vim.api.nvim_create_autocmd("VimEnter", {
        nested = true,
        callback = function()
          if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
            require("persistence").load()
          end
        end,
      })
    end,
  },
}
