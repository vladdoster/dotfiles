local packer = require("packer")
local use = packer.use

return require("packer").startup(
    function()
        -- PKG MANAGER
        use "wbthomason/packer.nvim"
        -- COLOR-SCHEME
        use "norcalli/nvim-colorizer.lua"
        use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
        use "kyazdani42/nvim-web-devicons"
        -- UI
        use "akinsho/nvim-bufferline.lua"
        use "alvan/vim-closetag"
        use "glepnir/galaxyline.nvim"
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
        use "karb94/neoscroll.nvim"
        use {"lukas-reineke/indent-blankline.nvim", branch = "lua"}
    end
)
