local prettier = { "prettier" }

---@type LazySpec
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<C-A-f>",
      function() require("conform").format({ async = true }) end,
      mode = { "n", "v" },
      desc = "Format",
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      css = prettier,
      html = prettier,
      javascript = prettier,
      javascriptreact = prettier,
      json = prettier,
      jsonc = prettier,
      markdown = prettier,
      scss = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      yaml = prettier,
      php = { "phpcbf_docker" },
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = { timeout_ms = 3000 },
    formatters = {
      -- Same as the PHP formatter in Zed: phpcbf inside the core container
      phpcbf_docker = {
        command = "docker",
        args = { "exec", "-i", "core", "vendor/bin/phpcbf", "--standard=.phpcs.xml", "--stdin-path=$FILENAME", "-" },
        stdin = true,
        -- phpcbf exits with 1 when it fixed something
        exit_codes = { 0, 1 },
      },
    },
  },
}
