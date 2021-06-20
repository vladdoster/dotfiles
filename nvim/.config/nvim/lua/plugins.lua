local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    execute 'packadd packer.nvim'
end

local packer = require('packer')
local use = packer.use

-- using { } for using different branch , loading plugin with certain commands etc
return packer.startup(
         function(use)
      -- Packer can manage itself as an optional plugin
      use 'wbthomason/packer.nvim'
      -- USER INTERFACE
      use 'rktjmp/lush.nvim'
      use 'npxbr/gruvbox.nvim'
      use 'kyazdani42/nvim-web-devicons'
      use 'hoob3rt/lualine.nvim'
      use 'jose-elias-alvarez/buftabline.nvim'

      -- FILE TREE
      use 'kyazdani42/nvim-tree.lua'
      use 'kevinhwang91/rnvimr'
      -- TELESCOPE
      use 'nvim-lua/popup.nvim'
      use 'nvim-telescope/telescope-media-files.nvim'
      use 'nvim-lua/plenary.nvim'
      use 'nvim-telescope/telescope.nvim'
      -- LSP
      use 'neovim/nvim-lspconfig'
      use 'alexaandru/nvim-lspupdate'
      use 'folke/lua-dev.nvim'
      use 'hrsh7th/nvim-compe'
      use 'kabouzeid/nvim-lspinstall'
      use 'nvim-treesitter/nvim-treesitter'
      use 'ray-x/lsp_signature.nvim'

      -- TPOPE 
      use 'tpope/vim-fugitive'
      use 'tpope/vim-commentary'
      use 'tpope/vim-rhubarb'
      use 'tpope/vim-sensible'
      use 'tpope/vim-repeat'
      -- SNIPPETS
      use 'hrsh7th/vim-vsnip'
      use 'rafamadriz/friendly-snippets'
      -- TERMINAL
      use 'numToStr/FTerm.nvim'
      -- MISC.
      use 'dhruvasagar/vim-table-mode'
      use 'lukas-reineke/indent-blankline.nvim'
      use 'windwp/nvim-autopairs'
  end, {
      display = {
          open_fn = function()
              return require('packer.util').float({border = 'single'})
          end
      }
  }
       )
