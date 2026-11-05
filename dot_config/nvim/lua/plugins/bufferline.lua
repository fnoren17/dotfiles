-- Tabs for open files (buffers), like in Zed
---@type LazySpec
return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      close_command = function(buf) Snacks.bufdelete(buf) end,
      right_mouse_command = function(buf) Snacks.bufdelete(buf) end,
      -- Keep the tabs from sliding in over the file explorer
      offsets = {
        { filetype = "snacks_layout_box", text = "Explorer", highlight = "Directory" },
      },
    },
  },
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous tab" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next tab" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Close tab" },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Close other tabs" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin tab" },
    { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Tab 1" },
    { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Tab 2" },
    { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Tab 3" },
    { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Tab 4" },
    { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Tab 5" },
  },
}
