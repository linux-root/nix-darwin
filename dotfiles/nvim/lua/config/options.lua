-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- This file is automatically loaded by plugins.core
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" } -- FROM nvim-metals. What is this?
vim.opt_global.shortmess:remove("F") -- Frrom nvim-metals integration guide
