local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  desc = "PHP uses 4-space indentation",
  pattern = "php",
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
  end,
})

autocmd("TextYankPost", {
  desc = "Briefly highlight yanked text",
  callback = function()
    vim.hl.on_yank()
  end,
})
