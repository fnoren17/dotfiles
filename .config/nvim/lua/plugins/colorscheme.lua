return
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
      -- Had to change the text color of
      -- comments for better visibility
    on_colors = function(colors)
        colors.comment = "#7aa2f7"
      end
  },
}


