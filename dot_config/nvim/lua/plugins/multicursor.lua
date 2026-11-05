-- Multiple cursors with the same keys as in Zed (VSCode keymap)
---@type LazySpec
return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  event = "VeryLazy",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local map = vim.keymap.set
    -- Replaces Neovim's "scroll half page down"; Ctrl+u still scrolls up
    map({ "n", "x" }, "<C-d>", function() mc.matchAddCursor(1) end, { desc = "Add cursor at next match" })
    map({ "n", "x" }, "<C-S-d>", function() mc.matchSkipCursor(1) end, { desc = "Skip next match" })
    map({ "n", "x" }, "<C-S-Down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })
    map({ "n", "x" }, "<C-S-Up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
    map({ "n", "x" }, "<leader>ma", mc.matchAllAddCursors, { desc = "Add cursors at all matches" })

    -- Only active while there are multiple cursors
    mc.addKeymapLayer(function(layer)
      layer({ "n", "x" }, "<Left>", mc.prevCursor)
      layer({ "n", "x" }, "<Right>", mc.nextCursor)
      layer({ "n", "x" }, "<leader>mx", mc.deleteCursor)
      layer("n", "<Esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)
  end,
}
