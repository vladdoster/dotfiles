-- leader
vim.g.mapleader = ','

-- mapping functions
local nmap =        function(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, {}) end
local vmap =        function(lhs, rhs) vim.api.nvim_set_keymap('v', lhs, rhs, {}) end
local snmap =       function(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, { silent = true}) end
local nnoremap =    function(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true }) end
local inoremap =    function(lhs, rhs) vim.api.nvim_set_keymap('i', lhs, rhs, { noremap = true }) end
local bufsnoremap = function(lhs, rhs) vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, { noremap = true, silent = true }) end
local lspremap =    function(keymap, fn_name) bufsnoremap(keymap, '<cmd>lua vim.lsp.' .. fn_name .. '()<CR>') end

-- Define autocommands in lua
-- https://github.com/neovim/neovim/pull/12378
-- https://github.com/norcalli/nvim_utils/blob/71919c2f05920ed2f9718b4c2e30f8dd5f167194/lua/nvim_utils.lua#L554-L567
function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup ' .. group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

-- bootstrap packer
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
if not packer_exists then
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
  vim.fn.system('git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

-- packer
local packer = require('packer').startup {
  function(use)
    use { 'ervandew/supertab' }
    use { 'fatih/vim-go' }

    use { 'norcalli/nvim-colorizer.lua' }
    use { 'gruvbox-community/gruvbox' }

    use { 'majutsushi/tagbar' }
    use { 'kyazdani42/nvim-tree.lua' }
    use { 'neovim/nvim-lspconfig' }
    use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
    use { 'sheerun/vim-polyglot' }
    use { 'hrsh7th/nvim-compe' }

    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-fugitive', requires = {{ 'junegunn/gv.vim' }}}
    use { 'tpope/vim-repeat' }
    use { 'tpope/vim-surround' }
    use { 'tpope/vim-unimpaired' }
    use { 'tpope/vim-vinegar' }
    use { 'tpope/vim-eunuch' }

    use { 'vim-airline/vim-airline' }
    use { 'vim-airline/vim-airline-themes' }

    use { 'wbthomason/packer.nvim', opt = true }
  end,
}
if not packer_exists then packer.install() end -- install plugins during initial bootstrap

-- misc global opts
settings = {
  'set colorcolumn=80,100',
  'set cursorline',
  'set completeopt-=preview',
  'set cpoptions=ces$',
  'set ffs=unix,dos',
  'set fillchars=vert:·',
  'set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo',
  'set guioptions-=T',
  'set guioptions-=m',
  'set hidden',
  'set hlsearch',
  'set ignorecase',
  'set lazyredraw',
  'set list listchars=tab:·\\ ,eol:¬',
  'set nobackup',
  'set noerrorbells',
  'set noshowmode',
  'set noswapfile',
  'set number',
  'set shellslash',
  'set showfulltag',
  'set showmatch',
  'set showmode',
  'set smartcase',
  'set synmaxcol=2048',
  'set t_Co=256',
  'set title',
  'set ts=2 sts=2 sw=2 et ci',
  'set ttyfast',
  'set vb',
  'set virtualedit=all',
  'set visualbell',
  'set wrapscan',
  'set termguicolors',
  'set cpoptions+=_',
  'colorscheme gruvbox',
}
for _, setting in ipairs(settings) do
  vim.cmd(setting)
end

-- setup colorizer
require('colorizer').setup()

-- language server

vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = false;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

local lspcfg = {
  gopls =         { binary = 'gopls',                    format_on_save = '*.go'       },
  golangcilsp =   { binary = 'golangci-lint-langserver', format_on_save = nil          },
  pyls =          { binary = 'pyls',                     format_on_save = '*.py'       },
  pyright =       { binary = 'pyright',                  format_on_save = nil          },
  yamlls =        { binary = 'yamlls',                   format_on_save = nil          },
  bashls =        { binary = 'bash-language-server',     format_on_save = nil          },
  dockerls =      { binary = 'docker-langserver',        format_on_save = 'Dockerfile' },
}

local lsp = require('lspconfig')
local custom_lsp_attach = function(client)
  local opts = lspcfg[client.name]

  -- format on save
  if opts['format_on_save'] ~= nil then
    nvim_create_augroups({[client.name] = {{'BufWritePre', opts['format_on_save'], ':lua vim.lsp.buf.formatting_sync(nil, 1000)'}}})
  end
end

-- golangci-lint lsp
local lspconfigs = require('lspconfig/configs')
lspconfigs.golangcilsp = {
  default_config = {
    cmd = {'golangci-lint-langserver'};
    filetypes = {'go', 'gomod'};
    root_dir = lsp.util.root_pattern('.git', 'go.mod');
    init_options = {
      command = { 'golangci-lint', 'run', '--out-format', 'json' };
    }
  };
}

-- only setup lsp clients for binaries that exist
for srv, opts in pairs(lspcfg) do
  if vim.fn.executable(opts['binary']) then lsp[srv].setup { on_attach = custom_lsp_attach } end
end

-- productive arrow keys
nmap('<Up>',    '[e')
vmap('<Up>',    '[egv')
nmap('<Down>',  ']e')
vmap('<Down>',  ']egv')
nmap('<Left>',  '<<')
nmap('<Right>', '>>')
vmap('<Left>',  '<gv')
vmap('<Right>', '>gv')

-- clear hlsearch on redraw
nnoremap('<C-L>', ':nohlsearch<CR><C-L>')

-- telescope
nnoremap('<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap('<c-p>', "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap('<c-b>', "<cmd>lua require('telescope.builtin').buffers()<cr>")
nnoremap('<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
nnoremap('<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>")
nnoremap('<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>")

-- clipboard
if vim.fn.has('unnamedplus') then vim.o.clipboard = 'unnamedplus' else vim.o.clipboard = 'unnamed' end

-- airline
vim.g.airline_theme = 'monochrome'
vim.g.airline_powerline_fonts = '0'
vim.cmd('let g:airline#extensions#tabline#enabled = 1')
vim.cmd('let g:airline#extensions#tabline#buffer_nr_show = 1')

-- tags
snmap('<leader>o', ':TagbarToggle<CR>')

-- toggle paste and wrap
snmap('<leader>p', ':set invpaste<CR>:set paste?<CR>')
snmap('<leader>w', ':set invwrap<CR>:set wrap?<CR>')

-- strip trailing whitespace
nnoremap('<leader>sws', ':%s/\\s\\+$//e<CR>')
