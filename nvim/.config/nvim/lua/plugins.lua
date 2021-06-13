local packer = require("packer")
local use = packer.use

return require("packer").startup(
    function()
        -- PKG MANAGER
        use "wbthomason/packer.nvim"
        -- COLOR-SCHEME
        use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
        -- UI
        use {
            'hoob3rt/lualine.nvim',
            requires = {'kyazdani42/nvim-web-devicons', opt = true}
        }
        use 'romgrk/barbar.nvim'
        use "lukas-reineke/indent-blankline.nvim"
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
        use "windwp/nvim-autopairs"
        -- TPOPE 
        use "tpope/vim-fugitive"
        use "tpope/vim-commentary"
        use "tpope/vim-rhubarb"
        use "tpope/vim-sensible"
        use "tpope/vim-repeat"
        -- SNIPPETS
        use "hrsh7th/vim-vsnip"
        use "rafamadriz/friendly-snippets"
        -- TERMINAL
        use "numToStr/FTerm.nvim"
    end
)
