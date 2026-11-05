---@type LazySpec
return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = { "rafamadriz/friendly-snippets" },
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    -- Enter accepts, like in Zed
    keymap = { preset = "enter" },
    completion = {
      documentation = { auto_show = true },
    },
    signature = { enabled = true },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },
  },
}
