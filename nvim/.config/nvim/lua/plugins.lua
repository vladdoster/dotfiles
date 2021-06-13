-- Helper aliases
local cmd = vim.cmd
local execute = vim.api.nvim_command
local fn = vim.fn
local g = vim.g

-- Bootstrap Packer if absent
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

-- Load Packer
local packer = require("packer")
local use = packer.use

-- Load plugins
return require("packer").startup(
    function()
        -- PKG MANAGER
        use "wbthomason/packer.nvim"
        -- COLOR-SCHEME
        use "norcalli/nvim-colorizer.lua"
        use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
        -- UI
        use {
            'hoob3rt/lualine.nvim',
            requires = {'kyazdani42/nvim-web-devicons', opt = true}
        }
        use "alvan/vim-closetag"
        use "lewis6991/gitsigns.nvim"
        use "windwp/nvim-autopairs"
        -- FILE FINDER
        use "kyazdani42/nvim-tree.lua"
        use {
            'nvim-telescope/telescope.nvim',
            requires = {{'nvim-lua/popup.nvim'}, {"nvim-telescope/telescope-media-files.nvim"},
 {'nvim-lua/plenary.nvim'}}
        }
        -- LSP
        use "hrsh7th/nvim-compe"
        use "kabouzeid/nvim-lspinstall"
        use "alexaandru/nvim-lspupdate"
        use "neovim/nvim-lspconfig"
        use "nvim-treesitter/nvim-treesitter"
        use "onsails/lspkind-nvim"
        use "sbdchd/neoformat"
        -- SNIPPETS
        use "hrsh7th/vim-vsnip"
        use "rafamadriz/friendly-snippets"
        -- MISC.
        use "907th/vim-auto-save"
        use "folke/which-key.nvim"
        use {"lukas-reineke/indent-blankline.nvim", branch = "lua"}
    end
)
