-- Picker + file explorer (replaces telescope and neo-tree)
---@type LazySpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    explorer = { enabled = true, replace_netrw = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        -- Show dotfiles and gitignored files, like the old neo-tree setup
        explorer = { hidden = true, ignored = true },
      },
    },
  },
  keys = {
    { "<C-p>", function() Snacks.picker.files() end, desc = "Find files" },
    { "<C-n>", function() Snacks.explorer() end, desc = "File explorer" },
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word", mode = { "n", "x" } },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fr", function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = "Recent files" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Search in buffer" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader>gl", function() Snacks.picker.git_log_file() end, desc = "Git log (file)" },
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Go to definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Go to declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Go to implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Go to type definition" },
  },
}
