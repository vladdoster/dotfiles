local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute "packadd packer.nvim"
end

local function require_plugin(plugin)
    local plugin_prefix = fn.stdpath("data") .. "/site/pack/packer/opt/"
    local plugin_path = plugin_prefix .. plugin .. "/"
    local ok, err, code = os.rename(plugin_path, plugin_path)
    if not ok then
        if code == 13 then
            return true
        end
    end
    if ok then vim.cmd("packadd " .. plugin) end
    return ok, err, code
end
vim.cmd "autocmd BufWritePost plugins.lua PackerCompile"

return require("packer").startup(function(use)
    	-- Packer can manage itself as an optional plugin
        use "wbthomason/packer.nvim"
        -- USER INTERFACE
        use {
          "npxbr/gruvbox.nvim",
            requires = {"rktjmp/lush.nvim"}
        }
        use 'kyazdani42/nvim-web-devicons'
        use 'hoob3rt/lualine.nvim'
        use {
            "jose-elias-alvarez/buftabline.nvim",
            requires = {"kyazdani42/nvim-web-devicons"}, -- optional
            config = function() require("buftabline").setup {} end
        }
        use "lukas-reineke/indent-blankline.nvim"
        -- FILE TREE
        use "kyazdani42/nvim-tree.lua"
        use "kevinhwang91/rnvimr"

        use {
          'nvim-telescope/telescope.nvim',
            requires = {
              {'nvim-lua/popup.nvim'},
              {"nvim-telescope/telescope-media-files.nvim"},
              {'nvim-lua/plenary.nvim'},
            }
        }
        -- LSP
        use "alexaandru/nvim-lspupdate"
        use "hrsh7th/nvim-compe"
        use "kabouzeid/nvim-lspinstall"
        use "neovim/nvim-lspconfig"
        use "nvim-treesitter/nvim-treesitter"
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
        -- MISC.
        use "windwp/nvim-autopairs"
  end
)
