-- Install packer
local execute = vim.api.nvim_command
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

vim.cmd [[packadd packer.nvim]]
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]], false)

local use = require('packer').use
require('packer').startup(function()
  use {'wbthomason/packer.nvim', opt = true}
  use 'hrsh7th/nvim-compe'
  use 'lewis6991/gitsigns.nvim'
  use 'morhetz/gruvbox'
  use 'neovim/nvim-lspconfig'
  use 'sheerun/im-polyglot'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-vinegar'
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
end)

--Incremental live completion
vim.o.inccommand = "nosplit"

-- mapping and settings helpers
local utils = {}

function utils.map(type, key, value, opts) -- the other functions are just for more vim-feel usage
  local options = opts or {}
  vim.api.nvim_set_keymap(type, key, value, options)
end
function utils.noremap(type, key, value, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(type,key,value, options)
end
function utils.nnoremap(key, value, opts)
  utils.noremap('n', key, value, opts)
end
function utils.inoremap(key, value, opts)
  utils.noremap('i', key, value, opts)
end
function utils.vnoremap(key, value, opts)
  utils.noremap('v', key, value, opts)
end
function utils.xnoremap(key, value, opts)
  utils.noremap('x', key, value, opts)
end
function utils.tnoremap(key, value, opts)
  utils.noremap('t', key, value, opts)
end
function utils.cnoremap(key, value, opts)
  utils.noremap('c', key, value, opts)
end
function utils.nmap(key, value, opts)
  utils.map('n', key, value, opts)
end
function utils.imap(key, value, opts)
  utils.map('i', key, value, opts)
end
function utils.vmap(key, value, opts)
  utils.map('v', key, value, opts)
end
function utils.tmap(key, value, opts)
  utils.map('t', key, value, opts)
end

P = function(stuff) return print(vim.inspect(stuff)) end

-- SET OPTS --> EG --> opt('b', 'expandtab', true)
local scopes = {o = vim.o, b = vim.bo, w = vim.wo, g = vim.g}
function utils.opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

-- ===== real config starts here =====
local g = vim.g
local o = vim.o

g.mapleader = ' '
g.tex_flavor = "latex"

utils.opt('w', 'number', true)
utils.opt('w', 'relativenumber', true)
-- faster macros
utils.opt('o', 'lazyredraw', true)
-- matching parenthesis
utils.opt('o', 'showmatch', true)
-- switch buffer without saving them
utils.opt('o', 'hidden', true)
-- better searching
utils.opt('o', 'ignorecase', true)
utils.opt('o', 'smartcase', true)
utils.opt('o', 'hlsearch', false)
-- show lines bellow cursor
utils.opt('o', 'scrolloff', 5)
utils.opt('o', 'sidescrolloff', 5)
-- tab config
utils.opt('b', 'expandtab', true)
utils.opt('b', 'shiftwidth', 2)
utils.opt('b', 'tabstop', 2)
utils.opt('b', 'softtabstop', 2)
-- split in reasonable positions
utils.opt('o', 'splitright', true)
utils.opt('o', 'splitbelow', true)
--folds
utils.opt('w', 'foldmethod', 'expr')
utils.opt('w', 'foldexpr', 'nvim_treesitter#foldexpr()')
utils.opt('o', 'foldlevelstart', 99)
o.formatoptions = o.formatoptions:gsub("r", ""):gsub("o", "")

-- ===== plugins =====
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
  use {'dylanaraps/wal.vim'}
  use {'hrsh7th/nvim-compe'}
  use {'morhetz/gruvbox'}
  use {'neovim/nvim-lspconfig'}
  use {'norcalli/nvim-colorizer.lua', config = [[require"colorizer".setup()]]}
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
  use {'tpope/vim-fugitive'}
  use {'wbthomason/packer.nvim', opt = true}
end)
-- update plugins
vim.cmd([[autocmd BufWritePost plugins.lua PackerCompile]])

-- ===== colorsheme settings =====
vim.cmd('syntax on')
vim.o.termguicolors = true
vim.g.gruvbox_contrast_dark="hard"
vim.cmd("colorscheme gruvbox")

