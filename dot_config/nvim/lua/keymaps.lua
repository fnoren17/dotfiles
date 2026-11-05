-- Picker, explorer and LSP navigation keys live in plugins/snacks.lua,
-- formatting in plugins/formatting.lua
local map = vim.keymap.set

-- Habits carried over from Zed
map({ "n", "i", "v" }, "<C-A-s>", "<cmd>wall<cr>", { desc = "Save all" })
map("n", "<A-S-Down>", "<cmd>t.<cr>", { desc = "Duplicate line down" })
map("n", "<A-S-Up>", "<cmd>t-1<cr>", { desc = "Duplicate line up" })

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Swedish keyboard: ö/ä instead of [/] (AltGr+8/9) for all "previous/next"
-- motions, e.g. äh = next git hunk, öd = previous diagnostic
map({ "n", "x", "o" }, "ö", "[", { remap = true, desc = "[" })
map({ "n", "x", "o" }, "ä", "]", { remap = true, desc = "]" })

-- Move between splits
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session" })

map("n", "<leader>?", function()
  Snacks.win({
    file = vim.fn.stdpath("config") .. "/cheatsheet.md",
    width = 0.7,
    height = 0.85,
    border = "rounded",
    title = " Fusklapp ",
    bo = { modifiable = false, filetype = "markdown" },
    wo = { wrap = true, conceallevel = 2, number = false, relativenumber = false },
  })
end, { desc = "Cheatsheet" })
