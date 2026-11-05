-- Servers are installed by mason and enabled automatically by
-- mason-lspconfig; nvim-lspconfig provides their default cmd/filetypes.
local servers = {
  "bashls",
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "emmet_language_server",
  "eslint",
  "fish_lsp",
  "html",
  "jsonls",
  "lemminx",
  "lua_ls",
  "stylelint_lsp",
  "vtsls",
  "yamlls",
}

-- phpantom isn't in mason; prefer one on PATH, otherwise reuse the binary
-- Zed's PHP extension already downloaded
local function phpantom_cmd()
  if vim.fn.executable("phpantom_lsp") == 1 then
    return "phpantom_lsp"
  end
  local found = vim.fn.glob(vim.env.HOME .. "/.local/share/zed/extensions/work/php/phpantom_lsp-*/phpantom_lsp", false, true)
  table.sort(found)
  return found[#found]
end

---@type LazySpec
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("vtsls", {
        settings = {
          vtsls = { autoUseWorkspaceTsdk = true },
          -- Restart tsserver instead of letting it eat all RAM
          typescript = { tsserver = { maxTsServerMemory = 3072 } },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = {
              library = { "/usr/share/hypr/stubs" },
              checkThirdParty = false,
            },
          },
        },
      })

      local phpantom = phpantom_cmd()
      if phpantom then
        vim.lsp.config("phpantom", {
          cmd = { phpantom, "--stdio" },
          filetypes = { "php" },
          root_markers = { "composer.json", ".phpantom.toml", ".git" },
        })
        vim.lsp.enable("phpantom")
      end

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = true,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = function(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = args.buf, desc = desc })
          end
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<F2>", vim.lsp.buf.rename, "Rename symbol")
        end,
      })
    end,
  },
  {
    -- Stops LSP servers when Neovim has been unfocused for a while (e.g. you
    -- switched to another tmux session) and restarts them on return
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      grace_period = 60 * 10,
    },
  },
}
