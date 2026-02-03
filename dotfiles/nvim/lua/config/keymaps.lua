-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Resize window using <ctrl> arrow keys

-- Exit terminal insert mode with <Esc>
-- This can be problematic if you:
-- - Run vim/nvim inside the terminal (you won't be able to exit insert mode in the nested vim)
-- - Use TUI applications that need <Esc> (like htop, lazygit, etc.)
-- - Use shell vi mode where <Esc> switches to normal mode
-- - Run any CLI program that uses <Esc> for navigation or closing dialogs

-- Exit terminal mode with Escape
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
