local cmd = vim.cmd
local execute = vim.api.nvim_command
local fn = vim.fn
local g = vim.g

g.auto_save = 0
g.mapleader = " "
-- load all plugins
require "plugins"
require "settings"
require "user-interface"
-- lsp stuff
require "file-finder"
require "icons"

require "lsp-config"
require "lsp-completion"
require "telescope-config"
require "treesitter-config"
-- colorscheme related stuff
cmd "syntax on"
require "mappings"
-- hide line numbers in terminal windows
vim.api.nvim_exec([[
   au BufEnter term://* setlocal nonumber
]], false)
-- setup for TrueZen.nvim
require "whichkey"
