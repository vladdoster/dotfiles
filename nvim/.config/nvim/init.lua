local cmd = vim.cmd
local execute = vim.api.nvim_command
local fn = vim.fn
local g = vim.g

g.auto_save = 0
g.mapleader = " "

-- load all plugins
require "settings"
require "plugins"
require "misc-utils"
require "user-interface"
require "file-finder"
require "icons"
require "terminal"
-- lsp stuff
require "lsp-config"
require "lsp-completion"
require "telescope-config"
require "treesitter-config"
require "mappings"
