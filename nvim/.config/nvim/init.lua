


local cmd = vim.cmd
local execute = vim.api.nvim_command
local fn = vim.fn
local g = vim.g

g.auto_save = 0
g.mapleader = " "
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end
-- load all plugins
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
