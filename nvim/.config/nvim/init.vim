"--- AUTO-INSTALL PLUGGED
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
"--- PLUGINS
call plug#begin('~/.config/nvim/autoload/plugged')
  Plug 'godlygeek/tabular'
  Plug 'gruvbox-community/gruvbox'
  Plug 'preservim/vimux'
  Plug 'mbbill/undotree'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'stsewd/fzf-checkout.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()
"--- GENERAL
set relativenumber
set nohlsearch
set noerrorbells
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set incsearch
set termguicolors
set scrolloff=10
set noshowmode
set completeopt=menuone,noinsert,noselect
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey
"--- REMAPS
let mapleader = " "
" easily resize split windows with Ctrl+hjkl
nnoremap <C-j> <C-w>+
nnoremap <C-k> <C-w>-
nnoremap <C-h> <C-w><
nnoremap <C-l> <C-w>>
" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv
" move by screen lines instead of file line
nnoremap j gj
nnoremap k gk
" join lines from below too. See :help J
map K kJ
" make Y behave like other capitals
map Y y$
" select another file from the directory of the current one
nnoremap <leader>F :execute 'edit' expand("%:p:h")<cr>
nnoremap <leader>gm /\v^\<\<\<\<\<\<\< \|\=\=\=\=\=\=\=$\|\>\>\>\>\>\>\> /<cr>
"--- CODE COMPLETION
set cmdheight=2
set hidden
set nobackup
set nowritebackup
set shortmess+=c
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
set updatetime=50
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
"--- COLORSCHEME
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection='0'
set background=dark
"--- FZF
let g:rg_derive_root='true'
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
nnoremap \ :Rg<CR>
nnoremap <C-T> :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>s :BLines<cr>
"--- NETRW
let g:NetrwIsOpen=0
let g:netrw_banner = 0
let g:netrw_winsize = 15
let g:netrw_browse_split = 2
let g:netrw_winsize = 20
let g:netrw_localrmdir='rm -r'
let g:netrw_dirhistmax = 0
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction
noremap <silent> <C-E> :call ToggleNetrw()<CR>
"--- UNDOTREE
if has("persistent_undo")
    set undodir=$XDG_CACHE_HOME/nvim/undodir
    set undofile
endif
"--- FUNCTIONS
function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
"--- VIMUX
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vm :VimuxPromptCommand("make ")<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vq :VimuxCloseRunner<CR>
map <Leader>vs :VimuxInterruptRunner<CR>
map <Leader>v<C-l> :VimuxClearTerminalScreen<CR>
