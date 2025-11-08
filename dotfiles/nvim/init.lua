-- Use ',' as leader key
vim.g.mapleader = ","

-- attempt to increase performance.lol
vim.opt.undolevels = 10000
vim.opt.history = 10000
vim.opt.synmaxcol = 120

-- auto refresh buffer
vim.opt.autoread = true
vim.api.nvim_create_autocmd("FocusGained", {
  pattern = "*",
  command = "checktime",
})

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