-- remove trailing whitespaces
vim.cmd([[autocmd BufWritePre * %s/\s\+$//e]])
-- remove trailing newline
vim.cmd([[autocmd BufWritePre * %s/\n\+\%$//e]])
-- Run xrdb whenever Xdefaults or Xresources are updated.
vim.cmd([[autocmd BufWritePost *xresources !xrdb %]])
-- Update binds when sxhkdrc is updated.
vim.cmd([[autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd]])

-- ===== mappings =====
-- split resize
utils.nnoremap("<leader>-", "<cmd>vertical resize -10<CR>")
utils.nnoremap("<leader>+", "<cmd>vertical resize +10<CR>")
utils.nnoremap("<leader>_", "<cmd>resize -10<CR>")
utils.nnoremap("<leader>*", "<cmd>resize +10<CR>")
-- split navigation
utils.map("", "<C-h>", "<C-w>h")
utils.map("", "<C-j>", "<C-w>j")
utils.map("", "<C-k>", "<C-w>k")
utils.map("", "<C-l>", "<C-w>l")
-- run command in current line and paste stout into current buffer
utils.nnoremap("Q", "!!$SHELL<CR>")
-- move lines up and down in visual mode
utils.xnoremap("K", ":move '<-2<CR>gv-gv")
utils.xnoremap("J", ":move '>+1<CR>gv-gv")
-- useful bindings
utils.inoremap("kj", "<Esc>")
utils.noremap("", "<Space>", ":")
utils.nnoremap("<leader>ev", "<cmd>vs $MYVIMRC<CR>")
utils.nnoremap("<leader>sv", "<cmd>source $MYVIMRC<CR>")
-- quote quickly
utils.inoremap('<leader>"', '<Esc>viw<Esc>a"<Esc>bi"<Esc>leli')
utils.vnoremap('<leader>"', '<Esc>`<i"<Esc>`>ea"<Esc>')
-- substitute shortcut
utils.nnoremap("S", ":%s//g<Left><Left>")
utils.vnoremap("S", ":s//g<Left><Left>")
-- quickfix navigation
utils.nnoremap("<leader>q", "<cmd>cnext<cr>")
utils.nnoremap("<leader>Q", "<cmd>cprev<cr>")
-- spellcheck
utils.nnoremap("<leader>sp", ":setlocal spell spelllang=en")
-- more reachable line start/end
utils.nnoremap("H", "^")
utils.nnoremap("L", "$")
-- write to ----READONLY---- files
utils.cnoremap("w!!",  "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!")
-- nvim-commenter
utils.vnoremap("<leader>x", "<cmd>MultiCommenterToggle<cr>")
utils.nnoremap("<leader>x", "<cmd>SingleCommenterToggle<cr>")
-- terminal mappings
utils.tnoremap("<Esc>", "<C-\\><C-n>")
utils.nnoremap("<leader>t", "<cmd>sp | term<cr>")
-- termdebugger
utils.nnoremap("<leader>dd", ":TermdebugCommand")

-- ===== find project root for quick cd =====
local api = vim.api
function find_project_root()
  local id = [[.git]]
  local file = api.nvim_buf_get_name(0)
  local root = vim.fn.finddir(id, file .. ';')
  if root ~= "" then
    root = root:gsub(id, '')
    print(root)
    vim.api.nvim_set_current_dir(root)
  else
    print("No repo found.")
  end
end
-- smart cwd
utils.nnoremap("cf", "<cmd>cd %:p:h | pwd<cr>")
utils.nnoremap("cr", "<cmd>lua find_project_root()<cr>")
-- tab for completion menu
utils.inoremap("<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
utils.inoremap("<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})

-- ===== statusline =====
local stl = {' %M', ' %y', ' %r', ' %{pathshorten(expand("%:p"))}', ' %{FugitiveStatusline()}',
  '%=', ' %c:%l/%L'
}
vim.o.statusline = table.concat(stl)

-- ===== telescope setup =====
require('telescope').setup{
  --defaults excluded to reduce lines :P
}
utils.nnoremap('<leader>b', '<cmd>Telescope buffers<cr>')
utils.nnoremap('<leader>o', '<cmd>Telescope find_files<cr>')
utils.nnoremap('<leader>h', '<cmd>Telescope oldfiles<cr>')
utils.nnoremap('<leader>c', '<cmd>Telescope commands<cr>')
utils.nnoremap('<leader>ch', '<cmd>Telescope command_history<cr>')
utils.nnoremap('<leader>f', '<cmd>Telescope live_grep<cr>')
utils.nnoremap('<leader>z', '<cmd>Telescope spell_suggest<cr>')
utils.noremap('','<F1>', '<cmd>Telescope help_tags<cr>')

-- ===== lsp setup =====
local nvim_lsp = require('lspconfig')
local on_attach = function(_client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

local servers = { 'pyright' }

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

-- Set completeopt to have a better completion experience
vim.o.completeopt="menuone,noinsert,noselect"

-- Compe setup
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
  documentation = true;

  source = {
    path = true;
    buffer = false;
    calc = true;
    vsnip = false;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = false;
    treesitter = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
