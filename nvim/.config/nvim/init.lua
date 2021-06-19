local cmd = vim.cmd
local execute = vim.api.nvim_command
local fn = vim.fn
local g = vim.g

g.auto_save = 0
g.mapleader = " "

-- load plugins
require "settings"
require "plugins"
require "file-tree"
require "key-bindings"
require "lsp-completion"
require "lsp-config"
require "misc-utils"
require "telescope-config"
require "terminal"
require "treesitter-config"
require "user-interface"
