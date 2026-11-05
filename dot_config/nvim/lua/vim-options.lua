vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local o = vim.opt

-- Indentation (PHP gets 4 spaces in autocmds.lua, same as in Zed)
o.expandtab = true
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2

-- UI
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.wrap = false
o.scrolloff = 8
o.splitright = true
o.splitbelow = true
o.termguicolors = true

-- Behaviour
o.mouse = "a"
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.confirm = true
o.updatetime = 250
o.timeoutlen = 400
o.sessionoptions = { "buffers", "curdir", "folds", "tabpages", "winsize", "help", "globals", "skiprtp" }

-- Deferred so wl-clipboard lookup doesn't slow down startup
vim.schedule(function()
  o.clipboard = "unnamedplus"
end)

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
