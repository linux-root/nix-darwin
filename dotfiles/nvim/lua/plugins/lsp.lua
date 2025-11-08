return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      marksman = {
        -- Disable diagnostics for markdown files
        diagnostics = false,
      },
    },
  },
}
