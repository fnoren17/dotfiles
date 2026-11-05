-- nvim-treesitter's main branch: parsers are compiled locally and need the
-- tree-sitter CLI (pacman: tree-sitter-cli). Highlighting is started per
-- buffer by Neovim itself.
local parsers = {
  "bash", "c_sharp", "css", "diff", "dockerfile", "fish", "git_rebase", "gitcommit",
  "html", "javascript", "jsdoc", "json", "lua", "luadoc", "make", "markdown",
  "markdown_inline", "php", "phpdoc", "query", "regex", "scss", "tsx", "typescript",
  "vim", "vimdoc", "xml", "yaml",
}

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
