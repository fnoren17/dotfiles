---@type LazySpec
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "storm",
    -- Had to change the text color of
    -- comments for better visibility
    on_colors = function(colors)
      colors.comment = "#7aa2f7"
    end,
    on_highlights = function(highlights, colors)
      highlights.Comment = {
        fg = colors.comment,
        italic = false,
      }
      highlights.Keyword = { italic = false }
      highlights.Statement = { italic = false }
      highlights.Type = { italic = false }
      highlights.Function = { italic = false }
      highlights.Identifier = { italic = false }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight-storm")
  end,
}
