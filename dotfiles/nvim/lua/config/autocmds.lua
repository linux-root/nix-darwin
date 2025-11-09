-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
--

-- Disable autoformat for certain file types
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "scala", "md", "mdx" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Open build.sbt if it exists in the current directory on startup
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.schedule(function()
      if vim.fn.filereadable("build.sbt") == 1 then
        vim.cmd("edit build.sbt")
      end
    end)
  end,
  group = vim.api.nvim_create_augroup("sbt_auto_open", { clear = true }),
  pattern = "*",
  desc = "Auto open build.sbt on startup",
})

-- Close empty buffer on startup
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local buf_name = vim.api.nvim_buf_get_name(bufnr)
    if buf_name == "" and vim.bo[bufnr].buftype == "" then
      local wins = vim.api.nvim_list_wins()
      if #vim.api.nvim_list_bufs() == 1 and #wins == 1 then
        local win_buf = vim.api.nvim_win_get_buf(wins[1])
        if win_buf == bufnr then
          vim.cmd("q")
        end
      end
    end
  end,
  group = vim.api.nvim_create_augroup("close_empty_buffer", { clear = true }),
  pattern = "*",
  desc = "Close empty buffer on startup",
})
